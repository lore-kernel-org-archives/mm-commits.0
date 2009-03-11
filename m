From: akpm@linux-foundation.org
Subject: [merged] dvb-frontends-fix-duplicate-debug-symbol.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:59 -0700
Message-ID: <200903111809.n2BI9x7t020022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691AbZCKSMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dvb/frontends: fix duplicate 'debug' symbol
has been removed from the -mm tree.  Its filename was
     dvb-frontends-fix-duplicate-debug-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb/frontends: fix duplicate 'debug' symbol
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix dvb frontend debug variable to be static, to avoid linker
errors:

drivers/built-in.o:(.data+0xf4b0): multiple definition of `debug'
arch/x86/kernel/built-in.o:(.kprobes.text+0x90): first defined here
ld: Warning: size of symbol `debug' changed from 85 in arch/x86/kernel/built-in.o to 4 in drivers/built-in.o

It would also be Good if arch/x86/kernel/entry_32.S didn't have a
non-static 'debug' symbol.  OTOH, it helps catch things like this one.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stv0900_core.c |    4 ++--
 drivers/media/dvb/frontends/stv0900_priv.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/dvb/frontends/stv0900_core.c~dvb-frontends-fix-duplicate-debug-symbol drivers/media/dvb/frontends/stv0900_core.c
--- a/drivers/media/dvb/frontends/stv0900_core.c~dvb-frontends-fix-duplicate-debug-symbol
+++ a/drivers/media/dvb/frontends/stv0900_core.c
@@ -34,8 +34,8 @@
 #include "stv0900_priv.h"
 #include "stv0900_init.h"
 
-int debug = 1;
-module_param(debug, int, 0644);
+static int stvdebug = 1;
+module_param_named(debug, stvdebug, int, 0644);
 
 /* internal params node */
 struct stv0900_inode {
diff -puN drivers/media/dvb/frontends/stv0900_priv.h~dvb-frontends-fix-duplicate-debug-symbol drivers/media/dvb/frontends/stv0900_priv.h
--- a/drivers/media/dvb/frontends/stv0900_priv.h~dvb-frontends-fix-duplicate-debug-symbol
+++ a/drivers/media/dvb/frontends/stv0900_priv.h
@@ -62,11 +62,11 @@
 
 #define dmd_choose(a, b)	(demod = STV0900_DEMOD_2 ? b : a))
 
-extern int debug;
+static int stvdebug;
 
 #define dprintk(args...) \
 	do { \
-		if (debug) \
+		if (stvdebug) \
 			printk(KERN_DEBUG args); \
 	} while (0)
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
git-acpi-vs-git-cpufreq.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
wimax-fix-i2400m-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
alpha-convert-u64-to-unsigned-long-long.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

