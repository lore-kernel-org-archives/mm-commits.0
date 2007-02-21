From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-architecture-independant-code-license-fix.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:57:06 -0800
Message-ID: <200702212157.l1LLv6tq027621@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50986 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXBUWA1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:00:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, mathieu.desnoyers@polymtl.ca


The patch titled
     marker exports must be EXPORT_SYMBOL_GPL
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-architecture-independant-code-license-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: marker exports must be EXPORT_SYMBOL_GPL
From: Adrian Bunk <bunk@stusta.de>

This is definitely functionality illegal modules have no business to
use.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/module.c~linux-kernel-markers-architecture-independant-code-license-fix kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-architecture-independant-code-license-fix
+++ a/kernel/module.c
@@ -305,7 +305,7 @@ static struct module *find_module(const 
 void __mark_empty_function(const char *fmt, ...)
 {
 }
-EXPORT_SYMBOL(__mark_empty_function);
+EXPORT_SYMBOL_GPL(__mark_empty_function);
 
 #ifdef MARK_POLYMORPHIC
 static int marker_set_ins_enable(void *address, char enable)
@@ -462,7 +462,7 @@ int marker_set_probe(const char *name, c
 	mutex_unlock(&module_mutex);
 	return found;
 }
-EXPORT_SYMBOL(marker_set_probe);
+EXPORT_SYMBOL_GPL(marker_set_probe);
 
 int marker_remove_probe(marker_probe_func *probe)
 {
@@ -482,7 +482,7 @@ int marker_remove_probe(marker_probe_fun
 	mutex_unlock(&module_mutex);
 	return found;
 }
-EXPORT_SYMBOL(marker_remove_probe);
+EXPORT_SYMBOL_GPL(marker_remove_probe);
 
 int marker_list_probe(marker_probe_func *probe)
 {
@@ -506,7 +506,7 @@ int marker_list_probe(marker_probe_func 
 	mutex_unlock(&module_mutex);
 	return found;
 }
-EXPORT_SYMBOL(marker_list_probe);
+EXPORT_SYMBOL_GPL(marker_list_probe);
 #endif
 
 #ifdef CONFIG_SMP
@@ -2511,7 +2511,7 @@ void list_modules(void)
 	}
 	mutex_unlock(&module_mutex);
 }
-EXPORT_SYMBOL(list_modules);
+EXPORT_SYMBOL_GPL(list_modules);
 
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
_

Patches currently in -mm which might be from bunk@stusta.de are

git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-ubi.patch
git-net.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
lumpy-reclaim-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
