From: akpm@linux-foundation.org
Subject: - always-build-arch-ia64-lib-xoro.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:17 -0800
Message-ID: <200703070422.l274MH5H018979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47122 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbXCGEWX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, bob.picco@hp.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     always build arch/ia64/lib/xor.o
has been removed from the -mm tree.  Its filename was
     always-build-arch-ia64-lib-xoro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: always build arch/ia64/lib/xor.o
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Always build ia64 xor.o because multiple config options now depend on it.

Necessary to build .20-mm* on ia64 when, e.g., CONFIG_ASYNC_TX_DMA is
defined.  Don't know if '_ASYNC_TX_DMA makes sense on ia64.  If not, maybe
Kconfig should preclude it.

Could have defined a Kconfig option that defaults to true if MD_RAID456 ||
ASYNC_TX_DMA to control building of xor.o, but xor.o is only 848 bytes and
this IS ia64...

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Bob Picco <bob.picco@hp.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/lib/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/ia64/lib/Makefile~always-build-arch-ia64-lib-xoro arch/ia64/lib/Makefile
--- a/arch/ia64/lib/Makefile~always-build-arch-ia64-lib-xoro
+++ a/arch/ia64/lib/Makefile
@@ -9,12 +9,11 @@ lib-y := __divsi3.o __udivsi3.o __modsi3
 	checksum.o clear_page.o csum_partial_copy.o			\
 	clear_user.o strncpy_from_user.o strlen_user.o strnlen_user.o	\
 	flush.o ip_fast_csum.o do_csum.o				\
-	memset.o strlen.o
+	memset.o strlen.o xor.o
 
 lib-$(CONFIG_ITANIUM)	+= copy_page.o copy_user.o memcpy.o
 lib-$(CONFIG_MCKINLEY)	+= copy_page_mck.o memcpy_mck.o
 lib-$(CONFIG_PERFMON)	+= carta_random.o
-lib-$(CONFIG_MD_RAID456)	+= xor.o
 
 AFLAGS___divdi3.o	=
 AFLAGS___udivdi3.o	= -DUNSIGNED
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
