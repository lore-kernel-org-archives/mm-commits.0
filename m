Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93660C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBQEqM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBQEpj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:45:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD975A382
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AFA1612CA
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E206C433EF;
        Fri, 17 Feb 2023 04:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609096;
        bh=43b+/Da3N6ux/so2oDU86IiwXOSFCkwcm0IV4csjehQ=;
        h=Date:To:From:Subject:From;
        b=qPFb4Z2BJiHFOyBdT7L9Q7liUg3amYCYdQtq215GEJU5v+d6G7RJiJAu97y+zGtCr
         ibIM2OxFR1Hc44LrSD7os9kNkRXxwftWfvlsLrSHRwN4BFAw8dKV20bWngCz1Suo+S
         HIn5lwmjyxFMbbF+k5zX3PFaf97u1woo+3MbH+7k=
Date:   Thu, 16 Feb 2023 20:44:56 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        linux@roeck-us.net, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, david@redhat.com,
        dalias@libc.org, arnd@arndb.de, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-initialize-max_mapnr.patch removed from -mm tree
Message-Id: <20230217044456.9E206C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: initialize max_mapnr
has been removed from the -mm tree.  Its filename was
     sh-initialize-max_mapnr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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


