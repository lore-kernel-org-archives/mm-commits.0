From: akpm@linux-foundation.org
Subject: - 53c7xx-removal-fallout.patch removed from -mm tree
Date: Mon, 05 Nov 2007 14:07:54 -0800
Message-ID: <200711052207.lA5M7s70022068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbXKEWIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     53c7xx removal fallout
has been removed from the -mm tree.  Its filename was
     53c7xx-removal-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 53c7xx removal fallout
From: Adrian Bunk <bunk@kernel.org>

This patch does some additional cleanups after the 53c7xx removal.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dontdiff                |    2 
 Documentation/m68k/kernel-options.txt |   60 ------------------------
 Documentation/scsi/00-INDEX           |    2 
 Documentation/scsi/ncr53c7xx.txt      |   40 ----------------
 drivers/scsi/.gitignore               |    2 
 5 files changed, 106 deletions(-)

diff -puN Documentation/dontdiff~53c7xx-removal-fallout Documentation/dontdiff
--- a/Documentation/dontdiff~53c7xx-removal-fallout
+++ a/Documentation/dontdiff
@@ -46,8 +46,6 @@
 .mailmap
 .mm
 53c700_d.h
-53c7xx_d.h
-53c7xx_u.h
 53c8xx_d.h*
 BitKeeper
 COPYING
diff -puN Documentation/m68k/kernel-options.txt~53c7xx-removal-fallout Documentation/m68k/kernel-options.txt
--- a/Documentation/m68k/kernel-options.txt~53c7xx-removal-fallout
+++ a/Documentation/m68k/kernel-options.txt
@@ -867,66 +867,6 @@ controller and should be autodetected by
 24 bit region which is specified by a mask of 0x00fffffe.
 
 
-5.5) 53c7xx=
-------------
-
-Syntax: 53c7xx=<sub-options...>
-
-These options affect the A4000T, A4091, WarpEngine, Blizzard 603e+,
-and GForce 040/060 SCSI controllers on the Amiga, as well as the
-builtin MVME 16x SCSI controller.
-
-The <sub-options> is a comma-separated list of the sub-options listed
-below.
-
-5.5.1) nosync
--------------
-
-Syntax: nosync:0
-
-  Disables sync negotiation for all devices.  Any value after the
-  colon is acceptable (and has the same effect).
-
-5.5.2) noasync
---------------
-
-[OBSOLETE, REMOVED]
-
-5.5.3) nodisconnect
--------------------
-
-Syntax: nodisconnect:0
-
-  Disables SCSI disconnects.  Any value after the colon is acceptable
-  (and has the same effect).
-
-5.5.4) validids
----------------
-
-Syntax: validids:0xNN
-
-  Specify which SCSI ids the driver should pay attention to.  This is
-  a bitmask (i.e. to only pay attention to ID#4, you'd use 0x10).
-  Default is 0x7f (devices 0-6).
-
-5.5.5) opthi
-5.5.6) optlo
-------------
-
-Syntax: opthi:M,optlo:N
-
-  Specify options for "hostdata->options".  The acceptable definitions
-  are listed in drivers/scsi/53c7xx.h; the 32 high bits should be in
-  opthi and the 32 low bits in optlo.  They must be specified in the
-  order opthi=M,optlo=N.
-
-5.5.7) next
------------
-
-  No argument. Used to separate blocks of keywords when there's more
-  than one 53c7xx host adapter in the system.
-
-
 /* Local Variables: */
 /* mode: text       */
 /* End:             */
diff -puN Documentation/scsi/00-INDEX~53c7xx-removal-fallout Documentation/scsi/00-INDEX
--- a/Documentation/scsi/00-INDEX~53c7xx-removal-fallout
+++ a/Documentation/scsi/00-INDEX
@@ -64,8 +64,6 @@ lpfc.txt
 	- LPFC driver release notes
 megaraid.txt
 	- Common Management Module, shared code handling ioctls for LSI drivers
-ncr53c7xx.txt
-	- info on driver for NCR53c7xx based adapters
 ncr53c8xx.txt
 	- info on driver for NCR53c8xx based adapters
 osst.txt
diff -puN Documentation/scsi/ncr53c7xx.txt~53c7xx-removal-fallout /dev/null
--- a/Documentation/scsi/ncr53c7xx.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-README for WarpEngine/A4000T/A4091 SCSI kernels.
-
-Use the following options to disable options in the SCSI driver.
-
-Using amiboot for example.....
-
-To disable Synchronous Negotiation....
-
-	amiboot -k kernel 53c7xx=nosync:0	
-
-To disable Disconnection....
-	
-	amiboot -k kernel 53c7xx=nodisconnect:0
-
-To disable certain SCSI devices...
-
-	amiboot -k kernel 53c7xx=validids:0x3F
-
-	this allows only device ID's 0,1,2,3,4 and 5 for linux to handle.
-	(this is a bitmasked field - i.e. each bit represents a SCSI ID)
-
-These commands work on a per controller basis and use the option 'next' to
-move to the next controller in the system.
-
-e.g.
-	amiboot -k kernel 53c7xx=nodisconnect:0,next,nosync:0
-
-	this uses No Disconnection on the first controller and Asynchronous
-	SCSI on the second controller.
-
-Known Issues:
-
-Two devices are known not to function with the default settings of using
-synchronous SCSI. These are the Archive Viper 150 Tape Drive and the 
-SyQuest SQ555 removeable hard drive. When using these devices on a controller
-use the 'nosync:0' option.
-
-Please try these options and post any problems/successes to me.
-
-Alan Hourihane <alanh@fairlite.demon.co.uk>
diff -puN drivers/scsi/.gitignore~53c7xx-removal-fallout drivers/scsi/.gitignore
--- a/drivers/scsi/.gitignore~53c7xx-removal-fallout
+++ a/drivers/scsi/.gitignore
@@ -1,3 +1 @@
 53c700_d.h
-53c7xx_d.h
-53c7xx_u.h
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fs-afs-vlocationc-fix-off-by-one.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
git-dvb.patch
git-hwmon.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
xtensa-iss_net_setup-must-be-__init.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
