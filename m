From: akpm@linux-foundation.org
Subject: [merged] arm-add-pmd_mkclean-for-thp.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:12:52 -0800
Message-ID: <569e98c4.3N9u1aObFSUQmxuk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbcASUMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:12:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, danielmicay@gmail.com, darrick.wong@oracle.com, davem@davemloft.net, deller@gmx.de, fengguang.wu@intel.com, gang.chen.5i5j@gmail.com, hannes@cmpxchg.org, hughd@google.com, ink@jurassic.park.msu.ru, jcmvbkbc@gmail.com, je@fb.com, jejb@parisc-linux.org, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, luto@amacapital.net, mattst88@gmail.com, mgorman@suse.de, mhocko@suse.com, mika.penttila@nextfour.com, mtk.manpages@gmail.com, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, roland@kernel.org, rth@twiddle.net, shli@kernel.org, will.deacon@arm.com, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/include/asm/pgtable-3level.h: add pmd_mkclean for THP
has been removed from the -mm tree.  Its filename was
     arm-add-pmd_mkclean-for-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: arch/arm/include/asm/pgtable-3level.h: add pmd_mkclean for THP

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_mkclean for THP page MADV_FREE support.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Shaohua Li <shli@kernel.org>
Cc: <yalin.wang2010@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jason Evans <je@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil <mika.penttila@nextfour.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/include/asm/pgtable-3level.h~arm-add-pmd_mkclean-for-thp arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-add-pmd_mkclean-for-thp
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -240,6 +240,7 @@ PMD_BIT_FUNC(wrprotect,	|= L_PMD_SECT_RD
 PMD_BIT_FUNC(mkold,	&= ~PMD_SECT_AF);
 PMD_BIT_FUNC(mkwrite,   &= ~L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkdirty,   |= L_PMD_SECT_DIRTY);
+PMD_BIT_FUNC(mkclean,   &= ~L_PMD_SECT_DIRTY);
 PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 
 #define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
_

Patches currently in -mm which might be from minchan@kernel.org are


