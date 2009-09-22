From: akpm@linux-foundation.org
Subject: [folded] walk-system-ram-range-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:45:21 -0700
Message-ID: <200909222145.n8MLjM4e004439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbZIVVqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk, ralf@linux-mips.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     walk-system-ram-range-fix
has been removed from the -mm tree.  Its filename was
     walk-system-ram-range-fix.patch

This patch was dropped because it was folded into walk-system-ram-range.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: walk-system-ram-range-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

walk-system-ram-range.patch renames walk_memory_resource()
to be walk_system_ram_range().
But powerpc has its own one and it's exported.
(Because ehea driver (IBM's one) uses this, powerpc export this.)

> arch/powerpc/mm/mem.c:169: error: ‘walk_memory_resource’ undeclared here (not in a function)
> cc1: warnings being treated as errors
> arch/powerpc/mm/mem.c:169: error: type defaults to ‘int’ in declaration of ‘walk_memory_resource’
> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
>
The patch failed to update powerpc's EXPORT_SYMBOL, this patch fixes it.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/mem.c~walk-system-ram-range-fix arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~walk-system-ram-range-fix
+++ a/arch/powerpc/mm/mem.c
@@ -166,7 +166,7 @@ walk_system_ram_range(unsigned long star
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(walk_memory_resource);
+EXPORT_SYMBOL_GPL(walk_system_ram_range);
 
 /*
  * Initialize the bootmem system and give it all the memory we
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix.patch
walk-system-ram-range-fix-2.patch
kcore-use-registerd-physmem-information.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
kcore-more-fixes-for-init.patch
proc-kcore-fix-statst_size.patch
proc-kcore-update-statst_size-after-memory-hotplug.patch

