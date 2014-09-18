From: akpm@linux-foundation.org
Subject: [merged]
 mm-apply-the-section-attribute-to-the-variable-not-its-type.patch removed
 from -mm tree
Date: Thu, 18 Sep 2014 11:31:23 -0700
Message-ID: <541b24fb.mksFyGmCgRvEimhA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRSbY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 14:31:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dl9pf@gmx.de, behanw@converseincode.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/mm/mmap.c: apply the section attribute to the va=
riable, not its type
has been removed from the -mm tree.  Its filename was
     mm-apply-the-section-attribute-to-the-variable-not-its-type.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Jan-Simon M=F6ller <dl9pf@gmx.de>
Subject: arch/x86/mm/mmap.c: apply the section attribute to the variabl=
e, not its type

This fixes a compilation error in clang in that a linker section attrib=
ute
can't be added to a type.

arch/x86/mm/mmap.c:34:8: error: '__section__' attribute only applies to=
 functions and global variables
struct __read_mostly va_alignment va_align =3D {
       ^
arch/x86/include/asm/cache.h:10:38: note: expanded from macro '__read_m=
ostly'
#define __read_mostly __attribute__((__section__(".data..read_mostly"))=
)
                                     ^
1 error generated.

By moving the section attribute to the variable declaration, the desire=
d
effect is acheived.

Signed-off-by: Jan-Simon M=F6ller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/mmap.c~mm-apply-the-section-attribute-to-the-vari=
able-not-its-type arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~mm-apply-the-section-attribute-to-the-variable=
-not-its-type
+++ a/arch/x86/mm/mmap.c
@@ -31,7 +31,7 @@
 #include <linux/sched.h>
 #include <asm/elf.h>
=20
-struct __read_mostly va_alignment va_align =3D {
+struct va_alignment __read_mostly va_align =3D {
 	.flags =3D -1,
 };
=20
_

Patches currently in -mm which might be from dl9pf@gmx.de are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
