From: akpm@linux-foundation.org
Subject: + proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch added to -mm tree
Date: Wed, 05 Sep 2012 14:37:15 -0700
Message-ID: <20120905213716.7A0965C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59421 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538Ab2IEVhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Sep 2012 17:37:18 -0400
Received: by eaac1 with SMTP id c1so64259eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Sep 2012 14:37:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clouds.yan@gmail.com


The patch titled
     Subject: proc-use-kzalloc-instead-of-kmalloc-and-memset-fix
has been added to the -mm tree.  Its filename is
     proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-use-kzalloc-instead-of-kmalloc-and-memset-fix

fix __proc_create() coding-style issues, remove unneeded zero-initialisations

Cc: yan <clouds.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset-fix fs/proc/generic.c
--- a/fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset-fix
+++ a/fs/proc/generic.c
@@ -605,7 +605,8 @@ static struct proc_dir_entry *__proc_cre
 	unsigned int len;
 
 	/* make sure name is valid */
-	if (!name || !strlen(name)) goto out;
+	if (!name || !strlen(name))
+		goto out;
 
 	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
@@ -617,18 +618,17 @@ static struct proc_dir_entry *__proc_cre
 	len = strlen(fn);
 
 	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
-	if (!ent) goto out;
+	if (!ent)
+		goto out;
 
 	memcpy(ent->name, fn, len + 1);
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
-	ent->pde_users = 0;
 	spin_lock_init(&ent->pde_unload_lock);
-	ent->pde_unload_completion = NULL;
 	INIT_LIST_HEAD(&ent->pde_openers);
- out:
+out:
 	return ent;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

