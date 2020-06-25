From: akpm@linux-foundation.org
Subject: + fix-annotation-of-ioreadwrite1632be.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 22:31:36 -0700
Message-ID: <20200625053136.GD_e3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389781AbgFYFbh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 01:31:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@kernel.org, rth@twiddle.net, mattst88@gmail.com, lkp@intel.com, ink@jurassic.park.msu.ru, arnd@arndb.de, luc.vanoostenryck@gmail.com


The patch titled
     Subject: alpha: fix annotation of io{read,write}{16,32}be()
has been added to the -mm tree.  Its filename is
     fix-annotation-of-ioreadwrite1632be.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-annotation-of-ioreadwrite1632be.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-annotation-of-ioreadwrite1632be.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: alpha: fix annotation of io{read,write}{16,32}be()

These accessors must be used to read/write a big-endian bus.  The value
returned or written is native-endian.

However, these accessors are defined using be{16,32}_to_cpu() or
cpu_to_be{16,32}() to make the endian conversion but these expect a
__be{16,32} when none is present.  Keeping them would need a force cast
that would solve nothing at all.

So, do the conversion using swab{16,32}, like done in asm-generic for
similar situations.

Link: http://lkml.kernel.org/r/20200622114232.80039-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/io.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/alpha/include/asm/io.h~fix-annotation-of-ioreadwrite1632be
+++ a/arch/alpha/include/asm/io.h
@@ -489,10 +489,10 @@ extern inline void writeq(u64 b, volatil
 }
 #endif
 
-#define ioread16be(p) be16_to_cpu(ioread16(p))
-#define ioread32be(p) be32_to_cpu(ioread32(p))
-#define iowrite16be(v,p) iowrite16(cpu_to_be16(v), (p))
-#define iowrite32be(v,p) iowrite32(cpu_to_be32(v), (p))
+#define ioread16be(p) swab16(ioread16(p))
+#define ioread32be(p) swab32(ioread32(p))
+#define iowrite16be(v,p) iowrite16(swab16(v), (p))
+#define iowrite32be(v,p) iowrite32(swab32(v), (p))
 
 #define inb_p		inb
 #define inw_p		inw
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are

fix-annotation-of-ioreadwrite1632be.patch
