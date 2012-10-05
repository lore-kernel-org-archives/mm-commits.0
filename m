From: akpm@linux-foundation.org
Subject: [merged] aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:09 -0700
Message-ID: <20121005202210.0F49420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:48264 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:12 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so58088wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update documentation to better reflect aoe-plus-udev usage
has been removed from the -mm tree.  Its filename was
     aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update documentation to better reflect aoe-plus-udev usage

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/aoe/aoe.txt    |   49 +++++++++++++++++++++------------
 Documentation/aoe/mkdevs.sh  |   41 ---------------------------
 Documentation/aoe/mkshelf.sh |   28 ------------------
 Documentation/aoe/status.sh  |    3 ++
 4 files changed, 35 insertions(+), 86 deletions(-)

diff -puN Documentation/aoe/aoe.txt~aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage Documentation/aoe/aoe.txt
--- a/Documentation/aoe/aoe.txt~aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage
+++ a/Documentation/aoe/aoe.txt
@@ -1,3 +1,8 @@
+ATA over Ethernet is a network protocol that provides simple access to
+block storage on the LAN.
+
+  http://support.coraid.com/documents/AoEr11.txt
+
 The EtherDrive (R) HOWTO for 2.6 and 3.x kernels is found at ...
 
   http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO.html
@@ -26,20 +31,12 @@ CREATING DEVICE NODES
   There is a udev-install.sh script that shows how to install these
   rules on your system.
 
-  If you are not using udev, two scripts are provided in
-  Documentation/aoe as examples of static device node creation for
-  using the aoe driver.
-
-    rm -rf /dev/etherd
-    sh Documentation/aoe/mkdevs.sh /dev/etherd
-
-  ... or to make just one shelf's worth of block device nodes ...
-
-    sh Documentation/aoe/mkshelf.sh /dev/etherd 0
-
   There is also an autoload script that shows how to edit
   /etc/modprobe.d/aoe.conf to ensure that the aoe module is loaded when
-  necessary.
+  necessary.  Preloading the aoe module is preferable to autoloading,
+  however, because AoE discovery takes a few seconds.  It can be
+  confusing when an AoE device is not present the first time the a
+  command is run but appears a second later.
 
 USING DEVICE NODES
 
@@ -54,9 +51,9 @@ USING DEVICE NODES
   "echo > /dev/etherd/discover" tells the driver to find out what AoE
   devices are available.
 
-  These character devices may disappear and be replaced by sysfs
-  counterparts.  Using the commands in aoetools insulates users from
-  these implementation details.
+  In the future these character devices may disappear and be replaced
+  by sysfs counterparts.  Using the commands in aoetools insulates
+  users from these implementation details.
 
   The block devices are named like this:
 
@@ -79,8 +76,8 @@ USING SYSFS
   The netif attribute is the network interface on the localhost
   through which we are communicating with the remote AoE device.
 
-  There is a script in this directory that formats this information
-  in a convenient way.  Users with aoetools can use the aoe-stat
+  There is a script in this directory that formats this information in
+  a convenient way.  Users with aoetools should use the aoe-stat
   command.
 
   root@makki root# sh Documentation/aoe/status.sh 
@@ -124,3 +121,21 @@ DRIVER OPTIONS
   usage example for the module parameter.
 
     modprobe aoe_iflist="eth1 eth3"
+
+  The aoe_deadsecs module parameter determines the maximum number of
+  seconds that the driver will wait for an AoE device to provide a
+  response to an AoE command.  After aoe_deadsecs seconds have
+  elapsed, the AoE device will be marked as "down".
+
+  The aoe_maxout module parameter has a default of 128.  This is the
+  maximum number of unresponded packets that will be sent to an AoE
+  target at one time.
+
+  The aoe_dyndevs module parameter defaults to 1, meaning that the
+  driver will assign a block device minor number to a discovered AoE
+  target based on the order of its discovery.  With dynamic minor
+  device numbers in use, a greater range of AoE shelf and slot
+  addresses can be supported.  Users with udev will never have to
+  think about minor numbers.  Using aoe_dyndevs=0 allows device nodes
+  to be pre-created using a static minor-number scheme with the
+  aoe-mkshelf script in the aoetools.
diff -puN Documentation/aoe/mkdevs.sh~aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage /dev/null
--- a/Documentation/aoe/mkdevs.sh
+++ /dev/null
@@ -1,41 +0,0 @@
-#!/bin/sh
-
-n_shelves=${n_shelves:-10}
-n_partitions=${n_partitions:-16}
-
-if test "$#" != "1"; then
-	echo "Usage: sh `basename $0` {dir}" 1>&2
-	echo "       n_partitions=16 sh `basename $0` {dir}" 1>&2
-	exit 1
-fi
-dir=$1
-
-MAJOR=152
-
-echo "Creating AoE devnode files in $dir ..."
-
-set -e
-
-mkdir -p $dir
-
-# (Status info is in sysfs.  See status.sh.)
-# rm -f $dir/stat
-# mknod -m 0400 $dir/stat c $MAJOR 1
-rm -f $dir/err
-mknod -m 0400 $dir/err c $MAJOR 2
-rm -f $dir/discover
-mknod -m 0200 $dir/discover c $MAJOR 3
-rm -f $dir/interfaces
-mknod -m 0200 $dir/interfaces c $MAJOR 4
-rm -f $dir/revalidate
-mknod -m 0200 $dir/revalidate c $MAJOR 5
-rm -f $dir/flush
-mknod -m 0200 $dir/flush c $MAJOR 6
-
-export n_partitions
-mkshelf=`echo $0 | sed 's!mkdevs!mkshelf!'`
-i=0
-while test $i -lt $n_shelves; do
-	sh -xc "sh $mkshelf $dir $i"
-	i=`expr $i + 1`
-done
diff -puN Documentation/aoe/mkshelf.sh~aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage /dev/null
--- a/Documentation/aoe/mkshelf.sh
+++ /dev/null
@@ -1,28 +0,0 @@
-#! /bin/sh
-
-if test "$#" != "2"; then
-	echo "Usage: sh `basename $0` {dir} {shelfaddress}" 1>&2
-	echo "       n_partitions=16 sh `basename $0` {dir} {shelfaddress}" 1>&2
-	exit 1
-fi
-n_partitions=${n_partitions:-16}
-dir=$1
-shelf=$2
-nslots=16
-maxslot=`echo $nslots 1 - p | dc`
-MAJOR=152
-
-set -e
-
-minor=`echo $nslots \* $shelf \* $n_partitions | bc`
-endp=`echo $n_partitions - 1 | bc`
-for slot in `seq 0 $maxslot`; do
-	for part in `seq 0 $endp`; do
-		name=e$shelf.$slot
-		test "$part" != "0" && name=${name}p$part
-		rm -f $dir/$name
-		mknod -m 0660 $dir/$name b $MAJOR $minor
