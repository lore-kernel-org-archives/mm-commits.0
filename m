From: akpm@linux-foundation.org
Subject: + nozomi-use-null-for-pointers.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:17:23 -0800
Message-ID: <200703220617.l2M6HN10013771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXCVGR2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     nozomi: use NULL for pointers
has been added to the -mm tree.  Its filename is
     nozomi-use-null-for-pointers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nozomi: use NULL for pointers
From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointers:
drivers/char/nozomi.c:1028:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1029:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1031:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1032:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1034:70: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1035:70: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1037:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1039:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1040:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1042:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1043:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1045:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1046:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1048:64: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/char/nozomi.c~nozomi-use-null-for-pointers drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~nozomi-use-null-for-pointers
+++ a/drivers/char/nozomi.c
@@ -1025,27 +1025,27 @@ static char *interrupt2str(u16 interrupt
 	static char buf[TMP_BUF_MAX];
 	char *p = buf;
 
-	interrupt & MDM_DL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL1 ") : 0;
-	interrupt & MDM_DL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL2 ") : 0;
+	interrupt & MDM_DL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL1 ") : NULL;
+	interrupt & MDM_DL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL2 ") : NULL;
 
-	interrupt & MDM_UL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL1 ") : 0;
-	interrupt & MDM_UL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL2 ") : 0;
+	interrupt & MDM_UL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL1 ") : NULL;
+	interrupt & MDM_UL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL2 ") : NULL;
 
-	interrupt & DIAG_DL1 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL1 ") : 0;
-	interrupt & DIAG_DL2 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL2 ") : 0;
+	interrupt & DIAG_DL1 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL1 ") : NULL;
+	interrupt & DIAG_DL2 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL2 ") : NULL;
 
-	interrupt & DIAG_UL ? p += snprintf(p, TMP_BUF_MAX, "DIAG_UL ") : 0;
+	interrupt & DIAG_UL ? p += snprintf(p, TMP_BUF_MAX, "DIAG_UL ") : NULL;
 
-	interrupt & APP1_DL ? p += snprintf(p, TMP_BUF_MAX, "APP1_DL ") : 0;
-	interrupt & APP2_DL ? p += snprintf(p, TMP_BUF_MAX, "APP2_DL ") : 0;
+	interrupt & APP1_DL ? p += snprintf(p, TMP_BUF_MAX, "APP1_DL ") : NULL;
+	interrupt & APP2_DL ? p += snprintf(p, TMP_BUF_MAX, "APP2_DL ") : NULL;
 
-	interrupt & APP1_UL ? p += snprintf(p, TMP_BUF_MAX, "APP1_UL ") : 0;
-	interrupt & APP2_UL ? p += snprintf(p, TMP_BUF_MAX, "APP2_UL ") : 0;
+	interrupt & APP1_UL ? p += snprintf(p, TMP_BUF_MAX, "APP1_UL ") : NULL;
+	interrupt & APP2_UL ? p += snprintf(p, TMP_BUF_MAX, "APP2_UL ") : NULL;
 
-	interrupt & CTRL_DL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_DL ") : 0;
-	interrupt & CTRL_UL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_UL ") : 0;
+	interrupt & CTRL_DL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_DL ") : NULL;
+	interrupt & CTRL_UL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_UL ") : NULL;
 
-	interrupt & RESET ? p += snprintf(p, TMP_BUF_MAX, "RESET ") : 0;
+	interrupt & RESET ? p += snprintf(p, TMP_BUF_MAX, "RESET ") : NULL;
 
 	return buf;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-drm.patch
git-libata-all.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ptrace-needs-proc_fs.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
ipwireless-use-ansi-func-decl.patch
cpuidle-unsigned-bitfield.patch
acpi-dock-use-null-for-pointer.patch
ext4-use-null-for-pointers.patch
nozomi-use-null-for-pointers.patch
