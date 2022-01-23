Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D56DC433FE
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbiAWX7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiAWX7D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:59:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21139C06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC466121E
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F11C340E3;
        Sun, 23 Jan 2022 23:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982342;
        bh=MQ0VPVy/5NVC285YXg/8LccrlziZPHic3kd88LolP7c=;
        h=Date:From:To:Subject:From;
        b=UKNt4gx7uBgKqsRK9rm5tlF7Kjs8pN2TS2lO/gFJUCs2/lAVYKnsP87sYEJF+P393
         J0NLM7Jk13u6QEVRr9eJIOInRXKb0r5cnmRUrUTKPxg9Ut8BTI1US8VMl0Sd+LZPZm
         fusJYWaaVO4H8ZEvLRZA1oDMjxTFuCmz48HHyWu8=
Date:   Sun, 23 Jan 2022 15:59:01 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, geert@linux-m68k.org, hch@lst.de,
        hughd@google.com, jgross@suse.com, Konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com, willy@infradead.org
Subject:  [merged] mm-hide-the-frontswap-kconfig-symbol.patch
 removed from -mm tree
Message-ID: <20220123235901.phPZryqDe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hide the FRONTSWAP Kconfig symbol
has been removed from the -mm tree.  Its filename was
     mm-hide-the-frontswap-kconfig-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: hide the FRONTSWAP Kconfig symbol

Select FRONTSWAP from ZSWAP instead of prompting for it.

Link: https://lkml.kernel.org/r/20211224062246.1258487-14-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/mm/Kconfig~mm-hide-the-frontswap-kconfig-symbol
+++ a/mm/Kconfig
@@ -445,20 +445,7 @@ config HAVE_SETUP_PER_CPU_AREA
 	bool
 
 config FRONTSWAP
-	bool "Enable frontswap to cache swap pages if tmem is present"
-	depends on SWAP
-	help
-	  Frontswap is so named because it can be thought of as the opposite
-	  of a "backing" store for a swap device.  The data is stored into
-	  "transcendent memory", memory that is not directly accessible or
-	  addressable by the kernel and is of unknown and possibly
-	  time-varying size.  When space in transcendent memory is available,
-	  a significant swap I/O reduction may be achieved.  When none is
-	  available, all frontswap calls are reduced to a single pointer-
-	  compare-against-NULL resulting in a negligible performance hit
-	  and swap data is stored as normal on the matching swap device.
-
-	  If unsure, say Y to enable frontswap.
+	bool
 
 config CMA
 	bool "Contiguous Memory Allocator"
@@ -523,7 +510,8 @@ config MEM_SOFT_DIRTY
 
 config ZSWAP
 	bool "Compressed cache for swap pages (EXPERIMENTAL)"
-	depends on FRONTSWAP && CRYPTO=y
+	depends on SWAP && CRYPTO=y
+	select FRONTSWAP
 	select ZPOOL
 	help
 	  A lightweight compressed cache for swap pages.  It takes
_

Patches currently in -mm which might be from hch@lst.de are


