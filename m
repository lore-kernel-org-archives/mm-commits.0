From: akpm@linux-foundation.org
Subject: + m68k-bitops-always-include-asm-generic-bitops-findh.patch added to -mm tree
Date: Wed, 06 Dec 2017 15:54:31 -0800
Message-ID: <5a288337.zRfUNSg0lffyOc4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdLFXyc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 18:54:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, courbet@google.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/bitops: always include <asm-generic/bitops/find.h>
has been added to the -mm tree.  Its filename is
     m68k-bitops-always-include-asm-generic-bitops-findh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-bitops-always-include-asm-generic-bitops-findh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-bitops-always-include-asm-generic-bitops-findh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m68k/bitops: always include <asm-generic/bitops/find.h>

Currently <asm/bitops.h> only includes <asm-generic/bitops/find.h> if
CONFIG_CPU_HAS_NO_BITFIELDS=y.  This used to be fine, as the code for
CONFIG_CPU_HAS_NO_BITFIELDS=n implemented everything provided by
<asm-generic/bitops/find.h>.

However, e49c614e6b37254b ("lib: optimize cpumask_next_and()") added
find_next_and_bit(), which is now not available if
CONFIG_CPU_HAS_NO_BITFIELDS=y:

    lib/find_bit_benchmark.c: In function `test_find_next_and_bit':
    lib/find_bit_benchmark.c:115: error: implicit declaration of function `find_next_and_bit'

Move the inclusion of <asm-generic/bitops/find.h> outside the #ifdef to
fix this.

Link: http://lkml.kernel.org/r/1512556816-28627-1-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Clement Courbet <courbet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/m68k/include/asm/bitops.h~m68k-bitops-always-include-asm-generic-bitops-findh arch/m68k/include/asm/bitops.h
--- a/arch/m68k/include/asm/bitops.h~m68k-bitops-always-include-asm-generic-bitops-findh
+++ a/arch/m68k/include/asm/bitops.h
@@ -311,7 +311,6 @@ static inline int bfchg_mem_test_and_cha
  *	functions.
  */
 #if defined(CONFIG_CPU_HAS_NO_BITFIELDS)
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ffz.h>
 #else
 
@@ -441,6 +440,8 @@ static inline unsigned long ffz(unsigned
 
 #endif
 
+#include <asm-generic/bitops/find.h>
+
 #ifdef __KERNEL__
 
 #if defined(CONFIG_CPU_HAS_NO_BITFIELDS)
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-bitops-always-include-asm-generic-bitops-findh.patch

