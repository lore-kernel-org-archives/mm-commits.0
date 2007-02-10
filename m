From: akpm@linux-foundation.org
Subject: - fix-utrace-utrace-ptrace-compat.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:28:18 -0800
Message-ID: <200702100528.l1A5SIS7004701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36902 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbXBJF2c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix utrace-utrace-ptrace-compat
has been removed from the -mm tree.  Its filename was
     fix-utrace-utrace-ptrace-compat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix utrace-utrace-ptrace-compat
From: Andrew Morton <akpm@linux-foundation.org>

kernel/ptrace.c: In function 'compat_sys_ptrace':
kernel/ptrace.c:955: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'compat_long_t'

Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ptrace.c~fix-utrace-utrace-ptrace-compat kernel/ptrace.c
--- a/kernel/ptrace.c~fix-utrace-utrace-ptrace-compat
+++ a/kernel/ptrace.c
@@ -952,7 +952,7 @@ asmlinkage long compat_sys_ptrace(compat
 out_tsk:
 	put_task_struct(child);
 out:
-	pr_debug("%d ptrace -> %lx\n", current->pid, ret);
+	pr_debug("%d ptrace -> %lx\n", current->pid, (long)ret);
 	return ret;
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-input.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
