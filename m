From: akpm@linux-foundation.org
Subject: - lib-trivial-whitespace-tidy.patch removed from -mm tree
Date: Thu, 16 Oct 2008 13:22:40 -0700
Message-ID: <200810162022.m9GKMeB8014100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbYJPUWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, yi.y.yang@intel.com, mm-commits@vger.kernel.org


The patch titled
     lib: trivial whitespace tidy
has been removed from the -mm tree.  Its filename was
     lib-trivial-whitespace-tidy.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: trivial whitespace tidy
From: Harvey Harrison <harvey.harrison@gmail.com>

Remove extra lines before the EXPORT_SYMBOL()s

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Yi Yang <yi.y.yang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff -puN lib/vsprintf.c~lib-trivial-whitespace-tidy lib/vsprintf.c
--- a/lib/vsprintf.c~lib-trivial-whitespace-tidy
+++ a/lib/vsprintf.c
@@ -50,7 +50,7 @@ static unsigned int simple_guess_base(co
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long simple_strtoul(const char *cp,char **endp,unsigned int base)
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long result = 0;
 
@@ -82,13 +82,12 @@ EXPORT_SYMBOL(simple_strtoul);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long simple_strtol(const char *cp,char **endp,unsigned int base)
+long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp=='-')
-		return -simple_strtoul(cp+1,endp,base);
-	return simple_strtoul(cp,endp,base);
+	if(*cp == '-')
+		return -simple_strtoul(cp + 1, endp, base);
+	return simple_strtoul(cp, endp, base);
 }
-
 EXPORT_SYMBOL(simple_strtol);
 
 /**
@@ -97,7 +96,7 @@ EXPORT_SYMBOL(simple_strtol);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long long simple_strtoull(const char *cp,char **endp,unsigned int base)
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long long result = 0;
 
@@ -129,11 +128,11 @@ EXPORT_SYMBOL(simple_strtoull);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long long simple_strtoll(const char *cp,char **endp,unsigned int base)
+long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
 	if(*cp=='-')
-		return -simple_strtoull(cp+1,endp,base);
-	return simple_strtoull(cp,endp,base);
+		return -simple_strtoull(cp + 1, endp, base);
+	return simple_strtoull(cp, endp, base);
 }
 
 
@@ -798,7 +797,6 @@ int vsnprintf(char *buf, size_t size, co
 	/* the trailing null byte doesn't count towards the total */
 	return str-buf;
 }
-
 EXPORT_SYMBOL(vsnprintf);
 
 /**
@@ -824,7 +822,6 @@ int vscnprintf(char *buf, size_t size, c
 	i=vsnprintf(buf,size,fmt,args);
 	return (i >= size) ? (size - 1) : i;
 }
-
 EXPORT_SYMBOL(vscnprintf);
 
 /**
@@ -851,7 +848,6 @@ int snprintf(char * buf, size_t size, co
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(snprintf);
 
 /**
@@ -896,7 +892,6 @@ int vsprintf(char *buf, const char *fmt,
 {
 	return vsnprintf(buf, INT_MAX, fmt, args);
 }
-
 EXPORT_SYMBOL(vsprintf);
 
 /**
@@ -921,7 +916,6 @@ int sprintf(char * buf, const char *fmt,
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(sprintf);
 
 /**
@@ -1150,7 +1144,6 @@ int vsscanf(const char * buf, const char
 
 	return num;
 }
-
 EXPORT_SYMBOL(vsscanf);
 
 /**
@@ -1169,5 +1162,4 @@ int sscanf(const char * buf, const char 
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(sscanf);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
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

