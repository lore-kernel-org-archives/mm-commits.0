From: akpm@linux-foundation.org
Subject: + lib-trivial-whitespace-tidy.patch added to -mm tree
Date: Wed, 17 Sep 2008 16:06:12 -0700
Message-ID: <200809172306.m8HN6CWm002904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbYIQXGP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 19:06:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, yi.y.yang@intel.com


The patch titled
     lib: trivial whitespace tidy
has been added to the -mm tree.  Its filename is
     lib-trivial-whitespace-tidy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
 
 
@@ -794,7 +793,6 @@ int vsnprintf(char *buf, size_t size, co
 	/* the trailing null byte doesn't count towards the total */
 	return str-buf;
 }
-
 EXPORT_SYMBOL(vsnprintf);
 
 /**
@@ -818,7 +816,6 @@ int vscnprintf(char *buf, size_t size, c
 	i=vsnprintf(buf,size,fmt,args);
 	return (i >= size) ? (size - 1) : i;
 }
-
 EXPORT_SYMBOL(vscnprintf);
 
 /**
@@ -843,7 +840,6 @@ int snprintf(char * buf, size_t size, co
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(snprintf);
 
 /**
@@ -886,7 +882,6 @@ int vsprintf(char *buf, const char *fmt,
 {
 	return vsnprintf(buf, INT_MAX, fmt, args);
 }
-
 EXPORT_SYMBOL(vsprintf);
 
 /**
@@ -909,7 +904,6 @@ int sprintf(char * buf, const char *fmt,
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(sprintf);
 
 /**
@@ -1138,7 +1132,6 @@ int vsscanf(const char * buf, const char
 
 	return num;
 }
-
 EXPORT_SYMBOL(vsscanf);
 
 /**
@@ -1157,5 +1150,4 @@ int sscanf(const char * buf, const char 
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(sscanf);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
net-compile-fix-depcac.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
bq27x00_battery-use-unaligned-access-helper.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
fbcon-fix-monochrome-color-value-calculation.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

