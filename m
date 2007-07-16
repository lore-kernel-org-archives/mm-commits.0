From: akpm@linux-foundation.org
Subject: - undeprecate-raw-driver.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:09 -0700
Message-ID: <200707162056.l6GKu98d002070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812AbXGPVIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     undeprecate raw driver
has been removed from the -mm tree.  Its filename was
     undeprecate-raw-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: undeprecate raw driver
From: Dave Jones <davej@redhat.com>

Despite repeated attempts over the last two and half years, this driver
seems somewhat persistant.  Remove its deprecated status as it has existing
users who may not be in a position to migrate their apps to O_DIRECT.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 --------
 drivers/char/Kconfig                       |    9 ++++-----
 2 files changed, 4 insertions(+), 13 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~undeprecate-raw-driver Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~undeprecate-raw-driver
+++ a/Documentation/feature-removal-schedule.txt
@@ -41,14 +41,6 @@ Who:	Pavel Machek <pavel@suse.cz>
 
 ---------------------------
 
-What:	RAW driver (CONFIG_RAW_DRIVER)
-When:	December 2005
-Why:	declared obsolete since kernel 2.6.3
-	O_DIRECT can be used instead
-Who:	Adrian Bunk <bunk@stusta.de>
-
----------------------------
-
 What:	old NCR53C9x driver
 When:	October 2007
 Why:	Replaced by the much better esp_scsi driver.  Actual low-level
diff -puN drivers/char/Kconfig~undeprecate-raw-driver drivers/char/Kconfig
--- a/drivers/char/Kconfig~undeprecate-raw-driver
+++ a/drivers/char/Kconfig
@@ -979,15 +979,14 @@ config GPIO_VR41XX
 	depends on CPU_VR41XX
 
 config RAW_DRIVER
-	tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
+	tristate "RAW driver (/dev/raw/rawN)"
 	depends on BLOCK
 	help
-	  The raw driver permits block devices to be bound to /dev/raw/rawN. 
-	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O. 
+	  The raw driver permits block devices to be bound to /dev/raw/rawN.
+	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
 	  See the raw(8) manpage for more details.
 
-          The raw driver is deprecated and will be removed soon.
-          Applications should simply open the device (eg /dev/hda1)
+          Applications should preferably open the device (eg /dev/hda1)
           with the O_DIRECT flag.
 
 config MAX_RAW_DEVS
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
fix-empty-macros-in-acpi.patch
git-alsa.patch
i386-remove-support-for-the-rise-cpu.patch
slow-down-printk-during-boot.patch
