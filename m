From: akpm@linux-foundation.org
Subject: + include-linux-unaligned-pack-the-whole-struct-rather-than-just-the-field.patch added to -mm tree
Date: Mon, 20 Dec 2010 21:45:29 -0800
Message-ID: <201012210548.oBL5msK3021364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525Ab0LUFtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 00:49:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, arnd@arndb.de, stable@kernel.org


The patch titled
     include/linux/unaligned: pack the whole struct rather than just the field
has been added to the -mm tree.  Its filename is
     include-linux-unaligned-pack-the-whole-struct-rather-than-just-the-field.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: <stable@kernel.org>
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

include-linux-unaligned-pack-the-whole-struct-rather-than-just-the-field.patch
arch-um-drivers-linec-safely-iterate-over-list-of-winch-handlers.patch
include-linux-unaligned-packed_structh-use-__packed.patch

