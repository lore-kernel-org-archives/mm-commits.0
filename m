From: akpm@linux-foundation.org
Subject: + inith-document-the-existence-of-__initconst.patch added to -mm
 tree
Date: Thu, 26 Sep 2013 14:50:05 -0700
Message-ID: <5244ac0d.X3mE9Ecu8d4DwnNr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3IZVuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + inith-document-the-existence-of-__initconst.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:50:05 -0700


The patch titled
     Subject: init.h: document the existence of __initconst
has been added to the -mm tree.  Its filename is
     inith-document-the-existence-of-__initconst.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/inith-document-the-existence-of-__initconst.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/inith-document-the-existence-of-__initconst.patch

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
Subject: init.h: document the existence of __initconst

Initdata can be const since more than 5 years, using the __initconst
keyword.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/init.h~inith-document-the-existence-of-__initconst include/linux/init.h
--- a/include/linux/init.h~inith-document-the-existence-of-__initconst
+++ a/include/linux/init.h
@@ -26,8 +26,8 @@
  * extern int initialize_foobar_device(int, int, int) __init;
  *
  * For initialized data:
- * You should insert __initdata between the variable name and equal
- * sign followed by value, e.g.:
+ * You should insert __initdata or __initconst between the variable name
+ * and equal sign followed by value, e.g.:
  *
  * static int init_variable __initdata = 0;
  * static const char linux_logo[] __initconst = { 0x32, 0x36, ... };
@@ -35,8 +35,6 @@
  * Don't forget to initialize data not at file scope, i.e. within a function,
  * as gcc otherwise puts the data into the bss section and not into the init
  * section.
- * 
- * Also note, that this data cannot be "const".
  */
 
 /* These are for everybody (although not all archs will actually
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-kconfig-fix-grammar-s-an-a.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
inith-document-the-existence-of-__initconst.patch
linux-next.patch

