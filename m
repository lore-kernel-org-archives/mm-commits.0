From: akpm@linux-foundation.org
Subject: + proc-fix-mount-t-proc-o-aaa.patch added to -mm tree
Date: Fri, 23 Mar 2012 16:15:10 -0700
Message-ID: <20120323231510.CC9FAA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:37788 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2CWXPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 19:15:13 -0400
Received: by wejx9 with SMTP id x9so191069wej.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 16:15:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, a.miskiewicz@gmail.com, adobriyan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: fix mount -t proc -o AAA
has been added to the -mm tree.  Its filename is
     proc-fix-mount-t-proc-o-aaa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasiliy Kulikov <segoon@openwall.com>
Subject: proc: fix mount -t proc -o AAA

The proc_parse_options() call from proc_mount() runs only once at boot
time.  So on any later mount attempt, any mount options are ignored
because ->s_root is already initialized.

As a consequence, "mount -o remount,<options>" will ignore the options.

To fix this, parse the mount options unconditionally.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/proc/root.c~proc-fix-mount-t-proc-o-aaa fs/proc/root.c
--- a/fs/proc/root.c~proc-fix-mount-t-proc-o-aaa
+++ a/fs/proc/root.c
@@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct 
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 
+	if (!proc_parse_options(options, ns)) {
+		deactivate_locked_super(sb);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (!sb->s_root) {
 		sb->s_flags = flags;
-		if (!proc_parse_options(options, ns)) {
-			deactivate_locked_super(sb);
-			return ERR_PTR(-EINVAL);
-		}
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
_
Subject: Subject: proc: fix mount -t proc -o AAA

Patches currently in -mm which might be from segoon@openwall.com are

proc-fix-mount-t-proc-o-aaa.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

