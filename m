From: akpm@linux-foundation.org
Subject: [merged] mm-use-may_adjust_brk-helper.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:55 -0700
Message-ID: <543c17cb.bKkDmxYWI53dlUhf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaJMSTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com, jln@google.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use may_adjust_brk helper
has been removed from the -mm tree.  Its filename was
     mm-use-may_adjust_brk-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: use may_adjust_brk helper

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   11 ++++-------
 mm/mmap.c    |    7 +++----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff -puN kernel/sys.c~mm-use-may_adjust_brk-helper kernel/sys.c
--- a/kernel/sys.c~mm-use-may_adjust_brk-helper
+++ a/kernel/sys.c
@@ -1693,7 +1693,6 @@ exit:
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
-	unsigned long rlim = rlimit(RLIMIT_DATA);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int error;
@@ -1733,9 +1732,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (mm->brk - addr) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (check_data_rlimit(rlimit(RLIMIT_DATA), mm->brk, addr,
+				      mm->end_data, mm->start_data))
 			goto out;
 
 		mm->start_brk = addr;
@@ -1745,9 +1743,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (addr - mm->start_brk) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (check_data_rlimit(rlimit(RLIMIT_DATA), addr, mm->start_brk,
+				      mm->end_data, mm->start_data))
 			goto out;
 
 		mm->brk = addr;
diff -puN mm/mmap.c~mm-use-may_adjust_brk-helper mm/mmap.c
--- a/mm/mmap.c~mm-use-may_adjust_brk-helper
+++ a/mm/mmap.c
@@ -268,7 +268,7 @@ static unsigned long do_brk(unsigned lon
 
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
-	unsigned long rlim, retval;
+	unsigned long retval;
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
 	unsigned long min_brk;
@@ -298,9 +298,8 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * segment grow beyond its set limit the in case where the limit is
 	 * not page aligned -Ram Gupta
 	 */
-	rlim = rlimit(RLIMIT_DATA);
-	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
-			(mm->end_data - mm->start_data) > rlim)
+	if (check_data_rlimit(rlimit(RLIMIT_DATA), brk, mm->start_brk,
+			      mm->end_data, mm->start_data))
 		goto out;
 
 	newbrk = PAGE_ALIGN(brk);
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

