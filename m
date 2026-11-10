Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293128;
	b=l0L8k01u8/699mWPhtTnIXah2dgdpxFwwyugXGOHg+3zIQJaTzmuVHUPldk9Jp38Ky06
	 ZUiUwGpEUSkknnQZNsEi34QLI2ncPbdYNi5EFuGIfoQldUaInTWLg6ei/WL3BugQsN9SU
	 rwt11E+oerxCxxFuwFCa7ZkHMJiRm6D2T+6wLdY+uehA3KXnqFgQ5YZGEd6NYSWqC/kKi
	 pBOgbLQgHeJ2FfQPKLIi8XfX2G4Cs1bBU9cwfy3BUlP+nUanPHc6sulISjSZXehhimeiI
	 QedJuUhPfQ6R5Bh1AvTuf+autAiQxNQEcLyBlPrWFIRDoObkzu6EWuNcmf3n1gqcvJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293128;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GvnGXm1d9rAqBgZNqdNyYQfZQn6nWRCt1+VBuOhcvs0=;
	b=Tg/IYb+9uYKuiHHx1hqkFNvF8yMxQiDgQlGx6Vh4/Fo2qK4umUWZZi69UTPjdMZCN8Yy
	 z7u1+5iODQ+Z4OLKCZbwOPEP0lnBTcZEZgkAIBsBqfv+BKpDpYP4/goXhBLb6klc9v3uf
	 vm44nkQC3ZsSpACY3QdLaEnw4MLoBYGWxyg1l4UBChc2spL4RnyW4KufHeocezohT3CC8
	 mx2LOmJCY63TxpJWhNIam9a/iQkSIgDVY2hKEW/h3iiigFGHCyld0LtIiva27GoT7U8MR
	 b28se0ED0mJorf1eskTE3TEWTaeydo80gyWQkTFGakQm0xrCgira2qHvrWPyGeOS0Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F4HZTagb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC64606CB1D;
	Tue, 10 Nov 2026 06:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F4HZTagb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5C11F0089F;
	Tue, 10 Nov 2026 06:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293128;
	bh=GvnGXm1d9rAqBgZNqdNyYQfZQn6nWRCt1+VBuOhcvs0=;
	h=Date:To:From:Subject;
	b=F4HZTagbjsETHeXzFeWwIFzFWlHDcM14KAJFuWb0/g0uJrfPS1b14nJoQa+kaGiqy
	 5/ttE8oSbRzm3y3BeNNJyZvFNZw2AN3EwB+d8eTYe0e35TAqcds3JLT2FYwZwiDcrw
	 vsXpeLMQhtTN5XrpzlA51awjVXOV0Gar6XAD22ro=
Date: Mon, 09 Nov 2026 22:45:27 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,tz2294@columbia.edu,
	stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,
	kasong@tencent.com,hughd@google.com,david@kernel.org,chrisl@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	mt4022@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch removed from -mm tree
Message-Id: <20261110064528.3F5C11F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/shmem: fix swapin livelock on a mismatched large swap cache folio
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mani Tofigh <mt4022@columbia.edu>
Subject: mm/shmem: fix swapin livelock on a mismatched large swap cache folio
Date: Tue, 27 Oct 2026 16:33:32 -0400

On a SWP_SYNCHRONOUS_IO swap device, a large shmem folio can be left in
the swap cache over swap slots that another file now uses.  Reading that
other file then loops forever in shmem_get_folio_gfp():
shmem_swapin_folio() finds the large folio, rounds the index and the swap
entry down to the folio's size, finds no matching entry in the file and
returns -EEXIST, and the retry finds the same folio again.  Since the task
keeps the mapping locked, a munmap() of the same mapping waits forever.

The folio is left behind when the slots are freed and reused while the
swapin is still allocating it:

  Task A (reads X)                      Task B
  ----------------                      ------
  shmem_swapin_folio()
    allocate a large folio
    for X's slots
                                        punch a hole in X
                                        /* X's slots freed */
                                        swap out file Y
                                        /* Y reuses those slots */
    add the folio to the swap
    cache over those slots
    shmem_confirm_swap() fails
    /* -EEXIST, the folio stays
       in the swap cache */

  Task C (reads Y)
  ----------------
  shmem_swapin_folio()
    finds the large folio
    rounds down to its start,
    where Y has no entry
    /* -EEXIST, retried forever */

Before commit c246d236b18b ("mm/shmem: never bypass the swap cache for
SWP_SYNCHRONOUS_IO"), a direct swapin that failed this way freed its folio
instead of leaving it in the swap cache.

do_swap_page() already drops a large swap cache folio that does not fit
for anonymous memory.  Do the same in shmem_swapin_folio() and on a
-EEXIST, remove a large folio that is not anonymous/dirty/under-writeback
from the swap cache so that the retry swaps in a folio that fits.

The reproducer below fills a small brd swap device so that a 64K shmem
folio and the 4K pages of another file land in the same slots, and races a
read of the first file with a hole punch and a swapout of the second. 
This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development, but the non-deterministic C
reproducer can typically trigger it in the 2-4s time range.  With the fix,
nothing is triggered after 600 seconds.

Link: https://lore.kernel.org/20261027-shmem-swapin-mismatch-v1-1-84e30aa3b9e5@columbia.edu
Fixes: c246d236b18b ("mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO")
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio
+++ a/mm/shmem.c
@@ -2612,11 +2612,14 @@ static int shmem_swapin_folio(struct ino
 	 * and swap cache folios are never partially freed.
 	 */
 	folio_lock(folio);
-	if (!folio_matches_swap_entry(folio, swap) ||
-	    shmem_confirm_swap(mapping, index, swap) < 0) {
+	if (!folio_matches_swap_entry(folio, swap)) {
 		error = -EEXIST;
 		goto unlock;
 	}
+	if (shmem_confirm_swap(mapping, index, swap) < 0) {
+		error = -EEXIST;
+		goto failed;
+	}
 	if (!folio_test_uptodate(folio)) {
 		error = -EIO;
 		goto failed;
@@ -2657,6 +2660,15 @@ failed:
 		error = -EEXIST;
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap);
+	/*
+	 * A large folio that does not fit the mapping, e.g. because its swap
+	 * entries were freed and reused, would be found again on every retry.
+	 * Drop it from the swap cache so the retry can swap in a fitting one.
+	 */
+	if (error == -EEXIST && folio && folio_test_large(folio) &&
+	    !folio_test_anon(folio) && !folio_test_dirty(folio) &&
+	    !folio_test_writeback(folio))
+		swap_cache_del_folio(folio);
 unlock:
 	if (folio)
 		folio_unlock(folio);
_

Patches currently in -mm which might be from mt4022@columbia.edu are

mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch

