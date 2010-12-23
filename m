From: akpm@linux-foundation.org
Subject: [merged] include-linux-unaligned-pack-the-whole-struct-rather-than-just-the-field.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:48 -0800
Message-ID: <201012232240.oBNMeZIe015463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab0LWWkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     include/linux/unaligned: pack the whole struct rather than just the field
has been removed from the -mm tree.  Its filename was
     include-linux-unaligned-pack-the-whole-struct-rather-than-just-the-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/unaligned: pack the whole struct rather than just the field
From: Will Newton <will.newton@gmail.com>

The current packed struct implementation of unaligned access adds the
packed attribute only to the field within the unaligned struct rather than
to the struct as a whole.  This is not sufficient to enforce proper
behaviour on architectures with a default struct alignment of more than
one byte.

For example, the current implementation of __get_unaligned_cpu16 when
compiled for arm with gcc -O1 -mstructure-size-boundary=32 assumes the
struct is on a 4 byte boundary so performs the load of the 16bit packed
field as if it were on a 4 byte boundary:

__get_unaligned_cpu16:
        ldrh    r0, [r0, #0]
        bx      lr

Moving the packed attribute to the struct rather than the field causes the
proper unaligned access code to be generated:

__get_unaligned_cpu16:
	ldrb	r3, [r0, #0]	@ zero_extendqisi2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	orr	r0, r3, r0, asl #8
	bx	lr

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/unaligned/packed_struct.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/unaligned/packed_struct.h~include-linux-unaligned-pack-the-whole-struct-rather-than-just-the-field include/linux/unaligned/packed_struct.h
--- a/include/linux/unaligned/packed_struct.h~include-linux-unaligned-pack-the-whole-struct-rather-than-just-the-field
+++ a/include/linux/unaligned/packed_struct.h
@@ -3,9 +3,9 @@
 
 #include <linux/kernel.h>
 
-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
+struct __una_u16 { u16 x; } __attribute__((packed));
+struct __una_u32 { u32 x; } __attribute__((packed));
+struct __una_u64 { u64 x; } __attribute__((packed));
 
 static inline u16 __get_unaligned_cpu16(const void *p)
 {
_

Patches currently in -mm which might be from will.newton@gmail.com are

origin.patch
arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers.patch
include-linux-unaligned-packed_structh-use-__packed.patch

