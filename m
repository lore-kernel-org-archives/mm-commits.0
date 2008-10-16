From: akpm@linux-foundation.org
Subject: - lib-pull-base-guessing-logic-to-helper-function.patch removed from -mm tree
Date: Thu, 16 Oct 2008 13:18:16 -0700
Message-ID: <200810162018.m9GKIGHa013540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbYJPUST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, yi.y.yang@intel.com, mm-commits@vger.kernel.org


The patch titled
     lib: pull base-guessing logic to helper function
has been removed from the -mm tree.  Its filename was
     lib-pull-base-guessing-logic-to-helper-function.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: pull base-guessing logic to helper function
From: Harvey Harrison <harvey.harrison@gmail.com>

There is a small behavior change in this patch, previously, when no base
was specified and the string began with 0x?  the base would be guessed as
8, unless isxdigit(?) was true.  This would then return 0 as 'x' was
larger than 8.  Now, the base is always guessed as 16 if the string starts
with '0x'

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Yi Yang <yi.y.yang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   80 ++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 38 deletions(-)

diff -puN lib/vsprintf.c~lib-pull-base-guessing-logic-to-helper-function lib/vsprintf.c
--- a/lib/vsprintf.c~lib-pull-base-guessing-logic-to-helper-function
+++ a/lib/vsprintf.c
@@ -32,6 +32,18 @@
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)
 
+static unsigned int simple_guess_base(const char *cp)
+{
+	if (cp[0] == '0') {
+		if (TOLOWER(cp[1]) == 'x')
+			return 16;
+		else
+			return 8;
+	} else {
+		return 10;
+	}
+}
+
 /**
  * simple_strtoul - convert a string to an unsigned long
  * @cp: The start of the string
@@ -40,32 +52,28 @@
  */
 unsigned long simple_strtoul(const char *cp,char **endp,unsigned int base)
 {
-	unsigned long result = 0,value;
+	unsigned long result = 0;
 
-	if (!base) {
-		base = 10;
-		if (*cp == '0') {
-			base = 8;
-			cp++;
-			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
-				cp++;
-				base = 16;
-			}
-		}
-	} else if (base == 16) {
-		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
-			cp += 2;
-	}
-	while (isxdigit(*cp) &&
-	       (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
-		result = result*base + value;
+	if (!base)
+		base = simple_guess_base(cp);
+
+	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
+		cp += 2;
+
+	while (isxdigit(*cp)) {
+		unsigned int value;
+
+		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		if (value >= base)
+			break;
+		result = result * base + value;
 		cp++;
 	}
+
 	if (endp)
 		*endp = (char *)cp;
 	return result;
 }
-
 EXPORT_SYMBOL(simple_strtoul);
 
 /**
@@ -91,32 +99,28 @@ EXPORT_SYMBOL(simple_strtol);
  */
 unsigned long long simple_strtoull(const char *cp,char **endp,unsigned int base)
 {
-	unsigned long long result = 0,value;
+	unsigned long long result = 0;
 
-	if (!base) {
-		base = 10;
-		if (*cp == '0') {
-			base = 8;
-			cp++;
-			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
-				cp++;
-				base = 16;
-			}
-		}
-	} else if (base == 16) {
-		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
-			cp += 2;
-	}
-	while (isxdigit(*cp)
-	 && (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
-		result = result*base + value;
+	if (!base)
+		base = simple_guess_base(cp);
+
+	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
+		cp += 2;
+
+	while (isxdigit(*cp)) {
+		unsigned int value;
+
+		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		if (value >= base)
+			break;
+		result = result * base + value;
 		cp++;
 	}
+
 	if (endp)
 		*endp = (char *)cp;
 	return result;
 }
-
 EXPORT_SYMBOL(simple_strtoull);
 
 /**
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

