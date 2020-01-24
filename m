From: akpm@linux-foundation.org
Subject: + documentation-zram-various-fixes-in-zramrst.patch added
 to -mm tree
Date: Thu, 23 Jan 2020 17:43:47 -0800
Message-ID: <20200124014347.NI2g_Bo0h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgAXBnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 20:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, rdunlap@infradead.org


The patch titled
     Subject: Documentation/admin-guide/blockdev/zram.rst: various fixes
has been added to the -mm tree.  Its filename is
     documentation-zram-various-fixes-in-zramrst.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-zram-various-fixes-in-zramrst.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-zram-various-fixes-in-zramrst.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: Documentation/admin-guide/blockdev/zram.rst: various fixes

Fix various items in zram.rst:
- typos/spellos
- punctuation
- grammar
- shell syntax
- indentation
- sysfs file names

Link: http://lkml.kernel.org/r/77000e12-677a-62f6-9f78-343be5bd6630@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   61 +++++++++---------
 1 file changed, 31 insertions(+), 30 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-various-fixes-in-zramrst
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -1,15 +1,15 @@
 ========================================
-zram: Compressed RAM based block devices
+zram: Compressed RAM-based block devices
 ========================================
 
 Introduction
 ============
 
-The zram module creates RAM based block devices named /dev/zram<id>
+The zram module creates RAM-based block devices named /dev/zram<id>
 (<id> = 0, 1, ...). Pages written to these disks are compressed and stored
 in memory itself. These disks allow very fast I/O and compression provides
-good amounts of memory savings. Some of the usecases include /tmp storage,
-use as swap disks, various caches under /var and maybe many more :)
+good amounts of memory savings. Some of the use cases include /tmp storage,
+use as swap disks, various caches under /var and maybe many more. :)
 
 Statistics for individual zram devices are exported through sysfs nodes at
 /sys/block/zram<id>/
@@ -43,17 +43,17 @@ The list of possible return codes:
 
 ========  =============================================================
 -EBUSY	  an attempt to modify an attribute that cannot be changed once
-	  the device has been initialised. Please reset device first;
+	  the device has been initialised. Please reset device first.
 -ENOMEM	  zram was not able to allocate enough memory to fulfil your
-	  needs;
+	  needs.
 -EINVAL	  invalid input has been provided.
 ========  =============================================================
 
-If you use 'echo', the returned value that is changed by 'echo' utility,
+If you use 'echo', the returned value is set by the 'echo' utility,
 and, in general case, something like::
 
 	echo 3 > /sys/block/zram0/max_comp_streams
-	if [ $? -ne 0 ];
+	if [ $? -ne 0 ]; then
 		handle_error
 	fi
 
@@ -65,7 +65,8 @@ should suffice.
 ::
 
 	modprobe zram num_devices=4
-	This creates 4 devices: /dev/zram{0,1,2,3}
+
+This creates 4 devices: /dev/zram{0,1,2,3}
 
 num_devices parameter is optional and tells zram how many devices should be
 pre-created. Default: 1.
@@ -73,12 +74,12 @@ pre-created. Default: 1.
 2) Set max number of compression streams
 ========================================
 
-Regardless the value passed to this attribute, ZRAM will always
-allocate multiple compression streams - one per online CPUs - thus
+Regardless of the value passed to this attribute, ZRAM will always
+allocate multiple compression streams - one per online CPU - thus
 allowing several concurrent compression operations. The number of
 allocated compression streams goes down when some of the CPUs
 become offline. There is no single-compression-stream mode anymore,
-unless you are running a UP system or has only 1 CPU online.
+unless you are running a UP system or have only 1 CPU online.
 
 To find out how many streams are currently available::
 
@@ -89,7 +90,7 @@ To find out how many streams are current
 
 Using comp_algorithm device attribute one can see available and
 currently selected (shown in square brackets) compression algorithms,
-change selected compression algorithm (once the device is initialised
+or change the selected compression algorithm (once the device is initialised
 there is no way to change compression algorithm).
 
 Examples::
@@ -167,9 +168,9 @@ Examples::
 zram provides a control interface, which enables dynamic (on-demand) device
 addition and removal.
 
-In order to add a new /dev/zramX device, perform read operation on hot_add
-attribute. This will return either new device's device id (meaning that you
-can use /dev/zram<id>) or error code.
+In order to add a new /dev/zramX device, perform a read operation on the hot_add
+attribute. This will return either the new device's device id (meaning that you
+can use /dev/zram<id>) or an error code.
 
 Example::
 
@@ -186,8 +187,8 @@ execute::
 
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
 
-A brief description of exported device attributes. For more details please
-read Documentation/ABI/testing/sysfs-block-zram.
+A brief description of exported device attributes follows. For more details
+please read Documentation/ABI/testing/sysfs-block-zram.
 
 ======================  ======  ===============================================
 Name            	access            description
@@ -245,7 +246,7 @@ whitespace:
 
 File /sys/block/zram<id>/mm_stat
 
-The stat file represents device's mm statistics. It consists of a single
+The mm_stat file represents the device's mm statistics. It consists of a single
 line of text and contains the following stats separated by whitespace:
 
  ================ =============================================================
@@ -261,7 +262,7 @@ line of text and contains the following
                   Unit: bytes
  mem_limit        the maximum amount of memory ZRAM can use to store
                   the compressed data
- mem_used_max     the maximum amount of memory zram have consumed to
+ mem_used_max     the maximum amount of memory zram has consumed to
                   store the data
  same_pages       the number of same element filled pages written to this disk.
                   No memory is allocated for such pages.
@@ -271,7 +272,7 @@ line of text and contains the following
 
 File /sys/block/zram<id>/bd_stat
 
-The stat file represents device's backing device statistics. It consists of
+The bd_stat file represents a device's backing device statistics. It consists of
 a single line of text and contains the following stats separated by whitespace:
 
  ============== =============================================================
@@ -316,7 +317,7 @@ To use the feature, admin should set up
 	echo /dev/sda5 > /sys/block/zramX/backing_dev
 
 before disksize setting. It supports only partition at this moment.
-If admin want to use incompressible page writeback, they could do via::
+If admin wants to use incompressible page writeback, they could do via::
 
 	echo huge > /sys/block/zramX/write
 
@@ -326,7 +327,7 @@ as idle::
 	echo all > /sys/block/zramX/idle
 
 From now on, any pages on zram are idle pages. The idle mark
-will be removed until someone request access of the block.
+will be removed until someone requests access of the block.
 IOW, unless there is access request, those pages are still idle pages.
 
 Admin can request writeback of those idle pages at right timing via::
@@ -341,16 +342,16 @@ to guarantee storage health for entire p
 
 To overcome the concern, zram supports "writeback_limit" feature.
 The "writeback_limit_enable"'s default value is 0 so that it doesn't limit
-any writeback. IOW, if admin want to apply writeback budget, he should
+any writeback. IOW, if admin wants to apply writeback budget, he should
 enable writeback_limit_enable via::
 
 	$ echo 1 > /sys/block/zramX/writeback_limit_enable
 
 Once writeback_limit_enable is set, zram doesn't allow any writeback
-until admin set the budget via /sys/block/zramX/writeback_limit.
+until admin sets the budget via /sys/block/zramX/writeback_limit.
 
 (If admin doesn't enable writeback_limit_enable, writeback_limit's value
-assigned via /sys/block/zramX/writeback_limit is meaninless.)
+assigned via /sys/block/zramX/writeback_limit is meaningless.)
 
 If admin want to limit writeback as per-day 400M, he could do it
 like below::
@@ -361,13 +362,13 @@ like below::
 		/sys/block/zram0/writeback_limit.
 	$ echo 1 > /sys/block/zram0/writeback_limit_enable
 
-If admin want to allow further write again once the bugdet is exausted,
+If admins want to allow further write again once the bugdet is exhausted,
 he could do it like below::
 
 	$ echo $((400<<MB_SHIFT>>4K_SHIFT)) > \
 		/sys/block/zram0/writeback_limit
 
-If admin want to see remaining writeback budget since he set::
+If admin wants to see remaining writeback budget since last set::
 
 	$ cat /sys/block/zramX/writeback_limit
 
@@ -375,12 +376,12 @@ If admin want to disable writeback limit
 
 	$ echo 0 > /sys/block/zramX/writeback_limit_enable
 
-The writeback_limit count will reset whenever you reset zram(e.g.,
+The writeback_limit count will reset whenever you reset zram (e.g.,
 system reboot, echo 1 > /sys/block/zramX/reset) so keeping how many of
 writeback happened until you reset the zram to allocate extra writeback
 budget in next setting is user's job.
 
-If admin want to measure writeback count in a certain period, he could
+If admin wants to measure writeback count in a certain period, he could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
 memory tracking
_

Patches currently in -mm which might be from rdunlap@infradead.org are

documentation-zram-various-fixes-in-zramrst.patch
pinctrl-fix-pxa2xxc-build-warnings.patch
