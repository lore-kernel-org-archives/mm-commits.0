From: akpm@linux-foundation.org
Subject: - ipmi-style-fixes-in-the-misc-code.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:55 -0700
Message-ID: <200804300544.m3U5itPu029452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757204AbYD3GKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: Style fixes in the misc code
has been removed from the -mm tree.  Its filename was
     ipmi-style-fixes-in-the-misc-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPMI: Style fixes in the misc code
From: Corey Minyard <cminyard@mvista.com>

Lots of style fixes for the miscellaneous IPMI files.  No functional
changes.  Basically fixes everything reported by checkpatch and fixes the
comment style.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_poweroff.c |  184 ++++++++++-----------
 drivers/char/ipmi/ipmi_watchdog.c |  244 +++++++++++++++-------------
 2 files changed, 227 insertions(+), 201 deletions(-)

diff -puN drivers/char/ipmi/ipmi_poweroff.c~ipmi-style-fixes-in-the-misc-code drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~ipmi-style-fixes-in-the-misc-code
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -87,7 +87,10 @@ MODULE_PARM_DESC(ifnum_to_use, "The inte
 
 /* parameter definition to allow user to flag power cycle */
 module_param(poweroff_powercycle, int, 0644);
-MODULE_PARM_DESC(poweroff_powercycle, " Set to non-zero to enable power cycle instead of power down. Power cycle is contingent on hardware support, otherwise it defaults back to power down.");
+MODULE_PARM_DESC(poweroff_powercycle,
+		 " Set to non-zero to enable power cycle instead of power"
+		 " down. Power cycle is contingent on hardware support,"
+		 " otherwise it defaults back to power down.");
 
 /* Stuff from the get device id command. */
 static unsigned int mfg_id;
@@ -95,10 +98,12 @@ static unsigned int prod_id;
 static unsigned char capabilities;
 static unsigned char ipmi_version;
 
-/* We use our own messages for this operation, we don't let the system
-   allocate them, since we may be in a panic situation.  The whole
-   thing is single-threaded, anyway, so multiple messages are not
-   required. */
+/*
+ * We use our own messages for this operation, we don't let the system
+ * allocate them, since we may be in a panic situation.  The whole
+ * thing is single-threaded, anyway, so multiple messages are not
+ * required.
+ */
 static atomic_t dummy_count = ATOMIC_INIT(0);
 static void dummy_smi_free(struct ipmi_smi_msg *msg)
 {
@@ -108,12 +113,10 @@ static void dummy_recv_free(struct ipmi_
 {
 	atomic_dec(&dummy_count);
 }
-static struct ipmi_smi_msg halt_smi_msg =
-{
+static struct ipmi_smi_msg halt_smi_msg = {
 	.done = dummy_smi_free
 };
-static struct ipmi_recv_msg halt_recv_msg =
-{
+static struct ipmi_recv_msg halt_recv_msg = {
 	.done = dummy_recv_free
 };
 
@@ -130,8 +133,7 @@ static void receive_handler(struct ipmi_
 		complete(comp);
 }
 
-static struct ipmi_user_hndl ipmi_poweroff_handler =
-{
+static struct ipmi_user_hndl ipmi_poweroff_handler = {
 	.ipmi_recv_hndl = receive_handler
 };
 
@@ -198,47 +200,47 @@ static int ipmi_request_in_rc_mode(ipmi_
 
 static void (*atca_oem_poweroff_hook)(ipmi_user_t user);
 
-static void pps_poweroff_atca (ipmi_user_t user)
+static void pps_poweroff_atca(ipmi_user_t user)
 {
-        struct ipmi_system_interface_addr smi_addr;
-        struct kernel_ipmi_msg            send_msg;
-        int                               rv;
-        /*
-         * Configure IPMI address for local access
-         */
-        smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-        smi_addr.channel = IPMI_BMC_CHANNEL;
-        smi_addr.lun = 0;
-
-        printk(KERN_INFO PFX "PPS powerdown hook used");
-
-        send_msg.netfn = IPMI_NETFN_OEM;
-        send_msg.cmd = IPMI_ATCA_PPS_GRACEFUL_RESTART;
-        send_msg.data = IPMI_ATCA_PPS_IANA;
-        send_msg.data_len = 3;
-        rv = ipmi_request_in_rc_mode(user,
-                                  (struct ipmi_addr *) &smi_addr,
-                                   &send_msg);
-        if (rv && rv != IPMI_UNKNOWN_ERR_COMPLETION_CODE) {
-                printk(KERN_ERR PFX "Unable to send ATCA ,"
-                       " IPMI error 0x%x\n", rv);
-        }
+	struct ipmi_system_interface_addr smi_addr;
+	struct kernel_ipmi_msg            send_msg;
+	int                               rv;
+	/*
+	 * Configure IPMI address for local access
+	 */
+	smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	smi_addr.channel = IPMI_BMC_CHANNEL;
+	smi_addr.lun = 0;
+
+	printk(KERN_INFO PFX "PPS powerdown hook used");
+
+	send_msg.netfn = IPMI_NETFN_OEM;
+	send_msg.cmd = IPMI_ATCA_PPS_GRACEFUL_RESTART;
+	send_msg.data = IPMI_ATCA_PPS_IANA;
+	send_msg.data_len = 3;
+	rv = ipmi_request_in_rc_mode(user,
+				     (struct ipmi_addr *) &smi_addr,
+				     &send_msg);
+	if (rv && rv != IPMI_UNKNOWN_ERR_COMPLETION_CODE) {
+		printk(KERN_ERR PFX "Unable to send ATCA ,"
+		       " IPMI error 0x%x\n", rv);
+	}
 	return;
 }
 
-static int ipmi_atca_detect (ipmi_user_t user)
+static int ipmi_atca_detect(ipmi_user_t user)
 {
 	struct ipmi_system_interface_addr smi_addr;
 	struct kernel_ipmi_msg            send_msg;
 	int                               rv;
 	unsigned char                     data[1];
 
-        /*
-         * Configure IPMI address for local access
-         */
-        smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-        smi_addr.channel = IPMI_BMC_CHANNEL;
-        smi_addr.lun = 0;
+	/*
+	 * Configure IPMI address for local access
+	 */
+	smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	smi_addr.channel = IPMI_BMC_CHANNEL;
+	smi_addr.lun = 0;
 
 	/*
 	 * Use get address info to check and see if we are ATCA
@@ -252,28 +254,30 @@ static int ipmi_atca_detect (ipmi_user_t
 					    (struct ipmi_addr *) &smi_addr,
 					    &send_msg);
 
-        printk(KERN_INFO PFX "ATCA Detect mfg 0x%X prod 0x%X\n", mfg_id, prod_id);
-        if((mfg_id == IPMI_MOTOROLA_MANUFACTURER_ID)
-            && (prod_id == IPMI_MOTOROLA_PPS_IPMC_PRODUCT_ID)) {
-		printk(KERN_INFO PFX "Installing Pigeon Point Systems Poweroff Hook\n");
+	printk(KERN_INFO PFX "ATCA Detect mfg 0x%X prod 0x%X\n",
+	       mfg_id, prod_id);
+	if ((mfg_id == IPMI_MOTOROLA_MANUFACTURER_ID)
+	    && (prod_id == IPMI_MOTOROLA_PPS_IPMC_PRODUCT_ID)) {
+		printk(KERN_INFO PFX
+		       "Installing Pigeon Point Systems Poweroff Hook\n");
 		atca_oem_poweroff_hook = pps_poweroff_atca;
 	}
 	return !rv;
 }
 
-static void ipmi_poweroff_atca (ipmi_user_t user)
+static void ipmi_poweroff_atca(ipmi_user_t user)
 {
 	struct ipmi_system_interface_addr smi_addr;
 	struct kernel_ipmi_msg            send_msg;
 	int                               rv;
 	unsigned char                     data[4];
 
-        /*
-         * Configure IPMI address for local access
-         */
-        smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-        smi_addr.channel = IPMI_BMC_CHANNEL;
-        smi_addr.lun = 0;
+	/*
+	 * Configure IPMI address for local access
+	 */
+	smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	smi_addr.channel = IPMI_BMC_CHANNEL;
+	smi_addr.lun = 0;
 
 	printk(KERN_INFO PFX "Powering down via ATCA power command\n");
 
@@ -287,22 +291,23 @@ static void ipmi_poweroff_atca (ipmi_use
 	data[2] = 0; /* Power Level */
 	data[3] = 0; /* Don't change saved presets */
 	send_msg.data = data;
-	send_msg.data_len = sizeof (data);
+	send_msg.data_len = sizeof(data);
 	rv = ipmi_request_in_rc_mode(user,
 				     (struct ipmi_addr *) &smi_addr,
 				     &send_msg);
-        /** At this point, the system may be shutting down, and most
-         ** serial drivers (if used) will have interrupts turned off
-         ** it may be better to ignore IPMI_UNKNOWN_ERR_COMPLETION_CODE
-         ** return code
-         **/
-        if (rv && rv != IPMI_UNKNOWN_ERR_COMPLETION_CODE) {
+	/*
+	 * At this point, the system may be shutting down, and most
+	 * serial drivers (if used) will have interrupts turned off
+	 * it may be better to ignore IPMI_UNKNOWN_ERR_COMPLETION_CODE
+	 * return code
+	 */
+	if (rv && rv != IPMI_UNKNOWN_ERR_COMPLETION_CODE) {
 		printk(KERN_ERR PFX "Unable to send ATCA powerdown message,"
 		       " IPMI error 0x%x\n", rv);
 		goto out;
 	}
 
-	if(atca_oem_poweroff_hook)
+	if (atca_oem_poweroff_hook)
 		return atca_oem_poweroff_hook(user);
  out:
 	return;
@@ -324,13 +329,13 @@ static void ipmi_poweroff_atca (ipmi_use
 #define IPMI_CPI1_PRODUCT_ID		0x000157
 #define IPMI_CPI1_MANUFACTURER_ID	0x0108
 
-static int ipmi_cpi1_detect (ipmi_user_t user)
+static int ipmi_cpi1_detect(ipmi_user_t user)
 {
 	return ((mfg_id == IPMI_CPI1_MANUFACTURER_ID)
 		&& (prod_id == IPMI_CPI1_PRODUCT_ID));
 }
 
-static void ipmi_poweroff_cpi1 (ipmi_user_t user)
+static void ipmi_poweroff_cpi1(ipmi_user_t user)
 {
 	struct ipmi_system_interface_addr smi_addr;
 	struct ipmi_ipmb_addr             ipmb_addr;
@@ -342,12 +347,12 @@ static void ipmi_poweroff_cpi1 (ipmi_use
 	unsigned char                     aer_addr;
 	unsigned char                     aer_lun;
 
-        /*
-         * Configure IPMI address for local access
-         */
-        smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-        smi_addr.channel = IPMI_BMC_CHANNEL;
-        smi_addr.lun = 0;
+	/*
+	 * Configure IPMI address for local access
+	 */
+	smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	smi_addr.channel = IPMI_BMC_CHANNEL;
+	smi_addr.lun = 0;
 
 	printk(KERN_INFO PFX "Powering down via CPI1 power command\n");
 
@@ -439,7 +444,7 @@ static void ipmi_poweroff_cpi1 (ipmi_use
  */
 
 #define DELL_IANA_MFR_ID {0xA2, 0x02, 0x00}
-static int ipmi_dell_chassis_detect (ipmi_user_t user)
+static int ipmi_dell_chassis_detect(ipmi_user_t user)
 {
 	const char ipmi_version_major = ipmi_version & 0xF;
 	const char ipmi_version_minor = (ipmi_version >> 4) & 0xF;
@@ -458,25 +463,25 @@ static int ipmi_dell_chassis_detect (ipm
 #define IPMI_NETFN_CHASSIS_REQUEST	0
 #define IPMI_CHASSIS_CONTROL_CMD	0x02
 
-static int ipmi_chassis_detect (ipmi_user_t user)
+static int ipmi_chassis_detect(ipmi_user_t user)
 {
 	/* Chassis support, use it. */
 	return (capabilities & 0x80);
 }
 
-static void ipmi_poweroff_chassis (ipmi_user_t user)
+static void ipmi_poweroff_chassis(ipmi_user_t user)
 {
 	struct ipmi_system_interface_addr smi_addr;
 	struct kernel_ipmi_msg            send_msg;
 	int                               rv;
 	unsigned char                     data[1];
 
-        /*
-         * Configure IPMI address for local access
-         */
-        smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-        smi_addr.channel = IPMI_BMC_CHANNEL;
-        smi_addr.lun = 0;
+	/*
+	 * Configure IPMI address for local access
+	 */
+	smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	smi_addr.channel = IPMI_BMC_CHANNEL;
+	smi_addr.lun = 0;
 
  powercyclefailed:
 	printk(KERN_INFO PFX "Powering %s via IPMI chassis control command\n",
@@ -539,7 +544,7 @@ static struct poweroff_function poweroff
 
 
 /* Called on a powerdown request. */
-static void ipmi_poweroff_function (void)
+static void ipmi_poweroff_function(void)
 {
 	if (!ready)
 		return;
@@ -573,13 +578,13 @@ static void ipmi_po_new_smi(int if_num, 
 
 	ipmi_ifnum = if_num;
 
-        /*
-         * Do a get device ide and store some results, since this is
+	/*
+	 * Do a get device ide and store some results, since this is
 	 * used by several functions.
-         */
-        smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
-        smi_addr.channel = IPMI_BMC_CHANNEL;
-        smi_addr.lun = 0;
+	 */
+	smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	smi_addr.channel = IPMI_BMC_CHANNEL;
+	smi_addr.lun = 0;
 
 	send_msg.netfn = IPMI_NETFN_APP_REQUEST;
 	send_msg.cmd = IPMI_GET_DEVICE_ID_CMD;
@@ -644,8 +649,7 @@ static void ipmi_po_smi_gone(int if_num)
 	pm_power_off = old_poweroff_func;
 }
 
-static struct ipmi_smi_watcher smi_watcher =
-{
+static struct ipmi_smi_watcher smi_watcher = {
 	.owner    = THIS_MODULE,
 	.new_smi  = ipmi_po_new_smi,
 	.smi_gone = ipmi_po_smi_gone
@@ -687,12 +691,12 @@ static struct ctl_table_header *ipmi_tab
 /*
  * Startup and shutdown functions.
  */
-static int ipmi_poweroff_init (void)
+static int ipmi_poweroff_init(void)
 {
 	int rv;
 
-	printk (KERN_INFO "Copyright (C) 2004 MontaVista Software -"
-		" IPMI Powerdown via sys_reboot.\n");
+	printk(KERN_INFO "Copyright (C) 2004 MontaVista Software -"
+	       " IPMI Powerdown via sys_reboot.\n");
 
 	if (poweroff_powercycle)
 		printk(KERN_INFO PFX "Power cycle is enabled.\n");
diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-style-fixes-in-the-misc-code drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-style-fixes-in-the-misc-code
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -54,13 +54,15 @@
 #include <asm/atomic.h>
 
 #ifdef CONFIG_X86
-/* This is ugly, but I've determined that x86 is the only architecture
-   that can reasonably support the IPMI NMI watchdog timeout at this
-   time.  If another architecture adds this capability somehow, it
-   will have to be a somewhat different mechanism and I have no idea
-   how it will work.  So in the unlikely event that another
-   architecture supports this, we can figure out a good generic
-   mechanism for it at that time. */
+/*
+ * This is ugly, but I've determined that x86 is the only architecture
+ * that can reasonably support the IPMI NMI watchdog timeout at this
+ * time.  If another architecture adds this capability somehow, it
+ * will have to be a somewhat different mechanism and I have no idea
+ * how it will work.  So in the unlikely event that another
+ * architecture supports this, we can figure out a good generic
+ * mechanism for it at that time.
+ */
 #include <asm/kdebug.h>
 #define HAVE_DIE_NMI
 #endif
@@ -95,9 +97,8 @@
 /* Operations that can be performed on a pretimout. */
 #define WDOG_PREOP_NONE		0
 #define WDOG_PREOP_PANIC	1
-#define WDOG_PREOP_GIVE_DATA	2 /* Cause data to be available to
-                                     read.  Doesn't work in NMI
-                                     mode. */
+/* Cause data to be available to read.  Doesn't work in NMI mode. */
+#define WDOG_PREOP_GIVE_DATA	2
 
 /* Actions to perform on a full timeout. */
 #define WDOG_SET_TIMEOUT_ACT(byte, use) \
@@ -108,8 +109,10 @@
 #define WDOG_TIMEOUT_POWER_DOWN		2
 #define WDOG_TIMEOUT_POWER_CYCLE	3
 
-/* Byte 3 of the get command, byte 4 of the get response is the
-   pre-timeout in seconds. */
+/*
+ * Byte 3 of the get command, byte 4 of the get response is the
+ * pre-timeout in seconds.
+ */
 
 /* Bits for setting byte 4 of the set command, byte 5 of the get response. */
 #define WDOG_EXPIRE_CLEAR_BIOS_FRB2	(1 << 1)
@@ -118,11 +121,13 @@
 #define WDOG_EXPIRE_CLEAR_SMS_OS	(1 << 4)
 #define WDOG_EXPIRE_CLEAR_OEM		(1 << 5)
 
-/* Setting/getting the watchdog timer value.  This is for bytes 5 and
-   6 (the timeout time) of the set command, and bytes 6 and 7 (the
-   timeout time) and 8 and 9 (the current countdown value) of the
-   response.  The timeout value is given in seconds (in the command it
-   is 100ms intervals). */
+/*
+ * Setting/getting the watchdog timer value.  This is for bytes 5 and
+ * 6 (the timeout time) of the set command, and bytes 6 and 7 (the
+ * timeout time) and 8 and 9 (the current countdown value) of the
+ * response.  The timeout value is given in seconds (in the command it
+ * is 100ms intervals).
+ */
 #define WDOG_SET_TIMEOUT(byte1, byte2, val) \
 	(byte1) = (((val) * 10) & 0xff), (byte2) = (((val) * 10) >> 8)
 #define WDOG_GET_TIMEOUT(byte1, byte2) \
@@ -184,8 +189,10 @@ static int ipmi_set_timeout(int do_heart
 static void ipmi_register_watchdog(int ipmi_intf);
 static void ipmi_unregister_watchdog(int ipmi_intf);
 
-/* If true, the driver will start running as soon as it is configured
-   and ready. */
+/*
+ * If true, the driver will start running as soon as it is configured
+ * and ready.
+ */
 static int start_now;
 
 static int set_param_int(const char *val, struct kernel_param *kp)
@@ -309,10 +316,12 @@ static int ipmi_ignore_heartbeat;
 /* Is someone using the watchdog?  Only one user is allowed. */
 static unsigned long ipmi_wdog_open;
 
-/* If set to 1, the heartbeat command will set the state to reset and
-   start the timer.  The timer doesn't normally run when the driver is
-   first opened until the heartbeat is set the first time, this
-   variable is used to accomplish this. */
+/*
+ * If set to 1, the heartbeat command will set the state to reset and
+ * start the timer.  The timer doesn't normally run when the driver is
+ * first opened until the heartbeat is set the first time, this
+ * variable is used to accomplish this.
+ */
 static int ipmi_start_timer_on_heartbeat;
 
 /* IPMI version of the BMC. */
@@ -329,10 +338,12 @@ static int nmi_handler_registered;
 
 static int ipmi_heartbeat(void);
 
-/* We use a mutex to make sure that only one thing can send a set
-   timeout at one time, because we only have one copy of the data.
-   The mutex is claimed when the set_timeout is sent and freed
-   when both messages are free. */
+/*
+ * We use a mutex to make sure that only one thing can send a set
+ * timeout at one time, because we only have one copy of the data.
+ * The mutex is claimed when the set_timeout is sent and freed
+ * when both messages are free.
+ */
 static atomic_t set_timeout_tofree = ATOMIC_INIT(0);
 static DEFINE_MUTEX(set_timeout_lock);
 static DECLARE_COMPLETION(set_timeout_wait);
@@ -346,15 +357,13 @@ static void set_timeout_free_recv(struct
     if (atomic_dec_and_test(&set_timeout_tofree))
 	    complete(&set_timeout_wait);
 }
-static struct ipmi_smi_msg set_timeout_smi_msg =
-{
+static struct ipmi_smi_msg set_timeout_smi_msg = {
 	.done = set_timeout_free_smi
 };
-static struct ipmi_recv_msg set_timeout_recv_msg =
-{
+static struct ipmi_recv_msg set_timeout_recv_msg = {
 	.done = set_timeout_free_recv
 };
- 
+
 static int i_ipmi_set_timeout(struct ipmi_smi_msg  *smi_msg,
 			      struct ipmi_recv_msg *recv_msg,
 			      int                  *send_heartbeat_now)
@@ -373,13 +382,14 @@ static int i_ipmi_set_timeout(struct ipm
 	WDOG_SET_TIMER_USE(data[0], WDOG_TIMER_USE_SMS_OS);
 
 	if ((ipmi_version_major > 1)
-	    || ((ipmi_version_major == 1) && (ipmi_version_minor >= 5)))
-	{
+	    || ((ipmi_version_major == 1) && (ipmi_version_minor >= 5))) {
 		/* This is an IPMI 1.5-only feature. */
 		data[0] |= WDOG_DONT_STOP_ON_SET;
 	} else if (ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
-		/* In ipmi 1.0, setting the timer stops the watchdog, we
-		   need to start it back up again. */
+		/*
+		 * In ipmi 1.0, setting the timer stops the watchdog, we
+		 * need to start it back up again.
+		 */
 		hbnow = 1;
 	}
 
@@ -465,12 +475,10 @@ static void panic_recv_free(struct ipmi_
 	atomic_dec(&panic_done_count);
 }
 
-static struct ipmi_smi_msg panic_halt_heartbeat_smi_msg =
-{
+static struct ipmi_smi_msg panic_halt_heartbeat_smi_msg = {
 	.done = panic_smi_free
 };
-static struct ipmi_recv_msg panic_halt_heartbeat_recv_msg =
-{
+static struct ipmi_recv_msg panic_halt_heartbeat_recv_msg = {
 	.done = panic_recv_free
 };
 
@@ -480,8 +488,10 @@ static void panic_halt_ipmi_heartbeat(vo
 	struct ipmi_system_interface_addr addr;
 	int rv;
 
-	/* Don't reset the timer if we have the timer turned off, that
-           re-enables the watchdog. */
+	/*
+	 * Don't reset the timer if we have the timer turned off, that
+	 * re-enables the watchdog.
+	 */
 	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE)
 		return;
 
@@ -505,19 +515,19 @@ static void panic_halt_ipmi_heartbeat(vo
 		atomic_add(2, &panic_done_count);
 }
 
-static struct ipmi_smi_msg panic_halt_smi_msg =
-{
+static struct ipmi_smi_msg panic_halt_smi_msg = {
 	.done = panic_smi_free
 };
-static struct ipmi_recv_msg panic_halt_recv_msg =
-{
+static struct ipmi_recv_msg panic_halt_recv_msg = {
 	.done = panic_recv_free
 };
 
-/* Special call, doesn't claim any locks.  This is only to be called
-   at panic or halt time, in run-to-completion mode, when the caller
-   is the only CPU and the only thing that will be going is these IPMI
-   calls. */
+/*
+ * Special call, doesn't claim any locks.  This is only to be called
+ * at panic or halt time, in run-to-completion mode, when the caller
+ * is the only CPU and the only thing that will be going is these IPMI
+ * calls.
+ */
 static void panic_halt_ipmi_set_timeout(void)
 {
 	int send_heartbeat_now;
@@ -540,10 +550,12 @@ static void panic_halt_ipmi_set_timeout(
 		ipmi_poll_interface(watchdog_user);
 }
 
-/* We use a semaphore to make sure that only one thing can send a
-   heartbeat at one time, because we only have one copy of the data.
-   The semaphore is claimed when the set_timeout is sent and freed
-   when both messages are free. */
+/*
+ * We use a mutex to make sure that only one thing can send a
+ * heartbeat at one time, because we only have one copy of the data.
+ * The semaphore is claimed when the set_timeout is sent and freed
+ * when both messages are free.
+ */
 static atomic_t heartbeat_tofree = ATOMIC_INIT(0);
 static DEFINE_MUTEX(heartbeat_lock);
 static DECLARE_COMPLETION(heartbeat_wait);
@@ -557,15 +569,13 @@ static void heartbeat_free_recv(struct i
     if (atomic_dec_and_test(&heartbeat_tofree))
 	    complete(&heartbeat_wait);
 }
-static struct ipmi_smi_msg heartbeat_smi_msg =
-{
+static struct ipmi_smi_msg heartbeat_smi_msg = {
 	.done = heartbeat_free_smi
 };
-static struct ipmi_recv_msg heartbeat_recv_msg =
-{
+static struct ipmi_recv_msg heartbeat_recv_msg = {
 	.done = heartbeat_free_recv
 };
- 
+
 static int ipmi_heartbeat(void)
 {
 	struct kernel_ipmi_msg            msg;
@@ -580,10 +590,12 @@ static int ipmi_heartbeat(void)
 		ipmi_watchdog_state = action_val;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_FORCE_HB);
 	} else if (pretimeout_since_last_heartbeat) {
-		/* A pretimeout occurred, make sure we set the timeout.
-		   We don't want to set the action, though, we want to
-		   leave that alone (thus it can't be combined with the
-		   above operation. */
+		/*
+		 * A pretimeout occurred, make sure we set the timeout.
+		 * We don't want to set the action, though, we want to
+		 * leave that alone (thus it can't be combined with the
+		 * above operation.
+		 */
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 	}
 
@@ -591,8 +603,10 @@ static int ipmi_heartbeat(void)
 
 	atomic_set(&heartbeat_tofree, 2);
 
-	/* Don't reset the timer if we have the timer turned off, that
-           re-enables the watchdog. */
+	/*
+	 * Don't reset the timer if we have the timer turned off, that
+	 * re-enables the watchdog.
+	 */
 	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE) {
 		mutex_unlock(&heartbeat_lock);
 		return 0;
@@ -625,10 +639,12 @@ static int ipmi_heartbeat(void)
 	wait_for_completion(&heartbeat_wait);
 
 	if (heartbeat_recv_msg.msg.data[0] != 0) {
-	    /* Got an error in the heartbeat response.  It was already
-	       reported in ipmi_wdog_msg_handler, but we should return
-	       an error here. */
-	    rv = -EINVAL;
+		/*
+		 * Got an error in the heartbeat response.  It was already
+		 * reported in ipmi_wdog_msg_handler, but we should return
+		 * an error here.
+		 */
+		rv = -EINVAL;
 	}
 
 	mutex_unlock(&heartbeat_lock);
@@ -636,8 +652,7 @@ static int ipmi_heartbeat(void)
 	return rv;
 }
 
-static struct watchdog_info ident =
-{
+static struct watchdog_info ident = {
 	.options	= 0,	/* WDIOF_SETTIMEOUT, */
 	.firmware_version = 1,
 	.identity	= "IPMI"
@@ -650,7 +665,7 @@ static int ipmi_ioctl(struct inode *inod
 	int i;
 	int val;
 
-	switch(cmd) {
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		i = copy_to_user(argp, &ident, sizeof(ident));
 		return i ? -EFAULT : 0;
@@ -690,15 +705,13 @@ static int ipmi_ioctl(struct inode *inod
 		i = copy_from_user(&val, argp, sizeof(int));
 		if (i)
 			return -EFAULT;
-		if (val & WDIOS_DISABLECARD)
-		{
+		if (val & WDIOS_DISABLECARD) {
 			ipmi_watchdog_state = WDOG_TIMEOUT_NONE;
 			ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
 			ipmi_start_timer_on_heartbeat = 0;
 		}
 
-		if (val & WDIOS_ENABLECARD)
-		{
+		if (val & WDIOS_ENABLECARD) {
 			ipmi_watchdog_state = action_val;
 			ipmi_set_timeout(IPMI_SET_TIMEOUT_FORCE_HB);
 		}
@@ -724,13 +737,13 @@ static ssize_t ipmi_write(struct file *f
 	int rv;
 
 	if (len) {
-	    	if (!nowayout) {
-		    	size_t i;
+		if (!nowayout) {
+			size_t i;
 
 			/* In case it was set long ago */
 			expect_close = 0;
 
-    			for (i = 0; i != len; i++) {
+			for (i = 0; i != len; i++) {
 				char c;
 
 				if (get_user(c, buf + i))
@@ -758,15 +771,17 @@ static ssize_t ipmi_read(struct file *fi
 	if (count <= 0)
 		return 0;
 
-	/* Reading returns if the pretimeout has gone off, and it only does
-	   it once per pretimeout. */
+	/*
+	 * Reading returns if the pretimeout has gone off, and it only does
+	 * it once per pretimeout.
+	 */
 	spin_lock(&ipmi_read_lock);
 	if (!data_to_read) {
 		if (file->f_flags & O_NONBLOCK) {
 			rv = -EAGAIN;
 			goto out;
 		}
-		
+
 		init_waitqueue_entry(&wait, current);
 		add_wait_queue(&read_q, &wait);
 		while (!data_to_read) {
@@ -776,7 +791,7 @@ static ssize_t ipmi_read(struct file *fi
 			spin_lock(&ipmi_read_lock);
 		}
 		remove_wait_queue(&read_q, &wait);
-	    
+
 		if (signal_pending(current)) {
 			rv = -ERESTARTSYS;
 			goto out;
@@ -799,25 +814,27 @@ static ssize_t ipmi_read(struct file *fi
 
 static int ipmi_open(struct inode *ino, struct file *filep)
 {
-        switch (iminor(ino)) {
-        case WATCHDOG_MINOR:
+	switch (iminor(ino)) {
+	case WATCHDOG_MINOR:
 		if (test_and_set_bit(0, &ipmi_wdog_open))
-                        return -EBUSY;
+			return -EBUSY;
 
-		/* Don't start the timer now, let it start on the
-		   first heartbeat. */
+		/*
+		 * Don't start the timer now, let it start on the
+		 * first heartbeat.
+		 */
 		ipmi_start_timer_on_heartbeat = 1;
 		return nonseekable_open(ino, filep);
 
 	default:
 		return (-ENODEV);
-        }
+	}
 }
 
 static unsigned int ipmi_poll(struct file *file, poll_table *wait)
 {
 	unsigned int mask = 0;
-	
+
 	poll_wait(file, &read_q, wait);
 
 	spin_lock(&ipmi_read_lock);
@@ -851,7 +868,7 @@ static int ipmi_close(struct inode *ino,
 		clear_bit(0, &ipmi_wdog_open);
 	}
 
-	ipmi_fasync (-1, filep, 0);
+	ipmi_fasync(-1, filep, 0);
 	expect_close = 0;
 
 	return 0;
@@ -882,7 +899,7 @@ static void ipmi_wdog_msg_handler(struct
 		       msg->msg.data[0],
 		       msg->msg.cmd);
 	}
-	
+
 	ipmi_free_recv_msg(msg);
 }
 
@@ -902,14 +919,14 @@ static void ipmi_wdog_pretimeout_handler
 		}
 	}
 
-	/* On some machines, the heartbeat will give
-	   an error and not work unless we re-enable
-	   the timer.   So do so. */
+	/*
+	 * On some machines, the heartbeat will give an error and not
+	 * work unless we re-enable the timer.  So do so.
+	 */
 	pretimeout_since_last_heartbeat = 1;
 }
 
-static struct ipmi_user_hndl ipmi_hndlrs =
-{
+static struct ipmi_user_hndl ipmi_hndlrs = {
 	.ipmi_recv_hndl           = ipmi_wdog_msg_handler,
 	.ipmi_watchdog_pretimeout = ipmi_wdog_pretimeout_handler
 };
@@ -949,8 +966,10 @@ static void ipmi_register_watchdog(int i
 		int old_timeout = timeout;
 		int old_preop_val = preop_val;
 
-		/* Set the pretimeout to go off in a second and give
-		   ourselves plenty of time to stop the timer. */
+		/*
+		 * Set the pretimeout to go off in a second and give
+		 * ourselves plenty of time to stop the timer.
+		 */
 		ipmi_watchdog_state = WDOG_TIMEOUT_RESET;
 		preop_val = WDOG_PREOP_NONE; /* Make sure nothing happens */
 		pretimeout = 99;
@@ -974,7 +993,7 @@ static void ipmi_register_watchdog(int i
 			       " occur.  The NMI pretimeout will"
 			       " likely not work\n");
 		}
-	out_restore:
+ out_restore:
 		testing_nmi = 0;
 		preop_val = old_preop_val;
 		pretimeout = old_pretimeout;
@@ -1009,9 +1028,11 @@ static void ipmi_unregister_watchdog(int
 	/* Make sure no one can call us any more. */
 	misc_deregister(&ipmi_wdog_miscdev);
 
-	/* Wait to make sure the message makes it out.  The lower layer has
-	   pointers to our buffers, we want to make sure they are done before
-	   we release our memory. */
+	/*
+	 * Wait to make sure the message makes it out.  The lower layer has
+	 * pointers to our buffers, we want to make sure they are done before
+	 * we release our memory.
+	 */
 	while (atomic_read(&set_timeout_tofree))
 		schedule_timeout_uninterruptible(1);
 
@@ -1052,15 +1073,17 @@ ipmi_nmi(struct notifier_block *self, un
 		return NOTIFY_STOP;
 	}
 
-        /* If we are not expecting a timeout, ignore it. */
+	/* If we are not expecting a timeout, ignore it. */
 	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE)
 		return NOTIFY_OK;
 
 	if (preaction_val != WDOG_PRETIMEOUT_NMI)
 		return NOTIFY_OK;
 
-	/* If no one else handled the NMI, we assume it was the IPMI
-           watchdog. */
+	/*
+	 * If no one else handled the NMI, we assume it was the IPMI
+	 * watchdog.
+	 */
 	if (preop_val == WDOG_PREOP_PANIC) {
 		/* On some machines, the heartbeat will give
 		   an error and not work unless we re-enable
@@ -1082,7 +1105,7 @@ static int wdog_reboot_handler(struct no
 			       unsigned long         code,
 			       void                  *unused)
 {
-	static int reboot_event_handled = 0;
+	static int reboot_event_handled;
 
 	if ((watchdog_user) && (!reboot_event_handled)) {
 		/* Make sure we only do this once. */
@@ -1115,7 +1138,7 @@ static int wdog_panic_handler(struct not
 			      unsigned long         event,
 			      void                  *unused)
 {
-	static int panic_event_handled = 0;
+	static int panic_event_handled;
 
 	/* On a panic, if we have a panic timeout, make sure to extend
 	   the watchdog timer to a reasonable value to complete the
@@ -1125,7 +1148,7 @@ static int wdog_panic_handler(struct not
 	    ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
 		/* Make sure we do this only once. */
 		panic_event_handled = 1;
-	    
+
 		timeout = 255;
 		pretimeout = 0;
 		panic_halt_ipmi_set_timeout();
@@ -1151,8 +1174,7 @@ static void ipmi_smi_gone(int if_num)
 	ipmi_unregister_watchdog(if_num);
 }
 
-static struct ipmi_smi_watcher smi_watcher =
-{
+static struct ipmi_smi_watcher smi_watcher = {
 	.owner    = THIS_MODULE,
 	.new_smi  = ipmi_new_smi,
 	.smi_gone = ipmi_smi_gone
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

