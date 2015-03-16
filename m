From: akpm@linux-foundation.org
Subject: + mm-move-memtest-under-mm-fix.patch added to -mm tree
Date: Mon, 16 Mar 2015 12:46:52 -0700
Message-ID: <5507332c.J70/nYyAkr99aPX4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbbCPTqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 15:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, vladimir.murzin@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: MEMTEST depends on MEMBLOCK
has been added to the -mm tree.  Its filename is
     mm-move-memtest-under-mm-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-memtest-under-mm-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-memtest-under-mm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: mm: MEMTEST depends on MEMBLOCK

Building alpha:allmodconfig fails with

mm/memtest.c: In function 'reserve_bad_mem':
mm/memtest.c:38:2: error: implicit declaration of function 'memblock_reserve'
mm/memtest.c: In function 'do_one_pass':
mm/memtest.c:77:2: error: implicit declaration of function 'for_each_free_mem_range'
mm/memtest.c:77:73: error: expected ';' before '{' token

because it depends on MEMBLOCK which is not defined for the alpha
architecture.

Fixes: 420c89e6185d ("mm: move memtest under mm")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~mm-move-memtest-under-mm-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-move-memtest-under-mm-fix
+++ a/lib/Kconfig.debug
@@ -1734,6 +1734,7 @@ config TEST_UDELAY
 
 config MEMTEST
 	bool "Memtest"
+	depends on MEMBLOCK
 	---help---
 	  This option adds a kernel parameter 'memtest', which allows memtest
 	  to be set.
_

Patches currently in -mm which might be from linux@roeck-us.net are

alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch
mm-move-memtest-under-mm-fix.patch
i8k-remove-use-of-seq_printf-return-value.patch
linux-next.patch

