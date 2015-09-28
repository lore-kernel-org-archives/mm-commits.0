From: akpm@linux-foundation.org
Subject: [merged] zram-update-documentation.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:16:17 -0700
Message-ID: <560983f1.cESpiXWLqV1w0Ui7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: update documentation
has been removed from the -mm tree.  Its filename was
     zram-update-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey SENOZHATSKY <sergey.senozhatsky@gmail.com>
Subject: zram: update documentation

Several documentation changes.

First, we never mentioned any errors and never required any error checks
in documentation.

Second, mention that there is another way to configure and manage zram
devices -- zramctl, provided by util-linux.

Third, add a bit of clarification on why `mem_used_max' attr is RW and
correct some typos.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |   44 +++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 4 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-update-documentation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-update-documentation
+++ a/Documentation/blockdev/zram.txt
@@ -14,8 +14,43 @@ Statistics for individual zram devices a
 
 * Usage
 
+There are several ways to configure and manage zram device(-s):
+a) using zram and zram_control sysfs attributes
+b) using zramctl utility, provided by util-linux (util-linux@vger.kernel.org).
+
+In this document we will describe only 'manual' zram configuration steps,
+IOW, zram and zram_control sysfs attributes.
+
+In order to get a better idea about zramctl please consult util-linux
+documentation, zramctl man-page or `zramctl --help'. Please be informed
+that zram maintainers do not develop/maintain util-linux or zramctl, should
+you have any questions please contact util-linux@vger.kernel.org
+
 Following shows a typical sequence of steps for using zram.
 
+WARNING
+=======
+For the sake of simplicity we skip error checking parts in most of the
+examples below. However, it is your sole responsibility to handle errors.
+
+zram sysfs attributes always return negative values in case of errors.
+The list of possible return codes:
+-EBUSY	-- an attempt to modify an attribute that cannot be changed once
+the device has been initialised. Please reset device first;
+-ENOMEM	-- zram was not able to allocate enough memory to fulfil your
+needs;
+-EINVAL	-- invalid input has been provided.
+
+If you use 'echo', the returned value that is changed by 'echo' utility,
+and, in general case, something like:
+
+	echo 3 > /sys/block/zram0/max_comp_streams
+	if [ $? -ne 0 ];
+		handle_error
+	fi
+
+should suffice.
+
 1) Load Module:
 	modprobe zram num_devices=4
 	This creates 4 devices: /dev/zram{0,1,2,3}
@@ -47,7 +82,7 @@ max_comp_streams adjustment.
 
 3) Select compression algorithm
 	Using comp_algorithm device attribute one can see available and
-	currently selected (shown in square brackets) compression algortithms,
+	currently selected (shown in square brackets) compression algorithms,
 	change selected compression algorithm (once the device is initialised
 	there is no way to change compression algorithm).
 
@@ -119,7 +154,7 @@ execute
 8) Stats:
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
 
-A brief description of exported device attritbutes. For more details please
+A brief description of exported device attributes. For more details please
 read Documentation/ABI/testing/sysfs-block-zram.
 
 Name            access            description
@@ -140,8 +175,9 @@ zero_pages        RO    the number of ze
 orig_data_size    RO    uncompressed size of data stored in this disk
 compr_data_size   RO    compressed size of data stored in this disk
 mem_used_total    RO    the amount of memory allocated for this disk
-mem_used_max      RW    the maximum amount memory zram have consumed to
-                        store compressed data
+mem_used_max      RW    the maximum amount of memory zram have consumed to
+                        store the data (to reset this counter to the actual
+                        current value, write 1 to this attribute)
 mem_limit         RW    the maximum amount of memory ZRAM can use to store
                         the compressed data
 pages_compacted   RO    the number of pages freed during compaction
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch

