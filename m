Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714E0C05027
	for <mm-commits@archiver.kernel.org>; Tue, 14 Feb 2023 21:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjBNVp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Feb 2023 16:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjBNVp0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2023 16:45:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758542942D
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 13:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03C91618FA
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 21:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466F4C433D2;
        Tue, 14 Feb 2023 21:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676411122;
        bh=shMXZnvecILM4TnmAWTLRboTWo6u8LbBEr4Y5BBGXQ8=;
        h=Date:To:From:Subject:From;
        b=0MSHAnHZPu6E8fZGcAQTIzUIIal1YMBzEPg0nXyPGUeQfj/z3AIDsRRF+vThSvpju
         YpNt5pb/Mtpvko0Hd0/WvStkVk3/a5PON4yerqhTU3fi2woTMhClhLe/PehYnSTh06
         jf+zKuN2X8f15H99F32TvTvp5104z1BhTW71o13M=
Date:   Tue, 14 Feb 2023 13:45:21 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        linux@roeck-us.net, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, dalias@libc.org,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-initialize-max_mapnr.patch added to mm-unstable branch
Message-Id: <20230214214522.466F4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: initialize max_mapnr
has been added to the -mm mm-unstable branch.  Its filename is
     sh-initialize-max_mapnr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-initialize-max_mapnr.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: sh: initialize max_mapnr
Date: Tue, 14 Feb 2023 16:07:29 +0200

sh never initializes max_mapnr which is used by the generic implementation
of pfn_valid().

Initialize max_mapnr with set_max_mapnr() in sh::paging_init().

Link: https://lkml.kernel.org/r/20230214140729.1649961-3-rppt@kernel.org
Fixes: e5080a967785 ("mm, arch: add generic implementation of pfn_valid() for FLATMEM")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/sh/mm/init.c~sh-initialize-max_mapnr
+++ a/arch/sh/mm/init.c
@@ -301,6 +301,7 @@ void __init paging_init(void)
 	 */
 	max_low_pfn = max_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
 	min_low_pfn = __MEMORY_START >> PAGE_SHIFT;
+	set_max_mapnr(max_low_pfn - min_low_pfn);
 
 	nodes_clear(node_online_map);
 
_

Patches currently in -mm which might be from rppt@kernel.org are

m68k-nommu-add-missing-definition-of-arch_pfn_offset.patch
sh-initialize-max_mapnr.patch

