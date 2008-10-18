From: akpm@linux-foundation.org
Subject: - kernel-sysc-improve-code-generation.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:02 -0700
Message-ID: <200810182312.m9INC2rW027911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbYJRXMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, serue@us.ibm.com, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/sys.c: improve code generation
has been removed from the -mm tree.  Its filename was
     kernel-sysc-improve-code-generation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sys.c: improve code generation
From: Andrew Morton <akpm@linux-foundation.org>

utsname() is quite expensive to calculate.  Cache it in a local.

          text    data     bss     dec     hex filename
before:  11136     720      16   11872    2e60 kernel/sys.o
after:   11096     720      16   11832    2e38 kernel/sys.o

Acked-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-improve-code-generation kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-improve-code-generation
+++ a/kernel/sys.c
@@ -1349,9 +1349,10 @@ asmlinkage long sys_sethostname(char __u
 	down_write(&uts_sem);
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
-		memcpy(utsname()->nodename, tmp, len);
-		memset(utsname()->nodename + len, 0,
-			sizeof(utsname()->nodename) - len);
+		struct new_utsname *u = utsname();
+
+		memcpy(u->nodename, tmp, len);
+		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
@@ -1363,15 +1364,17 @@ asmlinkage long sys_sethostname(char __u
 asmlinkage long sys_gethostname(char __user *name, int len)
 {
 	int i, errno;
+	struct new_utsname *u;
 
 	if (len < 0)
 		return -EINVAL;
 	down_read(&uts_sem);
-	i = 1 + strlen(utsname()->nodename);
+	u = utsname();
+	i = 1 + strlen(u->nodename);
 	if (i > len)
 		i = len;
 	errno = 0;
-	if (copy_to_user(name, utsname()->nodename, i))
+	if (copy_to_user(name, u->nodename, i))
 		errno = -EFAULT;
 	up_read(&uts_sem);
 	return errno;
@@ -1396,9 +1399,10 @@ asmlinkage long sys_setdomainname(char _
 	down_write(&uts_sem);
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
-		memcpy(utsname()->domainname, tmp, len);
-		memset(utsname()->domainname + len, 0,
-			sizeof(utsname()->domainname) - len);
+		struct new_utsname *u = utsname();
+
+		memcpy(u->domainname, tmp, len);
+		memset(u->domainname + len, 0, sizeof(u->domainname) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

