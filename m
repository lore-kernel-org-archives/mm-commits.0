From: akpm@linux-foundation.org
Subject: + documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch added to -mm tree
Date: Tue, 05 Jul 2011 13:54:38 -0700
Message-ID: <201107052054.p65Kscm6023324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab1GEUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 16:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wad@chromium.org, Trond.Myklebust@netapp.com, axboe@kernel.dk, kay.sievers@vrfy.org, namhyung@gmail.com, rdunlap@xenotime.net


The patch titled
     Documentation: add pointer to name_to_dev_t for root= values
has been added to the -mm tree.  Its filename is
     documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: add pointer to name_to_dev_t for root= values
From: Will Drewry <wad@chromium.org>

Update kernel-parameters.txt to point users to the authoritative comment
for name_to_dev_t.  In addition, updates other places where some
name_to_dev_t behavior was discussed.  All other references to root=
appear to be for explicit sample usage or just side comments when
discussing other kernel parameters.

Signed-off-by: Will Drewry <wad@chromium.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/frv/booting.txt         |   13 ++++++++++---
 Documentation/kernel-parameters.txt   |    1 +
 Documentation/m68k/kernel-options.txt |   14 ++++++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)

diff -puN Documentation/frv/booting.txt~documentation-add-pointer-to-name_to_dev_t-for-root=-values Documentation/frv/booting.txt
--- a/Documentation/frv/booting.txt~documentation-add-pointer-to-name_to_dev_t-for-root=-values
+++ a/Documentation/frv/booting.txt
@@ -106,13 +106,20 @@ separated by spaces:
       To use the first on-chip serial port at baud rate 115200, no parity, 8
       bits, and no flow control.
 
-  (*) root=/dev/<xxxx>
+  (*) root=<xxxx>
 
-      This specifies the device upon which the root filesystem resides. For
-      example:
+      This specifies the device upon which the root filesystem resides. It
+      may be specified by major and minor number, device path, or even
+      partition uuid, if supported.  For example:
 
 	/dev/nfs	NFS root filesystem
 	/dev/mtdblock3	Fourth RedBoot partition on the System Flash
+	PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF/PARTNROFF=1
+		first partition after the partition with the given UUID
+	253:0		Device with major 253 and minor 0
+
+      Authoritative information can be found in
+      "Documentation/kernel-parameters.txt".
 
   (*) rw
 
diff -puN Documentation/kernel-parameters.txt~documentation-add-pointer-to-name_to_dev_t-for-root=-values Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-add-pointer-to-name_to_dev_t-for-root=-values
+++ a/Documentation/kernel-parameters.txt
@@ -2234,6 +2234,7 @@ bytes respectively. Such letter suffixes
 	ro		[KNL] Mount root device read-only on boot
 
 	root=		[KNL] Root filesystem
+			See name_to_dev_t comment in init/do_mounts.c.
 
 	rootdelay=	[KNL] Delay (in seconds) to pause before attempting to
 			mount the root filesystem
diff -puN Documentation/m68k/kernel-options.txt~documentation-add-pointer-to-name_to_dev_t-for-root=-values Documentation/m68k/kernel-options.txt
--- a/Documentation/m68k/kernel-options.txt~documentation-add-pointer-to-name_to_dev_t-for-root=-values
+++ a/Documentation/m68k/kernel-options.txt
@@ -129,6 +129,20 @@ decimal 11 is the major of SCSI CD-ROMs,
 the first of these. You can find out all valid major numbers by
 looking into include/linux/major.h.
 
+In addition to major and minor numbers, if the device containing your
+root partition uses a partition table format with unique partition
+identifiers, then you may use them.  For instance,
+"root=PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF".  It is also
+possible to reference another partition on the same device using a
+known partition UUID as the starting point.  For example,
+if partition 5 of the device has the UUID of
+00112233-4455-6677-8899-AABBCCDDEEFF then partition 3 may be found as
+follows:
+  PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF/PARTNROFF=-2
+
+Authoritative information can be found in
+"Documentation/kernel-parameters.txt".
+
 
 2.2) ro, rw
 -----------
_

Patches currently in -mm which might be from wad@chromium.org are

init-add-root=partuuid=uuid-partnroff=%d-support.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch

