From: akpm@linux-foundation.org
Subject: + acpi-fix-null-bug-for-hid-uid-string-2.patch added to -mm tree
Date: Thu, 06 Aug 2009 16:38:14 -0700
Message-ID: <200908062338.n76NcEOH027773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967AbZHFXiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, Valdis.Kletnieks@vt.edu, ming.m.lin@intel.com


The patch titled
     acpi: fix NULL bug for HID/UID string
has been added to the -mm tree.  Its filename is
     acpi-fix-null-bug-for-hid-uid-string-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix NULL bug for HID/UID string
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

acpi_device->pnp.hardware_id and unique_id are now allocated pointers,
replacing the previous arrays.  acpi_device_install_notify_handler()
oopsed on the NULL hid when probing the video device, and perhaps other
uses are vulnerable too.  So initialize those pointers to empty strings
when there is no hid or uid.  Also, free hardware_id and unique_id when
when acpi_device is going to be freed.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/scan.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/scan.c~acpi-fix-null-bug-for-hid-uid-string-2 drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-fix-null-bug-for-hid-uid-string-2
+++ a/drivers/acpi/scan.c
@@ -309,6 +309,10 @@ static void acpi_device_release(struct d
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	kfree(acpi_dev->pnp.cid_list);
+	if (acpi_dev->flags.hardware_id)
+		kfree(acpi_dev->pnp.hardware_id);
+	if (acpi_dev->flags.unique_id)
+		kfree(acpi_dev->pnp.unique_id);
 	kfree(acpi_dev);
 }
 
@@ -1132,8 +1136,9 @@ static void acpi_device_set_id(struct ac
 			strcpy(device->pnp.hardware_id, hid);
 			device->flags.hardware_id = 1;
 		}
-	} else
-		device->pnp.hardware_id = NULL;
+	}
+	if (!device->flags.hardware_id)
+		device->pnp.hardware_id = "";
 
 	if (uid) {
 		device->pnp.unique_id = ACPI_ALLOCATE_ZEROED(strlen (uid) + 1);
@@ -1141,8 +1146,9 @@ static void acpi_device_set_id(struct ac
 			strcpy(device->pnp.unique_id, uid);
 			device->flags.unique_id = 1;
 		}
-	} else
-		device->pnp.unique_id = NULL;
+	}
+	if (!device->flags.unique_id)
+		device->pnp.unique_id = "";
 
 	if (cid_list || cid_add) {
 		struct acpica_device_id_list *list;
@@ -1357,10 +1363,8 @@ acpi_add_single_object(struct acpi_devic
 end:
 	if (!result)
 		*child = device;
-	else {
-		kfree(device->pnp.cid_list);
-		kfree(device);
-	}
+	else
+		acpi_device_release(&device->dev);
 
 	return result;
 }
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

acpi-fix-null-bug-for-hid-uid-string-2.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

