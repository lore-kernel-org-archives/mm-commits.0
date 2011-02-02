From: akpm@linux-foundation.org
Subject: [merged] mlock-operate-on-any-regions-with-protection-=-prot_none.patch removed from -mm tree
Date: Wed, 02 Feb 2011 11:41:19 -0800
Message-ID: <201102021941.p12JfJwa023901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489Ab1BBTlj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Feb 2011 14:41:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, tm@tao.ma, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mlock: operate on any regions with protection != PROT_NONE
has been removed from the -mm tree.  Its filename was
     mlock-operate-on-any-regions-with-protection-=-prot_none.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: operate on any regions with protection != PROT_NONE
From: Michel Lespinasse <walken@google.com>

As Tao Ma noticed, 5ecfda0 ("mlock: avoid dirtying pages and triggering
writeback") breaks blktrace.  This is because blktrace mmaps a file with
PROT_WRITE permissions but without PROT_READ, so my attempt to not
unnecessarity break COW during mlock ended up causing mlock to fail with a
permission problem.

Let mlock ignore vma protection in all cases except PROT_NONE.  In
particular, mlock should not fail for PROT_WRITE regions (as in the
blktrace case, which broke at 5ecfda0) or for PROT_EXEC regions (which
seem to me like they were always broken).

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Tao Ma <tm@tao.ma>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/mlock.c~mlock-operate-on-any-regions-with-protection-=-prot_none mm/mlock.c
--- a/mm/mlock.c~mlock-operate-on-any-regions-with-protection-=-prot_none
+++ a/mm/mlock.c
@@ -178,6 +178,13 @@ static long __mlock_vma_pages_range(stru
 	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
+	/*
+	 * We want mlock to succeed for regions that have any permissions
+	 * other than PROT_NONE.
+	 */
+	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
+		gup_flags |= FOLL_FORCE;
+
 	if (vma->vm_flags & VM_LOCKED)
 		gup_flags |= FOLL_MLOCK;
 
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch

