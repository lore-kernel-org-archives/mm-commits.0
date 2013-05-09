From: akpm@linux-foundation.org
Subject: + scripts-sortextablec-fix-building-on-non-linux-systems.patch added to -mm tree
Date: Thu, 09 May 2013 10:53:38 -0700
Message-ID: <20130509175338.71B7531C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62225 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3EIRxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 13:53:39 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so315142vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 10:53:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dt.tangr@gmail.com, matt.fleming@intel.com


The patch titled
     Subject: scripts/sortextable.c: fix building on non-Linux systems
has been added to the -mm tree.  Its filename is
     scripts-sortextablec-fix-building-on-non-linux-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-sortextablec-fix-building-on-non-linux-systems.patch

