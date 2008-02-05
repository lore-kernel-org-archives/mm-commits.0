From: akpm@linux-foundation.org
Subject: - dio-fix-kernel-doc-notation.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:05 -0800
Message-ID: <200802050253.m152rkeH031531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbYBECyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:54:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jochen@scram.de, mm-commits@vger.kernel.org


The patch titled
     dio: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     dio-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dio: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc in drivers/dio/ so that it is formatted correctly and the
parameter names match the function parameters.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jochen Friedrich <jochen@scram.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dio/dio-driver.c |   70 +++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

diff -puN drivers/dio/dio-driver.c~dio-fix-kernel-doc-notation drivers/dio/dio-driver.c
--- a/drivers/dio/dio-driver.c~dio-fix-kernel-doc-notation
+++ a/drivers/dio/dio-driver.c
@@ -15,16 +15,15 @@
 #include <linux/dio.h>
 
 
-	/**
-	 *  dio_match_device - Tell if a DIO device structure has a matching
-	 *                     DIO device id structure
-	 *  @ids: array of DIO device id structures to search in
-	 *  @dev: the DIO device structure to match against
-	 *
-	 *  Used by a driver to check whether a DIO device present in the
-	 *  system is in its list of supported devices. Returns the matching
-	 *  dio_device_id structure or %NULL if there is no match.
-	 */
+/**
+ *  dio_match_device - Tell if a DIO device structure has a matching DIO device id structure
+ *  @ids: array of DIO device id structures to search in
+ *  @d: the DIO device structure to match against
+ *
+ *  Used by a driver to check whether a DIO device present in the
+ *  system is in its list of supported devices. Returns the matching
+ *  dio_device_id structure or %NULL if there is no match.
+ */
 
 const struct dio_device_id *
 dio_match_device(const struct dio_device_id *ids,
@@ -66,13 +65,13 @@ static int dio_device_probe(struct devic
 }
 
 
-	/**
-	 *  dio_register_driver - register a new DIO driver
-	 *  @drv: the driver structure to register
-	 *
-	 *  Adds the driver structure to the list of registered drivers
-	 *  Returns zero or a negative error value.
-	 */
+/**
+ *  dio_register_driver - register a new DIO driver
+ *  @drv: the driver structure to register
+ *
+ *  Adds the driver structure to the list of registered drivers
+ *  Returns zero or a negative error value.
+ */
 
 int dio_register_driver(struct dio_driver *drv)
 {
@@ -85,15 +84,15 @@ int dio_register_driver(struct dio_drive
 }
 
 
-	/**
-	 *  dio_unregister_driver - unregister a DIO driver
-	 *  @drv: the driver structure to unregister
-	 *
-	 *  Deletes the driver structure from the list of registered DIO drivers,
-	 *  gives it a chance to clean up by calling its remove() function for
-	 *  each device it was responsible for, and marks those devices as
-	 *  driverless.
-	 */
+/**
+ *  dio_unregister_driver - unregister a DIO driver
+ *  @drv: the driver structure to unregister
+ *
+ *  Deletes the driver structure from the list of registered DIO drivers,
+ *  gives it a chance to clean up by calling its remove() function for
+ *  each device it was responsible for, and marks those devices as
+ *  driverless.
+ */
 
 void dio_unregister_driver(struct dio_driver *drv)
 {
@@ -101,16 +100,15 @@ void dio_unregister_driver(struct dio_dr
 }
 
 
-	/**
-	 *  dio_bus_match - Tell if a DIO device structure has a matching DIO
-	 *                  device id structure
-	 *  @ids: array of DIO device id structures to search in
-	 *  @dev: the DIO device structure to match against
-	 *
-	 *  Used by a driver to check whether a DIO device present in the
-	 *  system is in its list of supported devices. Returns the matching
-	 *  dio_device_id structure or %NULL if there is no match.
-	 */
+/**
+ *  dio_bus_match - Tell if a DIO device structure has a matching DIO device id structure
+ *  @dev: the DIO device structure to match against
+ *  @drv: the &device_driver that points to the array of DIO device id structures to search
+ *
+ *  Used by a driver to check whether a DIO device present in the
+ *  system is in its list of supported devices. Returns the matching
+ *  dio_device_id structure or %NULL if there is no match.
+ */
 
 static int dio_bus_match(struct device *dev, struct device_driver *drv)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-ia64.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
