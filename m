Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4E637E5EA
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 02:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789008496; cv=none; b=WvuL0TXpfkvO0lebbqWrUn5HFvGP9iA9jCnT/bjO0rgbsJsoK72EthsnG+daZh/kTtUeBHEWIWbOnzJ4TCA0IGYMLU/KV3cmjHpke3OfXXijxMUPL9ZLqsTWA9mS3QcrpTTpe8hfITrE/V9i6vC98TD8R5lOmolFRrLNizdfn9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789008496; c=relaxed/simple;
	bh=FqF6CKFVupuZ/C08mvSVcKpkwZ70Ix31byJ6xVWwI54=;
	h=Date:To:From:Subject:Message-Id; b=mRZkfRcA3pgCG0FJcDBFC5os05xdN0R0RryhEEHhsraccmGfZDRk6c/2zVexU5A6ZJCi4BpTWXupUB7vJzEtge5RhqKdrOm29B0G/1DlcpvPx6d5IyF1bsGiwUgiKcb7k32wsdZI+Hu58zyH0kCnRAyuVxiTMmJw6rrtuYQA99c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UekgMaRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UekgMaRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F29C1F000FF;
	Thu, 10 Sep 2026 02:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789008494;
	bh=ylYBkmILg57BfsLj7QoI4JJwo+eXaXxHCRtYIGbyYaI=;
	h=Date:To:From:Subject;
	b=UekgMaREp5fpCVzoqNLpELd9aXSomghCWg8DjqjSyqFJx2hxkBUS6WR4P1KdZBy2/
	 kDB7ereVcVqAGwPmCckpAJnd01kRgBMsWD2HK4HIft3l41zs7kRk7cmKoDPfhKyCIZ
	 84TX6SB3ZJjERZzP1r/MqUvP1AyTrXHL3mR0mHrc=
Date: Wed, 09 Sep 2026 19:48:13 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch added to mm-new branch
Message-Id: <20260910024814.2F29C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: don't fail a large-folio swapin whose range is not in zswap
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   58 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 15 deletions(-)

--- a/mm/zswap.c~mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap
+++ a/mm/zswap.c
@@ -1559,21 +1559,44 @@ check_old:
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
@@ -1592,13 +1615,18 @@ int zswap_load(struct folio *folio)
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

mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch

