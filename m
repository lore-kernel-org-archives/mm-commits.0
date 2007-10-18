From: akpm@linux-foundation.org
Subject: - sysctl-parport-remove-binary-paths-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:48:12 -0700
Message-ID: <200710180848.l9I8mCZx002845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932270AbXJRIs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     remove parport_device_num()
has been removed from the -mm tree.  Its filename was
     sysctl-parport-remove-binary-paths-fix.patch

This patch was dropped because it was folded into sysctl-parport-remove-binary-paths.patch

------------------------------------------------------
Subject: remove parport_device_num()
From: Adrian Bunk <bunk@kernel.org>

parport_device_num() is no longer used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/parport-lowlevel.txt |   29 ++-------------------------
 drivers/parport/daisy.c            |   29 ---------------------------
 include/linux/parport.h            |    1 
 3 files changed, 3 insertions(+), 56 deletions(-)

diff -puN Documentation/parport-lowlevel.txt~sysctl-parport-remove-binary-paths-fix Documentation/parport-lowlevel.txt
--- a/Documentation/parport-lowlevel.txt~sysctl-parport-remove-binary-paths-fix
+++ a/Documentation/parport-lowlevel.txt
@@ -25,7 +25,6 @@ Global functions:
   parport_open
   parport_close
   parport_device_id
-  parport_device_num
   parport_device_coords
   parport_find_class
   parport_find_device
@@ -735,7 +734,7 @@ NULL is returned.
 
 SEE ALSO
 
-parport_register_device, parport_device_num
+parport_register_device
 
 parport_close - unregister device for particular device number
 -------------
@@ -787,29 +786,7 @@ Many devices have ill-formed IEEE 1284 D
 
 SEE ALSO
 
-parport_find_class, parport_find_device, parport_device_num
-
-parport_device_num - convert device coordinates to device number
-------------------
-
-SYNOPSIS
-
-#include <linux/parport.h>
-
-int parport_device_num (int parport, int mux, int daisy);
-
-DESCRIPTION
-
-Convert between device coordinates (port, multiplexor, daisy chain
-address) and device number (zero-based).
-
-RETURN VALUE
-
-Device number, or -1 if no device at given coordinates.
-
-SEE ALSO
-
-parport_device_coords, parport_open, parport_device_id
+parport_find_class, parport_find_device
 
 parport_device_coords - convert device number to device coordinates
 ------------------
@@ -833,7 +810,7 @@ Zero on success, in which case the coord
 
 SEE ALSO
 
-parport_device_num, parport_open, parport_device_id
+parport_open, parport_device_id
 
 parport_find_class - find a device by its class
 ------------------
diff -puN drivers/parport/daisy.c~sysctl-parport-remove-binary-paths-fix drivers/parport/daisy.c
--- a/drivers/parport/daisy.c~sysctl-parport-remove-binary-paths-fix
+++ a/drivers/parport/daisy.c
@@ -275,35 +275,6 @@ void parport_close(struct pardevice *dev
 	parport_unregister_device(dev);
 }
 
-/**
- *	parport_device_num - convert device coordinates
- *	@parport: parallel port number
- *	@mux: multiplexor port number (-1 for no multiplexor)
- *	@daisy: daisy chain address (-1 for no daisy chain address)
- *
- *	This tries to locate a device on the given parallel port,
- *	multiplexor port and daisy chain address, and returns its
- *	device number or %-ENXIO if no device with those coordinates
- *	exists.
- **/
-
-int parport_device_num(int parport, int mux, int daisy)
-{
-	int res = -ENXIO;
-	struct daisydev *dev;
-
-	spin_lock(&topology_lock);
-	dev = topology;
-	while (dev && dev->port->portnum != parport &&
-	       dev->port->muxport != mux && dev->daisy != daisy)
-		dev = dev->next;
-	if (dev)
-		res = dev->devnum;
-	spin_unlock(&topology_lock);
-
-	return res;
-}
-
 /* Send a daisy-chain-style CPP command packet. */
 static int cpp_daisy(struct parport *port, int cmd)
 {
diff -puN include/linux/parport.h~sysctl-parport-remove-binary-paths-fix include/linux/parport.h
--- a/include/linux/parport.h~sysctl-parport-remove-binary-paths-fix
+++ a/include/linux/parport.h
@@ -510,7 +510,6 @@ extern struct pardevice *parport_open (i
 				       int flags, void *handle);
 extern void parport_close (struct pardevice *dev);
 extern ssize_t parport_device_id (int devnum, char *buffer, size_t len);
-extern int parport_device_num (int parport, int mux, int daisy);
 extern void parport_daisy_deselect_all (struct parport *port);
 extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
alpha-lock-bitops-fix.patch
