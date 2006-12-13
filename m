From: akpm@osdl.org
Subject: - ipmi-remove-zero-inits.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:52:14 -0800
Message-ID: <200612130652.kBD6qECl030420@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57427 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964991AbWLMGxD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:53:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: remove zero inits
has been removed from the -mm tree.  Its filename was
     ipmi-remove-zero-inits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: remove zero inits
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove all =0 and =NULL from static initializers.  They are not needed and
removing them saves space in the object files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_bt_sm.c      |    4 +++-
 drivers/char/ipmi/ipmi_devintf.c    |    2 +-
 drivers/char/ipmi/ipmi_msghandler.c |    6 +++---
 drivers/char/ipmi/ipmi_poweroff.c   |    6 +++---
 drivers/char/ipmi/ipmi_si_intf.c    |   12 ++++++------
 drivers/char/ipmi/ipmi_watchdog.c   |   18 +++++++++---------
 6 files changed, 25 insertions(+), 23 deletions(-)

diff -puN drivers/char/ipmi/ipmi_bt_sm.c~ipmi-remove-zero-inits drivers/char/ipmi/ipmi_bt_sm.c
--- a/drivers/char/ipmi/ipmi_bt_sm.c~ipmi-remove-zero-inits
+++ a/drivers/char/ipmi/ipmi_bt_sm.c
@@ -37,8 +37,10 @@
 #define BT_DEBUG_ENABLE	1	/* Generic messages */
 #define BT_DEBUG_MSG	2	/* Prints all request/response buffers */
 #define BT_DEBUG_STATES	4	/* Verbose look at state changes */
+/* BT_DEBUG_OFF must be zero to correspond to the default uninitialized
+   value */
 
-static int bt_debug = BT_DEBUG_OFF;
+static int bt_debug; /* 0 == BT_DEBUG_OFF */
 
 module_param(bt_debug, int, 0644);
 MODULE_PARM_DESC(bt_debug, "debug bitmask, 1=enable, 2=messages, 4=states");
diff -puN drivers/char/ipmi/ipmi_devintf.c~ipmi-remove-zero-inits drivers/char/ipmi/ipmi_devintf.c
--- a/drivers/char/ipmi/ipmi_devintf.c~ipmi-remove-zero-inits
+++ a/drivers/char/ipmi/ipmi_devintf.c
@@ -834,7 +834,7 @@ static const struct file_operations ipmi
 
 #define DEVICE_NAME     "ipmidev"
 
-static int ipmi_major = 0;
+static int ipmi_major;
 module_param(ipmi_major, int, 0);
 MODULE_PARM_DESC(ipmi_major, "Sets the major number of the IPMI device.  By"
 		 " default, or if you set it to zero, it will choose the next"
diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-remove-zero-inits drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-remove-zero-inits
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -53,10 +53,10 @@
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
 
-static int initialized = 0;
+static int initialized;
 
 #ifdef CONFIG_PROC_FS
-static struct proc_dir_entry *proc_ipmi_root = NULL;
+static struct proc_dir_entry *proc_ipmi_root;
 #endif /* CONFIG_PROC_FS */
 
 /* Remain in auto-maintenance mode for this amount of time (in ms). */
@@ -4043,7 +4043,7 @@ static void send_panic_events(char *str)
 }
 #endif /* CONFIG_IPMI_PANIC_EVENT */
 
-static int has_panicked = 0;
+static int has_panicked;
 
 static int panic_event(struct notifier_block *this,
 		       unsigned long         event,
diff -puN drivers/char/ipmi/ipmi_poweroff.c~ipmi-remove-zero-inits drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~ipmi-remove-zero-inits
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -58,10 +58,10 @@ static int poweroff_powercycle;
 static int ifnum_to_use = -1;
 
 /* Our local state. */
-static int ready = 0;
+static int ready;
 static ipmi_user_t ipmi_user;
 static int ipmi_ifnum;
-static void (*specific_poweroff_func)(ipmi_user_t user) = NULL;
+static void (*specific_poweroff_func)(ipmi_user_t user);
 
 /* Holds the old poweroff function so we can restore it on removal. */
 static void (*old_poweroff_func)(void);
@@ -182,7 +182,7 @@ static int ipmi_request_in_rc_mode(ipmi_
 #define IPMI_MOTOROLA_MANUFACTURER_ID		0x0000A1
 #define IPMI_MOTOROLA_PPS_IPMC_PRODUCT_ID	0x0051
 
-static void (*atca_oem_poweroff_hook)(ipmi_user_t user) = NULL;
+static void (*atca_oem_poweroff_hook)(ipmi_user_t user);
 
 static void pps_poweroff_atca (ipmi_user_t user)
 {
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-remove-zero-inits drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-remove-zero-inits
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -845,7 +845,7 @@ static void request_events(void *send_in
 	atomic_set(&smi_info->req_events, 1);
 }
 
-static int initialized = 0;
+static int initialized;
 
 static void smi_timeout(unsigned long data)
 {
@@ -1018,13 +1018,13 @@ static int num_ports;
 static int           irqs[SI_MAX_PARMS];
 static int num_irqs;
 static int           regspacings[SI_MAX_PARMS];
-static int num_regspacings = 0;
+static int num_regspacings;
 static int           regsizes[SI_MAX_PARMS];
-static int num_regsizes = 0;
+static int num_regsizes;
 static int           regshifts[SI_MAX_PARMS];
-static int num_regshifts = 0;
+static int num_regshifts;
 static int slave_addrs[SI_MAX_PARMS];
-static int num_slave_addrs = 0;
+static int num_slave_addrs;
 
 #define IPMI_IO_ADDR_SPACE  0
 #define IPMI_MEM_ADDR_SPACE 1
@@ -1668,7 +1668,7 @@ static __devinit void hardcode_find_bmc(
 /* Once we get an ACPI failure, we don't try any more, because we go
    through the tables sequentially.  Once we don't find a table, there
    are no more. */
-static int acpi_failure = 0;
+static int acpi_failure;
 
 /* For GPE-type interrupts. */
 static u32 ipmi_acpi_gpe(void *context)
diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-remove-zero-inits drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-remove-zero-inits
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -134,14 +134,14 @@
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 
-static ipmi_user_t watchdog_user = NULL;
+static ipmi_user_t watchdog_user;
 static int watchdog_ifnum;
 
 /* Default the timeout to 10 seconds. */
 static int timeout = 10;
 
 /* The pre-timeout is disabled by default. */
-static int pretimeout = 0;
+static int pretimeout;
 
 /* Default action is to reset the board on a timeout. */
 static unsigned char action_val = WDOG_TIMEOUT_RESET;
@@ -156,10 +156,10 @@ static unsigned char preop_val = WDOG_PR
 
 static char preop[16] = "preop_none";
 static DEFINE_SPINLOCK(ipmi_read_lock);
-static char data_to_read = 0;
+static char data_to_read;
 static DECLARE_WAIT_QUEUE_HEAD(read_q);
-static struct fasync_struct *fasync_q = NULL;
-static char pretimeout_since_last_heartbeat = 0;
+static struct fasync_struct *fasync_q;
+static char pretimeout_since_last_heartbeat;
 static char expect_close;
 
 static int ifnum_to_use = -1;
@@ -177,7 +177,7 @@ static void ipmi_unregister_watchdog(int
 
 /* If true, the driver will start running as soon as it is configured
    and ready. */
-static int start_now = 0;
+static int start_now;
 
 static int set_param_int(const char *val, struct kernel_param *kp)
 {
@@ -300,16 +300,16 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 static unsigned char ipmi_watchdog_state = WDOG_TIMEOUT_NONE;
 
 /* If shutting down via IPMI, we ignore the heartbeat. */
-static int ipmi_ignore_heartbeat = 0;
+static int ipmi_ignore_heartbeat;
 
 /* Is someone using the watchdog?  Only one user is allowed. */
-static unsigned long ipmi_wdog_open = 0;
+static unsigned long ipmi_wdog_open;
 
 /* If set to 1, the heartbeat command will set the state to reset and
    start the timer.  The timer doesn't normally run when the driver is
    first opened until the heartbeat is set the first time, this
    variable is used to accomplish this. */
-static int ipmi_start_timer_on_heartbeat = 0;
+static int ipmi_start_timer_on_heartbeat;
 
 /* IPMI version of the BMC. */
 static unsigned char ipmi_version_major;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fix-section-mismatch-in-parainstructions.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
isicom-fix-build-with-pci-disabled.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

