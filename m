From: akpm@linux-foundation.org
Subject: + kasan-do-not-sanitize-kexec-purgatory.patch added to -mm tree
Date: Wed, 29 Mar 2017 16:25:27 -0700
Message-ID: <58dc4267.KiuPz69LRZv1DIS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbdC2XZ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 19:25:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: do not sanitize kexec purgatory
has been added to the -mm tree.  Its filename is
     kasan-do-not-sanitize-kexec-purgatory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-do-not-sanitize-kexec-purgatory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-do-not-sanitize-kexec-purgatory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Galbraith <efault@gmx.de>
Subject: kasan: do not sanitize kexec purgatory

[   24.121074] kexec: Undefined symbol: __asan_load8_noabort
[   24.121999] kexec-bzImage64: Loading purgatory failed

Link: http://lkml.kernel.org/r/1489672155.4458.7.camel@gmx.de
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/purgatory/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/purgatory/Makefile~kasan-do-not-sanitize-kexec-purgatory arch/x86/purgatory/Makefile
--- a/arch/x86/purgatory/Makefile~kasan-do-not-sanitize-kexec-purgatory
+++ a/arch/x86/purgatory/Makefile
@@ -8,6 +8,7 @@ PURGATORY_OBJS = $(addprefix $(obj)/,$(p
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
 targets += purgatory.ro
 
+KASAN_SANITIZE	:= n
 KCOV_INSTRUMENT := n
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
_

Patches currently in -mm which might be from efault@gmx.de are

kasan-do-not-sanitize-kexec-purgatory.patch

