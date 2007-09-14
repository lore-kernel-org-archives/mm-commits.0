From: akpm@linux-foundation.org
Subject: + voyager-dont-try-to-support-unprocessor-builds.patch added to -mm tree
Date: Fri, 14 Sep 2007 03:53:08 -0700
Message-ID: <200709141053.l8EAr8ov001270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776AbXINKxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 06:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@steeleye.com, ak@suse.de


The patch titled
     voyager: don't try to support unprocessor builds
has been added to the -mm tree.  Its filename is
     voyager-dont-try-to-support-unprocessor-builds.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: voyager: don't try to support unprocessor builds
From: James Bottomley <James.Bottomley@steeleye.com>

A while ago Randy Dunlap and Adrian Bunk suggested we simply prevent UP
voyager building.  I resisted this on the grounds that the nagging was the
only thing that was going to cause me to look at this.  However, now I
think we should probably take this course.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/Kconfig~voyager-dont-try-to-support-unprocessor-builds arch/i386/Kconfig
--- a/arch/i386/Kconfig~voyager-dont-try-to-support-unprocessor-builds
+++ a/arch/i386/Kconfig
@@ -146,6 +146,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
+	select SMP if !BROKEN
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
_

Patches currently in -mm which might be from James.Bottomley@steeleye.com are

scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-send-media-state-change-modification-events.patch
fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch
advansys-printk-fix.patch
drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
scsi-early-detection-of-medium-not-present-updated.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
scsi-megaraid_sas-add-hibernation-support.patch
scsi-megaraid_sas-add-module-param-fast_load.patch
scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun.patch
scsi-megaraid_sas-update-version-and-changelog.patch
voyager-include-asm-smph-to-fix-compile-error.patch
voyager-dont-try-to-support-unprocessor-builds.patch
scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host.patch
do-not-export-usr-include-scsi-in-make-headers_install.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
