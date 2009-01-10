From: akpm@linux-foundation.org
Subject: - byteorder-add-load_-store_endian-api.patch removed from -mm tree
Date: Fri, 09 Jan 2009 16:16:30 -0800
Message-ID: <200901100032.n0A0Wuui006974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbZAJAdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 19:33:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: add load_/store_{endian} API
has been removed from the -mm tree.  Its filename was
     byteorder-add-load_-store_endian-api.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: add load_/store_{endian} API
From: Harvey Harrison <harvey.harrison@gmail.com>

load_le16 is a synonym for the existing le16_to_cpup and is added to be
symmetric with the load_le16_noalign API.  On arches where unaligned
access is OK, the unaligned calls are replaced with aligned calls.

store_le16 is a new API and is added to be symmetric with the unaligned
functions.  It is implemented as a macro to allow compile-time
byteswapping when the value is a constant.  This will also allow use in
many places currently that are of the form:

*(__le16 *)ptr = cpu_to_le16(foo);

In addition, some drivers/filesystems/arches already provide this API
privately, which will allow them to be consolidated into this common code.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/generic.h |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN include/linux/byteorder/generic.h~byteorder-add-load_-store_endian-api include/linux/byteorder/generic.h
--- a/include/linux/byteorder/generic.h~byteorder-add-load_-store_endian-api
+++ a/include/linux/byteorder/generic.h
@@ -119,6 +119,19 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
+#define load_le16 __le16_to_cpup
+#define load_le32 __le32_to_cpup
+#define load_le64 __le64_to_cpup
+#define load_be16 __be16_to_cpup
+#define load_be32 __be32_to_cpup
+#define load_be64 __be64_to_cpup
+#define store_le16(p, val) (*(__le16 *)(p) = cpu_to_le16(val))
+#define store_le32(p, val) (*(__le32 *)(p) = cpu_to_le32(val))
+#define store_le64(p, val) (*(__le64 *)(p) = cpu_to_le64(val))
+#define store_be16(p, val) (*(__be16 *)(p) = cpu_to_be16(val))
+#define store_be32(p, val) (*(__be32 *)(p) = cpu_to_be32(val))
+#define store_be64(p, val) (*(__be64 *)(p) = cpu_to_be64(val))
+
 /*
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
@@ -142,32 +155,32 @@
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
-	*var = cpu_to_le16(le16_to_cpu(*var) + val);
+	store_le16(var, load_le16(var) + val);
 }
 
 static inline void le32_add_cpu(__le32 *var, u32 val)
 {
-	*var = cpu_to_le32(le32_to_cpu(*var) + val);
+	store_le32(var, load_le32(var) + val);
 }
 
 static inline void le64_add_cpu(__le64 *var, u64 val)
 {
-	*var = cpu_to_le64(le64_to_cpu(*var) + val);
+	store_le64(var, load_le64(var) + val);
 }
 
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
-	*var = cpu_to_be16(be16_to_cpu(*var) + val);
+	store_be16(var, load_be16(var) + val);
 }
 
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
+	store_be32(var, load_be32(var) + val);
 }
 
 static inline void be64_add_cpu(__be64 *var, u64 val)
 {
-	*var = cpu_to_be64(be64_to_cpu(*var) + val);
+	store_be64(var, load_be64(var) + val);
 }
 
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
memstick-annotate-endianness-of-attribute-structs.patch

