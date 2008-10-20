From: akpm@linux-foundation.org
Subject: - byteorder-use-generic-c-version-for-value-byteswapping.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:27 -0700
Message-ID: <200810202037.m9KKbR9N011638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131AbYJTUqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     byteorder: use generic C version for value byteswapping
has been removed from the -mm tree.  Its filename was
     byteorder-use-generic-c-version-for-value-byteswapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

