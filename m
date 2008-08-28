From: akpm@linux-foundation.org
Subject: + byteorder-use-generic-c-version-for-value-byteswapping.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:32:35 -0700
Message-ID: <200808282332.m7SNWZmI020228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951AbYH1XdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, davem@davemloft.net


The patch titled
     byteorder: use generic C version for value byteswapping
has been added to the -mm tree.  Its filename is
     byteorder-use-generic-c-version-for-value-byteswapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: use generic C version for value byteswapping
From: Harvey Harrison <harvey.harrison@gmail.com>

This makes the new implementation of the byteorder helpers match the old
in how it degraded when an arch-defined version was not available:

1) swab()
	- look for arch defined
	- if not, use generic c version

2) swabp()
	- look for arch-defined
	- if not, deref pointer and use swab()

3) swabs()
	- look for arch defined
	- if not, use swabp

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swab.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN include/linux/swab.h~byteorder-use-generic-c-version-for-value-byteswapping include/linux/swab.h
--- a/include/linux/swab.h~byteorder-use-generic-c-version-for-value-byteswapping
+++ a/include/linux/swab.h
@@ -47,8 +47,6 @@ static inline __attribute_const__ __u16 
 {
 #ifdef __arch_swab16
 	return __arch_swab16(val);
-#elif defined(__arch_swab16p)
-	return __arch_swab16p(&val);
 #else
 	return __const_swab16(val);
 #endif
@@ -58,8 +56,6 @@ static inline __attribute_const__ __u32 
 {
 #ifdef __arch_swab32
 	return __arch_swab32(val);
-#elif defined(__arch_swab32p)
-	return __arch_swab32p(&val);
 #else
 	return __const_swab32(val);
 #endif
@@ -69,8 +65,6 @@ static inline __attribute_const__ __u64 
 {
 #ifdef __arch_swab64
 	return __arch_swab64(val);
-#elif defined(__arch_swab64p)
-	return __arch_swab64p(&val);
 #elif defined(__SWAB_64_THRU_32__)
 	__u32 h = val >> 32;
 	__u32 l = val & ((1ULL << 32) - 1);
@@ -84,8 +78,6 @@ static inline __attribute_const__ __u32 
 {
 #ifdef __arch_swahw32
 	return __arch_swahw32(val);
-#elif defined(__arch_swahw32p)
-	return __arch_swahw32p(&val);
 #else
 	return __const_swahw32(val);
 #endif
@@ -95,8 +87,6 @@ static inline __attribute_const__ __u32 
 {
 #ifdef __arch_swahb32
 	return __arch_swahb32(val);
-#elif defined(__arch_swahb32p)
-	return __arch_swahb32p(&val);
 #else
 	return __const_swahb32(val);
 #endif
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-mt9m111c-make-function-static.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch

