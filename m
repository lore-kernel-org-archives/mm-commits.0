From: akpm@linux-foundation.org
Subject: [to-be-updated] linuxpps-core-support.patch removed from -mm tree
Date: Tue, 26 May 2009 16:31:02 -0700
Message-ID: <200905262331.n4QNV2OC008924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368AbZEZXcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 19:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, hch@infradead.org, kay.sievers@vrfy.org, mtk.manpages@googlemail.com, randy.dunlap@oracle.com, zippel


The patch titled
     LinuxPPS: core support
has been removed from the -mm tree.  Its filename was
     linuxpps-core-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: LinuxPPS: core support
From: Rodolfo Giometti <giometti@linux.it>

This patch adds the kernel side of the PPS support currently named
"LinuxPPS".

PPS means "pulse per second" and a PPS source is just a device which
provides a high precision signal each second so that an application can
use it to adjust system clock time.

Common use is the combination of the NTPD as userland program with a GPS
receiver as PPS source to obtain a wallclock-time with sub-millisecond
synchronisation to UTC.

To obtain this goal the userland programs shoud use the PPS API
specification (RFC 2783 - Pulse-Per-Second API for UNIX-like Operating
Systems, Version 1.0) which in part is implemented by this patch.  It
provides a set of chars devices, one per PPS source, which can be used to
get the time signal.  The RFC's functions can be implemented by accessing
to these char devices.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-pps  |   73 +++++
 Documentation/ioctl/ioctl-number.txt |    2 
 Documentation/pps/pps.txt            |  172 +++++++++++++
 MAINTAINERS                          |    7 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/pps/Kconfig                  |   33 ++
 drivers/pps/Makefile                 |    8 
 drivers/pps/kapi.c                   |  329 +++++++++++++++++++++++++
 drivers/pps/pps.c                    |  312 +++++++++++++++++++++++
 drivers/pps/sysfs.c                  |  104 +++++++
 include/linux/Kbuild                 |    1 
 include/linux/pps.h                  |  194 ++++++++++++++
 13 files changed, 1238 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-pps
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-pps
@@ -0,0 +1,73 @@
+What:		/sys/class/pps/
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ directory will contain files and
+		directories that will provide a unified interface to
+		the PPS sources.
+
+What:		/sys/class/pps/ppsX/
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ppsX/ directory is related to X-th
+		PPS source into the system. Each directory will
+		contain files to manage and control its PPS source.
+
+What:		/sys/class/pps/ppsX/assert
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ppsX/assert file reports the assert events
+		and the assert sequence number of the X-th source in the form:
+
+			<secs>.<nsec>#<sequence>
+
+		If the source has no assert events the content of this file
+		is empty.
+
+What:		/sys/class/pps/ppsX/clear
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ppsX/clear file reports the clear events
+		and the clear sequence number of the X-th source in the form:
+
+			<secs>.<nsec>#<sequence>
+
+		If the source has no clear events the content of this file
+		is empty.
+
+What:		/sys/class/pps/ppsX/mode
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ppsX/mode file reports the functioning
+		mode of the X-th source in hexadecimal encoding.
+
+		Please, refer to linux/include/linux/pps.h for further
+		info.
+
+What:		/sys/class/pps/ppsX/echo
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ppsX/echo file reports if the X-th does
+		or does not support an "echo" function.
+
+What:		/sys/class/pps/ppsX/name
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ppsX/name file reports the name of the
+		X-th source.
+
+What:		/sys/class/pps/ppsX/path
+Date:		February 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/pps/ppsX/path file reports the path name of
+		the device connected with the X-th source.
+
+		If the source is not connected with any device the content
+		of this file is empty.
diff -puN Documentation/ioctl/ioctl-number.txt~linuxpps-core-support Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~linuxpps-core-support
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -149,6 +149,8 @@ Code	Seq#	Include File		Comments
 'p'	40-7F	linux/nvram.h
 'p'	80-9F				user-space parport
 					<mailto:tim@cyberelk.net>
+'p'	a1-a4	linux/pps.h		LinuxPPS
+					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
 'q'	80-FF				Internet PhoneJACK, Internet LineJACK
 					<http://www.quicknet.net>
diff -puN /dev/null Documentation/pps/pps.txt
--- /dev/null
+++ a/Documentation/pps/pps.txt
@@ -0,0 +1,172 @@
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
+LinuxPPS provides a programming interface (API) to define in the
+system several PPS sources.
+
+PPS means "pulse per second" and a PPS source is just a device which
+provides a high precision signal each second so that an application
+can use it to adjust system clock time.
+
+A PPS source can be connected to a serial port (usually to the Data
+Carrier Detect pin) or to a parallel port (ACK-pin) or to a special
+CPU's GPIOs (this is the common case in embedded systems) but in each
+case when a new pulse arrives the system must apply to it a timestamp
+and record it for userland.
+
+Common use is the combination of the NTPD as userland program, with a
+GPS receiver as PPS source, to obtain a wallclock-time with
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
+useful besides(!) the gathering of timestamps as it is the central
+task for a PPS-API. But this assumption does not work for a single
+purpose GPIO line. In this case even basic file-related functionality
+(like read() and write()) makes no sense at all and should not be a
+precondition for the use of a PPS-API.
+
+The problem can be simply solved if you consider that a PPS source is
+not always connected with a GPS data source.
+
+So your programs should check if the GPS data source (the serial port
+for instance) is a PPS source too, and if not they should provide the
+possibility to open another device as PPS source.
+
+In LinuxPPS the PPS sources are simply char devices usually mapped
+into files /dev/pps0, /dev/pps1, etc..
+
+
+Coding example
+--------------
+
+To register a PPS source into the kernel you should define a struct
+pps_source_info_s as follows:
+
+    static struct pps_source_info pps_ktimer_info = {
+	    .name         = "ktimer",
+	    .path         = "",
+	    .mode         = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+			    PPS_ECHOASSERT | \
+			    PPS_CANWAIT | PPS_TSFMT_TSPEC,
+	    .echo         = pps_ktimer_echo,
+	    .owner        = THIS_MODULE,
+    };
+
+and then calling the function pps_register_source() in your
+intialization routine as follows:
+
+    source = pps_register_source(&pps_ktimer_info,
+			PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
+
+The pps_register_source() prototype is:
+
+  int pps_register_source(struct pps_source_info_s *info, int default_params)
+
+where "info" is a pointer to a structure that describes a particular
+PPS source, "default_params" tells the system what the initial default
+parameters for the device should be (it is obvious that these parameters
+must be a subset of ones defined in the struct
+pps_source_info_s which describe the capabilities of the driver).
+
+Once you have registered a new PPS source into the system you can
+signal an assert event (for example in the interrupt handler routine)
+just using:
+
+    pps_event(source, &ts, PPS_CAPTUREASSERT, ptr)
+
+where "ts" is the event's timestamp.
+
+The same function may also run the defined echo function
+(pps_ktimer_echo(), passing to it the "ptr" pointer) if the user
+asked for that... etc..
+
+Please see the file drivers/pps/clients/ktimer.c for example code.
+
+
+SYSFS support
+-------------
+
+If the SYSFS filesystem is enabled in the kernel it provides a new class:
+
+   $ ls /sys/class/pps/
+   pps0/  pps1/  pps2/
+
+Every directory is the ID of a PPS sources defined in the system and
+inside you find several files:
+
+   $ ls /sys/class/pps/pps0/
+   assert	clear  echo  mode  name  path  subsystem@  uevent
+
+Inside each "assert" and "clear" file you can find the timestamp and a
+sequence number:
+
+   $ cat /sys/class/pps/pps0/assert
+   1170026870.983207967#8
+
+Where before the "#" is the timestamp in seconds; after it is the
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
+
+
+Testing the PPS support
+-----------------------
+
+In order to test the PPS support even without specific hardware you can use
+the ktimer driver (see the client subsection in the PPS configuration menu)
+and the userland tools provided into Documentaion/pps/ directory.
+
+Once you have enabled the compilation of ktimer just modprobe it (if
+not statically compiled):
+
+   # modprobe ktimer
+
+and the run ppstest as follow:
+
+   $ ./ppstest /dev/pps0
+   trying PPS source "/dev/pps1"
+   found PPS source "/dev/pps1"
+   ok, found 1 source(s), now start fetching data...
+   source 0 - assert 1186592699.388832443, sequence: 364 - clear  0.000000000, sequence: 0
+   source 0 - assert 1186592700.388931295, sequence: 365 - clear  0.000000000, sequence: 0
+   source 0 - assert 1186592701.389032765, sequence: 366 - clear  0.000000000, sequence: 0
+
+Please, note that to compile userland programs you need the file timepps.h
+(see Documentation/pps/).
diff -puN MAINTAINERS~linuxpps-core-support MAINTAINERS
--- a/MAINTAINERS~linuxpps-core-support
+++ a/MAINTAINERS
@@ -4478,6 +4478,13 @@ S:	Maintained
 F:	drivers/net/pppol2tp.c
 F:	include/linux/if_pppol2tp.h
 
+PPS SUPPORT
+P:	Rodolfo Giometti
+M:	giometti@enneenne.com
+W:	http://wiki.enneenne.com/index.php/LinuxPPS_support
+L:	linuxpps@ml.enneenne.com (subscribers-only)
+S:	Maintained
+
 PREEMPTIBLE KERNEL
 P:	Robert Love
 M:	rml@tech9.net
diff -puN drivers/Kconfig~linuxpps-core-support drivers/Kconfig
--- a/drivers/Kconfig~linuxpps-core-support
+++ a/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/pps/Kconfig"
+
 source "drivers/gpio/Kconfig"
 
 source "drivers/w1/Kconfig"
diff -puN drivers/Makefile~linuxpps-core-support drivers/Makefile
--- a/drivers/Makefile~linuxpps-core-support
+++ a/drivers/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_SERIO)		+= input/serio/
 obj-$(CONFIG_GAMEPORT)		+= input/gameport/
 obj-$(CONFIG_INPUT)		+= input/
 obj-$(CONFIG_I2O)		+= message/
+obj-$(CONFIG_PPS)		+= pps/
 obj-$(CONFIG_RTC_LIB)		+= rtc/
 obj-y				+= i2c/ media/
 obj-$(CONFIG_W1)		+= w1/
diff -puN /dev/null drivers/pps/Kconfig
--- /dev/null
+++ a/drivers/pps/Kconfig
@@ -0,0 +1,33 @@
+#
+# PPS support configuration
+#
+
+menu "PPS support"
+
+config PPS
+	tristate "PPS support"
+	depends on EXPERIMENTAL
+	---help---
+	  PPS (Pulse Per Second) is a special pulse provided by some GPS
+	  antennae. Userland can use it to get a high-precision time
+	  reference.
+
+	  Some antennae's PPS signals are connected with the CD (Carrier
+	  Detect) pin of the serial line they use to communicate with the
+	  host. In this case use the SERIAL_LINE client support.
+
+	  Some antennae's PPS signals are connected with some special host
+	  inputs so you have to enable the corresponding client support.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pps_core.ko.
+
+config PPS_DEBUG
+	bool "PPS debugging messages"
+	depends on PPS
+	help
+	  Say Y here if you want the PPS support to produce a bunch of debug
+	  messages to the system log.  Select this if you are having a
+	  problem with PPS support and want to see more of what is going on.
+
+endmenu
diff -puN /dev/null drivers/pps/Makefile
--- /dev/null
+++ a/drivers/pps/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the PPS core.
+#
+
+pps_core-y			:= pps.o kapi.o sysfs.o
+obj-$(CONFIG_PPS)		:= pps_core.o
+
+ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
diff -puN /dev/null drivers/pps/kapi.c
--- /dev/null
+++ a/drivers/pps/kapi.c
@@ -0,0 +1,329 @@
+/*
+ * kernel API
+ *
+ *
+ * Copyright (C) 2005-2009   Rodolfo Giometti <giometti@linux.it>
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
+#include <linux/sched.h>
+#include <linux/time.h>
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/fs.h>
+#include <linux/pps.h>
+
+/*
+ * Global variables
+ */
+
+DEFINE_SPINLOCK(pps_idr_lock);
+DEFINE_IDR(pps_idr);
+
+/*
+ * Local functions
+ */
+
+static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
+{
+	ts->nsec += offset->nsec;
+	while (ts->nsec >= NSEC_PER_SEC) {
+		ts->nsec -= NSEC_PER_SEC;
+		ts->sec++;
+	}
+	while (ts->nsec < 0) {
+		ts->nsec += NSEC_PER_SEC;
+		ts->sec--;
+	}
+	ts->sec += offset->sec;
+}
+
+/*
+ * Exported functions
+ */
+
+/* pps_get_source - find a PPS source
+ * @source: the PPS source ID.
+ *
+ * This function is used to find an already registered PPS source into the
+ * system.
+ *
+ * The function returns NULL if found nothing, otherwise it returns a pointer
+ * to the PPS source data struct (the refcounter is incremented by 1).
+ */
+
+struct pps_device *pps_get_source(int source)
+{
+	struct pps_device *pps;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pps_idr_lock, flags);
+
+	pps = idr_find(&pps_idr, source);
+	if (pps != NULL)
+		atomic_inc(&pps->usage);
+
+	spin_unlock_irqrestore(&pps_idr_lock, flags);
+
+	return pps;
+}
+
+/* pps_put_source - free the PPS source data
+ * @pps: a pointer to the PPS source.
+ *
+ * This function is used to free a PPS data struct if its refcount is 0.
+ */
+
+void pps_put_source(struct pps_device *pps)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pps_idr_lock, flags);
+	BUG_ON(atomic_read(&pps->usage) == 0);
+
+	if (!atomic_dec_and_test(&pps->usage)) {
+		pps = NULL;
+		goto exit;
+	}
+
+	/* No more reference to the PPS source. We can safely remove the
+	 * PPS data struct.
+	 */
+	idr_remove(&pps_idr, pps->id);
+
+exit:
+	spin_unlock_irqrestore(&pps_idr_lock, flags);
+	kfree(pps);
+}
+
+/* pps_register_source - add a PPS source in the system
+ * @info: the PPS info struct
+ * @default_params: the default PPS parameters of the new source
+ *
+ * This function is used to add a new PPS source in the system. The new
+ * source is described by info's fields and it will have, as default PPS
+ * parameters, the ones specified into default_params.
+ *
+ * The function returns, in case of success, the PPS source ID.
+ */
+
+int pps_register_source(struct pps_source_info *info, int default_params)
+{
+	struct pps_device *pps;
+	int id;
+	int err;
+
+	/* Sanity checks */
+	if ((info->mode & default_params) != default_params) {
+		printk(KERN_ERR "pps: %s: unsupported default parameters\n",
+					info->name);
+		err = -EINVAL;
+		goto pps_register_source_exit;
+	}
+	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
+			info->echo == NULL) {
+		printk(KERN_ERR "pps: %s: echo function is not defined\n",
+					info->name);
+		err = -EINVAL;
+		goto pps_register_source_exit;
+	}
+	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
+		printk(KERN_ERR "pps: %s: unspecified time format\n",
+					info->name);
+		err = -EINVAL;
+		goto pps_register_source_exit;
+	}
+
+	/* Allocate memory for the new PPS source struct */
+	pps = kzalloc(sizeof(struct pps_device), GFP_KERNEL);
+	if (pps == NULL) {
+		err = -ENOMEM;
+		goto pps_register_source_exit;
+	}
+
+	/* These initializations must be done before calling idr_get_new()
+	 * in order to avoid reces into pps_event().
+	 */
+	pps->params.api_version = PPS_API_VERS;
+	pps->params.mode = default_params;
+	pps->info = *info;
+
+	init_waitqueue_head(&pps->queue);
+	spin_lock_init(&pps->lock);
+	atomic_set(&pps->usage, 1);
+
+	/* Get new ID for the new PPS source */
+	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
+		err = -ENOMEM;
+		goto kfree_pps;
+	}
+
+	spin_lock_irq(&pps_idr_lock);
+
+	/* Now really allocate the PPS source.
+	 * After idr_get_new() calling the new source will be freely available
+	 * into the kernel.
+	 */
+	err = idr_get_new(&pps_idr, pps, &id);
+	if (err < 0) {
+		spin_unlock_irq(&pps_idr_lock);
+		goto kfree_pps;
+	}
+
+	id = id & MAX_ID_MASK;
+	if (id >= PPS_MAX_SOURCES) {
+		spin_unlock_irq(&pps_idr_lock);
+
+		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
+					info->name);
+		err = -EBUSY;
+		goto free_idr;
+	}
+	pps->id = id;
+
+	spin_unlock_irq(&pps_idr_lock);
+
+	/* Create the char device */
+	err = pps_register_cdev(pps);
+	if (err < 0) {
+		printk(KERN_ERR "pps: %s: unable to create char device\n",
+					info->name);
+		goto free_idr;
+	}
+
+	pr_info("new PPS source %s at ID %d\n", info->name, id);
+
+	return id;
+
+free_idr:
+	spin_lock_irq(&pps_idr_lock);
+	idr_remove(&pps_idr, id);
+	spin_unlock_irq(&pps_idr_lock);
+
+kfree_pps:
+	kfree(pps);
+
+pps_register_source_exit:
+	printk(KERN_ERR "pps: %s: unable to register source\n", info->name);
+
+	return err;
+}
+EXPORT_SYMBOL(pps_register_source);
+
+/* pps_unregister_source - remove a PPS source from the system
+ * @source: the PPS source ID
+ *
+ * This function is used to remove a previously registered PPS source from
+ * the system.
+ */
+
+void pps_unregister_source(int source)
+{
+	struct pps_device *pps;
+
+	spin_lock_irq(&pps_idr_lock);
+	pps = idr_find(&pps_idr, source);
+
+	if (!pps) {
+		BUG();
+		spin_unlock_irq(&pps_idr_lock);
+		return;
+	}
+	spin_unlock_irq(&pps_idr_lock);
+
+	pps_unregister_cdev(pps);
+	pps_put_source(pps);
+}
+EXPORT_SYMBOL(pps_unregister_source);
+
+/* pps_event - register a PPS event into the system
+ * @source: the PPS source ID
+ * @ts: the event timestamp
+ * @event: the event type
+ * @data: userdef pointer
+ *
+ * This function is used by each PPS client in order to register a new
+ * PPS event into the system (it's usually called inside an IRQ handler).
+ *
+ * If an echo function is associated with the PPS source it will be called
+ * as:
+ *	pps->info.echo(source, event, data);
+ */
+
+void pps_event(int source, struct pps_ktime *ts, int event, void *data)
+{
+	struct pps_device *pps;
+	unsigned long flags;
+
+	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
+		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
+			event, source);
+		return;
+	}
+
+	pps = pps_get_source(source);
+	if (!pps)
+		return;
+
+	pr_debug("PPS event on source %d at %llu.%06u\n",
+			pps->id, (unsigned long long) ts->sec, ts->nsec);
+
+	spin_lock_irqsave(&pps->lock, flags);
+
+	/* Must call the echo function? */
+	if ((pps->params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
+		pps->info.echo(source, event, data);
+
+	/* Check the event */
+	pps->current_mode = pps->params.mode;
+	if (event & PPS_CAPTUREASSERT) {
+		/* We have to add an offset? */
+		if (pps->params.mode & PPS_OFFSETASSERT)
+			pps_add_offset(ts, &pps->params.assert_off_tu);
+
+		/* Save the time stamp */
+		pps->assert_tu = *ts;
+		pps->assert_sequence++;
+		pr_debug("capture assert seq #%u for source %d\n",
+			pps->assert_sequence, source);
+	}
+	if (event & PPS_CAPTURECLEAR) {
+		/* We have to add an offset? */
+		if (pps->params.mode & PPS_OFFSETCLEAR)
+			pps_add_offset(ts, &pps->params.clear_off_tu);
+
+		/* Save the time stamp */
+		pps->clear_tu = *ts;
+		pps->clear_sequence++;
+		pr_debug("capture clear seq #%u for source %d\n",
+			pps->clear_sequence, source);
+	}
+
+	pps->go = ~0;
+	wake_up_interruptible(&pps->queue);
+
+	kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
+
+	spin_unlock_irqrestore(&pps->lock, flags);
+
+	/* Now we can release the PPS source for (possible) deregistration */
+	pps_put_source(pps);
+}
+EXPORT_SYMBOL(pps_event);
diff -puN /dev/null drivers/pps/pps.c
--- /dev/null
+++ a/drivers/pps/pps.c
@@ -0,0 +1,312 @@
+/*
+ * PPS core file
+ *
+ *
+ * Copyright (C) 2005-2009   Rodolfo Giometti <giometti@linux.it>
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
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/idr.h>
+#include <linux/cdev.h>
+#include <linux/poll.h>
+#include <linux/pps.h>
+
+/*
+ * Local variables
+ */
+
+static dev_t pps_devt;
+static struct class *pps_class;
+
+/*
+ * Char device methods
+ */
+
+static unsigned int pps_cdev_poll(struct file *file, poll_table *wait)
+{
+	struct pps_device *pps = file->private_data;
+
+	poll_wait(file, &pps->queue, wait);
+
+	return POLLIN | POLLRDNORM;
+}
+
+static int pps_cdev_fasync(int fd, struct file *file, int on)
+{
+	struct pps_device *pps = file->private_data;
+	return fasync_helper(fd, file, on, &pps->async_queue);
+}
+
+static long pps_cdev_ioctl(struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	struct pps_device *pps = file->private_data;
+	struct pps_kparams params;
+	struct pps_fdata fdata;
+	unsigned long ticks;
+	void __user *uarg = (void __user *) arg;
+	int __user *iuarg = (int __user *) arg;
+	int err;
+
+	switch (cmd) {
+	case PPS_GETPARAMS:
+		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
+
+		/* Return current parameters */
+		err = copy_to_user(uarg, &pps->params,
+						sizeof(struct pps_kparams));
+		if (err)
+			return -EFAULT;
+
+		break;
+
+	case PPS_SETPARAMS:
+		pr_debug("PPS_SETPARAMS: source %d\n", pps->id);
+
+		/* Check the capabilities */
+		if (!capable(CAP_SYS_TIME))
+			return -EPERM;
+
+		err = copy_from_user(&params, uarg, sizeof(struct pps_kparams));
+		if (err)
+			return -EFAULT;
+		if (!(params.mode & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR))) {
+			pr_debug("capture mode unspecified (%x)\n",
+								params.mode);
+			return -EINVAL;
+		}
+
+		/* Check for supported capabilities */
+		if ((params.mode & ~pps->info.mode) != 0) {
+			pr_debug("unsupported capabilities (%x)\n",
+								params.mode);
+			return -EINVAL;
+		}
+
+		spin_lock_irq(&pps->lock);
+
+		/* Save the new parameters */
+		pps->params = params;
+
+		/* Restore the read only parameters */
+		if ((params.mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
+			/* section 3.3 of RFC 2783 interpreted */
+			pr_debug("time format unspecified (%x)\n",
+								params.mode);
+			pps->params.mode |= PPS_TSFMT_TSPEC;
+		}
+		if (pps->info.mode & PPS_CANWAIT)
+			pps->params.mode |= PPS_CANWAIT;
+		pps->params.api_version = PPS_API_VERS;
+
+		spin_unlock_irq(&pps->lock);
+
+		break;
+
+	case PPS_GETCAP:
+		pr_debug("PPS_GETCAP: source %d\n", pps->id);
+
+		err = put_user(pps->info.mode, iuarg);
+		if (err)
+			return -EFAULT;
+
+		break;
+
+	case PPS_FETCH:
+		pr_debug("PPS_FETCH: source %d\n", pps->id);
+
+		err = copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
+		if (err)
+			return -EFAULT;
+
+		pps->go = 0;
+
+		/* Manage the timeout */
+		if (fdata.timeout.flags & PPS_TIME_INVALID)
+			err = wait_event_interruptible(pps->queue, pps->go);
+		else {
+			pr_debug("timeout %lld.%09d\n",
+					(long long) fdata.timeout.sec,
+					fdata.timeout.nsec);
+			ticks = fdata.timeout.sec * HZ;
+			ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
+
+			if (ticks != 0) {
+				err = wait_event_interruptible_timeout(
+						pps->queue, pps->go, ticks);
+				if (err == 0)
+					return -ETIMEDOUT;
+			}
+		}
+
+		/* Check for pending signals */
+		if (err == -ERESTARTSYS) {
+			pr_debug("pending signal caught\n");
+			return -EINTR;
+		}
+
+		/* Return the fetched timestamp */
+		spin_lock_irq(&pps->lock);
+
+		fdata.info.assert_sequence = pps->assert_sequence;
+		fdata.info.clear_sequence = pps->clear_sequence;
+		fdata.info.assert_tu = pps->assert_tu;
+		fdata.info.clear_tu = pps->clear_tu;
+		fdata.info.current_mode = pps->current_mode;
+
+		spin_unlock_irq(&pps->lock);
+
+		err = copy_to_user(uarg, &fdata, sizeof(struct pps_fdata));
+		if (err)
+			return -EFAULT;
+
+		break;
+
+	default:
+		return -ENOTTY;
+		break;
+	}
+
+	return 0;
+}
+
+static int pps_cdev_open(struct inode *inode, struct file *file)
+{
+	struct pps_device *pps = container_of(inode->i_cdev,
+						struct pps_device, cdev);
+	int found;
+
+	found = pps_get_source(pps->id) != 0;
+	if (!found)
+		return -ENODEV;
+
+	file->private_data = pps;
+
+	return 0;
+}
+
+static int pps_cdev_release(struct inode *inode, struct file *file)
+{
+	struct pps_device *pps = file->private_data;
+
+	/* Free the PPS source and wake up (possible) deregistration */
+	pps_put_source(pps);
+
+	return 0;
+}
+
+/*
+ * Char device stuff
+ */
+
+static const struct file_operations pps_cdev_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.poll		= pps_cdev_poll,
+	.fasync		= pps_cdev_fasync,
+	.unlocked_ioctl	= pps_cdev_ioctl,
+	.open		= pps_cdev_open,
+	.release	= pps_cdev_release,
+};
+
+int pps_register_cdev(struct pps_device *pps)
+{
+	int err;
+
+	pps->devno = MKDEV(MAJOR(pps_devt), pps->id);
+	cdev_init(&pps->cdev, &pps_cdev_fops);
+	pps->cdev.owner = pps->info.owner;
+
+	err = cdev_add(&pps->cdev, pps->devno, 1);
+	if (err) {
+		printk(KERN_ERR "pps: %s: failed to add char device %d:%d\n",
+				pps->info.name, MAJOR(pps_devt), pps->id);
+		return err;
+	}
+	pps->dev = device_create(pps_class, pps->info.dev, pps->devno, NULL,
+							"pps%d", pps->id);
+	if (err)
+		goto del_cdev;
+	dev_set_drvdata(pps->dev, pps);
+
+	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name,
+			MAJOR(pps_devt), pps->id);
+
+	return 0;
+
+del_cdev:
+	cdev_del(&pps->cdev);
+
+	return err;
+}
+
+void pps_unregister_cdev(struct pps_device *pps)
+{
+	device_destroy(pps_class, pps->devno);
+	cdev_del(&pps->cdev);
+}
+
+/*
+ * Module stuff
+ */
+
+static void __exit pps_exit(void)
+{
+	class_destroy(pps_class);
+	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
+}
+
+static int __init pps_init(void)
+{
+	int err;
+
+	pps_class = class_create(THIS_MODULE, "pps");
+	if (!pps_class) {
+		printk(KERN_ERR "pps: failed to allocate class\n");
+		return -ENOMEM;
+	}
+	pps_class->dev_attrs = pps_attrs;
+
+	err = alloc_chrdev_region(&pps_devt, 0, PPS_MAX_SOURCES, "pps");
+	if (err < 0) {
+		printk(KERN_ERR "pps: failed to allocate char device region\n");
+		goto remove_class;
+	}
+
+	pr_info("LinuxPPS API ver. %d registered\n", PPS_API_VERS);
+	pr_info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti "
+		"<giometti@linux.it>\n", PPS_VERSION);
+
+	return 0;
+
+remove_class:
+	class_destroy(pps_class);
+
+	return err;
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
@@ -0,0 +1,104 @@
+/*
+ * PPS sysfs support
+ *
+ *
+ * Copyright (C) 2007-2009   Rodolfo Giometti <giometti@linux.it>
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
+#include <linux/pps.h>
+
+/*
+ * Attribute functions
+ */
+
+static ssize_t pps_show_assert(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	if (!(pps->info.mode & PPS_CAPTUREASSERT))
+		return 0;
+
+	return sprintf(buf, "%lld.%09d#%d\n",
+			(long long) pps->assert_tu.sec, pps->assert_tu.nsec,
+			pps->assert_sequence);
+}
+DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
+
+static ssize_t pps_show_clear(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	if (!(pps->info.mode & PPS_CAPTURECLEAR))
+		return 0;
+
+	return sprintf(buf, "%lld.%09d#%d\n",
+			(long long) pps->clear_tu.sec, pps->clear_tu.nsec,
+			pps->clear_sequence);
+}
+DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
+
+static ssize_t pps_show_mode(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%4x\n", pps->info.mode);
+}
+DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
+
+static ssize_t pps_show_echo(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", !!pps->info.echo);
+}
+DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
+
+static ssize_t pps_show_name(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", pps->info.name);
+}
+DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
+
+static ssize_t pps_show_path(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", pps->info.path);
+}
+DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
+
+struct device_attribute pps_attrs[] = {
+	__ATTR(assert, S_IRUGO, pps_show_assert, NULL),
+	__ATTR(clear, S_IRUGO, pps_show_clear, NULL),
+	__ATTR(mode, S_IRUGO, pps_show_mode, NULL),
+	__ATTR(echo, S_IRUGO, pps_show_echo, NULL),
+	__ATTR(name, S_IRUGO, pps_show_name, NULL),
+	__ATTR(path, S_IRUGO, pps_show_path, NULL),
+	__ATTR_NULL,
+};
diff -puN include/linux/Kbuild~linuxpps-core-support include/linux/Kbuild
--- a/include/linux/Kbuild~linuxpps-core-support
+++ a/include/linux/Kbuild
@@ -306,6 +306,7 @@ unifdef-y += pmu.h
 unifdef-y += poll.h
 unifdef-y += ppp_defs.h
 unifdef-y += ppp-comp.h
+unifdef-y += pps.h
 unifdef-y += ptrace.h
 unifdef-y += qnx4_fs.h
 unifdef-y += quota.h
diff -puN /dev/null include/linux/pps.h
--- /dev/null
+++ a/include/linux/pps.h
@@ -0,0 +1,194 @@
+/*
+ * PPS API kernel header
+ *
+ *
+ * Copyright (C) 2005-2009   Rodolfo Giometti <giometti@linux.it>
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
+#define PPS_VERSION		"5.3.5"
+#define PPS_MAX_SOURCES		16		/* should be enough... */
+
+/* Implementation note: the logical states ``assert'' and ``clear''
+ * are implemented in terms of the chip register, i.e. ``assert''
+ * means the bit is set.  */
+
+/*
+ * 3.2 New data structures
+ */
+
+#define PPS_API_VERS_1		1
+#define PPS_API_VERS		PPS_API_VERS_1	/* we use API version 1 */
+#define PPS_MAX_NAME_LEN	32
+
+/* 32-bit vs. 64-bit compatibility.
+ *
+ * 0n i386, the alignment of a uint64_t is only 4 bytes, while on most other
+ * architectures it's 8 bytes. On i386, there will be no padding between the
+ * two consecutive 'struct pps_ktime' members of struct pps_kinfo and struct
+ * pps_kparams. But on most platforms there will be padding to ensure correct
+ * alignment.
+ *
+ * The simple fix is probably to add an explicit padding.
+ *					 		[David Woodhouse]
+ */
+struct pps_ktime {
+	__s64 sec;
+	__s32 nsec;
+	__u32 flags;
+};
+#define PPS_TIME_INVALID	(1<<0)	/* used to specify timeout==NULL */
+
+struct pps_kinfo {
+	__u32 assert_sequence;		/* seq. num. of assert event */
+	__u32 clear_sequence; 		/* seq. num. of clear event */
+	struct pps_ktime assert_tu;	/* time of assert event */
+	struct pps_ktime clear_tu;	/* time of clear event */
+	int current_mode;		/* current mode bits */
+};
+
+struct pps_kparams {
+	int api_version;		/* API version # */
+	int mode;			/* mode bits */
+	struct pps_ktime assert_off_tu;	/* offset compensation for assert */
+	struct pps_ktime clear_off_tu;	/* offset compensation for clear */
+};
+
+/*
+ * 3.3 Mode bit definitions
+ */
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
+/*
+ * 3.4.4 New functions: disciplining the kernel timebase
+ */
+
+/* Kernel consumers */
+#define PPS_KC_HARDPPS		0	/* hardpps() (or equivalent) */
+#define PPS_KC_HARDPPS_PLL	1	/* hardpps() constrained to
+					   use a phase-locked loop */
+#define PPS_KC_HARDPPS_FLL	2	/* hardpps() constrained to
+					   use a frequency-locked loop */
+/*
+ * Here begins the implementation-specific part!
+ */
+
+struct pps_fdata {
+	struct pps_kinfo info;
+	struct pps_ktime timeout;
+};
+
+#include <linux/ioctl.h>
+
+#define PPS_GETPARAMS		_IOR('p', 0xa1, struct pps_kparams *)
+#define PPS_SETPARAMS		_IOW('p', 0xa2, struct pps_kparams *)
+#define PPS_GETCAP		_IOR('p', 0xa3, int *)
+#define PPS_FETCH		_IOWR('p', 0xa4, struct pps_fdata *)
+
+#ifdef __KERNEL__
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/time.h>
+
+/*
+ * Global defines
+ */
+
+/* The specific PPS source info */
+struct pps_source_info {
+	char name[PPS_MAX_NAME_LEN];		/* simbolic name */
+	char path[PPS_MAX_NAME_LEN];		/* path of connected device */
+	int mode;				/* PPS's allowed mode */
+
+	void (*echo)(int source, int event, void *data); /* PPS echo function */
+
+	struct module *owner;
+	struct device *dev;
+};
+
+/* The main struct */
+struct pps_device {
+	struct pps_source_info info;		/* PSS source info */
+
+	struct pps_kparams params;		/* PPS's current params */
+
+	__u32 assert_sequence;			/* PPS' assert event seq # */
+	__u32 clear_sequence;			/* PPS' clear event seq # */
+	struct pps_ktime assert_tu;
+	struct pps_ktime clear_tu;
+	int current_mode;			/* PPS mode at event time */
+
+	int go;					/* PPS event is arrived? */
+	wait_queue_head_t queue;		/* PPS event queue */
+
+	unsigned int id;			/* PPS source unique ID */
+	struct cdev cdev;
+	struct device *dev;
+	int devno;
+	struct fasync_struct *async_queue;	/* fasync method */
+	spinlock_t lock;
+
+	atomic_t usage;				/* usage count */
+};
+
+/*
+ * Global variables
+ */
+
+extern spinlock_t pps_idr_lock;
+extern struct idr pps_idr;
+
+extern struct device_attribute pps_attrs[];
+
+/*
+ * Exported functions
+ */
+
+struct pps_device *pps_get_source(int source);
+extern void pps_put_source(struct pps_device *pps);
+extern int pps_register_source(struct pps_source_info *info,
+				int default_params);
+extern void pps_unregister_source(int source);
+extern int pps_register_cdev(struct pps_device *pps);
+extern void pps_unregister_cdev(struct pps_device *pps);
+extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
+
+#endif /* __KERNEL__ */
+
+#endif /* _PPS_H_ */
_

Patches currently in -mm which might be from giometti@linux.it are

linuxpps-core-support.patch

