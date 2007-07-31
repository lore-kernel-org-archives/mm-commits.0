From: akpm@linux-foundation.org
Subject: - use-__val-in-__get_unaligned.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:18 -0700
Message-ID: <200707312358.l6VNwI3i029539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763859AbXHAAN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     use __val in __get_unaligned
has been removed from the -mm tree.  Its filename was
     use-__val-in-__get_unaligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use __val in __get_unaligned
From: Mike Frysinger <vapier@gentoo.org>

Use "__val" rather than "val" in the __get_unaligned macro in
asm-generic/unaligned.h.  This way gcc wont warn if you happen to also name
something in the same scope "val".

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/unaligned.h~use-__val-in-__get_unaligned include/asm-generic/unaligned.h
--- a/include/asm-generic/unaligned.h~use-__val-in-__get_unaligned
+++ a/include/asm-generic/unaligned.h
@@ -79,24 +79,24 @@ static inline void __ustw(__u16 val, __u
 
 #define __get_unaligned(ptr, size) ({		\
 	const void *__gu_p = ptr;		\
-	__u64 val;				\
+	__u64 __val;				\
 	switch (size) {				\
 	case 1:					\
-		val = *(const __u8 *)__gu_p;	\
+		__val = *(const __u8 *)__gu_p;	\
 		break;				\
 	case 2:					\
-		val = __uldw(__gu_p);		\
+		__val = __uldw(__gu_p);		\
 		break;				\
 	case 4:					\
-		val = __uldl(__gu_p);		\
+		__val = __uldl(__gu_p);		\
 		break;				\
 	case 8:					\
-		val = __uldq(__gu_p);		\
+		__val = __uldq(__gu_p);		\
 		break;				\
 	default:				\
 		bad_unaligned_access_length();	\
 	};					\
-	(__force __typeof__(*(ptr)))val;	\
+	(__force __typeof__(*(ptr)))__val;	\
 })
 
 #define __put_unaligned(val, ptr, size)		\
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
x86_64-hide-cond_syscall-behind-__kernel__.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
