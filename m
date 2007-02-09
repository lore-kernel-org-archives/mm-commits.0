From: akpm@linux-foundation.org
Subject: + selinux-enhance-selinux-to-always-ignore-private-inodes.patch added to -mm tree
Date: Fri, 09 Feb 2007 03:04:17 -0800
Message-ID: <200702091104.l19B4HjX011421@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946361AbXBILE7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 06:04:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sds@tycho.nsa.gov, ebiederm@xmission.com


The patch titled
     selinux: Enhance selinux to always ignore private inodes.
has been added to the -mm tree.  Its filename is
     selinux-enhance-selinux-to-always-ignore-private-inodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: selinux: Enhance selinux to always ignore private inodes.
From: Stephen Smalley <sds@tycho.nsa.gov>

Hmmm...turns out to not be quite enough, as the /proc/sys inodes aren't truly
private to the fs, so we can run into them in a variety of security hooks
beyond just the inode hooks, such as security_file_permission (when reading
and writing them via the vfs helpers), security_sb_mount (when mounting other
filesystems on directories in proc like binfmt_misc), and deeper within the
security module itself (as in flush_unauthorized_files upon inheritance across
execve).  So I think we have to add an IS_PRIVATE() guard within SELinux, as
below.  Note however that the use of the private flag here could be confusing,
as these inodes are _not_ private to the fs, are exposed to userspace, and
security modules must implement the sysctl hook to get any access control over
them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN security/selinux/hooks.c~selinux-enhance-selinux-to-always-ignore-private-inodes security/selinux/hooks.c
--- a/security/selinux/hooks.c~selinux-enhance-selinux-to-always-ignore-private-inodes
+++ a/security/selinux/hooks.c
@@ -1077,6 +1077,9 @@ static int inode_has_perm(struct task_st
 	struct inode_security_struct *isec;
 	struct avc_audit_data ad;
 
+	if (unlikely (IS_PRIVATE (inode)))
+		return 0;
+
 	tsec = tsk->security;
 	isec = inode->i_security;
 
_

Patches currently in -mm which might be from sds@tycho.nsa.gov are

origin.patch
implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
make-reading-proc-sys-kernel-cap-bould-not-require.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-main-include-fix.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-documentation.patch
panic-on-slim-selinux.patch
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-2.patch
selinux-enhance-selinux-to-always-ignore-private-inodes.patch
