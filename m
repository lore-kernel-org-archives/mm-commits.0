From: akpm@linux-foundation.org
Subject: [obsolete] revert-selinux-check-open-on-truncate-calls.patch removed from -mm tree
Date: Tue, 05 Jun 2012 12:51:23 -0700
Message-ID: <20120605195124.05DDAA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33588 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2FETvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 15:51:24 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so628014ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 12:51:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eparis@parisplace.org, james.l.morris@oracle.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "SELinux: check OPEN on truncate calls"
has been removed from the -mm tree.  Its filename was
     revert-selinux-check-open-on-truncate-calls.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "SELinux: check OPEN on truncate calls"

This makes FC6 sshd refuse connections - "X11 forwarding request failed on
channel 0".  I can't log in on the console either.

Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN security/selinux/hooks.c~revert-selinux-check-open-on-truncate-calls security/selinux/hooks.c
--- a/security/selinux/hooks.c~revert-selinux-check-open-on-truncate-calls
+++ a/security/selinux/hooks.c
@@ -2703,7 +2703,6 @@ static int selinux_inode_setattr(struct 
 {
 	const struct cred *cred = current_cred();
 	unsigned int ia_valid = iattr->ia_valid;
-	__u32 av = FILE__WRITE;
 
 	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
 	if (ia_valid & ATTR_FORCE) {
@@ -2717,10 +2716,7 @@ static int selinux_inode_setattr(struct 
 			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
 		return dentry_has_perm(cred, dentry, FILE__SETATTR);
 
-	if (ia_valid & ATTR_SIZE)
-		av |= FILE__OPEN;
-
-	return dentry_has_perm(cred, dentry, av);
+	return dentry_has_perm(cred, dentry, FILE__WRITE);
 }
 
 static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
fs-nls-makefile-remove-bogus-config_-assignments.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

