From: akpm@linux-foundation.org
Subject: + revert-acpica-fixes-for-unload-and-ddbhandles.patch added to -mm tree
Date: Wed, 07 May 2008 00:47:14 -0700
Message-ID: <200805070747.m477lEYj018591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759503AbYEGHrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 03:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, astarikovskiy@suse.de, len.brown@intel.com, ming.m.lin@intel.com, penberg@cs.helsinki.fi, robert.moore@intel.com, vegard.nossum@gmail.com


The patch titled
     revert "ACPICA: Fixes for Unload and DDBHandles"
has been added to the -mm tree.  Its filename is
     revert-acpica-fixes-for-unload-and-ddbhandles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "ACPICA: Fixes for Unload and DDBHandles"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit bc7a36ab74e09da7bb63e2477b0740ac992b290e
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fixes for Unload and DDBHandles
    
    Implemented support for the use of DDBHandles as an Indexed
    Reference, as per the ACPI spec.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=486.
    
    Implemented support for UserTerm (Method invocation) for the Unload operator
    as per the ACPI spec.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=580
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

Due to a use-after-free identified with kmemcheck.


Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Lin Ming" <ming.m.lin@intel.com>
Cc: "Bob Moore" <robert.moore@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/executer/exdump.c   |   27 ++++++---------------
 drivers/acpi/executer/exresolv.c |   13 +++-------
 drivers/acpi/executer/exstore.c  |   23 +++---------------
 drivers/acpi/parser/psargs.c     |   37 ++---------------------------
 drivers/acpi/utilities/utcopy.c  |    8 ------
 5 files changed, 20 insertions(+), 88 deletions(-)

diff -puN drivers/acpi/executer/exdump.c~revert-acpica-fixes-for-unload-and-ddbhandles drivers/acpi/executer/exdump.c
--- a/drivers/acpi/executer/exdump.c~revert-acpica-fixes-for-unload-and-ddbhandles
+++ a/drivers/acpi/executer/exdump.c
@@ -895,25 +895,14 @@ static void acpi_ex_dump_reference_obj(u
 	} else if (obj_desc->reference.object) {
 		if (ACPI_GET_DESCRIPTOR_TYPE(obj_desc) ==
 		    ACPI_DESC_TYPE_OPERAND) {
-			acpi_os_printf(" Target: %p",
-				       obj_desc->reference.object);
-			if (obj_desc->reference.opcode == AML_LOAD_OP) {
-				/*
-				 * For DDBHandle reference,
-				 * obj_desc->Reference.Object is the table index
-				 */
-				acpi_os_printf(" [DDBHandle]\n");
-			} else {
-				acpi_os_printf(" [%s]\n",
-					       acpi_ut_get_type_name(((union
-								       acpi_operand_object
-								       *)
-								      obj_desc->
-								      reference.
-								      object)->
-								     common.
-								     type));
-			}
+			acpi_os_printf(" Target: %p [%s]\n",
+				       obj_desc->reference.object,
+				       acpi_ut_get_type_name(((union
+							       acpi_operand_object
+							       *)obj_desc->
+							      reference.
+							      object)->common.
+							     type));
 		} else {
 			acpi_os_printf(" Target: %p\n",
 				       obj_desc->reference.object);
diff -puN drivers/acpi/executer/exresolv.c~revert-acpica-fixes-for-unload-and-ddbhandles drivers/acpi/executer/exresolv.c
--- a/drivers/acpi/executer/exresolv.c~revert-acpica-fixes-for-unload-and-ddbhandles
+++ a/drivers/acpi/executer/exresolv.c
@@ -382,10 +382,10 @@ acpi_ex_resolve_multiple(struct acpi_wal
 	}
 
 	/*
-	 * For reference objects created via the ref_of, Index, or Load/load_table
-	 * operators, we need to get to the base object (as per the ACPI
-	 * specification of the object_type and size_of operators). This means
-	 * traversing the list of possibly many nested references.
+	 * For reference objects created via the ref_of or Index operators,
+	 * we need to get to the base object (as per the ACPI specification
+	 * of the object_type and size_of operators). This means traversing
+	 * the list of possibly many nested references.
 	 */
 	while (ACPI_GET_OBJECT_TYPE(obj_desc) == ACPI_TYPE_LOCAL_REFERENCE) {
 		switch (obj_desc->reference.opcode) {
@@ -455,11 +455,6 @@ acpi_ex_resolve_multiple(struct acpi_wal
 			}
 			break;
 
-		case AML_LOAD_OP:
-
-			type = ACPI_TYPE_DDB_HANDLE;
-			goto exit;
-
 		case AML_LOCAL_OP:
 		case AML_ARG_OP:
 
diff -puN drivers/acpi/executer/exstore.c~revert-acpica-fixes-for-unload-and-ddbhandles drivers/acpi/executer/exstore.c
--- a/drivers/acpi/executer/exstore.c~revert-acpica-fixes-for-unload-and-ddbhandles
+++ a/drivers/acpi/executer/exstore.c
@@ -462,24 +462,11 @@ acpi_ex_store_object_to_index(union acpi
 		 */
 		obj_desc = *(index_desc->reference.where);
 
-		if (ACPI_GET_OBJECT_TYPE(source_desc) ==
-		    ACPI_TYPE_LOCAL_REFERENCE
-		    && source_desc->reference.opcode == AML_LOAD_OP) {
-
-			/* This is a DDBHandle, just add a reference to it */
-
-			acpi_ut_add_reference(source_desc);
-			new_desc = source_desc;
-		} else {
-			/* Normal object, copy it */
-
-			status =
-			    acpi_ut_copy_iobject_to_iobject(source_desc,
-							    &new_desc,
-							    walk_state);
-			if (ACPI_FAILURE(status)) {
-				return_ACPI_STATUS(status);
-			}
+		status =
+		    acpi_ut_copy_iobject_to_iobject(source_desc, &new_desc,
+						    walk_state);
+		if (ACPI_FAILURE(status)) {
+			return_ACPI_STATUS(status);
 		}
 
 		if (obj_desc) {
diff -puN drivers/acpi/parser/psargs.c~revert-acpica-fixes-for-unload-and-ddbhandles drivers/acpi/parser/psargs.c
--- a/drivers/acpi/parser/psargs.c~revert-acpica-fixes-for-unload-and-ddbhandles
+++ a/drivers/acpi/parser/psargs.c
@@ -235,7 +235,6 @@ acpi_ps_get_next_namepath(struct acpi_wa
 	union acpi_parse_object *name_op;
 	union acpi_operand_object *method_desc;
 	struct acpi_namespace_node *node;
-	u8 *start = parser_state->aml;
 
 	ACPI_FUNCTION_TRACE(ps_get_next_namepath);
 
@@ -268,16 +267,6 @@ acpi_ps_get_next_namepath(struct acpi_wa
 	 */
 	if (ACPI_SUCCESS(status) &&
 	    possible_method_call && (node->type == ACPI_TYPE_METHOD)) {
-		if (walk_state->op->common.aml_opcode == AML_UNLOAD_OP) {
-			/*
-			 * acpi_ps_get_next_namestring has increased the AML pointer,
-			 * so we need to restore the saved AML pointer for method call.
-			 */
-			walk_state->parser_state.aml = start;
-			walk_state->arg_count = 1;
-			acpi_ps_init_op(arg, AML_INT_METHODCALL_OP);
-			return_ACPI_STATUS(AE_OK);
-		}
 
 		/* This name is actually a control method invocation */
 
@@ -689,29 +678,9 @@ acpi_ps_get_next_arg(struct acpi_walk_st
 				return_ACPI_STATUS(AE_NO_MEMORY);
 			}
 
-			/* To support super_name arg of Unload */
-
-			if (walk_state->op->common.aml_opcode == AML_UNLOAD_OP) {
-				status =
-				    acpi_ps_get_next_namepath(walk_state,
-							      parser_state, arg,
-							      1);
-
-				/*
-				 * If the super_name arg of Unload is a method call,
-				 * we have restored the AML pointer, just free this Arg
-				 */
-				if (arg->common.aml_opcode ==
-				    AML_INT_METHODCALL_OP) {
-					acpi_ps_free_op(arg);
-					arg = NULL;
-				}
-			} else {
-				status =
-				    acpi_ps_get_next_namepath(walk_state,
-							      parser_state, arg,
-							      0);
-			}
+			status =
+			    acpi_ps_get_next_namepath(walk_state, parser_state,
+						      arg, 0);
 		} else {
 			/* Single complex argument, nothing returned */
 
diff -puN drivers/acpi/utilities/utcopy.c~revert-acpica-fixes-for-unload-and-ddbhandles drivers/acpi/utilities/utcopy.c
--- a/drivers/acpi/utilities/utcopy.c~revert-acpica-fixes-for-unload-and-ddbhandles
+++ a/drivers/acpi/utilities/utcopy.c
@@ -742,15 +742,7 @@ acpi_ut_copy_simple_object(union acpi_op
 		/*
 		 * We copied the reference object, so we now must add a reference
 		 * to the object pointed to by the reference
-		 *
-		 * DDBHandle reference (from Load/load_table is a special reference,
-		 * it's Reference.Object is the table index, so does not need to
-		 * increase the reference count
 		 */
-		if (source_desc->reference.opcode == AML_LOAD_OP) {
-			break;
-		}
-
 		acpi_ut_add_reference(source_desc->reference.object);
 		break;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-jg-misc-git-rejects.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

