From: akpm@linux-foundation.org
Subject: + documentation-blockdev-ramdisktxt-updates.patch added to -mm
 tree
Date: Tue, 10 Dec 2013 16:19:29 -0800
Message-ID: <52a7af91.FUO0c2xAomnTA8hF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3LKAT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 19:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: + documentation-blockdev-ramdisktxt-updates.patch added to -mm tree
To: fabf@skynet.be,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 16:19:29 -0800


The patch titled
     Subject: Documentation/blockdev/ramdisk.txt: updates
has been added to the -mm tree.  Its filename is
     documentation-blockdev-ramdisktxt-updates.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-blockdev-ramdisktxt-updates.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-blockdev-ramdisktxt-updates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: Documentation/blockdev/ramdisk.txt: updates

-ramdisk_blocksize doesn't exist anymore
-Module parameters added to documentation

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/ramdisk.txt |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN Documentation/blockdev/ramdisk.txt~documentation-blockdev-ramdisktxt-updates Documentation/blockdev/ramdisk.txt
--- a/Documentation/blockdev/ramdisk.txt~documentation-blockdev-ramdisktxt-updates
+++ a/Documentation/blockdev/ramdisk.txt
@@ -36,21 +36,30 @@ allowing one to squeeze more programs on
 rescue floppy disk.
 
 
-2) Kernel Command Line Parameters
+2) Parameters
 ---------------------------------
 
+2a) Kernel Command Line Parameters
+
 	ramdisk_size=N
 	==============
 
 This parameter tells the RAM disk driver to set up RAM disks of N k size.  The
-default is 4096 (4 MB) (8192 (8 MB) on S390).
+default is 4096 (4 MB).
+
+2b) Module parameters
 
-	ramdisk_blocksize=N
-	===================
+	rd_nr
+	=====
+	/dev/ramX devices created.
 
-This parameter tells the RAM disk driver how many bytes to use per block.  The
-default is 1024 (BLOCK_SIZE).
+	max_part
+	========
+	Maximum partition number.
 
+	rd_size
+	=======
+	See ramdisk_size.
 
 3) Using "rdev -r"
 ------------------
_

Patches currently in -mm which might be from fabf@skynet.be are

drivers-block-kconfig-update-ram-block-device-module-name.patch
documentation-blockdev-ramdisktxt-updates.patch

