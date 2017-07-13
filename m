From: akpm@linux-foundation.org
Subject: [merged] powerpc-dont-fortify-prom_init.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:42:20 -0700
Message-ID: <20170713204220.R4TmBW949%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbdGMUmV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au


The patch titled
     Subject: powerpc: don't fortify prom_init
has been removed from the -mm tree.  Its filename was
     powerpc-dont-fortify-prom_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


