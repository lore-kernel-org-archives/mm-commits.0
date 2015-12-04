From: akpm@linux-foundation.org
Subject: + mm-kmemleak-mark-kmemleak_init-prototype-as-__init.patch added
 to -mm tree
Date: Fri, 04 Dec 2015 15:47:01 -0800
Message-ID: <566225f5.EGSjZpXY2VaODcQ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbbLDXrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:47:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: mark kmemleak_init prototype as __init
has been added to the -mm tree.  Its filename is
     mm-kmemleak-mark-kmemleak_init-prototype-as-__init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-mark-kmemleak_init-prototype-as-__init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-mark-kmemleak_init-prototype-as-__init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: mm: kmemleak: mark kmemleak_init prototype as __init

kmemleak_init() definition in mm/kmemleak.c is marked __init but its
prototype in include/linux/kmemleak.h is marked __ref since commit
a6186d89c913 ("kmemleak: Mark the early log buffer as __initdata").

This causes a section mismatch which is reported as a warning when
building with clang -Wsection, because kmemleak_init() is declared in
section .ref.text but defined in .init.text.

Fix this by marking kmemleak_init() prototype __init.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemleak.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kmemleak.h~mm-kmemleak-mark-kmemleak_init-prototype-as-__init include/linux/kmemleak.h
--- a/include/linux/kmemleak.h~mm-kmemleak-mark-kmemleak_init-prototype-as-__init
+++ a/include/linux/kmemleak.h
@@ -25,7 +25,7 @@
 
 #ifdef CONFIG_DEBUG_KMEMLEAK
 
-extern void kmemleak_init(void) __ref;
+extern void kmemleak_init(void) __init;
 extern void kmemleak_alloc(const void *ptr, size_t size, int min_count,
 			   gfp_t gfp) __ref;
 extern void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size,
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

mm-kmemleak-mark-kmemleak_init-prototype-as-__init.patch

