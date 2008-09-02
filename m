From: akpm@linux-foundation.org
Subject: - drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:43 -0700
Message-ID: <200809022041.m82Kfh22011658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYIBUmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cordsam@linux.vnet.ibm.com, cordesam@gmail.com, jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers-pci-hotplug-ibmphp_ebda.c: list_for_each to list_for_each_entry
has been removed from the -mm tree.  Its filename was
     drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-pci-hotplug-ibmphp_ebda.c: list_for_each to list_for_each_entry
From: Cordelia Sam <cordsam@linux.vnet.ibm.com>

Make code more readable with list_for_each_entry().

Signed-off-by: Cordelia Sam <cordesam@gmail.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_ebda.c |   92 +++++++---------------------
 1 file changed, 23 insertions(+), 69 deletions(-)

diff -puN drivers/pci/hotplug/ibmphp_ebda.c~drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry drivers/pci/hotplug/ibmphp_ebda.c
--- a/drivers/pci/hotplug/ibmphp_ebda.c~drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry
+++ a/drivers/pci/hotplug/ibmphp_ebda.c
@@ -123,10 +123,8 @@ static struct ebda_pci_rsrc *alloc_ebda_
 static void __init print_bus_info (void)
 {
 	struct bus_info *ptr;
-	struct list_head *ptr1;
 	
-	list_for_each (ptr1, &bus_info_head) {
-		ptr = list_entry (ptr1, struct bus_info, bus_info_list);
+	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {
 		debug ("%s - slot_min = %x\n", __func__, ptr->slot_min);
 		debug ("%s - slot_max = %x\n", __func__, ptr->slot_max);
 		debug ("%s - slot_count = %x\n", __func__, ptr->slot_count);
@@ -146,10 +144,8 @@ static void __init print_bus_info (void)
 static void print_lo_info (void)
 {
 	struct rio_detail *ptr;
-	struct list_head *ptr1;
 	debug ("print_lo_info ----\n");	
-	list_for_each (ptr1, &rio_lo_head) {
-		ptr = list_entry (ptr1, struct rio_detail, rio_detail_list);
+	list_for_each_entry (ptr, &rio_lo_head, rio_detail_list) {
 		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
 		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
 		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
@@ -163,10 +159,8 @@ static void print_lo_info (void)
 static void print_vg_info (void)
 {
 	struct rio_detail *ptr;
-	struct list_head *ptr1;
 	debug ("%s ---\n", __func__);
-	list_for_each (ptr1, &rio_vg_head) {
-		ptr = list_entry (ptr1, struct rio_detail, rio_detail_list);
+	list_for_each_entry (ptr, &rio_vg_head, rio_detail_list) {
 		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
 		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
 		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
@@ -180,10 +174,8 @@ static void print_vg_info (void)
 static void __init print_ebda_pci_rsrc (void)
 {
 	struct ebda_pci_rsrc *ptr;
-	struct list_head *ptr1;
 
-	list_for_each (ptr1, &ibmphp_ebda_pci_rsrc_head) {
-		ptr = list_entry (ptr1, struct ebda_pci_rsrc, ebda_pci_rsrc_list);
+	list_for_each_entry (ptr, &ibmphp_ebda_pci_rsrc_head, ebda_pci_rsrc_list) {
 		debug ("%s - rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n", 
 			__func__, ptr->rsrc_type ,ptr->bus_num, ptr->dev_fun,ptr->start_addr, ptr->end_addr);
 	}
@@ -192,10 +184,8 @@ static void __init print_ebda_pci_rsrc (
 static void __init print_ibm_slot (void)
 {
 	struct slot *ptr;
-	struct list_head *ptr1;
 
-	list_for_each (ptr1, &ibmphp_slot_head) {
-		ptr = list_entry (ptr1, struct slot, ibm_slot_list);
+	list_for_each_entry (ptr, &ibmphp_slot_head, ibm_slot_list) {
 		debug ("%s - slot_number: %x\n", __func__, ptr->number);
 	}
 }
@@ -203,10 +193,8 @@ static void __init print_ibm_slot (void)
 static void __init print_opt_vg (void)
 {
 	struct opt_rio *ptr;
-	struct list_head *ptr1;
 	debug ("%s ---\n", __func__);
-	list_for_each (ptr1, &opt_vg_head) {
-		ptr = list_entry (ptr1, struct opt_rio, opt_rio_list);
+	list_for_each_entry (ptr, &opt_vg_head, opt_rio_list) {
 		debug ("%s - rio_type %x\n", __func__, ptr->rio_type);
 		debug ("%s - chassis_num: %x\n", __func__, ptr->chassis_num);
 		debug ("%s - first_slot_num: %x\n", __func__, ptr->first_slot_num);
@@ -217,13 +205,9 @@ static void __init print_opt_vg (void)
 static void __init print_ebda_hpc (void)
 {
 	struct controller *hpc_ptr;
-	struct list_head *ptr1;
 	u16 index;
 
-	list_for_each (ptr1, &ebda_hpc_head) {
-
-		hpc_ptr = list_entry (ptr1, struct controller, ebda_hpc_list); 
-
+	list_for_each_entry (hpc_ptr, &ebda_hpc_head, ebda_hpc_list) {
 		for (index = 0; index < hpc_ptr->slot_count; index++) {
 			debug ("%s - physical slot#: %x\n", __func__, hpc_ptr->slots[index].slot_num);
 			debug ("%s - pci bus# of the slot: %x\n", __func__, hpc_ptr->slots[index].slot_bus_num);
@@ -460,9 +444,7 @@ static int __init ebda_rio_table (void)
 static struct opt_rio *search_opt_vg (u8 chassis_num)
 {
 	struct opt_rio *ptr;
-	struct list_head *ptr1;
-	list_for_each (ptr1, &opt_vg_head) {
-		ptr = list_entry (ptr1, struct opt_rio, opt_rio_list);
+	list_for_each_entry (ptr, &opt_vg_head, opt_rio_list) {
 		if (ptr->chassis_num == chassis_num)
 			return ptr;
 	}		
@@ -473,10 +455,8 @@ static int __init combine_wpg_for_chassi
 {
 	struct opt_rio *opt_rio_ptr = NULL;
 	struct rio_detail *rio_detail_ptr = NULL;
-	struct list_head *list_head_ptr = NULL;
 	
-	list_for_each (list_head_ptr, &rio_vg_head) {
-		rio_detail_ptr = list_entry (list_head_ptr, struct rio_detail, rio_detail_list);
+	list_for_each_entry (rio_detail_ptr, &rio_vg_head, rio_detail_list) {
 		opt_rio_ptr = search_opt_vg (rio_detail_ptr->chassis_num);
 		if (!opt_rio_ptr) {
 			opt_rio_ptr = kzalloc(sizeof(struct opt_rio), GFP_KERNEL);
@@ -497,14 +477,12 @@ static int __init combine_wpg_for_chassi
 }	
 
 /*
- * reorgnizing linked list of expansion box	 
+ * reorganizing linked list of expansion box
  */
 static struct opt_rio_lo *search_opt_lo (u8 chassis_num)
 {
 	struct opt_rio_lo *ptr;
-	struct list_head *ptr1;
-	list_for_each (ptr1, &opt_lo_head) {
-		ptr = list_entry (ptr1, struct opt_rio_lo, opt_rio_lo_list);
+	list_for_each_entry (ptr, &opt_lo_head, opt_rio_lo_list) {
 		if (ptr->chassis_num == chassis_num)
 			return ptr;
 	}		
@@ -515,10 +493,8 @@ static int combine_wpg_for_expansion (vo
 {
 	struct opt_rio_lo *opt_rio_lo_ptr = NULL;
 	struct rio_detail *rio_detail_ptr = NULL;
-	struct list_head *list_head_ptr = NULL;
 	
-	list_for_each (list_head_ptr, &rio_lo_head) {
-		rio_detail_ptr = list_entry (list_head_ptr, struct rio_detail, rio_detail_list);
+	list_for_each_entry (rio_detail_ptr, &rio_lo_head, rio_detail_list) {
 		opt_rio_lo_ptr = search_opt_lo (rio_detail_ptr->chassis_num);
 		if (!opt_rio_lo_ptr) {
 			opt_rio_lo_ptr = kzalloc(sizeof(struct opt_rio_lo), GFP_KERNEL);
@@ -550,20 +526,17 @@ static int first_slot_num (u8 slot_num, 
 {
 	struct opt_rio *opt_vg_ptr = NULL;
 	struct opt_rio_lo *opt_lo_ptr = NULL;
-	struct list_head *ptr = NULL;
 	int rc = 0;
 
 	if (!var) {
-		list_for_each (ptr, &opt_vg_head) {
-			opt_vg_ptr = list_entry (ptr, struct opt_rio, opt_rio_list);
+		list_for_each_entry (opt_vg_ptr, &opt_vg_head, opt_rio_list) {
 			if ((first_slot < opt_vg_ptr->first_slot_num) && (slot_num >= opt_vg_ptr->first_slot_num)) { 
 				rc = -ENODEV;
 				break;
 			}
 		}
 	} else {
-		list_for_each (ptr, &opt_lo_head) {
-			opt_lo_ptr = list_entry (ptr, struct opt_rio_lo, opt_rio_lo_list);
+		list_for_each_entry (opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {
 			if ((first_slot < opt_lo_ptr->first_slot_num) && (slot_num >= opt_lo_ptr->first_slot_num)) {
 				rc = -ENODEV;
 				break;
@@ -576,10 +549,8 @@ static int first_slot_num (u8 slot_num, 
 static struct opt_rio_lo * find_rxe_num (u8 slot_num)
 {
 	struct opt_rio_lo *opt_lo_ptr;
-	struct list_head *ptr;
 
-	list_for_each (ptr, &opt_lo_head) {
-		opt_lo_ptr = list_entry (ptr, struct opt_rio_lo, opt_rio_lo_list);
+	list_for_each_entry (opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {
 		//check to see if this slot_num belongs to expansion box
 		if ((slot_num >= opt_lo_ptr->first_slot_num) && (!first_slot_num (slot_num, opt_lo_ptr->first_slot_num, 1))) 
 			return opt_lo_ptr;
@@ -590,10 +561,8 @@ static struct opt_rio_lo * find_rxe_num 
 static struct opt_rio * find_chassis_num (u8 slot_num)
 {
 	struct opt_rio *opt_vg_ptr;
-	struct list_head *ptr;
 
-	list_for_each (ptr, &opt_vg_head) {
-		opt_vg_ptr = list_entry (ptr, struct opt_rio, opt_rio_list);
+	list_for_each_entry (opt_vg_ptr, &opt_vg_head, opt_rio_list) {
 		//check to see if this slot_num belongs to chassis 
 		if ((slot_num >= opt_vg_ptr->first_slot_num) && (!first_slot_num (slot_num, opt_vg_ptr->first_slot_num, 0))) 
 			return opt_vg_ptr;
@@ -607,11 +576,9 @@ static struct opt_rio * find_chassis_num
 static u8 calculate_first_slot (u8 slot_num)
 {
 	u8 first_slot = 1;
-	struct list_head * list;
 	struct slot * slot_cur;
 	
-	list_for_each (list, &ibmphp_slot_head) {
-		slot_cur = list_entry (list, struct slot, ibm_slot_list);
+	list_for_each_entry (slot_cur, &ibmphp_slot_head, ibm_slot_list) {
 		if (slot_cur->ctrl) {
 			if ((slot_cur->ctrl->ctlr_type != 4) && (slot_cur->ctrl->ending_slot_num > first_slot) && (slot_num > slot_cur->ctrl->ending_slot_num)) 
 				first_slot = slot_cur->ctrl->ending_slot_num;
@@ -767,7 +734,6 @@ static int __init ebda_rsrc_controller (
 	struct bus_info *bus_info_ptr1, *bus_info_ptr2;
 	int rc;
 	struct slot *tmp_slot;
-	struct list_head *list;
 
 	addr = hpc_list_ptr->phys_addr;
 	for (ctlr = 0; ctlr < hpc_list_ptr->num_ctlrs; ctlr++) {
@@ -997,9 +963,7 @@ static int __init ebda_rsrc_controller (
 
 	}			/* each hpc  */
 
-	list_for_each (list, &ibmphp_slot_head) {
-		tmp_slot = list_entry (list, struct slot, ibm_slot_list);
-
+	list_for_each_entry (tmp_slot, &ibmphp_slot_head, ibm_slot_list) {
 		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
 		pci_hp_register(tmp_slot->hotplug_slot,
 			pci_find_bus(0, tmp_slot->bus), tmp_slot->device);
@@ -1101,10 +1065,8 @@ u16 ibmphp_get_total_controllers (void)
 struct slot *ibmphp_get_slot_from_physical_num (u8 physical_num)
 {
 	struct slot *slot;
-	struct list_head *list;
 
-	list_for_each (list, &ibmphp_slot_head) {
-		slot = list_entry (list, struct slot, ibm_slot_list);
+	list_for_each_entry (slot, &ibmphp_slot_head, ibm_slot_list) {
 		if (slot->number == physical_num)
 			return slot;
 	}
@@ -1120,10 +1082,8 @@ struct slot *ibmphp_get_slot_from_physic
 struct bus_info *ibmphp_find_same_bus_num (u32 num)
 {
 	struct bus_info *ptr;
-	struct list_head  *ptr1;
 
-	list_for_each (ptr1, &bus_info_head) {
-		ptr = list_entry (ptr1, struct bus_info, bus_info_list); 
+	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {
 		if (ptr->busno == num) 
 			 return ptr;
 	}
@@ -1136,10 +1096,8 @@ struct bus_info *ibmphp_find_same_bus_nu
 int ibmphp_get_bus_index (u8 num)
 {
 	struct bus_info *ptr;
-	struct list_head  *ptr1;
 
-	list_for_each (ptr1, &bus_info_head) {
-		ptr = list_entry (ptr1, struct bus_info, bus_info_list);
+	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {
 		if (ptr->busno == num)  
 			return ptr->index;
 	}
@@ -1212,11 +1170,9 @@ static struct pci_driver ibmphp_driver =
 int ibmphp_register_pci (void)
 {
 	struct controller *ctrl;
-	struct list_head *tmp;
 	int rc = 0;
 
-	list_for_each (tmp, &ebda_hpc_head) {
-		ctrl = list_entry (tmp, struct controller, ebda_hpc_list);
+	list_for_each_entry (ctrl, &ebda_hpc_head, ebda_hpc_list) {
 		if (ctrl->ctlr_type == 1) {
 			rc = pci_register_driver(&ibmphp_driver);
 			break;
@@ -1227,12 +1183,10 @@ int ibmphp_register_pci (void)
 static int ibmphp_probe (struct pci_dev * dev, const struct pci_device_id *ids)
 {
 	struct controller *ctrl;
-	struct list_head *tmp;
 
 	debug ("inside ibmphp_probe\n");
 	
-	list_for_each (tmp, &ebda_hpc_head) {
-		ctrl = list_entry (tmp, struct controller, ebda_hpc_list);
+	list_for_each_entry (ctrl, &ebda_hpc_head, ebda_hpc_list) {
 		if (ctrl->ctlr_type == 1) {
 			if ((dev->devfn == ctrl->u.pci_ctlr.dev_fun) && (dev->bus->number == ctrl->u.pci_ctlr.bus)) {
 				ctrl->ctrl_dev = dev;
_

Patches currently in -mm which might be from cordsam@linux.vnet.ibm.com are

origin.patch
linux-next.patch

