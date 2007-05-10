From: akpm@linux-foundation.org
Subject: + linuxpps-pulse-per-second-support-for-linux.patch added to -mm tree
Date: Thu, 10 May 2007 00:27:47 -0700
Message-ID: <200705100727.l4A7Rli0015015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150AbXEJH2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 03:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@enneenne.com, johnstul@us.ibm.com, zippel@linux-m68k.org


The patch titled
     LinuxPPS: pulse per Second support for Linux
has been added to the -mm tree.  Its filename is
     linuxpps-pulse-per-second-support-for-linux.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: LinuxPPS: pulse per Second support for Linux
From: Rodolfo Giometti <giometti@enneenne.com>

Pulse per Second (PPS) support for Linux.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pps.txt        |  183 ++++++++++++++++
 MAINTAINERS                  |    7 
 drivers/Kconfig              |    2 
 drivers/char/lp.c            |   59 +++++
 drivers/pps/Kconfig          |   34 +++
 drivers/pps/Makefile         |    7 
 drivers/pps/clients/Kconfig  |   38 +++
 drivers/pps/clients/Makefile |    6 
 drivers/pps/clients/ktimer.c |  106 +++++++++
 drivers/pps/kapi.c           |  197 +++++++++++++++++
 drivers/pps/pps.c            |  373 +++++++++++++++++++++++++++++++++
 drivers/pps/sysfs.c          |  209 ++++++++++++++++++
 drivers/serial/8250.c        |    3 
 drivers/serial/serial_core.c |   72 ++++++
 include/linux/netlink.h      |    1 
 include/linux/parport.h      |   15 +
 include/linux/pps.h          |  207 ++++++++++++++++++
 include/linux/serial_core.h  |   34 ++-
 18 files changed, 1546 insertions(+), 7 deletions(-)

diff -puN /dev/null Documentation/pps.txt
--- /dev/null
+++ a/Documentation/pps.txt
@@ -0,0 +1,183 @@
+
+			PPS - Pulse Per Second
+			----------------------
+
+(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
+
+This program is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2 of the License, or
+(at your option) any later version.
+
+This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+
+
+Overview
+--------
+
+LinuxPPS provides a programming interface (API) to define into the
+system several PPS sources.
+
+PPS means "pulse per second" and a PPS source is just a device which
+provides a high precision signal each second so that an application
+can use it to adjust system clock time.
+
+A PPS source can be connected to a serial port (usually to the Data
+Carrier Detect pin) or to a parallel port (ACK-pin) or to a special
+CPU's GPIOs (this is the common case in embedded systems) but in each
+case when a new pulse comes the system must apply to it a timestamp
+and record it for the userland.
+
+Common use is the combination of the NTPD as userland program with a
+GPS receiver as PPS source to obtain a wallclock-time with
+sub-millisecond synchronisation to UTC.
+
+
+RFC considerations
+------------------
+
+While implementing a PPS API as RFC 2783 defines and using an embedded
+CPU GPIO-Pin as physical link to the signal, I encountered a deeper
+problem:
+
+   At startup it needs a file descriptor as argument for the function
+   time_pps_create().
+
+This implies that the source has a /dev/... entry. This assumption is
+ok for the serial and parallel port, where you can do something
+usefull besides(!) the gathering of timestamps as it is the central
+task for a PPS-API. But this assumption does not work for a single
+purpose GPIO line. In this case even basic file-related functionality
+(like read() and write()) makes no sense at all and should not be a
+precondition for the use of a PPS-API.
+
+The problem can be simply solved if you change the original RFC 2783:
+
+    pps_handle_t type is an opaque __scalar type__ used to represent a
+    PPS source within the API
+
+into a modified:
+
+   pps_handle_t type is an opaque __variable__ used to represent a PPS
+   source within the API and programs should not access it directly to
+   it due to its opacity.
+
+This change seems to be neglibile because even the original RFC 2783
+does not encourage programs to check (read: use) the pps_handle_t
+variable before calling the time_pps_*() functions, since each
+function should do this job internally.
+
+If I intentionally separate the concept of "file descriptor" from the
+concept of the "PPS source" I'm obliged to provide a solution to find
+and register a PPS-source without using a file descriptor: it's done
+by the functions time_pps_findsource() and time_pps_findpath() now.
+
+According to this current NTPD drivers' code should be modified as
+follows:
+
++#ifdef PPS_HAVE_FINDPATH
++      /* Get the PPS source's real name */
++      fd = readlink(link, path, STRING_LEN-1);
++      if (fd <= 0)
++              strncpy(path, link, STRING_LEN);
++      else
++              path[fd] = '\0';
++
++      /* Try to find the source */
++      fd = time_pps_findpath(path, STRING_LEN, id, STRING_LEN);
++      if (fd < 0) {
++              msyslog(LOG_ERR, "refclock: cannot find PPS source \"%s\" in the system", path);
++              return 1;
++      }
++      msyslog(LOG_INFO, "refclock: found PPS source #%d \"%s\" on \"%s\"", fd, path, id);
++#endif   /* PPS_HAVE_FINDPATH */
++
++
+       if (time_pps_create(fd, &pps_handle) < 0) {
+-              pps_handle = 0;
+               msyslog(LOG_ERR, "refclock: time_pps_create failed: %m");
+       }
+
+
+Coding example
+--------------
+
+To register a PPS source into the kernel you should define a struct
+pps_source_info_s as follow:
+
+    static struct pps_source_info_s pps_ktimer_info = {
+            name         : "ktimer",
+            path         : "",
+            mode         : PPS_CAPTUREASSERT|PPS_OFFSETASSERT|PPS_ECHOASSERT| \
+                           PPS_CANWAIT|PPS_TSFMT_TSPEC,
+            echo         : pps_ktimer_echo,
+    };
+
+and then calling the function pps_register_source() in your
+intialization routine as follow:
+
+    source = pps_register_source(&pps_ktimer_info,
+			PPS_CAPTUREASSERT|PPS_OFFSETASSERT,
+			-1 /* is up to the system */);
+
+The pps_register_source() prototype is:
+
+  int pps_register_source(struct pps_source_info_s *info, int default_params, int try_id)
+
+where "info" is a pointer to a structure that describes a particular
+PPS source, "default_params" tells the system what the initial default
+parameters for the device should be (is obvious that these parameters
+must be a subset of ones defined into the struct
+pps_source_info_s which describe the capabilities of the driver)
+and "try_id" can be used to force a particular ID for your device into
+the system (just use -1 if you wish the system chooses one for you).
+
+Once you have registered a new PPS source into the system you can
+signal an assert event (for example in the interrupt handler routine)
+just using:
+
+    pps_event(source, PPS_CAPTUREASSERT, ptr);
+
+The same function may also run the defined echo function
+(pps_ktimer_echo(), passing to it the "ptr" pointer) if the user
+asked for that... etc..
+
+Please see the file drivers/pps/clients/ktimer.c for an example code.
+
+
+SYSFS support
+-------------
+
+The SYSFS support is enabled by default if the SYSFS filesystem is
+enabled in the kernel and it provides a new class:
+
+   $ ls /sys/class/pps/
+   00/  01/  02/
+
+Every directory is the ID of a PPS sources defined into the system and
+inside you find several files:
+
+    $ ls /sys/class/pps/00/
+    assert	clear  echo  mode  name  path  subsystem@  uevent
+
+Inside each "assert" and "clear" file you can find the timestamp and a
+sequence number:
+
+    $ cat cat /sys/class/pps/00/assert
+    1170026870.983207967#8
+
+Where before the "#" is the timestamp in seconds and after it is the
+sequence number. Other files are:
+
+* echo: reports if the PPS source has an echo function or not;
+
+* mode: reports available PPS functioning modes;
+
+* name: reports the PPS source's name;
+
+* path: reports the PPS source's device path, that is the device the
+  PPS source is connected to (if it exists).
diff -puN MAINTAINERS~linuxpps-pulse-per-second-support-for-linux MAINTAINERS
--- a/MAINTAINERS~linuxpps-pulse-per-second-support-for-linux
+++ a/MAINTAINERS
@@ -2847,6 +2847,13 @@ P:	Michal Ostrowski
 M:	mostrows@speakeasy.net
 S:	Maintained
 
+PPS SUPPORT
+P:	Rodolfo Giometti
+M:	giometti@enneenne.com
+W:	http://wiki.enneenne.com/index.php/LinuxPPS_support
+L:	linuxpps@ml.enneenne.com
+S:	Maintained
+
 PREEMPTIBLE KERNEL
 P:	Robert Love
 M:	rml@tech9.net
diff -puN drivers/Kconfig~linuxpps-pulse-per-second-support-for-linux drivers/Kconfig
--- a/drivers/Kconfig~linuxpps-pulse-per-second-support-for-linux
+++ a/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/pps/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
diff -puN drivers/char/lp.c~linuxpps-pulse-per-second-support-for-linux drivers/char/lp.c
--- a/drivers/char/lp.c~linuxpps-pulse-per-second-support-for-linux
+++ a/drivers/char/lp.c
@@ -746,6 +746,27 @@ static struct console lpcons = {
 
 #endif /* console on line printer */
 
+/* --- support for PPS signal on the line printer -------------- */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+
+static inline void lp_pps_echo(int source, int event, void *data)
+{
+	struct parport *port = (struct parport *) data;
+	unsigned char status = parport_read_status(port);
+
+	/* echo event via SEL bit */
+	parport_write_control(port,
+		parport_read_control(port) | PARPORT_CONTROL_SELECT);
+
+	/* signal no event */
+	if ((status & PARPORT_STATUS_ACK) != 0)
+		parport_write_control(port,
+			parport_read_control(port) & ~PARPORT_CONTROL_SELECT);
+}
+
+#endif
+
 /* --- initialisation code ------------------------------------- */
 
 static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
@@ -817,6 +838,36 @@ static int lp_register(int nr, struct pa
 	}
 #endif
 
+#ifdef CONFIG_PPS_CLIENT_LP
+	snprintf(port->pps_info.path, PPS_MAX_NAME_LEN, "/dev/lp%d", nr);
+
+	/* No PPS support if lp port has no IRQ line */
+	if (port->irq != PARPORT_IRQ_NONE) {
+		strncpy(port->pps_info.name, port->name, PPS_MAX_NAME_LEN);
+
+		port->pps_info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+				PPS_ECHOASSERT | \
+				PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+		port->pps_info.echo = lp_pps_echo;
+
+		port->pps_source = pps_register_source(&(port->pps_info),
+				PPS_CAPTUREASSERT | PPS_OFFSETASSERT,
+				-1 /* is up to the system */);
+		if (port->pps_source < 0)
+			err("cannot register PPS source \"%s\"",
+					port->pps_info.path);
+		else
+			info("PPS source #%d \"%s\" added to the system",
+					port->pps_source, port->pps_info.path);
+	}
+	else {
+		port->pps_source = -1;
+		err("PPS support disabled due port \"%s\" is in polling mode",
+			port->pps_info.path);
+	}
+#endif
+
 	return 0;
 }
 
@@ -860,6 +911,14 @@ static void lp_detach (struct parport *p
 		console_registered = NULL;
 	}
 #endif /* CONFIG_LP_CONSOLE */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	if (port->pps_source >= 0) {
+		pps_unregister_source(&(port->pps_info));
+		dbg("PPS source #%d \"%s\" removed from the system",
+			port->pps_source, port->pps_info.path);
+	}
+#endif
 }
 
 static struct parport_driver lp_driver = {
diff -puN /dev/null drivers/pps/Kconfig
--- /dev/null
+++ a/drivers/pps/Kconfig
@@ -0,0 +1,34 @@
+#
+# Character device configuration
+#
+
+menu "PPS support"
+
+config PPS
+	tristate "PPS support"
+	depends on EXPERIMENTAL
+	---help---
+	  PPS (Pulse Per Second) is a special pulse provided by some GPS
+	  antennas. Userland can use it to get an high time reference.
+
+	  Some antennas' PPS signals are connected with the CD (Carrier
+	  Detect) pin of the serial line they use to communicate with the
+	  host. In this case use the SERIAL_LINE client support.
+
+	  Some antennas' PPS signals are connected with some special host
+	  inputs so you have to enable the corresponding client support.
+
+	  This PPS support can also be built as a module.  If so, the module
+	  will be called pps-core.
+
+config PPS_DEBUG
+	bool "PPS debugging messages"
+	depends on PPS
+	help
+	  Say Y here if you want the PPS support to produce a bunch of debug
+	  messages to the system log.  Select this if you are having a
+	  problem with PPS support and want to see more of what is going on.
+
+source drivers/pps/clients/Kconfig
+
+endmenu
diff -puN /dev/null drivers/pps/Makefile
--- /dev/null
+++ a/drivers/pps/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the PPS core.
+#
+
+pps_core-objs			+= pps.o kapi.o sysfs.o
+obj-$(CONFIG_PPS)		+= pps_core.o
+obj-y				+= clients/
diff -puN /dev/null drivers/pps/clients/Kconfig
--- /dev/null
+++ a/drivers/pps/clients/Kconfig
@@ -0,0 +1,38 @@
+#
+# LinuxPPS clients configuration
+#
+
+if PPS
+
+comment "PPS clients support"
+
+config PPS_CLIENT_KTIMER
+	tristate "Kernel timer client (Testing client, use for debug)"
+	help
+	  If you say yes here you get support for a PPS debugging client
+	  which uses a kernel timer to generate the PPS signal.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ktimer.o.
+
+comment "UART serial support (forced off)"
+	depends on ! ( SERIAL_CORE != n && ! ( PPS = m && SERIAL_CORE = y ) )
+
+config PPS_CLIENT_UART
+	bool "UART serial support"
+	depends on SERIAL_CORE != n && ! ( PPS = m && SERIAL_CORE = y )
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
+comment "Parallel printer support (forced off)"
+	depends on ! ( PRINTER != n && ! ( PPS = m && PRINTER = y ) )
+
+config PPS_CLIENT_LP
+	bool "Parallel printer support"
+	depends on PRINTER != n && ! ( PPS = m && PRINTER = y )
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the interrupt pin of your parallel port.
+
+endif
diff -puN /dev/null drivers/pps/clients/Makefile
--- /dev/null
+++ a/drivers/pps/clients/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for miscellaneous I2C chip drivers.
+#
+
+obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+
diff -puN /dev/null drivers/pps/clients/ktimer.c
--- /dev/null
+++ a/drivers/pps/clients/ktimer.c
@@ -0,0 +1,106 @@
+/*
+ * ktimer.c -- kernel timer test client
+ *
+ *
+ * Copyright (C) 2005-2006   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+
+#include <linux/pps.h>
+
+/* --- Global variables ----------------------------------------------------- */
+
+static int source;
+static struct timer_list ktimer;
+
+/* --- The kernel timer ----------------------------------------------------- */
+
+static void pps_ktimer_event(unsigned long ptr) {
+	info("PPS event at %lu", jiffies);
+
+	pps_event(source, PPS_CAPTUREASSERT, NULL);
+
+	/* Rescheduling */
+	ktimer.expires = jiffies+HZ;   /* 1 second */
+	add_timer(&ktimer);
+}
+
+/* --- The echo function ---------------------------------------------------- */
+
+static void pps_ktimer_echo(int source, int event, void *data)
+{
+	info("echo %s %s for source %d",
+	 event&PPS_CAPTUREASSERT ? "assert" : "",
+	 event&PPS_CAPTURECLEAR ? "clear" : "",
+	 source);
+}
+
+/* --- The PPS info struct -------------------------------------------------- */
+
+static struct pps_source_info_s pps_ktimer_info = {
+	name		: "ktimer",
+	path		: "",
+	mode		: PPS_CAPTUREASSERT|PPS_OFFSETASSERT|PPS_ECHOASSERT| \
+			  PPS_CANWAIT|PPS_TSFMT_TSPEC,
+	echo 		: pps_ktimer_echo,
+};
+
+/* --- Module staff -------------------------------------------------------- */
+
+static void __exit pps_ktimer_exit(void)
+{
+	del_timer_sync(&ktimer);
+	pps_unregister_source(&pps_ktimer_info);
+
+	info("ktimer PPS source unregistered");
+}
+
+static int __init pps_ktimer_init(void)
+{
+	int ret;
+
+	ret = pps_register_source(&pps_ktimer_info,
+				PPS_CAPTUREASSERT|PPS_OFFSETASSERT,
+				-1 /* is up to the system */);
+	if (ret < 0) {
+		err("cannot register ktimer source");
+		return ret;
+	}
+	source = ret;
+
+	init_timer(&ktimer);
+	ktimer.function = pps_ktimer_event;
+	ktimer.expires = jiffies+HZ;   /* 1 second */
+	add_timer(&ktimer);
+
+	info("ktimer PPS source registered at %d", source);
+
+	return  0;
+}
+
+module_init(pps_ktimer_init);
+module_exit(pps_ktimer_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("testing PPS source by using a kernel timer (just for debug)");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/pps/kapi.c
--- /dev/null
+++ a/drivers/pps/kapi.c
@@ -0,0 +1,197 @@
+/*
+ * kapi.c -- kernel API
+ *
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/time.h>
+
+#include <linux/pps.h>
+
+/* --- Local functions ----------------------------------------------------- */
+
+static void pps_add_offset(struct timespec *ts, struct timespec *offset)
+{
+	ts->tv_nsec += offset->tv_nsec;
+	if (ts->tv_nsec >= NSEC_PER_SEC) {
+		ts->tv_nsec -= NSEC_PER_SEC;
+		ts->tv_sec++;
+	} else if (ts->tv_nsec < 0) {
+		ts->tv_nsec += NSEC_PER_SEC;
+		ts->tv_sec--;
+	}
+	ts->tv_sec += offset->tv_sec;
+}
+
+/* --- Exported functions -------------------------------------------------- */
+
+static inline int __pps_register_source(struct pps_source_info_s *info, int default_params, int try_id)
+{
+	int i;
+
+	if (try_id >= 0) {
+		if (pps_is_allocated(try_id)) {
+			err("source id %d busy", try_id);
+			return -EBUSY;
+		}
+		i = try_id;
+	}
+	else {
+		for (i = 0; i < PPS_MAX_SOURCES; i++)
+			if (!pps_is_allocated(i))
+				break;
+		if (i >= PPS_MAX_SOURCES) {
+			err("no free source ids");
+			return -ENOMEM;
+		}
+	}
+
+	/* Sanity checks */
+	if ((info->mode&default_params) != default_params) {
+		err("unsupported default parameters");
+		return -EINVAL;
+	}
+	if ((info->mode&(PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0 && info->echo == NULL) {
+		err("echo function is not defined");
+		return -EINVAL;
+	}
+	if ((info->mode&(PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+		err("unspecified time format");
+		return -EINVAL;
+	}
+
+	/* Allocate the PPS source */
+	memset(&pps_source[i], 0, sizeof(struct pps_s));
+	pps_source[i].info = info;
+	pps_source[i].params.api_version = PPS_API_VERS;
+	pps_source[i].params.mode = default_params;
+	init_waitqueue_head(&pps_source[i].queue);
+
+	return i;
+}
+
+int pps_register_source(struct pps_source_info_s *info, int default_params, int try_id)
+{
+	unsigned long flags;
+	int i, ret;
+
+	spin_lock_irqsave(&pps_lock, flags);
+	ret = __pps_register_source(info, default_params, try_id);
+	spin_unlock_irqrestore(&pps_lock, flags);
+
+	if (ret < 0)
+		return ret;
+	i = ret;
+
+	ret = pps_sysfs_create_source_entry(info, i);
+	if (ret < 0)
+		err("unable to create sysfs entry for source %d", i);
+
+	return i;
+}
+
+static inline void __pps_unregister_source(struct pps_source_info_s *info)
+{
+	int i;
+
+	for (i = 0; i < PPS_MAX_SOURCES; i++)
+		if (pps_is_allocated(i) && pps_source[i].info == info)
+			break;
+
+	if (i >= PPS_MAX_SOURCES) {
+		err("warning! Try to unregister an unknow PPS source");
+		return;
+	}
+
+	/* Deallocate the PPS source */
+	pps_source[i].info = NULL;
+}
+
+void pps_unregister_source(struct pps_source_info_s *info)
+{
+	unsigned long flags;
+
+	pps_sysfs_remove_source_entry(info);
+
+	spin_lock_irqsave(&pps_lock, flags);
+	__pps_unregister_source(info);
+	spin_unlock_irqrestore(&pps_lock, flags);
+}
+
+void pps_event(int source, int event, void *data)
+{
+	struct timespec ts;
+
+	/* In this function we shouldn't need locking at all since each PPS
+	 * source arrives once per second and due the per-PPS source data
+	 * array... */
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&ts);
+
+	/* ... then we can do some sanity checks */
+	if (!pps_is_allocated(source)) {
+		err("unknow source for event!");
+		return;
+	}
+	if ((event&(PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0 ) {
+		err("unknow event (%x) for source %d", event, source);
+		return;
+	}
+
+	/* Must call the echo function? */
+	if ((pps_source[source].params.mode&(PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0)
+		pps_source[source].info->echo(source, event, data);
+
+	/* Check the event */
+	pps_source[source].current_mode = pps_source[source].params.mode;
+	if (event&PPS_CAPTUREASSERT) {
+		/* We have to add an offset? */
+		if (pps_source[source].params.mode&PPS_OFFSETASSERT)
+			pps_add_offset(&ts, &pps_source[source].params.assert_off_tu.tspec);
+
+		/* Save the time stamp */
+		pps_source[source].assert_tu.tspec = ts;
+		pps_source[source].assert_sequence++;
+		dbg("capture assert seq #%lu for source %d",
+			pps_source[source].assert_sequence, source);
+	}
+	if (event&PPS_CAPTURECLEAR) {
+		/* We have to add an offset? */
+		if (pps_source[source].params.mode&PPS_OFFSETCLEAR)
+			pps_add_offset(&ts, &pps_source[source].params.clear_off_tu.tspec);
+
+		/* Save the time stamp */
+		pps_source[source].clear_tu.tspec = ts;
+		pps_source[source].clear_sequence++;
+		dbg("capture clear seq #%lu for source %d",
+			pps_source[source].clear_sequence, source);
+	}
+
+	wake_up_interruptible(&pps_source[source].queue);
+}
+
+/* --- Exported functions -------------------------------------------------- */
+
+EXPORT_SYMBOL(pps_register_source);
+EXPORT_SYMBOL(pps_unregister_source);
+EXPORT_SYMBOL(pps_event);
diff -puN /dev/null drivers/pps/pps.c
--- /dev/null
+++ a/drivers/pps/pps.c
@@ -0,0 +1,373 @@
+/*
+ * pps.c -- Main PPS support file
+ *
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+
+#include <linux/pps.h>
+
+/* --- Global variables ---------------------------------------------------- */
+
+struct pps_s pps_source[PPS_MAX_SOURCES];
+spinlock_t pps_lock = SPIN_LOCK_UNLOCKED;
+
+/* --- Local variables ----------------------------------------------------- */
+
+static struct sock *nl_sk = NULL;
+
+/* --- Misc functions ------------------------------------------------------ */
+
+static inline int pps_check_source(int source)
+{
+	return (source < 0 || !pps_is_allocated(source)) ? -EINVAL : 0;
+}
+
+static inline int pps_find_source(int source)
+{
+	int i;
+
+	if (source >= 0) {
+		if (source >= PPS_MAX_SOURCES || !pps_is_allocated(source))
+			return -EINVAL;
+		else
+			return source;
+	}
+
+	for (i = 0; i < PPS_MAX_SOURCES; i++)
+		if (pps_is_allocated(i))
+			break;
+
+	if (i >= PPS_MAX_SOURCES)
+		return -EINVAL;
+
+	return i;
+}
+
+static inline int pps_find_path(char *path)
+{
+	int i;
+
+	for (i = 0; i < PPS_MAX_SOURCES; i++)
+		if (pps_is_allocated(i) &&
+		    (strncmp(pps_source[i].info->path, path,
+			     	PPS_MAX_NAME_LEN) == 0 ||
+		     strncmp(pps_source[i].info->name, path,
+			     	PPS_MAX_NAME_LEN) == 0))
+			break;
+
+	if (i >= PPS_MAX_SOURCES)
+		return -EINVAL;
+
+	return i;
+}
+
+/* --- Input function ------------------------------------------------------ */
+
+static void pps_nl_data_ready(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct pps_netlink_msg *nlpps;
+
+	int cmd, source, id;
+	wait_queue_head_t *queue;
+	unsigned long timeout;
+
+	int ret;
+
+	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
+		nlh = (struct nlmsghdr *) skb->data;
+		dbg("New message from PID %d (flags %x)",
+			nlh->nlmsg_pid, nlh->nlmsg_flags);
+
+		/* Decode the userland command */
+		nlpps = (struct pps_netlink_msg*) NLMSG_DATA(nlh);
+		cmd = nlpps->cmd;
+		source = nlpps->source;
+
+		switch (cmd) {
+		case PPS_CREATE : {
+			dbg("PPS_CREATE: source %d", source);
+
+			/* Check if the requested source is allocated */
+			ret = pps_find_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+
+			nlpps->source = ret;
+			nlpps->ret = 0;
+
+			break;
+		}
+
+		case PPS_DESTROY : {
+			dbg("PPS_DESTROY: source %d", source);
+
+			/* Nothing to do here! Just answer ok... */
+			nlpps->ret = 0;
+
+			break;
+		}
+
+		case PPS_SETPARMS : {
+			dbg("PPS_SETPARMS: source %d", source);
+
+			/* Check the capabilities */
+			if (!capable(CAP_SYS_TIME)) {
+				nlpps->ret = -EPERM;
+				break;
+		 	}
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+			if ((nlpps->params.mode&~pps_source[source].info->mode) != 0) {
+				dbg("unsupported capabilities");
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+			if ((nlpps->params.mode&(PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0) {
+				dbg("capture mode unspecified");
+				nlpps->ret = -EINVAL;
+				break;
+			}
+			if ((nlpps->params.mode&(PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+				/* section 3.3 of RFC 2783 interpreted */
+				dbg("time format unspecified");
+				nlpps->params.mode |= PPS_TSFMT_TSPEC;
+			}
+
+			/* Save the new parameters */
+			pps_source[source].params = nlpps->params;
+
+			/* Restore the read only parameters */
+			if (pps_source[source].info->mode&PPS_CANWAIT)
+				pps_source[source].params.mode |= PPS_CANWAIT;
+			pps_source[source].params.api_version = PPS_API_VERS;
+
+			nlpps->ret = 0;
+
+			break;
+		}
+
+		case PPS_GETPARMS : {
+			dbg("PPS_GETPARMS: source %d", source);
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+
+			nlpps->params = pps_source[source].params;
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+	 	case PPS_GETCAP : {
+			dbg("PPS_GETCAP: source %d", source);
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+
+			nlpps->mode = pps_source[source].info->mode;
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+	 	case PPS_FETCH : {
+			dbg("PPS_FETCH: source %d", source);
+			queue = &pps_source[source].queue;
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+			if ((nlpps->tsformat != PPS_TSFMT_TSPEC) != 0 ) {
+				dbg("unsupported time format");
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+
+		 	/* Manage the timeout */
+			if (nlpps->timeout.tv_sec != -1) {
+				timeout = nlpps->timeout.tv_sec*HZ;
+				timeout += nlpps->timeout.tv_nsec/(1000000000/HZ);
+
+				if (timeout != 0) {
+					timeout = interruptible_sleep_on_timeout(queue, timeout);
+		  			if (timeout <= 0) {
+						dbg("timeout expired");
+						nlpps->ret = -ETIMEDOUT;
+						break;
+					}
+				}
+		 	}
+			else
+				interruptible_sleep_on(queue);
+
+			/* Return the fetched timestamp */
+			nlpps->info.assert_sequence = pps_source[source].assert_sequence;
+			nlpps->info.clear_sequence = pps_source[source].clear_sequence;
+			nlpps->info.assert_tu = pps_source[source].assert_tu;
+			nlpps->info.clear_tu = pps_source[source].clear_tu;
+			nlpps->info.current_mode = pps_source[source].current_mode;
+
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+	 	case PPS_KC_BIND : {
+			dbg("PPS_KC_BIND: source %d", source);
+			/* Feature currently not supported */
+			nlpps->ret = -EOPNOTSUPP;
+
+			break;
+	 	}
+
+		case PPS_FIND_SRC : {
+			dbg("PPS_FIND_SRC: source %d", source);
+			source = pps_find_source(source);
+			if (source < 0) {
+				dbg("no PPS devices found");
+				nlpps->ret = -ENODEV;
+				break;
+		 	}
+
+			/* Found! So copy the info */
+			nlpps->source = source;
+			strncpy(nlpps->name, pps_source[source].info->name,
+				PPS_MAX_NAME_LEN);
+			strncpy(nlpps->path, pps_source[source].info->path,
+				PPS_MAX_NAME_LEN);
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+		case PPS_FIND_PATH : {
+			dbg("PPS_FIND_PATH: source %s", nlpps->path);
+			source = pps_find_path(nlpps->path);
+			if (source < 0) {
+				dbg("no PPS devices found");
+				nlpps->ret = -ENODEV;
+				break;
+		 	}
+
+			/* Found! So copy the info */
+			nlpps->source = source;
+			strncpy(nlpps->name, pps_source[source].info->name,
+				PPS_MAX_NAME_LEN);
+			strncpy(nlpps->path, pps_source[source].info->path,
+				PPS_MAX_NAME_LEN);
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+		default : {
+			/* Unknow command */
+			dbg("unknow command %d", nlpps->cmd);
+
+			nlpps->ret = -EINVAL;
+		}
+		}
+
+		/* Send an answer to the userland */
+		id = NETLINK_CB(skb).pid;
+		dbg("start sending reply to ID %d...", id);
+		NETLINK_CB(skb).pid = 0;	/* from the kernel */
+		NETLINK_CB(skb).dst_group = 0;	/* not in mcast groups */
+
+		ret = netlink_unicast(nl_sk, skb, id, MSG_DONTWAIT);
+		dbg("... reply sent (%d)", ret);
+	}
+}
+
+/* --- Module staff -------------------------------------------------------- */
+
+static void __exit pps_exit(void)
+{
+	pps_sysfs_unregister();
+	sock_release(nl_sk->sk_socket);
+
+	info("LinuxPPS API ver. %d removed", PPS_API_VERS);
+}
+
+static int __init pps_init(void)
+{
+	int ret;
+
+	nl_sk = netlink_kernel_create(NETLINK_PPSAPI, 0,
+					pps_nl_data_ready, THIS_MODULE);
+	if (nl_sk == NULL) {
+		err("unable to create netlink kernel socket");
+		return -EBUSY;
+	}
+	dbg("netlink protocol %d created", NETLINK_PPSAPI);
+
+	/* Init the main struct */
+	memset(pps_source, 0, sizeof(struct pps_s)*PPS_MAX_SOURCES);
+
+	/* Register to sysfs */
+	ret = pps_sysfs_register();
+	if (ret < 0) {
+		err("unable to register sysfs");
+		goto pps_sysfs_register_error;
+	}
+
+	info("LinuxPPS API ver. %d registered", PPS_API_VERS);
+	info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>", PPS_VERSION);
+
+	return  0;
+
+pps_sysfs_register_error :
+
+	sock_release(nl_sk->sk_socket);
+
+	return ret;
+}
+
+subsys_initcall(pps_init);
+module_exit(pps_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("LinuxPPS support (RFC 2783) - ver. " PPS_VERSION);
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/pps/sysfs.c
--- /dev/null
+++ a/drivers/pps/sysfs.c
@@ -0,0 +1,209 @@
+/*
+ * sysfs.c -- sysfs support
+ *
+ *
+ * Copyright (C) 2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <linux/pps.h>
+
+/* ----- Private functions -------------------------------------------- */
+
+static ssize_t pps_show_assert(struct class_device *cdev, char *buf)
+{
+	struct pps_s *dev = class_get_devdata(cdev);
+
+	return sprintf(buf, "%ld.%09ld#%ld\n",
+			dev->assert_tu.tspec.tv_sec,
+			dev->assert_tu.tspec.tv_nsec,
+			dev->assert_sequence);
+}
+
+static ssize_t pps_show_clear(struct class_device *cdev, char *buf)
+{
+	struct pps_s *dev = class_get_devdata(cdev);
+
+	return sprintf(buf, "%ld.%09ld#%ld\n",
+			dev->clear_tu.tspec.tv_sec,
+			dev->clear_tu.tspec.tv_nsec,
+			dev->clear_sequence);
+}
+
+static ssize_t pps_show_mode(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%4x\n", info->mode);
+}
+
+static ssize_t pps_show_echo(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%d\n", !!info->echo);
+}
+
+static ssize_t pps_show_name(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%s\n", info->name);
+}
+
+static ssize_t pps_show_path(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%s\n", info->path);
+}
+
+/* ----- Files definitions -------------------------------------------- */
+
+#define DECLARE_INFO_ATTR(_name, _mode, _show, _store)			\
+{									\
+	.attr   = {							\
+		.name = __stringify(_name),				\
+		.mode = _mode, 						\
+		.owner = THIS_MODULE,					\
+	},								\
+	.show   = _show,						\
+	.store  = _store,						\
+}
+
+static struct class_device_attribute pps_class_device_attributes[] = {
+	DECLARE_INFO_ATTR(assert, 0444, pps_show_assert, NULL),
+	DECLARE_INFO_ATTR(clear, 0444, pps_show_clear, NULL),
+	DECLARE_INFO_ATTR(mode, 0444, pps_show_mode, NULL),
+	DECLARE_INFO_ATTR(echo, 0444, pps_show_echo, NULL),
+	DECLARE_INFO_ATTR(name, 0444, pps_show_name, NULL),
+	DECLARE_INFO_ATTR(path, 0444, pps_show_path, NULL),
+};
+
+/* ----- Class definitions -------------------------------------------- */
+
+static void pps_class_release(struct class_device *cdev)
+{
+	/* Nop??? */
+}
+
+static struct class pps_class = {
+	.name = "pps",
+	.release = pps_class_release,
+};
+
+/* ----- Public functions --------------------------------------------- */
+
+void pps_sysfs_remove_source_entry(struct pps_source_info_s *info) {
+	int i;
+
+	/* Sanity checks */
+	if (info == NULL)
+		return;
+
+	/* Delete info files */
+	if (info->mode&PPS_CAPTUREASSERT)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[0]);
+
+	if (info->mode&PPS_CAPTURECLEAR)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[1]);
+
+	for (i = 2; i < ARRAY_SIZE(pps_class_device_attributes); i++)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[i]);
+
+	/* Deregister the pps class */
+	class_device_unregister(&info->class_dev);
+}
+
+int pps_sysfs_create_source_entry(struct pps_source_info_s *info, int id) {
+	char buf[32];
+	int i, ret;
+
+	/* Sanity checks */
+	if (info == NULL || id >= PPS_MAX_SOURCES)
+		return -EINVAL;
+
+	/* Create dir class device name */
+	sprintf(buf, "%.02d", id);
+
+	/* Setup the class struct */
+	memset(&info->class_dev, 0, sizeof(struct class_device));
+	info->class_dev.class = &pps_class;
+	strlcpy(info->class_dev.class_id, buf, KOBJ_NAME_LEN);
+	class_set_devdata(&info->class_dev, &pps_source[id]);
+
+	/* Register the new class */
+	ret = class_device_register(&info->class_dev);
+	if (unlikely(ret))
+		goto error_class_device_register;
+
+	/* Create info files */
+
+	/* Create file "assert" and "clear" according to source capability */
+	if (info->mode&PPS_CAPTUREASSERT) {
+		ret = class_device_create_file(&info->class_dev,
+					&pps_class_device_attributes[0]);
+		i = 0;
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+	if (info->mode&PPS_CAPTURECLEAR) {
+		ret = class_device_create_file(&info->class_dev,
+					&pps_class_device_attributes[1]);
+		i = 1;
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+
+	for (i = 2; i < ARRAY_SIZE(pps_class_device_attributes); i++) {
+		ret = class_device_create_file(&info->class_dev,
+					&pps_class_device_attributes[i]);
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+
+	return 0;
+
+error_class_device_create_file :
+	while (--i >= 0)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[i]);
+
+	class_device_unregister(&info->class_dev);
+	/* Here the  release() method was already called */
+
+error_class_device_register :
+
+	return ret;
+}
+
+void pps_sysfs_unregister(void)
+{
+	class_unregister(&pps_class);
+}
+
+int pps_sysfs_register(void)
+{
+	return class_register(&pps_class);
+}
diff -puN drivers/serial/8250.c~linuxpps-pulse-per-second-support-for-linux drivers/serial/8250.c
--- a/drivers/serial/8250.c~linuxpps-pulse-per-second-support-for-linux
+++ a/drivers/serial/8250.c
@@ -2101,6 +2101,8 @@ serial8250_set_termios(struct uart_port 
 		up->ier |= UART_IER_MSI;
 	if (up->capabilities & UART_CAP_UUE)
 		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
+	if (up->port.flags & UPF_HARDPPS_CD)
+		up->ier |= UART_IER_MSI;	/* enable interrupts */
 
 	serial_out(up, UART_IER, up->ier);
 
@@ -2818,6 +2820,7 @@ void serial8250_unregister_port(int line
 	struct uart_8250_port *uart = &serial8250_ports[line];
 
 	mutex_lock(&serial_mutex);
+
 	uart_remove_one_port(&serial8250_reg, &uart->port);
 	if (serial8250_isa_devs) {
 		uart->port.flags &= ~UPF_BOOT_AUTOCONF;
diff -puN drivers/serial/serial_core.c~linuxpps-pulse-per-second-support-for-linux drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~linuxpps-pulse-per-second-support-for-linux
+++ a/drivers/serial/serial_core.c
@@ -34,6 +34,10 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 
+#ifdef CONFIG_PPS_CLIENT_UART
+#include <linux/pps.h>
+#endif
+
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
@@ -633,6 +637,52 @@ static int uart_get_info(struct uart_sta
 	return 0;
 }
 
+#ifdef CONFIG_PPS_CLIENT_UART
+
+static int
+uart_register_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	struct tty_driver *drv = port->info->tty->driver;
+	int ret;
+
+	snprintf(state->pps_info.name, PPS_MAX_NAME_LEN, "%s%d",
+		drv->driver_name, port->line);
+	snprintf(state->pps_info.path, PPS_MAX_NAME_LEN, "/dev/%s%d",
+		drv->name, port->line);
+
+	state->pps_info.mode = PPS_CAPTUREBOTH | \
+			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+			PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+	ret = pps_register_source(&state->pps_info, PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR,
+				-1 /* PPS ID is up to the system */);
+	if (ret < 0) {
+		err("cannot register PPS source \"%s\"", state->pps_info.path);
+		return ret;
+	}
+	port->pps_source = ret;
+	info("PPS source #%d \"%s\" added to the system ",
+		port->pps_source, state->pps_info.path);
+
+	return 0;
+}
+
+static void
+uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	pps_unregister_source(&state->pps_info);
+	dbg("PPS source #%d \"%s\" removed from the system",
+	port->pps_source, state->pps_info.path);
+}
+
+#else
+
+#define uart_register_pps_port(state, port)	do { } while (0)
+#define uart_unregister_pps_port(state, port)	do { } while (0)
+
+#endif /* CONFIG_PPS_CLIENT_UART */
+
 static int uart_set_info(struct uart_state *state,
 			 struct serial_struct __user *newinfo)
 {
@@ -807,11 +857,19 @@ static int uart_set_info(struct uart_sta
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
+	/* PPS support enabled/disabled? */
+	if ((old_flags & UPF_HARDPPS_CD) != (new_flags & UPF_HARDPPS_CD)) {
+		if (new_flags & UPF_HARDPPS_CD)
+			uart_register_pps_port(state, port);
+		else
+			uart_unregister_pps_port(state, port);
+	}
+
 	retval = 0;
 	if (port->type == PORT_UNKNOWN)
 		goto exit;
 	if (state->info->flags & UIF_INITIALIZED) {
-		if (((old_flags ^ port->flags) & UPF_SPD_MASK) ||
+		if (((old_flags ^ port->flags) & (UPF_SPD_MASK|UPF_HARDPPS_CD)) ||
 		    old_custom_divisor != port->custom_divisor) {
 			/*
 			 * If they're setting up a custom divisor or speed,
@@ -2101,6 +2159,12 @@ uart_configure_port(struct uart_driver *
 		port->ops->config_port(port, flags);
 	}
 
+	/*
+ 	 * Add the PPS support for the current port.
+ 	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_register_pps_port(state, port);
+
 	if (port->type != PORT_UNKNOWN) {
 		unsigned long flags;
 
@@ -2350,6 +2414,12 @@ int uart_remove_one_port(struct uart_dri
 	mutex_unlock(&state->mutex);
 
 	/*
+ 	 * Remove PPS support from the current port.
+	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_unregister_pps_port(state, port);
+
+	/*
 	 * Remove the devices from the tty layer
 	 */
 	tty_unregister_device(drv->tty_driver, port->line);
diff -puN include/linux/netlink.h~linuxpps-pulse-per-second-support-for-linux include/linux/netlink.h
--- a/include/linux/netlink.h~linuxpps-pulse-per-second-support-for-linux
+++ a/include/linux/netlink.h
@@ -24,6 +24,7 @@
 /* leave room for NETLINK_DM (DM Events) */
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
 #define NETLINK_ECRYPTFS	19
+#define NETLINK_PPSAPI          20	/* linuxPPS support */
 
 #define MAX_LINKS 32		
 
diff -puN include/linux/parport.h~linuxpps-pulse-per-second-support-for-linux include/linux/parport.h
--- a/include/linux/parport.h~linuxpps-pulse-per-second-support-for-linux
+++ a/include/linux/parport.h
@@ -104,6 +104,10 @@ typedef enum {
 #include <asm/ptrace.h>
 #include <asm/semaphore.h>
 
+#ifdef CONFIG_PPS_CLIENT_LP
+#include <linux/pps.h>
+#endif
+
 /* Define this later. */
 struct parport;
 struct pardevice;
@@ -327,6 +331,11 @@ struct parport {
 
 	struct list_head full_list;
 	struct parport *slaves[3];
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	struct pps_source_info_s pps_info;
+	int pps_source;		/* PPS source ID */
+#endif
 };
 
 #define DEFAULT_SPIN_TIME 500 /* us */
@@ -517,6 +526,12 @@ extern int parport_daisy_select (struct 
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
 static __inline__ void parport_generic_irq(int irq, struct parport *port)
 {
+#ifdef CONFIG_PPS_CLIENT_LP
+	pps_event(port->pps_source, PPS_CAPTUREASSERT, port);
+	dbg("parport_pc: PPS assert event at %lu on source #%d",
+		jiffies, port->pps_source);
+#endif
+
 	parport_ieee1284_interrupt (irq, port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
diff -puN /dev/null include/linux/pps.h
--- /dev/null
+++ a/include/linux/pps.h
@@ -0,0 +1,207 @@
+/*
+ * pps.h -- PPS API kernel header.
+ *
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#ifndef _PPS_H_
+#define _PPS_H_
+
+/* Implementation note: the logical states ``assert'' and ``clear''
+ * are implemented in terms of the chip register, i.e. ``assert''
+ * means the bit is set.  */
+
+/* --- 3.2 New data structures --------------------------------------------- */
+
+#ifndef __KERNEL__
+#include <asm/types.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#endif
+#include <linux/netlink.h>
+
+#define PPS_API_VERS_2          2       /* LinuxPPS proposal, dated 2006-05 */
+#define PPS_API_VERS            PPS_API_VERS_2
+#define LINUXPSS_API            1       /* mark LinuxPPS API */
+
+#define PPS_MAX_NAME_LEN	32
+
+typedef unsigned long pps_seq_t;        /* sequence number */
+
+typedef struct ntp_fp {
+	unsigned int integral;
+	unsigned int fractional;
+} ntp_fp_t;				/* NTP-compatible time stamp */
+
+typedef union pps_timeu {
+	struct timespec tspec;
+	ntp_fp_t ntpfp;
+	unsigned long longpad[3];
+} pps_timeu_t;			/* generic data type to represent time stamps */
+
+typedef struct pps_info {
+	pps_seq_t assert_sequence;	/* seq. num. of assert event */
+	pps_seq_t clear_sequence; 	/* seq. num. of clear event */
+	pps_timeu_t assert_tu;		/* time of assert event */
+	pps_timeu_t clear_tu;		/* time of clear event */
+	int current_mode;		/* current mode bits */
+} pps_info_t;
+
+typedef struct pps_params {
+	int api_version;		/* API version # */
+	int mode;			/* mode bits */
+	pps_timeu_t assert_off_tu;	/* offset compensation for assert */
+	pps_timeu_t clear_off_tu;	/* offset compensation for clear */
+} pps_params_t;
+
+/* --- 3.3 Mode bit definitions -------------------------------------------- */
+
+/* Device/implementation parameters */
+#define PPS_CAPTUREASSERT	0x01	/* capture assert events */
+#define PPS_CAPTURECLEAR	0x02	/* capture clear events */
+#define PPS_CAPTUREBOTH		0x03	/* capture assert and clear events */
+
+#define PPS_OFFSETASSERT	0x10	/* apply compensation for assert ev. */
+#define PPS_OFFSETCLEAR		0x20	/* apply compensation for clear ev. */
+
+#define PPS_CANWAIT		0x100	/* can we wait for an event? */
+#define PPS_CANPOLL		0x200	/* bit reserved for future use */
+
+/* Kernel actions */
+#define PPS_ECHOASSERT		0x40	/* feed back assert event to output */
+#define PPS_ECHOCLEAR		0x80	/* feed back clear event to output */
+
+/* Timestamp formats */
+#define PPS_TSFMT_TSPEC		0x1000	/* select timespec format */
+#define PPS_TSFMT_NTPFP		0x2000	/* select NTP format */
+
+/* --- 3.4.4 New functions: disciplining the kernel timebase --------------- */
+
+/* Kernel consumers */
+#define PPS_KC_HARDPPS		0	/* hardpps() (or equivalent) */
+#define PPS_KC_HARDPPS_PLL	1	/* hardpps() constrained to
+					   use a phase-locked loop */
+#define PPS_KC_HARDPPS_FLL	2	/* hardpps() constrained to
+					use a frequency-locked loop */
+/* --- Here begins the implementation-specific part! ----------------------- */
+
+struct pps_netlink_msg {
+	int cmd;			/* the command to execute */
+	int source;
+	char name[PPS_MAX_NAME_LEN];	/* symbolic name */
+	char path[PPS_MAX_NAME_LEN];	/* path of the connected device */
+	int consumer;			/* selected kernel consumer */
+	pps_params_t params;
+	int mode;			/* edge */
+	int tsformat;			/* format of time stamps */
+	pps_info_t info;
+	struct timespec timeout;
+	int ret;
+};
+#define PPSAPI_MAX_PAYLOAD	sizeof(struct pps_netlink_msg)
+
+#define PPS_CREATE		1
+#define PPS_DESTROY		2
+#define PPS_SETPARMS		3
+#define PPS_GETPARMS		4
+#define PPS_GETCAP		5
+#define PPS_FETCH		6
+#define PPS_KC_BIND		7
+#define PPS_FIND_SRC		8
+#define PPS_FIND_PATH		9
+
+#ifdef __KERNEL__
+
+#include <linux/socket.h>
+#include <net/sock.h>
+
+/* ----- Misc macros -------------------------------------------------- */
+
+#define PPS_VERSION	"3.1.0"
+
+#ifdef CONFIG_PPS_DEBUG
+#define dbg(format, arg...) printk(KERN_DEBUG "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+#else
+#define dbg(format, arg...) do {} while (0)
+#endif
+
+#define err(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+#define info(format, arg...) printk(KERN_INFO "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+
+/* --- Global defines ------------------------------------------------------ */
+
+#define PPS_MAX_SOURCES		16
+
+/* The specific PPS source info */
+struct pps_source_info_s {
+	char name[PPS_MAX_NAME_LEN];		/* simbolic name */
+	char path[PPS_MAX_NAME_LEN];		/* path of connected device */
+	int mode;				/* PPS's allowed mode */
+
+	void (*echo)(int source, int event, void *data);/* the PPS echo function */
+
+	/* sysfs section */
+	struct class_device class_dev;
+};
+
+/* The main struct */
+struct pps_s {
+	struct pps_source_info_s *info;		/* PSS source info */
+
+	pps_params_t params;			/* PPS's current params */
+
+	volatile pps_seq_t assert_sequence;	/* PPS' assert event seq # */
+	volatile pps_seq_t clear_sequence;	/* PPS' clear event seq # */
+	volatile pps_timeu_t assert_tu;
+	volatile pps_timeu_t clear_tu;
+	int current_mode;			/* PPS mode at event time */
+
+	wait_queue_head_t queue;		/* PPS event queue */
+};
+
+/* --- Global variables ---------------------------------------------------- */
+
+extern struct pps_s pps_source[PPS_MAX_SOURCES];
+extern spinlock_t pps_lock;
+
+/* --- Global functions ---------------------------------------------------- */
+
+static inline int pps_is_allocated(int source) {
+	return pps_source[source].info != NULL;
+}
+
+#define to_pps_info(obj) container_of((obj), struct pps_source_info_s, class_dev)
+
+/* --- Exported functions -------------------------------------------------- */
+
+extern int pps_register_source(struct pps_source_info_s *info, int default_params, int try_id);
+extern void pps_unregister_source(struct pps_source_info_s *info);
+extern void pps_event(int source, int event, void *data);
+
+extern int pps_sysfs_create_source_entry(struct pps_source_info_s *info, int id);
+extern void pps_sysfs_remove_source_entry(struct pps_source_info_s *info);
+extern int pps_sysfs_register(void);
+extern void pps_sysfs_unregister(void);
+
+#endif /* __KERNEL__ */
+
+#endif /* _PPS_H_ */
diff -puN include/linux/serial_core.h~linuxpps-pulse-per-second-support-for-linux include/linux/serial_core.h
--- a/include/linux/serial_core.h~linuxpps-pulse-per-second-support-for-linux
+++ a/include/linux/serial_core.h
@@ -149,6 +149,10 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 
+#ifdef CONFIG_PPS_CLIENT_UART
+#include <linux/pps.h>
+#endif
+
 struct uart_port;
 struct uart_info;
 struct serial_struct;
@@ -227,6 +231,9 @@ struct uart_port {
 	unsigned char		regshift;		/* reg offset shift */
 	unsigned char		iotype;			/* io access style */
 	unsigned char		unused1;
+#ifdef CONFIG_PPS_CLIENT_UART
+	int			pps_source;		/* PPS source ID */
+#endif
 
 #define UPIO_PORT		(0)
 #define UPIO_HUB6		(1)
@@ -271,7 +278,8 @@ struct uart_port {
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
 #define UPF_CHANGE_MASK		((__force upf_t) (0x17fff))
-#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY))
+#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY\
+							|UPF_HARDPPS_CD))
 
 	unsigned int		mctrl;			/* current modem ctrl settings */
 	unsigned int		timeout;		/* character-based timeout */
@@ -303,6 +311,10 @@ struct uart_state {
 	struct uart_info	*info;
 	struct uart_port	*port;
 
+#ifdef CONFIG_PPS_CLIENT_UART
+        struct pps_source_info_s pps_info;
+#endif
+
 	struct mutex		mutex;
 };
 
@@ -467,13 +479,23 @@ uart_handle_dcd_change(struct uart_port 
 {
 	struct uart_info *info = port->info;
 
-	port->icount.dcd++;
-
-#ifdef CONFIG_HARD_PPS
-	if ((port->flags & UPF_HARDPPS_CD) && status)
-		hardpps();
+#ifdef CONFIG_PPS_CLIENT_UART
+	if (port->flags & UPF_HARDPPS_CD) {
+		if (status) {
+			pps_event(port->pps_source, PPS_CAPTUREASSERT, port);
+			dbg("serial8250: PPS assert event at %lu on source #%d",
+				jiffies, port->pps_source);
+		}
+		else {
+			pps_event(port->pps_source, PPS_CAPTURECLEAR, port);
+			dbg("serial8250: PPS clear event at %lu on source #%d",
+				jiffies, port->pps_source);
+		}
+	}
 #endif
 
+	port->icount.dcd++;
+
 	if (info->flags & UIF_CHECK_CD) {
 		if (status)
 			wake_up_interruptible(&info->open_wait);
_

Patches currently in -mm which might be from giometti@enneenne.com are

origin.patch
i2c-tsl2550-support.patch
linuxpps-pulse-per-second-support-for-linux.patch
linuxpps-pulse-per-second-support-for-linux-fix.patch
