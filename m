From: akpm@linux-foundation.org
Subject: + kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch
 tentatively added to -mm tree
Date: Mon, 14 Sep 2015 14:46:28 -0700
Message-ID: <55f74034.TGQJPCl1d6SagMTP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbINVq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move KASAN_SANITIZE in arch/x86/boot/Makefile
has been added to the -mm tree.  Its filename is
     kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move KASAN_SANITIZE in arch/x86/boot/Makefile

Move KASAN_SANITIZE in arch/x86/boot/Makefile above the comment
related to SVGA_MODE, since the comment refers to 'the next line'.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/boot/Makefile~kasan-move-kasan_sanitize-in-arch-x86-boot-makefile arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~kasan-move-kasan_sanitize-in-arch-x86-boot-makefile
+++ a/arch/x86/boot/Makefile
@@ -9,13 +9,13 @@
 # Changed by many, many contributors over the years.
 #
 
+KASAN_SANITIZE := n
+
 # If you want to preset the SVGA mode, uncomment the next line and
 # set SVGA_MODE to whatever number you want.
 # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
 # The number is the same as you would ordinarily press at bootup.
 
-KASAN_SANITIZE := n
