From: akpm@linux-foundation.org
Subject: [patch 11/11] kasan: do not sanitize kexec purgatory
Date: Fri, 31 Mar 2017 15:12:12 -0700
Message-ID: <58ded43c.N6PWIhvajdV6ZJeT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933315AbdCaWMN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 18:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

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
