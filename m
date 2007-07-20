From: akpm@linux-foundation.org
Subject: + use-__val-in-__get_unaligned.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:15:47 -0700
Message-ID: <200707200015.l6K0FlPQ030201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635AbXGTAPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     use __val in __get_unaligned
has been added to the -mm tree.  Its filename is
     use-__val-in-__get_unaligned.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 6 deletions(-)

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

git-kbuild.patch
x86_64-hide-cond_syscall-behind-__kernel__.patch
use-__val-in-__get_unaligned.patch
