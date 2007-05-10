From: akpm@linux-foundation.org
Subject: - linuxpps-pulse-per-second-support-for-linux-fix.patch removed from -mm tree
Date: Thu, 10 May 2007 02:45:55 -0700
Message-ID: <200705100948.l4A9msH4017523@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757893AbXEJJuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 05:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, giometti@enneenne.com, johnstul@us.ibm.com, rmk@arm.linux.org.uk, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     linuxpps-pulse-per-second-support-for-linux-fix
has been removed from the -mm tree.  Its filename was
     linuxpps-pulse-per-second-support-for-linux-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: linuxpps-pulse-per-second-support-for-linux-fix
From: Andrew Morton <akpm@linux-foundation.org>

Review comments:

- Running a timer once per second will make the super-low-power people upset.

- This uses netlink?  Is that interface documented anywhere?

  Please check with Dave Miller that this:

	#define NETLINK_PPSAPI          20

  reservation is OK.

- This:

	if ((nlpps->tsformat != PPS_TSFMT_TSPEC) != 0 ) {

  is weird.  I changed it to

	if (nlpps->tsformat != PPS_TSFMT_TSPEC) {


- This:

	timeout += nlpps->timeout.tv_nsec/(1000000000/HZ);

  probably won't work on i386.  We use do_div() for 64/32 divides.  I'll
  find out when I compile it.

  It's nice to use NSEC_PER_SEC rather than having to count all those
  zeroes.

- The code uses interruptible_sleep_on_timeout().  That API is deprecated
  and is racy.  Please convert to wait_event_interruptible_timeout().

  Ditto interruptible_sleep_on()

- This:

        memset(pps_source, 0, sizeof(struct pps_s) * PPS_MAX_SOURCES);

  was unneeded.  The C startup code already did that.

- All these separators:

+/* --- Input function ------------------------------------------------------ */

  aren't typical for kernel code.  I left them in, but please consider
  removing them all.

- This:

	static void pps_class_release(struct class_device *cdev)
	{
		/* Nop??? */
	}

  is a bug and it earns you a nastygram from Greg.  These objects must be
  dynamically allocated - this is not optional.

- What's this doing in 8250.c?

+	if (up->port.flags & UPF_HARDPPS_CD)
+		up->ier |= UART_IER_MSI;	/* enable interrupts */

  Please fully describe the reasons for this change in the changelog, and in
  a code comment and then get the change reviewed by Russell King
  <rmk@arm.linux.org.uk>.

- Please document within the changelog the other changes to the serial code
  and we'll ask Russell to take a look at those as well.

- The Kconfig purports to support CONFIG_PPS=m.  Does that actually work?

  We have a bunch of code in random other drivers which is dependent upon
  CONFIG_PPS_CLIENT_foo.  The problem is that if a kernel was compiled with
  CONFIG_PPS_CLIENT_foo=n and then the pps driver is later built for that
  kernel, it won't actually work because lp, serial etc weren't correctly
  configured when _they_ were built.

  This sort of cross-module coupling is considered to be a bad thing, but
  I'm not really sure it's all that important.

- Please split the patch up into a series of patches: one for pps core and
  one for each of the clients (servers?): one for lp, one for serial, etc.

  Try to arrange for that series of patches to build and run at each stage
  of application.

  Please don't lose my changes when you do so ;)

  Please review the changes I made and a) stick to the same style and b) fix
  up any sites which I missed.

- Please remove all the typedefs:

+typedef struct ntp_fp {
+typedef union pps_timeu {
+typedef struct pps_info {
+typedef struct pps_params {

  and just use `struct ntp_fp' everywhere.

- The above four structures are communicated with userspace, yes?

  I believe that they will not work correctly when 32-bit userspace is
  communicating with a 64-bit kernel.  Alignments change and sizeof(long)
  changes.

  You don't want to have to write compat code.  I suggest that you redo
  those structures in terms of __u32, __u64, etc.  You probably need to use
  attribute((packed)) too, not sure.

  Then let's get that part carefully reviewed (Arnd Bergmann <arnd@arndb.de>
  is my go-to guru on this) and please test it carefully.

  Yeah, you just haven't got a chance that something as huge and as complex
  as struct pps_netlink_msg will survive the 32->64 transition.

- Please ensure that `make headers_check' passes OK (you'll hear from me if
  it doesn't ;))

- Can we get rid of the private dbg, err and info macros?  Surely there are
  generic ones somewhere.

- struct pps_s has volatiles in it.  Please remove them.  There's lots of
  discussion on this topic on linux-kernel just today.

- Why did the

	port->icount.dcd++;

  get moved in uart_handle_dcd_change()?

- In lots of places you do:

+#ifdef CONFIG_PPS_CLIENT_UART
+#include <linux/pps.h>
+#endif

  Please remove the ifdefs at all these sites and make the header file
  handle it.

- It no longer compiles, because netlink_kernel_create now requires a
  `struct mutex *'.  I stuck a NULL in there, which is permitted.  But I don't
  know if that was a good thing - please check this.

  Please also chase the net guys with a pointy stick for failing to document
  their damned APIs.

- Generally: code looks OK and is probably useful.  Please keep going ;)


Code changes:

- fix docs a bit

- uninline lp_pps_echo(): we take its address.

- remove unneeded and undesirable casts of void*'s

- coding-style fixes

- various changes to the use of the timer API.

- Remove lots of inlinings.  The compiler gets this right.

- DEFINE_SPINLOCK is required: SPIN_LOCK_UNLOCKED defeats lockdep.

Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pps.txt        |    4 -
 drivers/char/lp.c            |    7 +--
 drivers/pps/clients/Kconfig  |    8 +--
 drivers/pps/clients/ktimer.c |   19 +++-----
 drivers/pps/kapi.c           |   40 ++++++++---------
 drivers/pps/pps.c            |   75 +++++++++++----------------------
 drivers/pps/sysfs.c          |   14 +++---
 drivers/serial/8250.c        |    1 
 include/linux/pps.h          |    9 ++-
 9 files changed, 77 insertions(+), 100 deletions(-)

diff -puN Documentation/pps.txt~linuxpps-pulse-per-second-support-for-linux-fix Documentation/pps.txt
--- a/Documentation/pps.txt~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/Documentation/pps.txt
@@ -49,7 +49,7 @@ problem:
 
 This implies that the source has a /dev/... entry. This assumption is
 ok for the serial and parallel port, where you can do something
-usefull besides(!) the gathering of timestamps as it is the central
+useful besides(!) the gathering of timestamps as it is the central
 task for a PPS-API. But this assumption does not work for a single
 purpose GPIO line. In this case even basic file-related functionality
 (like read() and write()) makes no sense at all and should not be a
@@ -167,7 +167,7 @@ inside you find several files:
 Inside each "assert" and "clear" file you can find the timestamp and a
 sequence number:
 
-    $ cat cat /sys/class/pps/00/assert
+    $ cat /sys/class/pps/00/assert
     1170026870.983207967#8
 
 Where before the "#" is the timestamp in seconds and after it is the
diff -puN drivers/char/lp.c~linuxpps-pulse-per-second-support-for-linux-fix drivers/char/lp.c
--- a/drivers/char/lp.c~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/drivers/char/lp.c
@@ -750,9 +750,9 @@ static struct console lpcons = {
 
 #ifdef CONFIG_PPS_CLIENT_LP
 
-static inline void lp_pps_echo(int source, int event, void *data)
+static void lp_pps_echo(int source, int event, void *data)
 {
-	struct parport *port = (struct parport *) data;
+	struct parport *port = data;
 	unsigned char status = parport_read_status(port);
 
 	/* echo event via SEL bit */
@@ -860,8 +860,7 @@ static int lp_register(int nr, struct pa
 		else
 			info("PPS source #%d \"%s\" added to the system",
 					port->pps_source, port->pps_info.path);
-	}
-	else {
+	} else {
 		port->pps_source = -1;
 		err("PPS support disabled due port \"%s\" is in polling mode",
 			port->pps_info.path);
diff -puN drivers/pps/clients/Kconfig~linuxpps-pulse-per-second-support-for-linux-fix drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/drivers/pps/clients/Kconfig
@@ -16,21 +16,21 @@ config PPS_CLIENT_KTIMER
 	  will be called ktimer.o.
 
 comment "UART serial support (forced off)"
-	depends on ! ( SERIAL_CORE != n && ! ( PPS = m && SERIAL_CORE = y ) )
+	depends on ! (SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y))
 
 config PPS_CLIENT_UART
 	bool "UART serial support"
-	depends on SERIAL_CORE != n && ! ( PPS = m && SERIAL_CORE = y )
+	depends on SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y)
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
 
 comment "Parallel printer support (forced off)"
-	depends on ! ( PRINTER != n && ! ( PPS = m && PRINTER = y ) )
+	depends on !( PRINTER != n && !(PPS = m && PRINTER = y))
 
 config PPS_CLIENT_LP
 	bool "Parallel printer support"
-	depends on PRINTER != n && ! ( PPS = m && PRINTER = y )
+	depends on PRINTER != n && !(PPS = m && PRINTER = y)
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the interrupt pin of your parallel port.
diff -puN drivers/pps/clients/ktimer.c~linuxpps-pulse-per-second-support-for-linux-fix drivers/pps/clients/ktimer.c
--- a/drivers/pps/clients/ktimer.c~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/drivers/pps/clients/ktimer.c
@@ -35,14 +35,13 @@ static struct timer_list ktimer;
 
 /* --- The kernel timer ----------------------------------------------------- */
 
-static void pps_ktimer_event(unsigned long ptr) {
+static void pps_ktimer_event(unsigned long ptr)
+{
 	info("PPS event at %lu", jiffies);
 
 	pps_event(source, PPS_CAPTUREASSERT, NULL);
 
-	/* Rescheduling */
-	ktimer.expires = jiffies+HZ;   /* 1 second */
-	add_timer(&ktimer);
+	mod_timer(&ktimer, jiffies + HZ);
 }
 
 /* --- The echo function ---------------------------------------------------- */
@@ -50,9 +49,9 @@ static void pps_ktimer_event(unsigned lo
 static void pps_ktimer_echo(int source, int event, void *data)
 {
 	info("echo %s %s for source %d",
-	 event&PPS_CAPTUREASSERT ? "assert" : "",
-	 event&PPS_CAPTURECLEAR ? "clear" : "",
-	 source);
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "",
+		source);
 }
 
 /* --- The PPS info struct -------------------------------------------------- */
@@ -88,10 +87,8 @@ static int __init pps_ktimer_init(void)
 	}
 	source = ret;
 
-	init_timer(&ktimer);
-	ktimer.function = pps_ktimer_event;
-	ktimer.expires = jiffies+HZ;   /* 1 second */
-	add_timer(&ktimer);
+	setup_timer(&ktimer, pps_ktimer_event, 0);
+	mod_timer(&ktimer, jiffies + HZ);
 
 	info("ktimer PPS source registered at %d", source);
 
diff -puN drivers/pps/kapi.c~linuxpps-pulse-per-second-support-for-linux-fix drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/drivers/pps/kapi.c
@@ -24,7 +24,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/time.h>
-
 #include <linux/pps.h>
 
 /* --- Local functions ----------------------------------------------------- */
@@ -44,7 +43,8 @@ static void pps_add_offset(struct timesp
 
 /* --- Exported functions -------------------------------------------------- */
 
-static inline int __pps_register_source(struct pps_source_info_s *info, int default_params, int try_id)
+static int __pps_register_source(struct pps_source_info_s *info,
+				int default_params, int try_id)
 {
 	int i;
 
@@ -54,8 +54,7 @@ static inline int __pps_register_source(
 			return -EBUSY;
 		}
 		i = try_id;
-	}
-	else {
+	} else {
 		for (i = 0; i < PPS_MAX_SOURCES; i++)
 			if (!pps_is_allocated(i))
 				break;
@@ -66,15 +65,16 @@ static inline int __pps_register_source(
 	}
 
 	/* Sanity checks */
-	if ((info->mode&default_params) != default_params) {
+	if ((info->mode & default_params) != default_params) {
 		err("unsupported default parameters");
 		return -EINVAL;
 	}
-	if ((info->mode&(PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0 && info->echo == NULL) {
+	if ((info->mode & (PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0 &&
+			info->echo == NULL) {
 		err("echo function is not defined");
 		return -EINVAL;
 	}
-	if ((info->mode&(PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+	if ((info->mode & (PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
 		err("unspecified time format");
 		return -EINVAL;
 	}
@@ -89,7 +89,8 @@ static inline int __pps_register_source(
 	return i;
 }
 
-int pps_register_source(struct pps_source_info_s *info, int default_params, int try_id)
+int pps_register_source(struct pps_source_info_s *info, int default_params,
+			int try_id)
 {
 	unsigned long flags;
 	int i, ret;
@@ -108,8 +109,9 @@ int pps_register_source(struct pps_sourc
 
 	return i;
 }
+EXPORT_SYMBOL(pps_register_source);
 
-static inline void __pps_unregister_source(struct pps_source_info_s *info)
+static void __pps_unregister_source(struct pps_source_info_s *info)
 {
 	int i;
 
@@ -136,6 +138,7 @@ void pps_unregister_source(struct pps_so
 	__pps_unregister_source(info);
 	spin_unlock_irqrestore(&pps_lock, flags);
 }
+EXPORT_SYMBOL(pps_unregister_source);
 
 void pps_event(int source, int event, void *data)
 {
@@ -153,21 +156,22 @@ void pps_event(int source, int event, vo
 		err("unknow source for event!");
 		return;
 	}
-	if ((event&(PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0 ) {
+	if ((event & (PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0 ) {
 		err("unknow event (%x) for source %d", event, source);
 		return;
 	}
 
 	/* Must call the echo function? */
-	if ((pps_source[source].params.mode&(PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0)
+	if ((pps_source[source].params.mode & (PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0)
 		pps_source[source].info->echo(source, event, data);
 
 	/* Check the event */
 	pps_source[source].current_mode = pps_source[source].params.mode;
-	if (event&PPS_CAPTUREASSERT) {
+	if (event & PPS_CAPTUREASSERT) {
 		/* We have to add an offset? */
 		if (pps_source[source].params.mode&PPS_OFFSETASSERT)
-			pps_add_offset(&ts, &pps_source[source].params.assert_off_tu.tspec);
+			pps_add_offset(&ts,
+				&pps_source[source].params.assert_off_tu.tspec);
 
 		/* Save the time stamp */
 		pps_source[source].assert_tu.tspec = ts;
@@ -175,10 +179,11 @@ void pps_event(int source, int event, vo
 		dbg("capture assert seq #%lu for source %d",
 			pps_source[source].assert_sequence, source);
 	}
-	if (event&PPS_CAPTURECLEAR) {
+	if (event & PPS_CAPTURECLEAR) {
 		/* We have to add an offset? */
 		if (pps_source[source].params.mode&PPS_OFFSETCLEAR)
-			pps_add_offset(&ts, &pps_source[source].params.clear_off_tu.tspec);
+			pps_add_offset(&ts,
+				&pps_source[source].params.clear_off_tu.tspec);
 
 		/* Save the time stamp */
 		pps_source[source].clear_tu.tspec = ts;
@@ -189,9 +194,4 @@ void pps_event(int source, int event, vo
 
 	wake_up_interruptible(&pps_source[source].queue);
 }
-
-/* --- Exported functions -------------------------------------------------- */
-
-EXPORT_SYMBOL(pps_register_source);
-EXPORT_SYMBOL(pps_unregister_source);
 EXPORT_SYMBOL(pps_event);
diff -puN drivers/pps/pps.c~linuxpps-pulse-per-second-support-for-linux-fix drivers/pps/pps.c
--- a/drivers/pps/pps.c~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/drivers/pps/pps.c
@@ -31,7 +31,7 @@
 /* --- Global variables ---------------------------------------------------- */
 
 struct pps_s pps_source[PPS_MAX_SOURCES];
-spinlock_t pps_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(pps_lock);
 
 /* --- Local variables ----------------------------------------------------- */
 
@@ -44,7 +44,7 @@ static inline int pps_check_source(int s
 	return (source < 0 || !pps_is_allocated(source)) ? -EINVAL : 0;
 }
 
-static inline int pps_find_source(int source)
+static int pps_find_source(int source)
 {
 	int i;
 
@@ -65,7 +65,7 @@ static inline int pps_find_source(int so
 	return i;
 }
 
-static inline int pps_find_path(char *path)
+static int pps_find_path(char *path)
 {
 	int i;
 
@@ -90,11 +90,9 @@ static void pps_nl_data_ready(struct soc
 	struct sk_buff *skb;
 	struct nlmsghdr *nlh;
 	struct pps_netlink_msg *nlpps;
-
 	int cmd, source, id;
 	wait_queue_head_t *queue;
 	unsigned long timeout;
-
 	int ret;
 
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
@@ -108,7 +106,7 @@ static void pps_nl_data_ready(struct soc
 		source = nlpps->source;
 
 		switch (cmd) {
-		case PPS_CREATE : {
+		case PPS_CREATE:
 			dbg("PPS_CREATE: source %d", source);
 
 			/* Check if the requested source is allocated */
@@ -120,20 +118,16 @@ static void pps_nl_data_ready(struct soc
 
 			nlpps->source = ret;
 			nlpps->ret = 0;
-
 			break;
-		}
 
-		case PPS_DESTROY : {
+		case PPS_DESTROY:
 			dbg("PPS_DESTROY: source %d", source);
 
 			/* Nothing to do here! Just answer ok... */
 			nlpps->ret = 0;
-
 			break;
-		}
 
-		case PPS_SETPARMS : {
+		case PPS_SETPARMS:
 			dbg("PPS_SETPARMS: source %d", source);
 
 			/* Check the capabilities */
@@ -148,17 +142,17 @@ static void pps_nl_data_ready(struct soc
 				nlpps->ret = ret;
 				break;
 			}
-			if ((nlpps->params.mode&~pps_source[source].info->mode) != 0) {
+			if ((nlpps->params.mode & ~pps_source[source].info->mode) != 0) {
 				dbg("unsupported capabilities");
 				nlpps->ret = -EINVAL;
 				break;
 		 	}
-			if ((nlpps->params.mode&(PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0) {
+			if ((nlpps->params.mode & (PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0) {
 				dbg("capture mode unspecified");
 				nlpps->ret = -EINVAL;
 				break;
 			}
-			if ((nlpps->params.mode&(PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+			if ((nlpps->params.mode & (PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
 				/* section 3.3 of RFC 2783 interpreted */
 				dbg("time format unspecified");
 				nlpps->params.mode |= PPS_TSFMT_TSPEC;
@@ -173,11 +167,9 @@ static void pps_nl_data_ready(struct soc
 			pps_source[source].params.api_version = PPS_API_VERS;
 
 			nlpps->ret = 0;
-
 			break;
-		}
 
-		case PPS_GETPARMS : {
+		case PPS_GETPARMS:
 			dbg("PPS_GETPARMS: source %d", source);
 
 			/* Sanity checks */
@@ -189,11 +181,9 @@ static void pps_nl_data_ready(struct soc
 
 			nlpps->params = pps_source[source].params;
 			nlpps->ret = 0;
-
 			break;
-	 	}
 
-	 	case PPS_GETCAP : {
+	 	case PPS_GETCAP:
 			dbg("PPS_GETCAP: source %d", source);
 
 			/* Sanity checks */
@@ -205,11 +195,9 @@ static void pps_nl_data_ready(struct soc
 
 			nlpps->mode = pps_source[source].info->mode;
 			nlpps->ret = 0;
-
 			break;
-	 	}
 
-	 	case PPS_FETCH : {
+	 	case PPS_FETCH:
 			dbg("PPS_FETCH: source %d", source);
 			queue = &pps_source[source].queue;
 
@@ -219,7 +207,7 @@ static void pps_nl_data_ready(struct soc
 				nlpps->ret = ret;
 				break;
 			}
-			if ((nlpps->tsformat != PPS_TSFMT_TSPEC) != 0 ) {
+			if (nlpps->tsformat != PPS_TSFMT_TSPEC) {
 				dbg("unsupported time format");
 				nlpps->ret = -EINVAL;
 				break;
@@ -227,8 +215,9 @@ static void pps_nl_data_ready(struct soc
 
 		 	/* Manage the timeout */
 			if (nlpps->timeout.tv_sec != -1) {
-				timeout = nlpps->timeout.tv_sec*HZ;
-				timeout += nlpps->timeout.tv_nsec/(1000000000/HZ);
+				timeout = nlpps->timeout.tv_sec * HZ;
+				timeout += nlpps->timeout.tv_nsec/
+						(NSEC_PER_SEC/HZ);
 
 				if (timeout != 0) {
 					timeout = interruptible_sleep_on_timeout(queue, timeout);
@@ -238,8 +227,7 @@ static void pps_nl_data_ready(struct soc
 						break;
 					}
 				}
-		 	}
-			else
+		 	} else
 				interruptible_sleep_on(queue);
 
 			/* Return the fetched timestamp */
@@ -250,19 +238,15 @@ static void pps_nl_data_ready(struct soc
 			nlpps->info.current_mode = pps_source[source].current_mode;
 
 			nlpps->ret = 0;
-
 			break;
-	 	}
 
-	 	case PPS_KC_BIND : {
+	 	case PPS_KC_BIND:
 			dbg("PPS_KC_BIND: source %d", source);
 			/* Feature currently not supported */
 			nlpps->ret = -EOPNOTSUPP;
-
 			break;
-	 	}
 
-		case PPS_FIND_SRC : {
+		case PPS_FIND_SRC:
 			dbg("PPS_FIND_SRC: source %d", source);
 			source = pps_find_source(source);
 			if (source < 0) {
@@ -278,11 +262,9 @@ static void pps_nl_data_ready(struct soc
 			strncpy(nlpps->path, pps_source[source].info->path,
 				PPS_MAX_NAME_LEN);
 			nlpps->ret = 0;
-
 			break;
-	 	}
 
-		case PPS_FIND_PATH : {
+		case PPS_FIND_PATH:
 			dbg("PPS_FIND_PATH: source %s", nlpps->path);
 			source = pps_find_path(nlpps->path);
 			if (source < 0) {
@@ -298,17 +280,14 @@ static void pps_nl_data_ready(struct soc
 			strncpy(nlpps->path, pps_source[source].info->path,
 				PPS_MAX_NAME_LEN);
 			nlpps->ret = 0;
-
 			break;
-	 	}
 
-		default : {
+		default:
 			/* Unknow command */
 			dbg("unknow command %d", nlpps->cmd);
 
 			nlpps->ret = -EINVAL;
 		}
-		}
 
 		/* Send an answer to the userland */
 		id = NETLINK_CB(skb).pid;
@@ -336,16 +315,13 @@ static int __init pps_init(void)
 	int ret;
 
 	nl_sk = netlink_kernel_create(NETLINK_PPSAPI, 0,
-					pps_nl_data_ready, THIS_MODULE);
+					pps_nl_data_ready, NULL, THIS_MODULE);
 	if (nl_sk == NULL) {
 		err("unable to create netlink kernel socket");
 		return -EBUSY;
 	}
 	dbg("netlink protocol %d created", NETLINK_PPSAPI);
 
-	/* Init the main struct */
-	memset(pps_source, 0, sizeof(struct pps_s)*PPS_MAX_SOURCES);
-
 	/* Register to sysfs */
 	ret = pps_sysfs_register();
 	if (ret < 0) {
@@ -354,11 +330,12 @@ static int __init pps_init(void)
 	}
 
 	info("LinuxPPS API ver. %d registered", PPS_API_VERS);
-	info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>", PPS_VERSION);
+	info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti "
+		"<giometti@linux.it>", PPS_VERSION);
 
-	return  0;
+	return 0;
 
-pps_sysfs_register_error :
+pps_sysfs_register_error:
 
 	sock_release(nl_sk->sk_socket);
 
diff -puN drivers/pps/sysfs.c~linuxpps-pulse-per-second-support-for-linux-fix drivers/pps/sysfs.c
--- a/drivers/pps/sysfs.c~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/drivers/pps/sysfs.c
@@ -112,7 +112,8 @@ static struct class pps_class = {
 
 /* ----- Public functions --------------------------------------------- */
 
-void pps_sysfs_remove_source_entry(struct pps_source_info_s *info) {
+void pps_sysfs_remove_source_entry(struct pps_source_info_s *info)
+{
 	int i;
 
 	/* Sanity checks */
@@ -136,7 +137,8 @@ void pps_sysfs_remove_source_entry(struc
 	class_device_unregister(&info->class_dev);
 }
 
-int pps_sysfs_create_source_entry(struct pps_source_info_s *info, int id) {
+int pps_sysfs_create_source_entry(struct pps_source_info_s *info, int id)
+{
 	char buf[32];
 	int i, ret;
 
@@ -161,14 +163,14 @@ int pps_sysfs_create_source_entry(struct
 	/* Create info files */
 
 	/* Create file "assert" and "clear" according to source capability */
-	if (info->mode&PPS_CAPTUREASSERT) {
+	if (info->mode & PPS_CAPTUREASSERT) {
 		ret = class_device_create_file(&info->class_dev,
 					&pps_class_device_attributes[0]);
 		i = 0;
 		if (unlikely(ret))
 			goto error_class_device_create_file;
 	}
-	if (info->mode&PPS_CAPTURECLEAR) {
+	if (info->mode & PPS_CAPTURECLEAR) {
 		ret = class_device_create_file(&info->class_dev,
 					&pps_class_device_attributes[1]);
 		i = 1;
@@ -185,7 +187,7 @@ int pps_sysfs_create_source_entry(struct
 
 	return 0;
 
-error_class_device_create_file :
+error_class_device_create_file:
 	while (--i >= 0)
 		class_device_remove_file(&info->class_dev,
 					&pps_class_device_attributes[i]);
@@ -193,7 +195,7 @@ error_class_device_create_file :
 	class_device_unregister(&info->class_dev);
 	/* Here the  release() method was already called */
 
-error_class_device_register :
+error_class_device_register:
 
 	return ret;
 }
diff -puN drivers/serial/8250.c~linuxpps-pulse-per-second-support-for-linux-fix drivers/serial/8250.c
--- a/drivers/serial/8250.c~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/drivers/serial/8250.c
@@ -2820,7 +2820,6 @@ void serial8250_unregister_port(int line
 	struct uart_8250_port *uart = &serial8250_ports[line];
 
 	mutex_lock(&serial_mutex);
-
 	uart_remove_one_port(&serial8250_reg, &uart->port);
 	if (serial8250_isa_devs) {
 		uart->port.flags &= ~UPF_BOOT_AUTOCONF;
diff -puN include/linux/pps.h~linuxpps-pulse-per-second-support-for-linux-fix include/linux/pps.h
--- a/include/linux/pps.h~linuxpps-pulse-per-second-support-for-linux-fix
+++ a/include/linux/pps.h
@@ -185,7 +185,8 @@ extern spinlock_t pps_lock;
 
 /* --- Global functions ---------------------------------------------------- */
 
-static inline int pps_is_allocated(int source) {
+static inline int pps_is_allocated(int source)
+{
 	return pps_source[source].info != NULL;
 }
 
@@ -193,11 +194,13 @@ static inline int pps_is_allocated(int s
 
 /* --- Exported functions -------------------------------------------------- */
 
-extern int pps_register_source(struct pps_source_info_s *info, int default_params, int try_id);
+extern int pps_register_source(struct pps_source_info_s *info,
+				int default_params, int try_id);
 extern void pps_unregister_source(struct pps_source_info_s *info);
 extern void pps_event(int source, int event, void *data);
 
-extern int pps_sysfs_create_source_entry(struct pps_source_info_s *info, int id);
+extern int pps_sysfs_create_source_entry(struct pps_source_info_s *info,
+				int id);
 extern void pps_sysfs_remove_source_entry(struct pps_source_info_s *info);
 extern int pps_sysfs_register(void);
 extern void pps_sysfs_unregister(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
upper-32-bits.patch
afs-write-support-fixes-fix.patch
revert-md-improve-partition-detection-in-md-array.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-fix.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
x86_64-rename-and-export-bad_srat-to-kernel-code-fix.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
xfs-clean-up-shrinker-games.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
lib-hexdump.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
synclink_gt-add-compat_ioctl-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
linux-kernel-markers-architecture-independant-code-update-fix.patch
linux-kernel-markers-powerpc-optimization-fix.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-documentation-update.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
pm3fb-preliminary-24-to-26-port-fix.patch
linuxpps-pulse-per-second-support-for-linux-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
