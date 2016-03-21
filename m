From: akpm@linux-foundation.org
Subject: [merged] ia64-define-ioremap_uc.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:37:42 -0700
Message-ID: <56f03f76.hPPKcP1IzbPNb5YI%akpm__7153.53389173305$1458590238$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525AbcCUT4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, fengguang.wu@intel.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: define ioremap_uc()
has been removed from the -mm tree.  Its filename was
     ia64-define-ioremap_uc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: ia64: define ioremap_uc()

All architectures now need ioremap_uc(), ia64 seems defines this already
through its ioremap_nocache() and it already ensures it *only* uses UC.

This is needed since v4.3 to complete an allyesconfig compile on ia64,
there were others archs that needed this, and this one seems to have
fallen through the cracks.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>	[4.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/include/asm/io.h~ia64-define-ioremap_uc arch/ia64/include/asm/io.h
--- a/arch/ia64/include/asm/io.h~ia64-define-ioremap_uc
+++ a/arch/ia64/include/asm/io.h
@@ -433,6 +433,7 @@ static inline void __iomem * ioremap_cac
 	return ioremap(phys_addr, size);
 }
 #define ioremap_cache ioremap_cache
+#define ioremap_uc ioremap_nocache
 
 
 /*
_

Patches currently in -mm which might be from mcgrof@kernel.org are


