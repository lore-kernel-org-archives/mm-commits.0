From: akpm@linux-foundation.org
Subject: [merged] menu-fix-embedded-menu-snafu.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:21 -0700
Message-ID: <200903111809.n2BI9LbZ019930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbZCKSKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     menu: fix embedded menu snafu
has been removed from the -mm tree.  Its filename was
     menu-fix-embedded-menu-snafu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: menu: fix embedded menu snafu
From: Randy Dunlap <randy.dunlap@oracle.com>

The COMPAT_BRK kconfig symbol does not depend on EMBEDDED, but it is in
the midst of the EMBEDDED menu symbols, so it mucks up the EMBEDDED menu. 
Fix by moving it to just after all of the EMBEDDED menu symbols.  Also,
ANON_INODES has a similar problem, so move it to just above the EMBEDDED
menu items since it is used in the EMBEDDED menu.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN init/Kconfig~menu-fix-embedded-menu-snafu init/Kconfig
--- a/init/Kconfig~menu-fix-embedded-menu-snafu
+++ a/init/Kconfig
@@ -675,6 +675,9 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config ANON_INODES
+	bool
+
 menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
@@ -780,18 +783,6 @@ config PCSPKR_PLATFORM
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
-config COMPAT_BRK
-	bool "Disable heap randomization"
-	default y
-	help
-	  Randomizing heap placement makes heap exploits harder, but it
-	  also breaks ancient binaries (including anything libc5 based).
-	  This option changes the bootup default to heap randomization
-	  disabled, and can be overriden runtime by setting
-	  /proc/sys/kernel/randomize_va_space to 2.
-
-	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
-
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EMBEDDED
@@ -809,9 +800,6 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
-config ANON_INODES
-	bool
-
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
@@ -897,6 +885,18 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config COMPAT_BRK
+	bool "Disable heap randomization"
+	default y
+	help
+	  Randomizing heap placement makes heap exploits harder, but it
+	  also breaks ancient binaries (including anything libc5 based).
+	  This option changes the bootup default to heap randomization
+	  disabled, and can be overriden runtime by setting
+	  /proc/sys/kernel/randomize_va_space to 2.
+
+	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
+
 choice
 	prompt "Choose SLAB allocator"
 	default SLUB
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

