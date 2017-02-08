From: akpm@linux-foundation.org
Subject: +
 kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix.patch added to -mm tree
Date: Wed, 08 Feb 2017 13:21:47 -0800
Message-ID: <589b8beb.tXmSYY8eZkoLtaAX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49000 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdBHVVs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 16:21:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, broonie@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix
has been added to the -mm tree.  Its filename is
     kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix

On Wed, Feb 8, 2017 at 9:22 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Feb 08, 2017 at 10:54:16AM +0000, Build bot for Mark Brown wrote:
>
> Today's -next fails to build an arm64 allmodconfig due to:
>
>>       arm64-allmodconfig
>> ../arch/arm64/kernel/armv8_deprecated.c:359:31: error: expected '=',
>> ',', ';',
> +'asm' or '__attribute__' before 'aarch32_check_condition'
>> ../arch/arm64/kernel/armv8_deprecated.c:386:10: error: implicit
>> declaration of
> +function 'aarch32_check_condition'
> [-Werror=implicit-function-declaration]
>
> triggered by 1930faf201e83f6 (kprobes: move kprobe declarations to
> asm-generic/kprobes.h) according to a bisect, though I didn't
> immediately see how.

This fixes that, will send patch.

Link: http://lkml.kernel.org/r/CAB=NE6X1WMByuARS4mZ1g9+W=LuVBnMDnh_5zyN0CLADaVh=Jw@mail.gmail.com
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/armv8_deprecated.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm64/kernel/armv8_deprecated.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix arch/arm64/kernel/armv8_deprecated.c
--- a/arch/arm64/kernel/armv8_deprecated.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix
+++ a/arch/arm64/kernel/armv8_deprecated.c
@@ -19,6 +19,7 @@
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
 #include <asm/traps.h>
+#include <asm/kprobes.h>
 #include <linux/uaccess.h>
 #include <asm/cpufeature.h>
 
_

Patches currently in -mm which might be from mcgrof@kernel.org are

ucount-mark-user_header-with-kmemleak_ignore.patch
kprobes-move-kprobe-declarations-to-asm-generic-kprobesh.patch
kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix.patch

