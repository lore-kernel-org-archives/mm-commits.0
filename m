From: akpm@linux-foundation.org
Subject: [merged] block-remove-refs-to-xd-disks-from-documentation.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:37:28 -0700
Message-ID: <51a50778.ntzwb8GPUd3vCuuW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab3E1Th3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, axboe@kernel.dk, linus.walleij@linaro.org

Subject: [merged] block-remove-refs-to-xd-disks-from-documentation.patch removed from -mm tree
To: linus.walleij@linaro.org,axboe@kernel.dk,paul.gortmaker@windriver.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:28 -0700


The patch titled
     Subject: block: remove refs to XD disks from documentation
has been removed from the -mm tree.  Its filename was
     block-remove-refs-to-xd-disks-from-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: block: remove refs to XD disks from documentation

d1a6f4f19728d6 ("block: delete super ancient PC-XT driver for 1980's
hardware") deleted the XD disk driver, but there are still a few
references to it in the documentation directory.  Delete the remnants and
thus also free up the major block device 13 for reuse.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devices.txt             |    7 +------
 Documentation/kernel-parameters.txt   |    3 ---
 Documentation/m68k/kernel-options.txt |    2 --
 3 files changed, 1 insertion(+), 11 deletions(-)

diff -puN Documentation/devices.txt~block-remove-refs-to-xd-disks-from-documentation Documentation/devices.txt
--- a/Documentation/devices.txt~block-remove-refs-to-xd-disks-from-documentation
+++ a/Documentation/devices.txt
@@ -498,12 +498,7 @@ Your cooperation is appreciated.
 
 		Each device type has 5 bits (32 minors).
 
- 13 block	8-bit MFM/RLL/IDE controller
-		  0 = /dev/xda		First XT disk whole disk
-		 64 = /dev/xdb		Second XT disk whole disk
-
-		Partitions are handled in the same way as IDE disks
-		(see major number 3).
+ 13 block
 
  14 char	Open Sound System (OSS)
 		  0 = /dev/mixer	Mixer control
diff -puN Documentation/kernel-parameters.txt~block-remove-refs-to-xd-disks-from-documentation Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~block-remove-refs-to-xd-disks-from-documentation
+++ a/Documentation/kernel-parameters.txt
@@ -3368,9 +3368,6 @@ bytes respectively. Such letter suffixes
 			plus one apbt timer for broadcast timer.
 			x86_mrst_timer=apbt_only | lapic_and_apbt
 
-	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
-	xd_geo=		See header of drivers/block/xd.c.
