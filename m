From: akpm@linux-foundation.org
Subject: - revert-acpica-fixes-for-unload-and-ddbhandles.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:44 -0700
Message-ID: <200805162253.m4GMriHA003166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756758AbYEPWx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, astarikovskiy@suse.de, len.brown@intel.com, ming.m.lin@intel.com, penberg@cs.helsinki.fi, robert.moore@intel.com, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     revert "ACPICA: Fixes for Unload and DDBHandles"
has been removed from the -mm tree.  Its filename was
     revert-acpica-fixes-for-unload-and-ddbhandles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
audit_send_reply-fix-error-path-memory-leak.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-vfs-cleanups-reject.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
git-xtensa.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
spufs-use-the-new-vm_ops-access-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
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

