Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459023B7B8C;
	Wed,  4 Mar 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646316; cv=none; b=JYN2abpSZ7lH45UnpR/kv99Pc5UIBzuagZcVn8aovBa9EeTZosrzEaa3dt5rIrHYhYxvWdevXQveHb8ajuooO3bn/tFaHnZokCSkWKmOXs3PmVBLr+18WY/Q4vUkKMJ8bJWcM1Vb1dYBEQmz4AogRCNWf/wD8E7aip+3/lxIYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646316; c=relaxed/simple;
	bh=aHGrYKmyTI7mfNtq3NtPvMpGaSo0V6qBZ02Ef80RnL0=;
	h=Date:To:From:Subject:Message-Id; b=BMqrHP8VpchbYq9Xe+EefjTxL/rcOlYF0qDOlOXD5pCBGHmmBB2xdwNG9tVrvoAWgLR+EOOzJt0dCbGTGTn1SUfoNCSsO1JdWx3v2m9Vt315s/cF5lcZse07WwM3PQ2KSp2qSY+YZK/gq2hnLC7nDDpqXiEcaUES0TtKMzoXiTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BV1Xw8WR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BV1Xw8WR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31CCC19425;
	Wed,  4 Mar 2026 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646315;
	bh=aHGrYKmyTI7mfNtq3NtPvMpGaSo0V6qBZ02Ef80RnL0=;
	h=Date:To:From:Subject:From;
	b=BV1Xw8WRI94FSPbwZLUZoivyOfg8cbo3NVS+yuoqkmml7aDghLLiTeF0Z0AtwAocQ
	 j6M7tK8bIAcQMU1QIZJv7KVYRfWoGoBMGvE2HjlZBLHavyilY73VlSNU/hsYAz3Ior
	 Bp75KqLUOx31vzsJgkXfchQpAMqATP/UgYwbYTnA=
Date: Wed, 04 Mar 2026 09:45:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,bas@dfinity.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch removed from -mm tree
Message-Id: <20260304174515.D31CCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix a folio_split() race condition with folio_try_get()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: fix a folio_split() race condition with folio_try_get()
Date: Mon, 2 Mar 2026 15:31:59 -0500

During a pagecache folio split, the values in the related xarray should
not be changed from the original folio at xarray split time until all
after-split folios are well formed and stored in the xarray.  Current use
of xas_try_split() in __split_unmapped_folio() lets some after-split
folios show up at wrong indices in the xarray.  When these misplaced
after-split folios are unfrozen, before correct folios are stored via
__xa_store(), and grabbed by folio_try_get(), they are returned to
userspace at wrong file indices, causing data corruption.  More detailed
explanation is at the bottom.

The reproducer is at: https://github.com/dfinity/thp-madv-remove-test
It
1. creates a memfd,
2. forks,
3. in the child process, maps the file with large folios (via shmem code
   path) and reads the mapped file continuously with 16 threads,
4. in the parent process, uses madvise(MADV_REMOVE) to punch poles in the
   large folio.

Data corruption can be observed without the fix.  Basically, data from a
wrong page->index is returned.

Fix it by using the original folio in xas_try_split() calls, so that
folio_try_get() can get the right after-split folios after the original
folio is unfrozen.

Uniform split, split_huge_page*(), is not affected, since it uses
xas_split_alloc() and xas_split() only once and stores the original folio
in the xarray.  Change xas_split() used in uniform split branch to use the
original folio to avoid confusion.

Fixes below points to the commit introduces the code, but folio_split() is
used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
truncate operation").

More details:

For example, a folio f is split non-uniformly into f, f2, f3, f4 like
below:
+----------------+---------+----+----+
|       f        |    f2   | f3 | f4 |
+----------------+---------+----+----+
but the xarray would look like below after __split_unmapped_folio() is
done:
+----------------+---------+----+----+
|       f        |    f2   | f3 | f3 |
+----------------+---------+----+----+

After __split_unmapped_folio(), the code changes the xarray and unfreezes
after-split folios:

1. unfreezes f2, __xa_store(f2)
2. unfreezes f3, __xa_store(f3)
3. unfreezes f4, __xa_store(f4), which overwrites the second f3 to f4.
4. unfreezes f.

Meanwhile, a parallel filemap_get_entry() can read the second f3 from the
xarray and use folio_try_get() on it at step 2 when f3 is unfrozen. Then,
f3 is wrongly returned to user.

After the fix, the xarray looks like below after __split_unmapped_folio():
+----------------+---------+----+----+
|       f        |    f    | f  | f  |
+----------------+---------+----+----+
so that the race window no longer exists.

[ziy@nvidia.com: move comment, per David]
  Link: https://lkml.kernel.org/r/5C9FA053-A4C6-4615-BE05-74E47A6462B3@nvidia.com
Link: https://lkml.kernel.org/r/20260302203159.3208341-1-ziy@nvidia.com
Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Bas van Dijk <bas@dfinity.org>
Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get
+++ a/mm/huge_memory.c
@@ -3631,6 +3631,7 @@ static int __split_unmapped_folio(struct
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
 	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
+	struct folio *old_folio = folio;
 	int split_order;
 
 	/*
@@ -3651,12 +3652,16 @@ static int __split_unmapped_folio(struct
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
+			 * Use the to-be-split folio, so that a parallel
+			 * folio_try_get() waits on it until xarray is updated
+			 * with after-split folios and the original one is
+			 * unfrozen.
 			 */
-			if (split_type == SPLIT_TYPE_UNIFORM)
-				xas_split(xas, folio, old_order);
-			else {
+			if (split_type == SPLIT_TYPE_UNIFORM) {
+				xas_split(xas, old_folio, old_order);
+			} else {
 				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
+				xas_try_split(xas, old_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
 			}
_

Patches currently in -mm which might be from ziy@nvidia.com are


