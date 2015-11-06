From: akpm@linux-foundation.org
Subject: [merged]
 kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:17:45 -0800
Message-ID: <563d0ae9.8BqXEgj9E4ijJ4HV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162900AbbKFURq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move KASAN_SANITIZE in arch/x86/boot/Makefile
has been removed from the -mm tree.  Its filename was
     kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
