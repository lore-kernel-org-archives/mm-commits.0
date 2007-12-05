From: akpm@linux-foundation.org
Subject: + dio-fix-kernel-doc-notation.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:35:27 -0800
Message-ID: <200712052235.lB5MZRi3028540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbXLEWg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jochen@scram.de


The patch titled
     dio: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     dio-fix-kernel-doc-notation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pcmcia-fix-kernel-doc-comments.patch
git-dvb.patch
git-kbuild.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
