From: akpm@osdl.org
Subject: - swsusp-fix-labels.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:50 -0800
Message-ID: <200612072259.kB7MxovO029555@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51100 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163701AbWLGW77 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Fix labels
has been removed from the -mm tree.  Its filename was
     swsusp-fix-labels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Fix labels
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Move all labels in the swsusp code to the second column, so that they won't
fool diff -p.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/disk.c     |    6 +++---
 kernel/power/snapshot.c |    8 ++++----
 kernel/power/swap.c     |    4 ++--
 kernel/power/swsusp.c   |    2 +-
 kernel/power/user.c     |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/power/disk.c~swsusp-fix-labels kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-fix-labels
+++ a/kernel/power/disk.c
@@ -117,9 +117,9 @@ static int prepare_processes(void)
 		return 0;
 
 	platform_finish();
-thaw:
+ thaw:
 	thaw_processes();
-enable_cpus:
+ enable_cpus:
 	enable_nonboot_cpus();
 	pm_restore_console();
 	return error;
@@ -392,7 +392,7 @@ static ssize_t resume_store(struct subsy
 	noresume = 0;
 	software_resume();
 	ret = n;
-out:
+ out:
 	return ret;
 }
 
diff -puN kernel/power/snapshot.c~swsusp-fix-labels kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~swsusp-fix-labels
+++ a/kernel/power/snapshot.c
@@ -411,7 +411,7 @@ memory_bm_create(struct memory_bitmap *b
 	memory_bm_position_reset(bm);
 	return 0;
 
-Free:
+ Free:
 	bm->p_list = ca.chain;
 	memory_bm_free(bm, PG_UNSAFE_CLEAR);
 	return -ENOMEM;
@@ -557,7 +557,7 @@ static unsigned long memory_bm_next_pfn(
 	memory_bm_position_reset(bm);
 	return BM_END_OF_MAP;
 
-Return_pfn:
+ Return_pfn:
 	bm->cur.chunk = chunk;
 	bm->cur.bit = bit;
 	return bb->start_pfn + chunk * BM_BITS_PER_CHUNK + bit;
@@ -964,7 +964,7 @@ swsusp_alloc(struct memory_bitmap *orig_
 	}
 	return 0;
 
-Free:
+ Free:
 	swsusp_free();
 	return -ENOMEM;
 }
@@ -1540,7 +1540,7 @@ prepare_image(struct memory_bitmap *new_
 	}
 	return 0;
 
-Free:
+ Free:
 	swsusp_free();
 	return error;
 }
diff -puN kernel/power/swap.c~swsusp-fix-labels kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-fix-labels
+++ a/kernel/power/swap.c
@@ -301,7 +301,7 @@ static int swap_write_page(struct swap_m
 		handle->cur_swap = offset;
 		handle->k = 0;
 	}
-out:
+ out:
 	return error;
 }
 
@@ -429,7 +429,7 @@ int swsusp_write(void)
 	if (error)
 		free_all_swap_pages(root_swap, handle.bitmap);
 	release_swap_writer(&handle);
-out:
+ out:
 	swsusp_close();
 	return error;
 }
diff -puN kernel/power/swsusp.c~swsusp-fix-labels kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~swsusp-fix-labels
+++ a/kernel/power/swsusp.c
@@ -288,7 +288,7 @@ int swsusp_suspend(void)
 	 * that suspended with irqs off ... no overall powerup.
 	 */
 	device_power_up();
-Enable_irqs:
+ Enable_irqs:
 	local_irq_enable();
 	return error;
 }
diff -puN kernel/power/user.c~swsusp-fix-labels kernel/power/user.c
--- a/kernel/power/user.c~swsusp-fix-labels
+++ a/kernel/power/user.c
@@ -313,7 +313,7 @@ static int snapshot_ioctl(struct inode *
 		if (pm_ops->finish)
 			pm_ops->finish(PM_SUSPEND_MEM);
 
-OutS3:
+ OutS3:
 		mutex_unlock(&pm_mutex);
 		break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

