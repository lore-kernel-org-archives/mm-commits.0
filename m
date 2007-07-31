From: akpm@linux-foundation.org
Subject: + netconsole-add-some-useful-tips-to-documentation.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:13:27 -0700
Message-ID: <200707310013.l6V0DRFM005677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937347AbXGaANw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 20:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com


The patch titled
     netconsole: Add some useful tips to documentation
has been added to the -mm tree.  Its filename is
     netconsole-add-some-useful-tips-to-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netconsole: Add some useful tips to documentation
From: Satyam Sharma <satyam@infradead.org>

Add some useful general-purpose tips.  Also suggest solution for the frequent
problem of console loglevel set too low numerically (i.e.  for high priority
messages only) on the sender.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/netconsole.txt |   25 ++++++++++++++++++++++
 1 files changed, 25 insertions(+)

diff -puN Documentation/networking/netconsole.txt~netconsole-add-some-useful-tips-to-documentation Documentation/networking/netconsole.txt
--- a/Documentation/networking/netconsole.txt~netconsole-add-some-useful-tips-to-documentation
+++ a/Documentation/networking/netconsole.txt
@@ -44,11 +44,36 @@ WARNING: the default target ethernet set
 ethernet address to send packets, which can cause increased load on
 other systems on the same ethernet segment.
 
+TIP: some LAN switches may be configured to suppress ethernet broadcasts
+so it is advised to explicitly specify the remote agents' MAC addresses
+from the config parameters passed to netconsole.
+
+TIP: to find out the MAC address of, say, 10.0.0.2, you may try using:
+
+ ping -c 1 10.0.0.2 ; /sbin/arp -n | grep 10.0.0.2
+
+TIP: in case the remote logging agent is on a separate LAN subnet than
+the sender, it is suggested to try specifying the MAC address of the
+default gateway (you may use /sbin/route -n to find it out) as the
+remote MAC address instead.
+
 NOTE: the network device (eth1 in the above case) can run any kind
 of other network traffic, netconsole is not intrusive. Netconsole
 might cause slight delays in other traffic if the volume of kernel
 messages is high, but should have no other impact.
 
+NOTE: if you find that the remote logging agent is not receiving or
+printing all messages from the sender, it is likely that you have set
+the "console_loglevel" parameter (on the sender) to only send high
+priority messages to the console. You can change this at runtime using:
+
+ dmesg -n 8
+
+or by specifying "debug" on the kernel command line at boot, to send
+all kernel messages to the console. A specific value for this parameter
+can also be set using the "loglevel" kernel boot option. See the
+dmesg(8) man page and Documentation/kernel-parameters.txt for details.
+
 Netconsole was designed to be as instantaneous as possible, to
 enable the logging of even the most critical kernel bugs. It works
 from IRQ contexts as well, and does not enable interrupts while
_

Patches currently in -mm which might be from satyam@infradead.org are

use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch
netconsole-cleanups-codingstyle-prettyfication.patch
netconsole-remove-bogus-check.patch
netconsole-simplify-boot-module-option-setup-logic.patch
netconsole-use-netif_running-in-write_msg.patch
netconsole-add-some-useful-tips-to-documentation.patch
netconsole-introduce-netconsole_target.patch
netconsole-introduce-netconsole_netdev_notifier.patch
netconsole-support-multiple-logging-targets.patch
netconsole-support-dynamic-reconfiguration-using-configfs.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
