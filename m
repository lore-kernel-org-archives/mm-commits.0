From: akpm@linux-foundation.org
Subject: [merged] proc-fix-mount-t-proc-o-aaa.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:41 -0700
Message-ID: <20120406184841.CDD90A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51472 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2DFSso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:48:44 -0400
Received: by wgbdt11 with SMTP id dt11so142012wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, Valdis.Kletnieks@vt.edu, a.miskiewicz@gmail.com, adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix mount -t proc -o AAA
has been removed from the -mm tree.  Its filename was
     proc-fix-mount-t-proc-o-aaa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasiliy Kulikov <segoon@openwall.com>
Subject: proc: fix mount -t proc -o AAA

The proc_parse_options() call from proc_mount() runs only once at boot
time.  So on any later mount attempt, any mount options are ignored
because ->s_root is already initialized.

As a consequence, "mount -o <options>" will ignore the options.  The only
way to change mount options is "mount -o remount,<options>".

To fix this, parse the mount options unconditionally.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Tested-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
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

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

