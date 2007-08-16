From: akpm@linux-foundation.org
Subject: + allow-disabling-dnotify-without-embedded.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:10:28 -0700
Message-ID: <200708162110.l7GLASNX006894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbXHPVKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:10:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, sfr@canb.auug.org.au


The patch titled
     allow disabling DNOTIFY without EMBEDDED
has been added to the -mm tree.  Its filename is
     allow-disabling-dnotify-without-embedded.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: allow disabling DNOTIFY without EMBEDDED
From: Adrian Bunk <bunk@kernel.org>

Allow disabling DNOTIFY with CONFIG_EMBEDDED=n.

I'm currently running a kernel with dnotify disabled and I haven't run into
any problem.  Is there any popular application left that breaks without
dnotify support in the kernel?

Note that this patch does not remove dnotify support, it still defaults to
"y", and the help text recommends enabling it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/Kconfig~allow-disabling-dnotify-without-embedded fs/Kconfig
--- a/fs/Kconfig~allow-disabling-dnotify-without-embedded
+++ a/fs/Kconfig
@@ -558,7 +558,7 @@ config QUOTACTL
 	default y
 
 config DNOTIFY
-	bool "Dnotify support" if EMBEDDED
+	bool "Dnotify support"
 	default y
 	help
 	  Dnotify is a directory-based per-fd file change notification system
@@ -566,7 +566,7 @@ config DNOTIFY
 	  superior alternatives, but some applications may still rely on
 	  dnotify.
 
-	  Because of this, if unsure, say Y.
+	  If unsure, say Y.
 
 config AUTOFS_FS
 	tristate "Kernel automounter support"
_

Patches currently in -mm which might be from bunk@kernel.org are

pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
if-0-v9fs_fid_lookup_remove.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
