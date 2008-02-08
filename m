From: akpm@linux-foundation.org
Subject: - kernel-doc-prevent-duplicate-description-output.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:34 -0800
Message-ID: <200802080802.m1882FwQ014022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463AbYBHIT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: prevent duplicate description: output
has been removed from the -mm tree.  Its filename was
     kernel-doc-prevent-duplicate-description-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: prevent duplicate description: output
From: Randy Dunlap <randy.dunlap@oracle.com>

Prevent duplicate output of a Description: section when there is a "blank"
("*") line between the initial function name/description line and the
"Description:" header.

Test case:  drivers/scsi/scsi_devinfo.c::scsi_init_devinfo().

Rob Landley hit this while he was producing SCSI kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-prevent-duplicate-description-output scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-prevent-duplicate-description-output
+++ a/scripts/kernel-doc
@@ -1907,7 +1907,7 @@ sub process_file($) {
 		$newsection = $1;
 		$newcontents = $2;
 
-		if ($contents ne "") {
+		if (($contents ne "") && ($contents ne "\n")) {
 		    if (!$in_doc_sect && $verbose) {
 			print STDERR "Warning(${file}:$.): contents before sections\n";
 			++$warnings;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
