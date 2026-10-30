Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793380105;
	b=mJ4Kln/b622Dm8G78H0yScJHQILSTcKXjERv0tiubYd2eyo1k5Q/JWRn45PnC8TiC3zo
	 ZC2VINt17kHneW9pMUTDzpAZU2tOmqJhaWS2bYRnImzN9Upuu/8fJ0BJP6eNjivgItERR
	 c+/XoComXR3qhlAm19CX8hCbexuC3tSGDjCjM4IJLPuYhQ8qDnZQSW/UVe2oJeSA9Tg/q
	 7TbD8q6ONL0GB04En4Sx6fkFQpYee8LaW9NYaTOE9HRmbGHODz8Ht5GtQ7gbkSJBmIGj8
	 zJx9zCKQ+rmr0TQFFjVx27ZPUHA/CWZzlKPepI3/IuVQgthnThkcWCZv//zZMLmwucg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793380105;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ar0206v81QreD1XeYeiPdhGSp/Z+z9/udhIHQEQ/t0w=;
	b=YYIJC0C1AIM/tdryzXIW4F7sFG/Yk/LcwbsTImoHBt2kPVPFH29dSLyWsJN4Y8tCZDyi
	 NB1rHpsYeP+gYLqqzKkw7dJV3AQiXYvhHCilUZAE+ZNJcj4gm7HZ0+aL2IOgROAR2FSor
	 uegQFP7j/HQ8vqTuRq2VgHTM0wUIN54XZ7M39ZsQyYHS7qd62SB4JybNS8IP/e+QIIpnt
	 +HTzeWygI9zfSFLgB43HPCwedNtEPbX6VhQjvtrYQfkNMwuVzCize/RyGdw4QoPtPMTwH
	 hVheOTLT5793IFjCRQOfiraDVA2cpWo6O8K4/tsbM8N59ukiDEZz10gZRKgIP5qsDsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mytZGOrU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033B9606A331;
	Fri, 30 Oct 2026 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mytZGOrU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DED1F00A1E;
	Fri, 30 Oct 2026 17:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793380104;
	bh=Ar0206v81QreD1XeYeiPdhGSp/Z+z9/udhIHQEQ/t0w=;
	h=Date:To:From:Subject;
	b=mytZGOrU0Tuh3Frk7XCpmbx7ZiezqWETw6jq+HGCv1DnJF45TYslx5j+VuaVwVAl0
	 wHFf5NM1+D/jvX2fkIiWJ5qa29FgJJt0ciPQsT/7rij/3R+bICoufgGa4hcgCOh9Rj
	 ZhNks1ZC1nEOtFxtZOcRDhUnWCPrbV6PlH4V3i+g=
Date: Fri, 30 Oct 2026 10:08:23 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,tz2294@columbia.edu,
	stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,
	kasong@tencent.com,hughd@google.com,david@kernel.org,chrisl@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	mt4022@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20261030170824.69DED1F00A1E@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/shmem: fix swapin livelock on a mismatched large swap cache folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2568,11 +2568,14 @@ static int shmem_swapin_folio(struct ino
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
@@ -2613,6 +2616,15 @@ failed:
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

mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch
mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch

