From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-unwinder.patch removed from -mm tree
Date: Tue, 02 Oct 2007 14:44:00 -0700
Message-ID: <200710022144.l92Li0HV023839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbXJBVoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 17:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ak@suse.de, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     remove unwind exports
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-unwinder.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: remove unwind exports
From: Adrian Bunk <bunk@kernel.org>

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
> +x86_64-mm-unwinder.patch
>...
>  x86 tree updates
>...

This patch removes the unused unwind exports.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/unwind.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/unwind.c~fix-x86_64-mm-unwinder kernel/unwind.c
--- a/kernel/unwind.c~fix-x86_64-mm-unwinder
+++ a/kernel/unwind.c
@@ -1243,7 +1243,6 @@ int unwind(struct unwind_frame_info *fra
 #undef CASES
 #undef FRAME_REG
 }
-EXPORT_SYMBOL(unwind);
 
 int unwind_init_frame_info(struct unwind_frame_info *info,
                            struct task_struct *tsk,
@@ -1255,7 +1254,6 @@ int unwind_init_frame_info(struct unwind
 
 	return 0;
 }
-EXPORT_SYMBOL(unwind_init_frame_info);
 
 /*
  * Prepare to unwind a blocked task.
@@ -1269,7 +1267,6 @@ int unwind_init_blocked(struct unwind_fr
 
 	return 0;
 }
-EXPORT_SYMBOL(unwind_init_blocked);
 
 /*
  * Prepare to unwind the currently running thread.
@@ -1284,5 +1281,4 @@ int unwind_init_running(struct unwind_fr
 
 	return arch_unwind_init_running(info, callback, arg);
 }
-EXPORT_SYMBOL(unwind_init_running);
 
_

Patches currently in -mm which might be from bunk@kernel.org are

git-alsa.patch
git-arm.patch
git-powerpc.patch
powerpc-proper-defconfig-for-crosscompiles.patch
git-dvb.patch
git-kbuild.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
git-net.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-block.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
isdn-hisax-hfc_usbc-fix-check-after-use.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
