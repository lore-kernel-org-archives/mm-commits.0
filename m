From: akpm@linux-foundation.org
Subject: [folded-dropped] proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:03:14 -0700
Message-ID: <20121005000315.89491200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:57342 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2JEADS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:03:18 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so51690lah.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:03:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clouds.yan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-use-kzalloc-instead-of-kmalloc-and-memset-fix
has been removed from the -mm tree.  Its filename was
     proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch

This patch was dropped because it was folded into proc-use-kzalloc-instead-of-kmalloc-and-memset.patch

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
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
idr-rename-max_level-to-max_idr_level.patch
lib-parserc-avoid-overflow-in-match_number.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch
rtc-add-dallas-ds2404-driver.patch
fat-simplify-writeback_inode.patch
coredump-make-core-dump-functionality-optional.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

