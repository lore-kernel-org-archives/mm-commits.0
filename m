From: akpm@linux-foundation.org
Subject: [alternative-merged]
 scripts-sortextablec-fix-building-on-non-linux-systems.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:18:03 -0700
Message-ID: <51db106b.HXcA2bBI3D3UGMY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3GHTSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, dt.tangr@gmail.com

Subject: [alternative-merged] scripts-sortextablec-fix-building-on-non-linux-systems.patch removed from -mm tree
To: dt.tangr@gmail.com,matt.fleming@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:18:03 -0700


The patch titled
     Subject: scripts/sortextable.c: fix building on non-Linux systems
has been removed from the -mm tree.  Its filename was
     scripts-sortextablec-fix-building-on-non-linux-systems.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Daniel Tang <dt.tangr@gmail.com>
Subject: scripts/sortextable.c: fix building on non-Linux systems

scripts/sortextable.c fails to compile on non-Linux systems due to the
missing 'linux/types.h' header.

Unless I'm missing something obvious, including the standard 'inttypes.h'
header instead and using uintX_t types instead of __uX types does the
exact same job and doesn't break compilation on non-Linux systems.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/tools/be_byteshift.h |   34 +++++++++++++--------------
 tools/include/tools/le_byteshift.h |   34 +++++++++++++--------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff -puN tools/include/tools/be_byteshift.h~scripts-sortextablec-fix-building-on-non-linux-systems tools/include/tools/be_byteshift.h
--- a/tools/include/tools/be_byteshift.h~scripts-sortextablec-fix-building-on-non-linux-systems
+++ a/tools/include/tools/be_byteshift.h
@@ -1,68 +1,68 @@
 #ifndef _TOOLS_BE_BYTESHIFT_H
 #define _TOOLS_BE_BYTESHIFT_H
 
-#include <linux/types.h>
+#include <inttypes.h>
 
-static inline __u16 __get_unaligned_be16(const __u8 *p)
+static inline uint16_t __get_unaligned_be16(const uint8_t *p)
 {
 	return p[0] << 8 | p[1];
 }
 
-static inline __u32 __get_unaligned_be32(const __u8 *p)
+static inline uint32_t __get_unaligned_be32(const uint8_t *p)
 {
 	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
 }
 
-static inline __u64 __get_unaligned_be64(const __u8 *p)
+static inline uint64_t __get_unaligned_be64(const uint8_t *p)
 {
-	return (__u64)__get_unaligned_be32(p) << 32 |
+	return (uint64_t)__get_unaligned_be32(p) << 32 |
 	       __get_unaligned_be32(p + 4);
 }
 
-static inline void __put_unaligned_be16(__u16 val, __u8 *p)
+static inline void __put_unaligned_be16(uint16_t val, uint8_t *p)
 {
 	*p++ = val >> 8;
 	*p++ = val;
 }
 
-static inline void __put_unaligned_be32(__u32 val, __u8 *p)
+static inline void __put_unaligned_be32(uint32_t val, uint8_t *p)
 {
 	__put_unaligned_be16(val >> 16, p);
 	__put_unaligned_be16(val, p + 2);
 }
 
-static inline void __put_unaligned_be64(__u64 val, __u8 *p)
+static inline void __put_unaligned_be64(uint64_t val, uint8_t *p)
 {
 	__put_unaligned_be32(val >> 32, p);
 	__put_unaligned_be32(val, p + 4);
 }
 
-static inline __u16 get_unaligned_be16(const void *p)
+static inline uint16_t get_unaligned_be16(const void *p)
 {
-	return __get_unaligned_be16((const __u8 *)p);
+	return __get_unaligned_be16((const uint8_t *)p);
 }
 
-static inline __u32 get_unaligned_be32(const void *p)
+static inline uint32_t get_unaligned_be32(const void *p)
 {
-	return __get_unaligned_be32((const __u8 *)p);
+	return __get_unaligned_be32((const uint8_t *)p);
 }
 
-static inline __u64 get_unaligned_be64(const void *p)
+static inline uint64_t get_unaligned_be64(const void *p)
 {
-	return __get_unaligned_be64((const __u8 *)p);
+	return __get_unaligned_be64((const uint8_t *)p);
 }
 
-static inline void put_unaligned_be16(__u16 val, void *p)
+static inline void put_unaligned_be16(uint16_t val, void *p)
 {
 	__put_unaligned_be16(val, p);
 }
 
-static inline void put_unaligned_be32(__u32 val, void *p)
+static inline void put_unaligned_be32(uint32_t val, void *p)
 {
 	__put_unaligned_be32(val, p);
 }
 
-static inline void put_unaligned_be64(__u64 val, void *p)
+static inline void put_unaligned_be64(uint64_t val, void *p)
 {
 	__put_unaligned_be64(val, p);
 }
diff -puN tools/include/tools/le_byteshift.h~scripts-sortextablec-fix-building-on-non-linux-systems tools/include/tools/le_byteshift.h
--- a/tools/include/tools/le_byteshift.h~scripts-sortextablec-fix-building-on-non-linux-systems
+++ a/tools/include/tools/le_byteshift.h
@@ -1,68 +1,68 @@
 #ifndef _TOOLS_LE_BYTESHIFT_H
 #define _TOOLS_LE_BYTESHIFT_H
 
-#include <linux/types.h>
+#include <inttypes.h>
 
-static inline __u16 __get_unaligned_le16(const __u8 *p)
+static inline uint16_t __get_unaligned_le16(const uint8_t *p)
 {
 	return p[0] | p[1] << 8;
 }
 
-static inline __u32 __get_unaligned_le32(const __u8 *p)
+static inline uint32_t __get_unaligned_le32(const uint8_t *p)
 {
 	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
 }
 
-static inline __u64 __get_unaligned_le64(const __u8 *p)
+static inline uint64_t __get_unaligned_le64(const uint8_t *p)
 {
-	return (__u64)__get_unaligned_le32(p + 4) << 32 |
+	return (uint64_t)__get_unaligned_le32(p + 4) << 32 |
 	       __get_unaligned_le32(p);
 }
 
-static inline void __put_unaligned_le16(__u16 val, __u8 *p)
+static inline void __put_unaligned_le16(uint16_t val, uint8_t *p)
 {
 	*p++ = val;
 	*p++ = val >> 8;
 }
 
-static inline void __put_unaligned_le32(__u32 val, __u8 *p)
+static inline void __put_unaligned_le32(uint32_t val, uint8_t *p)
 {
 	__put_unaligned_le16(val >> 16, p + 2);
 	__put_unaligned_le16(val, p);
 }
 
-static inline void __put_unaligned_le64(__u64 val, __u8 *p)
+static inline void __put_unaligned_le64(uint64_t val, uint8_t *p)
 {
 	__put_unaligned_le32(val >> 32, p + 4);
 	__put_unaligned_le32(val, p);
 }
 
-static inline __u16 get_unaligned_le16(const void *p)
+static inline uint16_t get_unaligned_le16(const void *p)
 {
-	return __get_unaligned_le16((const __u8 *)p);
+	return __get_unaligned_le16((const uint8_t *)p);
 }
 
-static inline __u32 get_unaligned_le32(const void *p)
+static inline uint32_t get_unaligned_le32(const void *p)
 {
-	return __get_unaligned_le32((const __u8 *)p);
+	return __get_unaligned_le32((const uint8_t *)p);
 }
 
-static inline __u64 get_unaligned_le64(const void *p)
+static inline uint64_t get_unaligned_le64(const void *p)
 {
-	return __get_unaligned_le64((const __u8 *)p);
+	return __get_unaligned_le64((const uint8_t *)p);
 }
 
-static inline void put_unaligned_le16(__u16 val, void *p)
+static inline void put_unaligned_le16(uint16_t val, void *p)
 {
 	__put_unaligned_le16(val, p);
 }
 
-static inline void put_unaligned_le32(__u32 val, void *p)
+static inline void put_unaligned_le32(uint32_t val, void *p)
 {
 	__put_unaligned_le32(val, p);
 }
 
-static inline void put_unaligned_le64(__u64 val, void *p)
+static inline void put_unaligned_le64(uint64_t val, void *p)
 {
 	__put_unaligned_le64(val, p);
 }
_

Patches currently in -mm which might be from dt.tangr@gmail.com are

origin.patch
linux-next.patch

