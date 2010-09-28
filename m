From: akpm@linux-foundation.org
Subject: + vfs-remove-a-warning-on-open_fmode.patch added to -mm tree
Date: Tue, 28 Sep 2010 14:39:44 -0700
Message-ID: <201009282139.o8SLdiJQ019365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639Ab0I1Vjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 17:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: sparse: remove a warning on OPEN_FMODE()
has been added to the -mm tree.  Its filename is
     vfs-remove-a-warning-on-open_fmode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: sparse: remove a warning on OPEN_FMODE()
From: Namhyung Kim <namhyung@gmail.com>

AND-ing FMODE_* constant with normal integer results in following
sparse warnings. Fix it.

 fs/open.c:662:21: warning: restricted fmode_t degrades to integer
 fs/anon_inodes.c:123:34: warning: restricted fmode_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/fs.h~vfs-remove-a-warning-on-open_fmode include/linux/fs.h
--- a/include/linux/fs.h~vfs-remove-a-warning-on-open_fmode
+++ a/include/linux/fs.h
@@ -2485,9 +2485,11 @@ int proc_nr_files(struct ctl_table *tabl
 
 int __init get_filesystem_list(char *buf);
 
+#define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
+
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
 #define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) | \
-					    (flag & FMODE_NONOTIFY)))
+					    (flag & __FMODE_NONOTIFY)))
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

