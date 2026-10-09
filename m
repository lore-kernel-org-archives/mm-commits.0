Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E5409620
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525485; cv=none; b=OnqpjuZv9F+srL2ZcNBkATsqBi3nhYpIYo/lLAUgzIOjqXxIoHAu7DD5TFwUuo9SeDjtTkhESYhJArG7SGF8WKD486oCcHyDoFnQF72TvrqW6adNtPf7c1epsnKg62yU3tIrZYX4R06odiFSjw+PB2mDmo7LNbeswDfB810hing=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525485; c=relaxed/simple;
	bh=O/BGl5HHhZQCjkB6INsEEs8NMx1Ohr2Mzw2909sOOWo=;
	h=Date:To:From:Subject:Message-Id; b=CjU0C5g74Evv2n34fSHI95r4GPYHK/UbnaIWg4zQ66KPg6AjPYZzO7fAp0F0mwStUiLA6Ma/hlqDEL6y7gJWiFHRvlsaL5Atf0REgySIdV1epwi0Qg9n0B6X8U9PYNjaIjLjc38gREB3mt36QYTPKxFE0VwlcQ5EM1ZxZX5xi7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=htyJ7SDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="htyJ7SDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4201F000FF;
	Fri,  9 Oct 2026 05:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525484;
	bh=/eqi6O4FnGNHQsTHiCHtCAJwOqHXm8XY8yZSkFfAaVQ=;
	h=Date:To:From:Subject;
	b=htyJ7SDjOXtRcdkQ2QPnsIKD2CZOM+ykpo+2nMegLCjgnc5M1iGfLQM0XVKMs6hWx
	 c4gvarHeOAfPo0Nz+WQGl1Q/G0wLbIRrE2kmpjg13yJAVdtz1mPzIhzCoxQtYMerXC
	 m8/NUhADI9i8CY+Iy6BHZG1+DD+1eYYbfPrmn+JY=
Date: Thu, 08 Oct 2026 22:58:03 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch removed from -mm tree
Message-Id: <20261009055803.EF4201F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: don't fail a large-folio swapin whose range is not in zswap
has been removed from the -mm tree.  Its filename was
     mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: zswap: don't fail a large-folio swapin whose range is not in zswap
Date: Mon, 7 Sep 2026 09:19:38 -0700

thp_swapin_suitable_orders() and shmem_swap_alloc_folio() sample
zswap_never_enabled() to decide whether a swapin may use a large folio. 
zswap_load() samples the same one-way static key again once the read
reaches it.  Nothing serialises the two reads, and in between the task
allocates and pins a high-order folio, which can sleep.

If zswap is enabled for the first time in that window, a large folio that
was correctly permitted reaches zswap_load(), which rejects every large
folio with -EINVAL.  swap_read_folio() treats anything other than -ENOENT
as "zswap handled it" and skips the backing-device read, so the folio
comes back unlocked and not uptodate: SIGBUS for an anonymous fault, -EIO
for shmem.  The data is intact on the swap device - it was written there
before zswap was ever enabled - and the not-uptodate folio stays in the
swap cache, so every retry of the fault fails the same way.  With
panic_on_warn the WARN takes the machine down rather than the task.

Scan the range instead of rejecting the folio.  The caller has pinned
every slot before issuing the read, so zswap cannot start a store or a
writeback into the range and the scan is stable.  If nothing in the range
is in zswap it is all on the backing device: return -ENOENT and let
swap_read_folio() read it.

A range that does have a slot in zswap is still refused, because zswap
stores large folios as order-0 entries and cannot reconstruct one.  That
stays reachable - a slot shared with another task can be stored inside the
same window - and refusing is correct, since the alternative is returning
the stale device copy.  Report it as -EIO rather than -EINVAL: the request
is valid, zswap just cannot serve it.  The only caller distinguishes
-ENOENT from everything else, so that part is a documentation fix.

Link: https://lore.kernel.org/20260907161938.1932355-1-usama.arif@linux.dev
Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---

 mm/zswap.c |   58 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 15 deletions(-)

--- a/mm/zswap.c~mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap
+++ a/mm/zswap.c
@@ -1556,21 +1556,44 @@ check_old:
 }
 
 /**
+ * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
+ * @entry: base swap entry of the range
+ * @nr: number of contiguous slots to check
+ *
+ * Context: The caller must keep the range pinned, otherwise the answer can
+ * change under it.
+ * Return: true if at least one slot in the range is in zswap.
+ */
+static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	pgoff_t offset = swp_offset(entry);
+	struct xarray *tree = swap_zswap_tree(entry);
+	unsigned long index = offset;
+
+	/*
+	 * A pinned range is at most SWAPFILE_CLUSTER slots and is aligned to
+	 * its own size, so one tree covers all of it and a single lookup is
+	 * enough. Scanning only part of the range would report a false
+	 * "absent" and let the caller read a stale copy from the device.
+	 */
+	BUILD_BUG_ON(SWAPFILE_CLUSTER > ZSWAP_ADDRESS_SPACE_PAGES);
+
+	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
+}
+
+/**
  * zswap_load() - load a folio from zswap
  * @folio: folio to load
  *
  * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
  * of the following error codes:
  *
- *  -EIO: if the swapped out content was in zswap, but could not be loaded
- *  into the page due to a decompression failure. The folio is unlocked, but
- *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
- *  will SIGBUS).
- *
- *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  -EIO: if the swapped out content was in zswap but could not be handed
+ *  back, either because decompression failed or because a slot in a
+ *  large-folio range is still in zswap and zswap cannot reconstruct a large
+ *  folio from per-page entries. The folio is unlocked, but NOT marked
+ *  up-to-date, so that an IO error is emitted (e.g. do_swap_page() will
+ *  SIGBUS).
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
@@ -1589,13 +1612,18 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 
 	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
+	 * A large folio can legitimately reach zswap_load() with its whole
+	 * range on the backing device, so scan the range rather than rejecting
+	 * it outright. The caller has pinned every slot, so zswap cannot start
+	 * a store or a writeback into the range while we look.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (WARN_ON_ONCE(zswap_is_present(swp,
+						  folio_nr_pages(folio)))) {
+			folio_unlock(folio);
+			return -EIO;
+		}
+		return -ENOENT;
 	}
 
 	entry = xa_load(tree, offset);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch
mm-remove-the-unused-zone-unaccepted_cleanup.patch

