From: akpm@linux-foundation.org
Subject: - memory_probe-fix-wrong-sysfs-file-attribute-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:40:15 -0700
Message-ID: <200810182340.m9INeFm7032642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbYJRXk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, randy.dunlap@oracle.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     memory_probe-fix-wrong-sysfs-file-attribute-fix
has been removed from the -mm tree.  Its filename was
     memory_probe-fix-wrong-sysfs-file-attribute-fix.patch

This patch was dropped because it was folded into memory_probe-fix-wrong-sysfs-file-attribute.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_probe-fix-wrong-sysfs-file-attribute-fix
From: Andrew Morton <akpm@linux-foundation.org>

Use S_IWUSR as suggested by Randy.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory_probe-fix-wrong-sysfs-file-attribute-fix drivers/base/memory.c
--- a/drivers/base/memory.c~memory_probe-fix-wrong-sysfs-file-attribute-fix
+++ a/drivers/base/memory.c
@@ -21,6 +21,8 @@
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/stat.h>
+
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
@@ -325,7 +327,7 @@ memory_probe_store(struct class *class, 
 
 	return count;
 }
-static CLASS_ATTR(probe, 0200, NULL, memory_probe_store);
+static CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 
 static int memory_probe_init(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
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

