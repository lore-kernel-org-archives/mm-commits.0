From: akpm@linux-foundation.org
Subject: - powerpc-proper-defconfig-for-crosscompiles.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:44 -0700
Message-ID: <200710051956.l95Jui2I022386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193AbXJET5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, benh@kernel.crashing.org, olof@lixom.net, paulus@samba.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: proper defconfig for crosscompiles
has been removed from the -mm tree.  Its filename was
     powerpc-proper-defconfig-for-crosscompiles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: proper defconfig for crosscompiles
From: Adrian Bunk <bunk@kernel.org>

The trick for finding the right defconfig is neat, but you forgot to
provide an i686_defconfig.  ;-)

More seriously, cross compiling the defconfig is often useful, e.g. for
testing the compilation of patches that touch multiple architectures,
and this patch therefore chooses g5_defconfig if $(CROSS_COMPILE) is
non-empty.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/powerpc/Makefile~powerpc-proper-defconfig-for-crosscompiles arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-proper-defconfig-for-crosscompiles
+++ a/arch/powerpc/Makefile
@@ -35,7 +35,11 @@ endif
 
 export CROSS32CC CROSS32AS CROSS32LD CROSS32AR CROSS32OBJCOPY
 
+ifeq ($(CROSS_COMPILE),)
 KBUILD_DEFCONFIG := $(shell uname -m)_defconfig
+else
+KBUILD_DEFCONFIG := ppc64_defconfig
+endif
 
 ifeq ($(CONFIG_PPC64),y)
 OLDARCH	:= ppc64
_

Patches currently in -mm which might be from bunk@kernel.org are

git-alsa.patch
git-arm.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-net.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-block.patch
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
