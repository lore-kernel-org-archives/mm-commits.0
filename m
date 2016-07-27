From: akpm@linux-foundation.org
Subject: [merged] zram-cosmetic-cleanup-documentation.patch removed from
 -mm tree
Date: Wed, 27 Jul 2016 12:00:08 -0700
Message-ID: <579904b8.Fg7me8eGzMVQXBWg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, corbet@lwn.net, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: cosmetic: cleanup documentation
has been removed from the -mm tree.  Its filename was
     zram-cosmetic-cleanup-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: cosmetic: cleanup documentation

zram documentation is a mix of different styles: spaces, tabs, tabs +
spaces, etc.  Clean it up.

Link: http://lkml.kernel.org/r/20160531122017.2878-6-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |   89 ++++++++++++++----------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-cosmetic-cleanup-documentation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-cosmetic-cleanup-documentation
+++ a/Documentation/blockdev/zram.txt
@@ -59,23 +59,23 @@ num_devices parameter is optional and te
 pre-created. Default: 1.
 
 2) Set max number of compression streams
-	Regardless the value passed to this attribute, ZRAM will always
-	allocate multiple compression streams - one per online CPUs - thus
-	allowing several concurrent compression operations. The number of
-	allocated compression streams goes down when some of the CPUs
-	become offline. There is no single-compression-stream mode anymore,
-	unless you are running a UP system or has only 1 CPU online.
+Regardless the value passed to this attribute, ZRAM will always
+allocate multiple compression streams - one per online CPUs - thus
+allowing several concurrent compression operations. The number of
+allocated compression streams goes down when some of the CPUs
+become offline. There is no single-compression-stream mode anymore,
+unless you are running a UP system or has only 1 CPU online.
 
-	To find out how many streams are currently available:
+To find out how many streams are currently available:
 	cat /sys/block/zram0/max_comp_streams
 
 3) Select compression algorithm
-	Using comp_algorithm device attribute one can see available and
-	currently selected (shown in square brackets) compression algorithms,
-	change selected compression algorithm (once the device is initialised
-	there is no way to change compression algorithm).
+Using comp_algorithm device attribute one can see available and
+currently selected (shown in square brackets) compression algorithms,
+change selected compression algorithm (once the device is initialised
+there is no way to change compression algorithm).
 
-	Examples:
+Examples:
 	#show supported compression algorithms
 	cat /sys/block/zram0/comp_algorithm
 	lzo [lz4]
@@ -83,28 +83,27 @@ pre-created. Default: 1.
 	#select lzo compression algorithm
 	echo lzo > /sys/block/zram0/comp_algorithm
 
-	For the time being, the `comp_algorithm' content does not necessarily
-	show every compression algorithm supported by the kernel. We keep this
-	list primarily to simplify device configuration and one can configure
-	a new device with a compression algorithm that is not listed in
-	`comp_algorithm'. The thing is that, internally, ZRAM uses Crypto API
-	and, if some of the algorithms were built as modules, it's impossible
-	to list all of them using, for instance, /proc/crypto or any other
-	method. This, however, has an advantage of permitting the usage of
-	custom crypto compression modules (implementing S/W or H/W
-	compression).
+For the time being, the `comp_algorithm' content does not necessarily
+show every compression algorithm supported by the kernel. We keep this
+list primarily to simplify device configuration and one can configure
+a new device with a compression algorithm that is not listed in
+`comp_algorithm'. The thing is that, internally, ZRAM uses Crypto API
+and, if some of the algorithms were built as modules, it's impossible
+to list all of them using, for instance, /proc/crypto or any other
+method. This, however, has an advantage of permitting the usage of
+custom crypto compression modules (implementing S/W or H/W compression).
 
 4) Set Disksize
-        Set disk size by writing the value to sysfs node 'disksize'.
-        The value can be either in bytes or you can use mem suffixes.
-        Examples:
-            # Initialize /dev/zram0 with 50MB disksize
-            echo $((50*1024*1024)) > /sys/block/zram0/disksize
-
-            # Using mem suffixes
-            echo 256K > /sys/block/zram0/disksize
-            echo 512M > /sys/block/zram0/disksize
-            echo 1G > /sys/block/zram0/disksize
+Set disk size by writing the value to sysfs node 'disksize'.
+The value can be either in bytes or you can use mem suffixes.
+Examples:
+	# Initialize /dev/zram0 with 50MB disksize
+	echo $((50*1024*1024)) > /sys/block/zram0/disksize
+
+	# Using mem suffixes
+	echo 256K > /sys/block/zram0/disksize
+	echo 512M > /sys/block/zram0/disksize
+	echo 1G > /sys/block/zram0/disksize
 
 Note:
 There is little point creating a zram of greater than twice the size of memory
@@ -112,20 +111,20 @@ since we expect a 2:1 compression ratio.
 size of the disk when not in use so a huge zram is wasteful.
 
 5) Set memory limit: Optional
-	Set memory limit by writing the value to sysfs node 'mem_limit'.
-	The value can be either in bytes or you can use mem suffixes.
-	In addition, you could change the value in runtime.
-	Examples:
-	    # limit /dev/zram0 with 50MB memory
-	    echo $((50*1024*1024)) > /sys/block/zram0/mem_limit
-
-	    # Using mem suffixes
-	    echo 256K > /sys/block/zram0/mem_limit
-	    echo 512M > /sys/block/zram0/mem_limit
-	    echo 1G > /sys/block/zram0/mem_limit
+Set memory limit by writing the value to sysfs node 'mem_limit'.
+The value can be either in bytes or you can use mem suffixes.
+In addition, you could change the value in runtime.
+Examples:
+	# limit /dev/zram0 with 50MB memory
+	echo $((50*1024*1024)) > /sys/block/zram0/mem_limit
+
+	# Using mem suffixes
+	echo 256K > /sys/block/zram0/mem_limit
+	echo 512M > /sys/block/zram0/mem_limit
+	echo 1G > /sys/block/zram0/mem_limit
 
-	    # To disable memory limit
-	    echo 0 > /sys/block/zram0/mem_limit
+	# To disable memory limit
+	echo 0 > /sys/block/zram0/mem_limit
 
 6) Activate:
 	mkswap /dev/zram0
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

printk-do-not-include-interrupth.patch
printk-introduce-suppress_message_printing.patch

