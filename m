From: akpm@linux-foundation.org
Subject: + pass-g-to-assembler-under-config_debug_info-fix.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:02:08 -0700
Message-ID: <200708162102.l7GL28M8006565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756471AbXHPVCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, jason.wessel@windriver.com, roland@redhat.com


The patch titled
     AFLAGS: fix the -g setting
has been added to the -mm tree.  Its filename is
     pass-g-to-assembler-under-config_debug_info-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AFLAGS: fix the -g setting
From: Adrian Bunk <bunk@kernel.org>

It's -gdwarf-2, not -gdwarf2. With this fix it can actually work.

And since even gcc 3.2 supports -gdwarf-2 there's no reason for checking
with as-option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~pass-g-to-assembler-under-config_debug_info-fix Makefile
--- a/Makefile~pass-g-to-assembler-under-config_debug_info-fix
+++ a/Makefile
@@ -499,7 +499,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
-AFLAGS		+= $(call as-option, -gdwarf2)
+AFLAGS		+= -gdwarf-2
 endif
 
 # Force gcc to behave correct even for buggy distributions
_

Patches currently in -mm which might be from bunk@kernel.org are

pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
