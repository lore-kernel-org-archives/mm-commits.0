From: akpm@linux-foundation.org
Subject: - cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:51:48 -0700
Message-ID: <200810182351.m9INpmct001806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbYJRXwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix
has been removed from the -mm tree.  Its filename was
     cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch

This patch was dropped because it was folded into cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix
+++ a/kernel/cgroup.c
@@ -259,6 +259,7 @@ static void __release_css_set(struct kre
 
 	write_lock(&css_set_lock);
 	if (atomic_read(&k->refcount) > 0) {
+		/* See find_css_set()'s read_lock()ed section */
 		write_unlock(&css_set_lock);
 		return;
 	}
@@ -425,7 +426,7 @@ static struct css_set *find_css_set(
 	 * __release_css_set() will re-check the refcount
 	 * with css_set_lock held.
 	 *
-	 * This race may trigger the warnning in kref_get().
+	 * This race may trigger the warning in kref_get().
 	 */
 	if (res)
 		get_css_set(res);
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
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

