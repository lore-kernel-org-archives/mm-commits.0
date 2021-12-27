Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27338C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhL0AIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60230 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbhL0AIn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F620B80E6B
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6610C36AE8;
        Mon, 27 Dec 2021 00:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563721;
        bh=pw2uZTH9lBxjFZscRXxp59phZcmMmrMRG1+vbuGC56E=;
        h=Date:From:To:Subject:From;
        b=HDH7xGzzlB2pxAYuryRU5JE7+5hWrj+gAZXI0Q6dKOfOAzJfc11z+8MXceR6JSVU1
         zJiKhP1UJX9t5nZ5mF+V0vIGSFuGAdQDkohVVTSIXVXWgu59JF8sJE6o/OPZyl+wip
         /PVUYr5F1Uf5ko8nnyKC8aYPxBFgBLGwrQvxVrps=
Date:   Sun, 26 Dec 2021 16:08:40 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + mm-hide-the-frontswap-kconfig-symbol.patch added to -mm
 tree
Message-ID: <20211227000840.ahe6G%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hide the FRONTSWAP Kconfig symbol
has been added to the -mm tree.  Its filename is
     mm-hide-the-frontswap-kconfig-symbol.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hide-the-frontswap-kconfig-symbol.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hide-the-frontswap-kconfig-symbol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-cleancache.patch
frontswap-remove-frontswap_writethrough.patch
frontswap-remove-frontswap_tmem_exclusive_gets.patch
frontswap-remove-frontswap_shrink.patch
frontswap-remove-frontswap_curr_pages.patch
frontswap-simplify-frontswap_init.patch
frontswap-remove-the-frontswap-exports.patch
mm-simplify-try_to_unuse.patch
frontswap-remove-frontswap_test.patch
frontswap-simplify-frontswap_register_ops.patch
mm-mark-swap_lock-and-swap_active_head-static.patch
frontswap-remove-support-for-multiple-ops.patch
mm-hide-the-frontswap-kconfig-symbol.patch

