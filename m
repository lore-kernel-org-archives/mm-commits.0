From: akpm@linux-foundation.org
Subject: + x86-fix-compilation-warning-discards-qualifiers-from-pointer-target-type-in-io_32h.patch added to -mm tree
Date: Wed, 17 Sep 2008 11:45:11 -0700
Message-ID: <200809171845.m8HIjBSM024974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852AbYIQSqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 14:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rvsjoen@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix compilation warning "discards qualifiers from pointer tar=
get type" in io_32.h
has been added to the -mm tree.  Its filename is
     x86-fix-compilation-warning-discards-qualifiers-from-pointer-targe=
t-type-in-io_32h.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86: fix compilation warning "discards qualifiers from pointer=
 target type" in io_32.h
=46rom: "Rune V. Sj=F8en" <rvsjoen@gmail.com>

=46ixes compilation warning "discards qualifiers from pointer target
type" in io_32.h

Signed-off-by: "Rune V. Sj=F8en" <rvsjoen@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/io_32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86/io_32.h~x86-fix-compilation-warning-discards-=
qualifiers-from-pointer-target-type-in-io_32h include/asm-x86/io_32.h
--- a/include/asm-x86/io_32.h~x86-fix-compilation-warning-discards-qual=
ifiers-from-pointer-target-type-in-io_32h
+++ a/include/asm-x86/io_32.h
@@ -152,7 +152,7 @@ memcpy_fromio(void *dst, const volatile=20
 }
=20
 static inline void
-memcpy_toio(volatile void __iomem *dst, const void *src, int count)
+memcpy_toio(void __iomem *dst, const void *src, int count)
 {
 	__memcpy((void __force *)dst, src, count);
 }
_

Patches currently in -mm which might be from rvsjoen@gmail.com are

x86-fix-compilation-warning-discards-qualifiers-from-pointer-target-typ=
e-in-io_32h.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
