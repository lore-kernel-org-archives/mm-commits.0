From: akpm@linux-foundation.org
Subject: [folded-merged]
 zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y.patch removed from -mm
 tree
Date: Wed, 10 Jul 2013 16:02:48 -0700
Message-ID: <51dde818.1Vpdo4s4WnYNxyo0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3GJXCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 19:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, sjenning@linux.vnet.ibm.com

Subject: [folded-merged] zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y.patch removed from -mm tree
To: sjenning@linux.vnet.ibm.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 16:02:48 -0700


The patch titled
     Subject: zswap: fix Kconfig to depend on CRYPTO=y
has been removed from the -mm tree.  Its filename was
     zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y.patch

This patch was dropped because it was folded into zswap-add-to-mm.patch

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: zswap: fix Kconfig to depend on CRYPTO=y

The Kconfig entry for zswap currently allows CRYPTO=m to satisfy the
zswap dependency.  However zswap is boolean (i.e. built-in) and has
symbol dependencies on CRYPTO.  Additionally, because the CRYPTO dependency
is satisfied with =m, the additional selects zswap does can also
be satisfied with =m, which leads to additional linking errors.

From the report:
=====
tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.9
head:   57cefddb141d6c9d0ab4f5a8589dd017f796a3f7
commit: 563f51c95b552e0d663df5bdf6cfc8e8a72d3ec6 [494/499] zswap: add to mm/
config: x86_64-randconfig-x004-0619 (attached as .config)

All error/warnings:

   mm/built-in.o: In function `zswap_frontswap_invalidate_area':
>> zswap.c:(.text+0x3a705): undefined reference to `zbud_free'
   mm/built-in.o: In function `zswap_free_entry':
>> zswap.c:(.text+0x3a76b): undefined reference to `zbud_free'
>> zswap.c:(.text+0x3a789): undefined reference to `zbud_get_pool_size'
on and on...
=====

This patch makes CRYPTO a built-in dependency of ZSWAP.  This has the
side effect of also making the selects built-in.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y mm/Kconfig
--- a/mm/Kconfig~zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y
+++ a/mm/Kconfig
@@ -490,7 +490,7 @@ config ZBUD
 
 config ZSWAP
 	bool "Compressed cache for swap pages (EXPERIMENTAL)"
-	depends on FRONTSWAP && CRYPTO
+	depends on FRONTSWAP && CRYPTO=y
 	select CRYPTO_LZO
 	select ZBUD
 	default n
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

