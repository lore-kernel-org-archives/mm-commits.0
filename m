From: akpm@linux-foundation.org
Subject: + block-remove-refs-to-xd-disks-from-documentation.patch added to -mm tree
Date: Wed, 22 May 2013 15:23:59 -0700
Message-ID: <519d457f.lKRCM5OnGZrcdiA5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab3EVWYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 18:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, axboe@kernel.dk, linus.walleij@linaro.org

Subject: + block-remove-refs-to-xd-disks-from-documentation.patch added to -mm tree
To: linus.walleij@linaro.org,axboe@kernel.dk,paul.gortmaker@windriver.com
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 15:23:59 -0700


The patch titled
     Subject: block: remove refs to XD disks from documentation
has been added to the -mm tree.  Its filename is
     block-remove-refs-to-xd-disks-from-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 	xen_emul_unplug=		[HW,X86,XEN]
 			Unplug Xen emulated devices
 			Format: [unplug0,][unplug1]
diff -puN Documentation/m68k/kernel-options.txt~block-remove-refs-to-xd-disks-from-documentation Documentation/m68k/kernel-options.txt
--- a/Documentation/m68k/kernel-options.txt~block-remove-refs-to-xd-disks-from-documentation
+++ a/Documentation/m68k/kernel-options.txt
@@ -80,8 +80,6 @@ Valid names are:
   /dev/sdd: -> 0x0830 (forth SCSI disk)
   /dev/sde: -> 0x0840 (fifth SCSI disk)
   /dev/fd : -> 0x0200 (floppy disk)
-  /dev/xda: -> 0x0c00 (first XT disk, unused in Linux/m68k)
-  /dev/xdb: -> 0x0c40 (second XT disk, unused in Linux/m68k)
 
   The name must be followed by a decimal number, that stands for the
 partition number. Internally, the value of the number is just
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch
block-remove-refs-to-xd-disks-from-documentation.patch
rtc-rtc-coh901331-remove-unnecessary-platform_set_drvdata.patch

