Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3284C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjBJA4O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjBJAy7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B676F20B
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18BBE61BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69133C433D2;
        Fri, 10 Feb 2023 00:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990441;
        bh=IEiqSqbI8VTWKJwA8P921rcRcfmNeX5sGZ9BbtWRhDc=;
        h=Date:To:From:Subject:From;
        b=GYu8MjKleyiTSVDJH6vy6UMTTZPq/R3QBOmnJfZhOgJBtVIHCT2Y9phcIV+DI+kR5
         XQwKlrHUr3HwpcTh5SYFrsXfthSXobiPIQS6alIdpD6KyHfhDYGiFk+9Tz+TWt3yom
         BfD+UIWDVVlJdgUp/ujO3/fcyLJgS1YP5jeKZSEY=
Date:   Thu, 09 Feb 2023 16:54:00 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vgupta@kernel.org, tsbogend@alpha.franken.de, shorne@gmail.com,
        richard@nod.at, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mattst88@gmail.com, linux@armlinux.org.uk,
        kernel@xen0n.name, jcmvbkbc@gmail.com, guoren@kernel.org,
        gerg@linux-m68k.org, geert@linux-m68k.org, dinguyen@kernel.org,
        deller@gmx.de, david@redhat.com, davem@davemloft.net,
        dalias@libc.org, chenhuacai@loongson.cn, chenhuacai@kernel.org,
        bcain@quicinc.com, arnd@arndb.de, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-drop-definition-of-pfn_valid-for-discontigmem.patch removed from -mm tree
Message-Id: <20230210005401.69133C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: drop definition of pfn_valid() for DISCONTIGMEM
has been removed from the -mm tree.  Its filename was
     mips-drop-definition-of-pfn_valid-for-discontigmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mips: drop definition of pfn_valid() for DISCONTIGMEM
Date: Sun, 29 Jan 2023 14:42:34 +0200

There is a stale definition of pfn_valid() for DISCONTINGMEM memory model
guarded !FLATMEM && !SPARSEMEM && NUMA ifdefery.

Remove everything but definition of pfn_valid() for FLATMEM.

Link: https://lkml.kernel.org/r/20230129124235.209895-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/page.h |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/arch/mips/include/asm/page.h~mips-drop-definition-of-pfn_valid-for-discontigmem
+++ a/arch/mips/include/asm/page.h
@@ -235,21 +235,6 @@ static inline int pfn_valid(unsigned lon
 	return pfn >= pfn_offset && pfn < max_mapnr;
 }
 
-#elif defined(CONFIG_SPARSEMEM)
-
-/* pfn_valid is defined in linux/mmzone.h */
-
-#elif defined(CONFIG_NUMA)
-
-#define pfn_valid(pfn)							\
-({									\
-	unsigned long __pfn = (pfn);					\
-	int __n = pfn_to_nid(__pfn);					\
-	((__n >= 0) ? (__pfn < NODE_DATA(__n)->node_start_pfn +		\
-			       NODE_DATA(__n)->node_spanned_pages)	\
-		    : 0);						\
-})
-
 #endif
 
 #define virt_to_pfn(kaddr)   	PFN_DOWN(virt_to_phys((void *)(kaddr)))
_

Patches currently in -mm which might be from rppt@kernel.org are


