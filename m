From: akpm@linux-foundation.org
Subject: - edac-core-fix-redundant-sysfs-controls-to-parameters.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:04:03 -0700
Message-ID: <200807252304.m6PN43RJ004016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYGYXEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ajones@riverbed.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: core fix redundant sysfs controls to parameters
has been removed from the -mm tree.  Its filename was
     edac-core-fix-redundant-sysfs-controls-to-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: core fix redundant sysfs controls to parameters
From: Arthur Jones <ajones@riverbed.com>

/sys/devices/system/edac/mc has a few files which are duplicated in
/sys/module/edac_core/parameters.  Now that all the functionality is
duplicated between these two locations, we remove the former kobject
attributes and update the documentation.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/edac.txt       |  151 +++++++++++++++------------------
 drivers/edac/edac_mc_sysfs.c |  117 -------------------------
 2 files changed, 73 insertions(+), 195 deletions(-)

diff -puN Documentation/edac.txt~edac-core-fix-redundant-sysfs-controls-to-parameters Documentation/edac.txt
--- a/Documentation/edac.txt~edac-core-fix-redundant-sysfs-controls-to-parameters
+++ a/Documentation/edac.txt
@@ -222,74 +222,9 @@ both csrow2 and csrow3 are populated, th
 set of DIMMs for channels 0 and 1.
 
 
-Within each of the 'mc','mcX' and 'csrowX' directories are several
+Within each of the 'mcX' and 'csrowX' directories are several
 EDAC control and attribute files.
 
-
-============================================================================
-DIRECTORY 'mc'
-
-In directory 'mc' are EDAC system overall control and attribute files:
-
-
-Panic on UE control file:
-
-	'edac_mc_panic_on_ue'
-
-	An uncorrectable error will cause a machine panic.  This is usually
-	desirable.  It is a bad idea to continue when an uncorrectable error
-	occurs - it is indeterminate what was uncorrected and the operating
-	system context might be so mangled that continuing will lead to further
-	corruption. If the kernel has MCE configured, then EDAC will never
-	notice the UE.
-
-	LOAD TIME: module/kernel parameter: panic_on_ue=[0|1]
-
-	RUN TIME:  echo "1" >/sys/devices/system/edac/mc/edac_mc_panic_on_ue
-
-
-Log UE control file:
-
-	'edac_mc_log_ue'
-
-	Generate kernel messages describing uncorrectable errors.  These errors
-	are reported through the system message log system.  UE statistics
-	will be accumulated even when UE logging is disabled.
-
-	LOAD TIME: module/kernel parameter: log_ue=[0|1]
-
-	RUN TIME: echo "1" >/sys/devices/system/edac/mc/edac_mc_log_ue
-
-
-Log CE control file:
-
-	'edac_mc_log_ce'
-
-	Generate kernel messages describing correctable errors.  These
-	errors are reported through the system message log system.
-	CE statistics will be accumulated even when CE logging is disabled.
-
-	LOAD TIME: module/kernel parameter: log_ce=[0|1]
-
-	RUN TIME: echo "1" >/sys/devices/system/edac/mc/edac_mc_log_ce
-
-
-Polling period control file:
-
-	'edac_mc_poll_msec'
-
-	The time period, in milliseconds, for polling for error information.
-	Too small a value wastes resources.  Too large a value might delay
-	necessary handling of errors and might loose valuable information for
-	locating the error.  1000 milliseconds (once each second) is the current
-	default. Systems which require all the bandwidth they can get, may
-	increase this.
-
-	LOAD TIME: module/kernel parameter: poll_msec=[0|1]
-
-	RUN TIME: echo "1000" >/sys/devices/system/edac/mc/edac_mc_poll_msec
-
-
 ============================================================================
 'mcX' DIRECTORIES
 
@@ -537,7 +472,6 @@ Channel 1 DIMM Label control file:
 	motherboard specific and determination of this information
 	must occur in userland at this time.
 
-
 ============================================================================
 SYSTEM LOGGING
 
@@ -570,7 +504,6 @@ error type, a notice of "no info" and th
 driver-specific error message.
 
 
-
 ============================================================================
 PCI Bus Parity Detection
 
@@ -604,6 +537,74 @@ Enable/Disable PCI Parity checking contr
 	echo "0" >/sys/devices/system/edac/pci/check_pci_parity
 
 
+Parity Count:
+
+	'pci_parity_count'
+
+	This attribute file will display the number of parity errors that
+	have been detected.
+
+
+============================================================================
+MODULE PARAMETERS
+
+Panic on UE control file:
+
+	'edac_mc_panic_on_ue'
+
+	An uncorrectable error will cause a machine panic.  This is usually
+	desirable.  It is a bad idea to continue when an uncorrectable error
+	occurs - it is indeterminate what was uncorrected and the operating
+	system context might be so mangled that continuing will lead to further
+	corruption. If the kernel has MCE configured, then EDAC will never
+	notice the UE.
+
+	LOAD TIME: module/kernel parameter: edac_mc_panic_on_ue=[0|1]
+
+	RUN TIME:  echo "1" > /sys/module/edac_core/parameters/edac_mc_panic_on_ue
+
+
+Log UE control file:
+
+	'edac_mc_log_ue'
+
+	Generate kernel messages describing uncorrectable errors.  These errors
+	are reported through the system message log system.  UE statistics
+	will be accumulated even when UE logging is disabled.
+
+	LOAD TIME: module/kernel parameter: edac_mc_log_ue=[0|1]
+
+	RUN TIME: echo "1" > /sys/module/edac_core/parameters/edac_mc_log_ue
+
+
+Log CE control file:
+
+	'edac_mc_log_ce'
+
+	Generate kernel messages describing correctable errors.  These
+	errors are reported through the system message log system.
+	CE statistics will be accumulated even when CE logging is disabled.
+
+	LOAD TIME: module/kernel parameter: edac_mc_log_ce=[0|1]
+
+	RUN TIME: echo "1" > /sys/module/edac_core/parameters/edac_mc_log_ce
+
+
+Polling period control file:
+
+	'edac_mc_poll_msec'
+
+	The time period, in milliseconds, for polling for error information.
+	Too small a value wastes resources.  Too large a value might delay
+	necessary handling of errors and might loose valuable information for
+	locating the error.  1000 milliseconds (once each second) is the current
+	default. Systems which require all the bandwidth they can get, may
+	increase this.
+
+	LOAD TIME: module/kernel parameter: edac_mc_poll_msec=[0|1]
+
+	RUN TIME: echo "1000" > /sys/module/edac_core/parameters/edac_mc_poll_msec
+
 
 Panic on PCI PARITY Error:
 
@@ -614,21 +615,13 @@ Panic on PCI PARITY Error:
 	error has been detected.
 
 
-	module/kernel parameter: panic_on_pci_parity=[0|1]
+	module/kernel parameter: edac_panic_on_pci_pe=[0|1]
 
 	Enable:
-	echo "1" >/sys/devices/system/edac/pci/panic_on_pci_parity
+	echo "1" > /sys/module/edac_core/parameters/edac_panic_on_pci_pe
 
 	Disable:
-	echo "0" >/sys/devices/system/edac/pci/panic_on_pci_parity
-
-
-Parity Count:
-
-	'pci_parity_count'
-
-	This attribute file will display the number of parity errors that
-	have been detected.
+	echo "0" > /sys/module/edac_core/parameters/edac_panic_on_pci_pe
 
 
 
diff -puN drivers/edac/edac_mc_sysfs.c~edac-core-fix-redundant-sysfs-controls-to-parameters drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~edac-core-fix-redundant-sysfs-controls-to-parameters
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -123,16 +123,6 @@ static const char *edac_caps[] = {
 
 
 
-/*
- * /sys/devices/system/edac/mc;
- *	data structures and methods
- */
-static ssize_t memctrl_int_show(void *ptr, char *buffer)
-{
-	int *value = (int *)ptr;
-	return sprintf(buffer, "%u\n", *value);
-}
-
 static ssize_t memctrl_int_store(void *ptr, const char *buffer, size_t count)
 {
 	int *value = (int *)ptr;
@@ -143,23 +133,6 @@ static ssize_t memctrl_int_store(void *p
 	return count;
 }
 
-/*
- * mc poll_msec time value
- */
-static ssize_t poll_msec_int_store(void *ptr, const char *buffer, size_t count)
-{
-	int *value = (int *)ptr;
-
-	if (isdigit(*buffer)) {
-		*value = simple_strtoul(buffer, NULL, 0);
-
-		/* notify edac_mc engine to reset the poll period */
-		edac_mc_reset_delay_period(*value);
-	}
-
-	return count;
-}
-
 
 /* EDAC sysfs CSROW data structures and methods
  */
@@ -669,98 +642,10 @@ static struct kobj_type ktype_mci = {
 	.default_attrs = (struct attribute **)mci_attr,
 };
 
-/* show/store, tables, etc for the MC kset */
-
-
-struct memctrl_dev_attribute {
-	struct attribute attr;
-	void *value;
-	 ssize_t(*show) (void *, char *);
-	 ssize_t(*store) (void *, const char *, size_t);
-};
-
-/* Set of show/store abstract level functions for memory control object */
-static ssize_t memctrl_dev_show(struct kobject *kobj,
-				struct attribute *attr, char *buffer)
-{
-	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute *)attr;
-
-	if (memctrl_dev->show)
-		return memctrl_dev->show(memctrl_dev->value, buffer);
-
-	return -EIO;
-}
-
-static ssize_t memctrl_dev_store(struct kobject *kobj, struct attribute *attr,
-				 const char *buffer, size_t count)
-{
-	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute *)attr;
-
-	if (memctrl_dev->store)
-		return memctrl_dev->store(memctrl_dev->value, buffer, count);
-
-	return -EIO;
-}
-
-static struct sysfs_ops memctrlfs_ops = {
-	.show = memctrl_dev_show,
-	.store = memctrl_dev_store
-};
-
-#define MEMCTRL_ATTR(_name, _mode, _show, _store)			\
-static struct memctrl_dev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = &_name,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-#define MEMCTRL_STRING_ATTR(_name, _data, _mode, _show, _store)	\
-static struct memctrl_dev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = _data,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-/* csrow<id> control files */
-MEMCTRL_ATTR(edac_mc_panic_on_ue,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
-
-MEMCTRL_ATTR(edac_mc_log_ue,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
-
-MEMCTRL_ATTR(edac_mc_log_ce,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
-
-MEMCTRL_ATTR(edac_mc_poll_msec,
-	S_IRUGO | S_IWUSR, memctrl_int_show, poll_msec_int_store);
-
-/* Base Attributes of the memory ECC object */
-static struct memctrl_dev_attribute *memctrl_attr[] = {
-	&attr_edac_mc_panic_on_ue,
-	&attr_edac_mc_log_ue,
-	&attr_edac_mc_log_ce,
-	&attr_edac_mc_poll_msec,
-	NULL,
-};
-
-
-/* the ktype for the mc_kset internal kobj */
-static struct kobj_type ktype_mc_set_attribs = {
-	.sysfs_ops = &memctrlfs_ops,
-	.default_attrs = (struct attribute **)memctrl_attr,
-};
-
 /* EDAC memory controller sysfs kset:
  *	/sys/devices/system/edac/mc
  */
-static struct kset mc_kset = {
-	.kobj = {.ktype = &ktype_mc_set_attribs },
-};
