From: akpm@linux-foundation.org
Subject: + shmem-avoid-maybe-uninitialized-warning.patch added to -mm tree
Date: Tue, 25 Oct 2016 13:21:41 -0700
Message-ID: <580fbed5.YEAeepAL5lLPF+RA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37513 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932301AbcJYUVm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 16:21:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, agruenba@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: avoid maybe-uninitialized warning
has been added to the -mm tree.  Its filename is
     shmem-avoid-maybe-uninitialized-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-avoid-maybe-uninitialized-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-avoid-maybe-uninitialized-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: shmem: avoid maybe-uninitialized warning

After enabling -Wmaybe-uninitialized warnings, we get a false-postive
warning for shmem:

mm/shmem.c: In function `shmem_getpage_gfp':
include/linux/spinlock.h:332:21: error: `info' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This can be easily avoided, since the correct 'info' pointer is known at
the time we first enter the function, so we can simply move the
initialization up.  Moving it before the first label avoids the warning
and lets us remove two later initializations.

Note that the function is so hard to read that it not only confuses the
compiler, but also most readers and without this patch it could\ easily
break if one of the 'goto's changed.

Link: https://www.spinics.net/lists/kernel/msg2368133.html
Link: http://lkml.kernel.org/r/20161024205725.786455-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/shmem.c~shmem-avoid-maybe-uninitialized-warning mm/shmem.c
--- a/mm/shmem.c~shmem-avoid-maybe-uninitialized-warning
+++ a/mm/shmem.c
@@ -1537,7 +1537,7 @@ static int shmem_getpage_gfp(struct inod
 	struct mm_struct *fault_mm, int *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct shmem_inode_info *info;
+	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
 	struct mem_cgroup *memcg;
@@ -1587,7 +1587,6 @@ repeat:
 	 * Fast cache lookup did not find it:
 	 * bring it back from swap or allocate.
 	 */
-	info = SHMEM_I(inode);
 	sbinfo = SHMEM_SB(inode->i_sb);
 	charge_mm = fault_mm ? : current->mm;
 
@@ -1840,7 +1839,6 @@ unlock:
 		put_page(page);
 	}
 	if (error == -ENOSPC && !once++) {
-		info = SHMEM_I(inode);
 		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
 		spin_unlock_irq(&info->lock);
_

Patches currently in -mm which might be from arnd@arndb.de are

slub-avoid-false-postive-warning.patch
shmem-avoid-maybe-uninitialized-warning.patch

