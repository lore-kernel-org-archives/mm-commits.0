From: akpm@linux-foundation.org
Subject: [merged]
 dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine.patch removed from -mm tree
Date: Mon, 05 Aug 2013 12:05:41 -0700
Message-ID: <51fff785.GPUgBUfua8CUc4sy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3HETFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:05:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhenzhong.duan@oracle.com, jdelvare@suse.de, ben@decadent.org.uk

Subject: [merged] dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine.patch removed from -mm tree
To: ben@decadent.org.uk,jdelvare@suse.de,zhenzhong.duan@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:41 -0700


The patch titled
     Subject: dmi_scan: add comments on dmi_present() and the loop in dmi_scan_machine()
has been removed from the -mm tree.  Its filename was
     dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Hutchings <ben@decadent.org.uk>
Subject: dmi_scan: add comments on dmi_present() and the loop in dmi_scan_machine()

My previous refactoring in 79bae42d51a5 ("dmi_scan: refactor
dmi_scan_machine(), {smbios,dmi}_present()") resulted in slightly tricky
code (though I think it's more elegant).  Explain what it's doing.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine
+++ a/drivers/firmware/dmi_scan.c
@@ -419,6 +419,13 @@ static void __init dmi_format_ids(char *
 			    dmi_get_system_info(DMI_BIOS_DATE));
 }
 
+/*
+ * Check for DMI/SMBIOS headers in the system firmware image.  Any
+ * SMBIOS header must start 16 bytes before the DMI header, so take a
+ * 32 byte buffer and check for DMI at offset 16 and SMBIOS at offset
+ * 0.  If the DMI header is present, set dmi_ver accordingly (SMBIOS
+ * takes precedence) and return 0.  Otherwise return 1.
+ */
 static int __init dmi_present(const u8 *buf)
 {
 	int smbios_ver;
@@ -506,6 +513,13 @@ void __init dmi_scan_machine(void)
 		if (p == NULL)
 			goto error;
 
+		/*
+		 * Iterate over all possible DMI header addresses q.
+		 * Maintain the 32 bytes around q in buf.  On the
+		 * first iteration, substitute zero for the
+		 * out-of-range bytes so there is no chance of falsely
+		 * detecting an SMBIOS header.
+		 */
 		memset(buf, 0, 16);
 		for (q = p; q < p + 0x10000; q += 16) {
 			memcpy_fromio(buf + 16, q, 16);
_

Patches currently in -mm which might be from ben@decadent.org.uk are

firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
linux-next.patch

