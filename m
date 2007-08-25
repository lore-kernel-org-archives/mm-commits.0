From: akpm@linux-foundation.org
Subject: - tglx-debug.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:22 -0700
Message-ID: <200708250519.l7P5JM5q032035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408AbXHYF2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:28:21 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7P5Rmjr016707
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2007 22:27:49 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     a
has been removed from the -mm tree.  Its filename was
     tglx-debug.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: a
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwsleep.c   |   36 +++++++++++++++++++++
 drivers/acpi/namespace/nsxfeval.c |   39 +++++++++++++++++++++++
 drivers/acpi/sleep/main.c         |    7 ++++
 drivers/acpi/sleep/wakeup.c       |    9 +++++
 include/linux/kernel.h            |    2 +
 kernel/power/disk.c               |   46 ++++++++++++++++++++++++++--
 kernel/power/snapshot.c           |    3 +
 kernel/power/swsusp.c             |   10 +++++-
 8 files changed, 147 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/hardware/hwsleep.c~tglx-debug drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c~tglx-debug
+++ a/drivers/acpi/hardware/hwsleep.c
@@ -67,15 +67,18 @@ acpi_set_firmware_waking_vector(acpi_phy
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector);
+	MMMM();
 
 	/* Get the FACS */
 
 	status =
 	    acpi_get_table_by_index(ACPI_TABLE_INDEX_FACS,
 				    (struct acpi_table_header **)&facs);
+	MMMM();
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
+	MMMM();
 
 	/* Set the vector */
 
@@ -83,13 +86,16 @@ acpi_set_firmware_waking_vector(acpi_phy
 		/*
 		 * ACPI 1.0 FACS or short table or optional X_ field is zero
 		 */
+	MMMM();
 		facs->firmware_waking_vector = (u32) physical_address;
 	} else {
 		/*
 		 * ACPI 2.0 FACS with valid X_ field
 		 */
+	MMMM();
 		facs->xfirmware_waking_vector = physical_address;
 	}
+	MMMM();
 
 	return_ACPI_STATUS(AE_OK);
 }
@@ -492,6 +498,9 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_stat
  *              Called with interrupts ENABLED.
  *
  ******************************************************************************/
+
+int akpm;
+
 acpi_status acpi_leave_sleep_state(u8 sleep_state)
 {
 	struct acpi_object_list arg_list;
@@ -504,6 +513,8 @@ acpi_status acpi_leave_sleep_state(u8 sl
 
 	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
+	MMMM();
+
 	/*
 	 * Set SLP_TYPE and SLP_EN to state S0.
 	 * This is unclear from the ACPI Spec, but it is required
@@ -512,40 +523,50 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	status = acpi_get_sleep_type_data(ACPI_STATE_S0,
 					  &acpi_gbl_sleep_type_a,
 					  &acpi_gbl_sleep_type_b);
+	MMMM();
 	if (ACPI_SUCCESS(status)) {
 		sleep_type_reg_info =
 		    acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_TYPE_A);
 		sleep_enable_reg_info =
 		    acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_ENABLE);
 
+	MMMM();
 		/* Get current value of PM1A control */
 
 		status = acpi_hw_register_read(ACPI_MTX_DO_NOT_LOCK,
 					       ACPI_REGISTER_PM1_CONTROL,
 					       &PM1Acontrol);
+	MMMM();
 		if (ACPI_SUCCESS(status)) {
 
 			/* Clear SLP_EN and SLP_TYP fields */
 
+	MMMM();
 			PM1Acontrol &= ~(sleep_type_reg_info->access_bit_mask |
 					 sleep_enable_reg_info->
 					 access_bit_mask);
+	MMMM();
 			PM1Bcontrol = PM1Acontrol;
 
 			/* Insert SLP_TYP bits */
 
+	MMMM();
 			PM1Acontrol |=
 			    (acpi_gbl_sleep_type_a << sleep_type_reg_info->
 			     bit_position);
+	MMMM();
 			PM1Bcontrol |=
 			    (acpi_gbl_sleep_type_b << sleep_type_reg_info->
 			     bit_position);
+	MMMM();
 
 			/* Just ignore any errors */
+	MMMM();
 
 			(void)acpi_hw_register_write(ACPI_MTX_DO_NOT_LOCK,
 						     ACPI_REGISTER_PM1A_CONTROL,
 						     PM1Acontrol);
+	MMMM();
 			(void)acpi_hw_register_write(ACPI_MTX_DO_NOT_LOCK,
 						     ACPI_REGISTER_PM1B_CONTROL,
 						     PM1Bcontrol);
@@ -554,6 +575,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
 
 	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
 
+	MMMM();
 	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
 
 	/* Setup parameter object */
@@ -561,6 +583,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	arg_list.count = 1;
 	arg_list.pointer = &arg;
 	arg.type = ACPI_TYPE_INTEGER;
+	MMMM();
 
 	/* Ignore any errors from these methods */
 
@@ -569,18 +592,25 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
 	}
+	MMMM();
 
 	arg.integer.value = sleep_state;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
 	}
+	MMMM();
+	dump_stack();
 
+	akpm=1;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
+	akpm=0;
+	MMMM();
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
 	}
 	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
+	MMMM();
 
 	/*
 	 * Restore the GPEs:
@@ -591,28 +621,34 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
+	MMMM();
 	acpi_gbl_system_awake_and_running = TRUE;
+	MMMM();
 
 	status = acpi_hw_enable_all_runtime_gpes();
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
+	MMMM();
 
 	/* Enable power button */
 
 	(void)
 	    acpi_set_register(acpi_gbl_fixed_event_info
 			      [ACPI_EVENT_POWER_BUTTON].enable_register_id, 1);
+	MMMM();
 
 	(void)
 	    acpi_set_register(acpi_gbl_fixed_event_info
 			      [ACPI_EVENT_POWER_BUTTON].status_register_id, 1);
+	MMMM();
 
 	arg.integer.value = ACPI_SST_WORKING;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
 	}
+	MMMM();
 
 	return_ACPI_STATUS(status);
 }
diff -puN drivers/acpi/namespace/nsxfeval.c~tglx-debug drivers/acpi/namespace/nsxfeval.c
--- a/drivers/acpi/namespace/nsxfeval.c~tglx-debug
+++ a/drivers/acpi/namespace/nsxfeval.c
@@ -46,6 +46,8 @@
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
 
+extern int akpm;
+
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsxfeval")
 #ifdef ACPI_FUTURE_USAGE
@@ -174,21 +176,27 @@ acpi_evaluate_object(acpi_handle handle,
 
 	ACPI_FUNCTION_TRACE(acpi_evaluate_object);
 
+	if (akpm) MMMM();
+
 	/* Allocate and initialize the evaluation information block */
 
 	info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
+	if (akpm) MMMM();
 	if (!info) {
 		return_ACPI_STATUS(AE_NO_MEMORY);
 	}
 
+	if (akpm) MMMM();
 	info->pathname = pathname;
 	info->parameter_type = ACPI_PARAM_ARGS;
 
 	/* Convert and validate the device handle */
 
 	info->prefix_node = acpi_ns_map_handle_to_node(handle);
+	if (akpm) MMMM();
 	if (!info->prefix_node) {
 		status = AE_BAD_PARAMETER;
+	if (akpm) MMMM();
 		goto cleanup;
 	}
 
@@ -201,24 +209,30 @@ acpi_evaluate_object(acpi_handle handle,
 		 * Allocate a new parameter block for the internal objects
 		 * Add 1 to count to allow for null terminated internal list
 		 */
+	if (akpm) MMMM();
 		info->parameters = ACPI_ALLOCATE_ZEROED(((acpi_size)
 							 external_params->
 							 count +
 							 1) * sizeof(void *));
+	if (akpm) MMMM();
 		if (!info->parameters) {
 			status = AE_NO_MEMORY;
 			goto cleanup;
 		}
 
+	if (akpm) MMMM();
 		/* Convert each external object in the list to an internal object */
 
 		for (i = 0; i < external_params->count; i++) {
+	if (akpm) MMMM();
 			status =
 			    acpi_ut_copy_eobject_to_iobject(&external_params->
 							    pointer[i],
 							    &info->
 							    parameters[i]);
+	if (akpm) MMMM();
 			if (ACPI_FAILURE(status)) {
+	if (akpm) MMMM();
 				goto cleanup;
 			}
 		}
@@ -235,6 +249,7 @@ acpi_evaluate_object(acpi_handle handle,
 
 		/* The path is fully qualified, just evaluate by name */
 
+	if (akpm) MMMM();
 		info->prefix_node = NULL;
 		status = acpi_ns_evaluate(info);
 	} else if (!handle) {
@@ -243,10 +258,13 @@ acpi_evaluate_object(acpi_handle handle,
 		 * Since we've already handled fully qualified names above, this is
 		 * an error
 		 */
+	if (akpm) MMMM();
 		if (!pathname) {
+	if (akpm) MMMM();
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					  "Both Handle and Pathname are NULL"));
 		} else {
+	if (akpm) MMMM();
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					  "Null Handle with relative pathname [%s]",
 					  pathname));
@@ -256,6 +274,7 @@ acpi_evaluate_object(acpi_handle handle,
 	} else {
 		/* We have a namespace a node and a possible relative path */
 
+	if (akpm) MMMM();
 		status = acpi_ns_evaluate(info);
 	}
 
@@ -264,9 +283,12 @@ acpi_evaluate_object(acpi_handle handle,
 	 * copy the return value to an external object.
 	 */
 	if (return_buffer) {
+	if (akpm) MMMM();
 		if (!info->return_object) {
+	if (akpm) MMMM();
 			return_buffer->length = 0;
 		} else {
+	if (akpm) MMMM();
 			if (ACPI_GET_DESCRIPTOR_TYPE(info->return_object) ==
 			    ACPI_DESC_TYPE_NAMED) {
 				/*
@@ -281,27 +303,33 @@ acpi_evaluate_object(acpi_handle handle,
 				info->return_object = NULL;	/* No need to delete a NS Node */
 				return_buffer->length = 0;
 			}
+	if (akpm) MMMM();
 
 			if (ACPI_SUCCESS(status)) {
 
 				/* Get the size of the returned object */
 
+	if (akpm) MMMM();
 				status =
 				    acpi_ut_get_object_size(info->return_object,
 							    &buffer_space_needed);
+	if (akpm) MMMM();
 				if (ACPI_SUCCESS(status)) {
 
 					/* Validate/Allocate/Clear caller buffer */
 
+	if (akpm) MMMM();
 					status =
 					    acpi_ut_initialize_buffer
 					    (return_buffer,
 					     buffer_space_needed);
+	if (akpm) MMMM();
 					if (ACPI_FAILURE(status)) {
 						/*
 						 * Caller's buffer is too small or a new one can't
 						 * be allocated
 						 */
+	if (akpm) MMMM();
 						ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 								  "Needed buffer size %X, %s\n",
 								  (u32)
@@ -311,6 +339,7 @@ acpi_evaluate_object(acpi_handle handle,
 					} else {
 						/* We have enough space for the object, build it */
 
+	if (akpm) MMMM();
 						status =
 						    acpi_ut_copy_iobject_to_eobject
 						    (info->return_object,
@@ -321,31 +350,41 @@ acpi_evaluate_object(acpi_handle handle,
 		}
 	}
 
+	if (akpm) MMMM();
 	if (info->return_object) {
 		/*
 		 * Delete the internal return object. NOTE: Interpreter must be
 		 * locked to avoid race condition.
 		 */
+		if (akpm) MMMM();
 		acpi_ex_enter_interpreter();
 
 		/* Remove one reference on the return object (should delete it) */
 
+		if (akpm) MMMM();
 		acpi_ut_remove_reference(info->return_object);
+		if (akpm) MMMM();
 		acpi_ex_exit_interpreter();
+		if (akpm) MMMM();
 	}
 
       cleanup:
 
 	/* Free the input parameter list (if we created one) */
 
+	if (akpm) MMMM();
 	if (info->parameters) {
 
 		/* Free the allocated parameter block */
 
+	if (akpm) MMMM();
 		acpi_ut_delete_internal_object_list(info->parameters);
+	if (akpm) MMMM();
 	}
 
 	ACPI_FREE(info);
+	if (akpm) MMMM();
+	if (akpm) dump_stack();
 	return_ACPI_STATUS(status);
 }
 
diff -puN drivers/acpi/sleep/main.c~tglx-debug drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~tglx-debug
+++ a/drivers/acpi/sleep/main.c
@@ -205,15 +205,22 @@ static int acpi_hibernation_enter(void)
 
 static void acpi_hibernation_finish(void)
 {
+	MMMM();
 	acpi_leave_sleep_state(ACPI_STATE_S4);
+	MMMM();
 	acpi_disable_wakeup_device(ACPI_STATE_S4);
+	MMMM();
 
 	/* reset firmware waking vector */
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
+	MMMM();
 
 	if (init_8259A_after_S1) {
+		MMMM();
 		printk("Broken toshiba laptop -> kicking interrupts\n");
+		MMMM();
 		init_8259A(0);
+		MMMM();
 	}
 }
 
diff -puN drivers/acpi/sleep/wakeup.c~tglx-debug drivers/acpi/sleep/wakeup.c
--- a/drivers/acpi/sleep/wakeup.c~tglx-debug
+++ a/drivers/acpi/sleep/wakeup.c
@@ -130,6 +130,7 @@ void acpi_disable_wakeup_device(u8 sleep
 	struct list_head *node, *next;
 
 	ACPI_FUNCTION_TRACE("acpi_disable_wakeup_device");
+	MMMM();
 
 	spin_lock(&acpi_device_lock);
 	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
@@ -137,6 +138,7 @@ void acpi_disable_wakeup_device(u8 sleep
 						       struct acpi_device,
 						       wakeup_list);
 
+	MMMM();
 		if (dev->wakeup.flags.run_wake && !dev->wakeup.state.enabled) {
 			spin_unlock(&acpi_device_lock);
 			acpi_set_gpe_type(dev->wakeup.gpe_device,
@@ -149,13 +151,17 @@ void acpi_disable_wakeup_device(u8 sleep
 			continue;
 		}
 
+	MMMM();
 		if (!dev->wakeup.flags.valid ||
 		    !dev->wakeup.state.active ||
 		    (sleep_state > (u32) dev->wakeup.sleep_state))
 			continue;
+	MMMM();
 
 		spin_unlock(&acpi_device_lock);
+	MMMM();
 		acpi_disable_wakeup_device_power(dev);
+	MMMM();
 		/* Never disable run-wake GPE */
 		if (!dev->wakeup.flags.run_wake) {
 			acpi_disable_gpe(dev->wakeup.gpe_device,
@@ -163,10 +169,13 @@ void acpi_disable_wakeup_device(u8 sleep
 			acpi_clear_gpe(dev->wakeup.gpe_device,
 				       dev->wakeup.gpe_number, ACPI_NOT_ISR);
 		}
+	MMMM();
 		dev->wakeup.state.active = 0;
 		spin_lock(&acpi_device_lock);
+	MMMM();
 	}
 	spin_unlock(&acpi_device_lock);
+	MMMM();
 }
 
 static int acpi_platform_enable_wakeup(struct device *dev, int is_on)
diff -puN include/linux/kernel.h~tglx-debug include/linux/kernel.h
--- a/include/linux/kernel.h~tglx-debug
+++ a/include/linux/kernel.h
@@ -17,6 +17,8 @@
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
+#define MMMM()	printk("%s:%d\n", __FILE__, __LINE__)
+
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
diff -puN kernel/power/disk.c~tglx-debug kernel/power/disk.c
--- a/kernel/power/disk.c~tglx-debug
+++ a/kernel/power/disk.c
@@ -87,8 +87,11 @@ static int platform_prepare(void)
 
 static void platform_finish(void)
 {
-	if (hibernation_mode == HIBERNATION_PLATFORM && hibernation_ops)
+	if (hibernation_mode == HIBERNATION_PLATFORM && hibernation_ops) {
+		printk("%p\n", hibernation_ops->finish);
+		MMMM();
 		hibernation_ops->finish();
+	}
 }
 
 /**
@@ -157,14 +160,17 @@ int hibernate(void)
 		return -EBUSY;
 
 	/* Allocate memory management structures */
+	MMMM();
 	error = create_basic_memory_bitmaps();
 	if (error)
 		goto Exit;
 
+	MMMM();
 	error = prepare_processes();
 	if (error)
 		goto Finish;
 
+	MMMM();
 	mutex_lock(&pm_mutex);
 	if (hibernation_mode == HIBERNATION_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
@@ -173,65 +179,99 @@ int hibernate(void)
 	}
 
 	/* Free memory before shutting down devices. */
+	MMMM();
 	error = swsusp_shrink_memory();
 	if (error)
 		goto Thaw;
 
+	MMMM();
 	error = platform_prepare();
 	if (error)
 		goto Thaw;
 
+	MMMM();
 	suspend_console();
+	MMMM();
 	error = device_suspend(PMSG_FREEZE);
+	MMMM();
 	if (error) {
+		MMMM();
 		printk(KERN_ERR "PM: Some devices failed to suspend\n");
 		goto Resume_devices;
 	}
+	MMMM();
 	error = disable_nonboot_cpus();
 	if (error)
 		goto Enable_cpus;
 
+	MMMM();
 	if (hibernation_mode == HIBERNATION_TEST) {
+		MMMM();
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
 		goto Enable_cpus;
 	}
 
+	MMMM();
 	pr_debug("PM: snapshotting memory.\n");
 	in_suspend = 1;
+	MMMM();
 	error = swsusp_suspend();
+	MMMM();
 	if (error)
 		goto Enable_cpus;
 
 	if (in_suspend) {
+		MMMM();
 		enable_nonboot_cpus();
+		MMMM();
 		platform_finish();
+		MMMM();
 		device_resume();
+		MMMM();
 		resume_console();
+		MMMM();
 		pr_debug("PM: writing image.\n");
+		MMMM();
 		error = swsusp_write();
-		if (!error)
+		MMMM();
+		if (!error) {
+			MMMM();
 			power_down();
-		else {
+		} else {
+			MMMM();
 			swsusp_free();
+			MMMM();
 			goto Thaw;
 		}
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
 	}
 
+	MMMM();
 	swsusp_free();
+	MMMM();
  Enable_cpus:
+	MMMM();
 	enable_nonboot_cpus();
+	MMMM();
  Resume_devices:
+	MMMM();
 	platform_finish();
+	MMMM();
 	device_resume();
+	MMMM();
 	resume_console();
+	MMMM();
  Thaw:
 	mutex_unlock(&pm_mutex);
+	MMMM();
 	unprepare_processes();
+	MMMM();
  Finish:
+	MMMM();
 	free_basic_memory_bitmaps();
+	MMMM();
  Exit:
 	atomic_inc(&snapshot_device_available);
 	return error;
diff -puN kernel/power/snapshot.c~tglx-debug kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~tglx-debug
+++ a/kernel/power/snapshot.c
@@ -1234,7 +1234,8 @@ asmlinkage int swsusp_save(void)
 	nr_meta_pages = DIV_ROUND_UP(nr_pages * sizeof(long), PAGE_SIZE);
 
 	printk("swsusp: critical section: done (%d pages copied)\n", nr_pages);
-
+	MMMM();
+	dump_stack();
 	return 0;
 }
 
diff -puN kernel/power/swsusp.c~tglx-debug kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~tglx-debug
+++ a/kernel/power/swsusp.c
@@ -274,9 +274,11 @@ int swsusp_suspend(void)
 {
 	int error;
 
+	MMMM();
 	if ((error = arch_prepare_suspend()))
 		return error;
 
+	MMMM();
 	local_irq_disable();
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* device_power_down() now.
@@ -284,22 +286,28 @@ int swsusp_suspend(void)
 	 * become desynchronized with the actual state of the hardware
 	 * at resume time, and evil weirdness ensues.
 	 */
+	MMMM();
 	if ((error = device_power_down(PMSG_FREEZE))) {
 		printk(KERN_ERR "Some devices failed to power down, aborting suspend\n");
 		goto Enable_irqs;
 	}
-
+	MMMM();
 	save_processor_state();
 	if ((error = swsusp_arch_suspend()))
 		printk(KERN_ERR "Error %d suspending\n", error);
+	MMMM();
 	/* Restore control flow magically appears here */
 	restore_processor_state();
+	MMMM();
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
 	device_power_up();
+	MMMM();
  Enable_irqs:
+	MMMM();
 	local_irq_enable();
+	MMMM();
 	return error;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-ecryptfs-fix-lookup-error-for-special-files.patch
process_zones-fix-recovery-code.patch
remove-bdput-from-do_open-in-fs-block_devc.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
sysfs-crash-debugging.patch
git-dma.patch
git-dma-makefile-fix.patch
disable-ioat.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
adbhid-produce-all-capslock-key-events.patch
iforce-warning-fix.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mmc.patch
git-mmc-fixup.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-net-fixup.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-wireless-printk-fixes.patch
net-add-ath5k-wireless-driver-fix.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
alloc_pages-permit-get_zeroed_pagegfp_atomic-from-interrupt-context.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
