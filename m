From: akpm@linux-foundation.org
Subject: + powerpc-dont-fortify-prom_init.patch added to -mm tree
Date: Tue, 20 Jun 2017 15:21:06 -0700
Message-ID: <59499fd2.eC2w/Saj9gT4yvJM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdFTWVH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2017 18:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dja@axtens.net, danielmicay@gmail.com, keescook@chromium.org, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: don't fortify prom_init
has been added to the -mm tree.  Its filename is
     powerpc-dont-fortify-prom_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-dont-fortify-prom_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-dont-fortify-prom_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: powerpc: don't fortify prom_init

prom_init is a bit special; in theory it should be able to be linked
separately to the kernel.  To keep this from getting too complex, the
symbols that prom_init.c uses are checked.

Fortification adds symbols, and it gets quite messy as it includes things
like panic().  So just don't fortify prom_init.c for now.

Link: http://lkml.kernel.org/r/1497903987-21002-6-git-send-email-keescook@chromium.org
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom_init.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/powerpc/kernel/prom_init.c~powerpc-dont-fortify-prom_init arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~powerpc-dont-fortify-prom_init
+++ a/arch/powerpc/kernel/prom_init.c
@@ -15,6 +15,9 @@
 
 #undef DEBUG_PROM
 
+/* we cannot use FORTIFY as it brings in new symbols */
+#define __NO_FORTIFY
+
 #include <stdarg.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
_

Patches currently in -mm which might be from dja@axtens.net are

powerpc-dont-fortify-prom_init.patch
powerpc-make-feature-fixup-tests-fortify-safe.patch

