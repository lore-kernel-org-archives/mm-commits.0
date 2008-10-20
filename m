From: akpm@linux-foundation.org
Subject: + hdq-documentation-for-omap-hdq.patch added to -mm tree
Date: Mon, 20 Oct 2008 16:08:16 -0700
Message-ID: <200810202308.m9KN8Ggv006585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755842AbYJTXIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 19:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: madhu.cr@ti.com, johnpol@2ka.mipt.ru


The patch titled
     hdq: documentation for OMAP HDQ
has been added to the -mm tree.  Its filename is
     hdq-documentation-for-omap-hdq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hdq: documentation for OMAP HDQ
From: Madhusudhan Chikkature <madhu.cr@ti.com>

Add a brief document about omap2430/3430 HDQ/1-wire driver.

Signed-off-by: Madhusudhan Chikkature<madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/masters/omap-hdq |   46 ++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff -puN /dev/null Documentation/w1/masters/omap-hdq
--- /dev/null
+++ a/Documentation/w1/masters/omap-hdq
@@ -0,0 +1,46 @@
+Kernel driver for omap HDQ/1-wire module.
+========================================
+
+Supported chips:
+================
+	HDQ/1-wire controller on the TI OMAP 2430/3430 platforms.
+
+A useful link about HDQ basics:
+===============================
+http://focus.ti.com/lit/an/slua408/slua408.pdf
+
+Description:
+============
+The HDQ/1-Wire module of TI OMAP2430/3430 platforms implement the hardware
+protocol of the master functions of the Benchmark HDQ and the Dallas
+Semiconductor 1-Wire protocols. These protocols use a single wire for
+communication between the master (HDQ/1-Wire controller) and the slave
+(HDQ/1-Wire external compliant device).
+
+A typical application of the HDQ/1-Wire module is the communication with battery
+monitor (gas gauge) integrated circuits.
+
+The controller supports operation in both HDQ and 1-wire mode. The essential
+difference between the HDQ and 1-wire mode is how the slave device responds to
+initialization pulse.In HDQ mode, the firmware does not require the host to
+create an initialization pulse to the slave.However, the slave can be reset by
+using an initialization pulse (also referred to as a break pulse).The slave
+does not respond with a presence pulse as it does in the 1-Wire protocol.
+
+Remarks:
+========
+The driver (drivers/w1/masters/omap_hdq.c) supports the HDQ mode of the
+controller. In this mode, as we can not read the ID which obeys the W1
+spec(family:id:crc), a module parameter can be passed to the driver which will
+be used to calculate the CRC and pass back an appropriate slave ID to the W1
+core.
+
+By default the master driver and the BQ slave i/f
+driver(drivers/w1/slaves/w1_bq27000.c) sets the ID to 1.
+Please note to load both the modules with a different ID if required, but note
+that the ID used should be same for both master and slave driver loading.
+
+e.g:
+insmod omap_hdq.ko W1_ID=2
+inamod w1_bq27000.ko F_ID=2
+
_

Patches currently in -mm which might be from madhu.cr@ti.com are

w1-export-w1_read_8-function.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
hdq-driver-for-omap2430-3430.patch
hdq-bq27000-hdq-slave-interface-driver.patch
hdq-documentation-for-omap-hdq.patch

