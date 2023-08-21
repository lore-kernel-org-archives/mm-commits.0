Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2295EE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjHUUmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjHUUlD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194CC139
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFBCF6069B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534B3C433C9;
        Mon, 21 Aug 2023 20:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650443;
        bh=pZBII9ced4HTcCLxURKG1sZH+9Hpkgli+JjGid8TNJ0=;
        h=Date:To:From:Subject:From;
        b=BuI9CUifNxQflAL2qTysAVReUTdNa4JMR3kKWtfBv8lQOnPCA1Eu3V2yTqqolDaP0
         az7ukuJXHKjuTOvVJjki/eY6MJ99z+WNv5KIYlTp3MXNqXym6/ezmCgLtlu4Hh41Tm
         7RUqGzJW0nQU2LFrqhhlc7rdXqTf2tLFhAyBPmOs=
Date:   Mon, 21 Aug 2023 13:40:42 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch removed from -mm tree
Message-Id: <20230821204043.534B3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init: use helper macro BITS_PER_LONG and BITS_PER_BYTE
has been removed from the -mm tree.  Its filename was
     mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mm_init: use helper macro BITS_PER_LONG and BITS_PER_BYTE
Date: Mon, 7 Aug 2023 10:35:28 +0800

It's more readable to use helper macro BITS_PER_LONG and BITS_PER_BYTE. 
No functional change intended.

Link: https://lkml.kernel.org/r/20230807023528.325191-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte
+++ a/mm/mm_init.c
@@ -79,7 +79,7 @@ void __init mminit_verify_pageflags_layo
 	int shift, width;
 	unsigned long or_mask, add_mask;
 
-	shift = 8 * sizeof(unsigned long);
+	shift = BITS_PER_LONG;
 	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH
 		- LAST_CPUPID_SHIFT - KASAN_TAG_WIDTH - LRU_GEN_WIDTH - LRU_REFS_WIDTH;
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
@@ -1426,9 +1426,9 @@ static unsigned long __init usemap_size(
 	usemapsize = roundup(zonesize, pageblock_nr_pages);
 	usemapsize = usemapsize >> pageblock_order;
 	usemapsize *= NR_PAGEBLOCK_BITS;
-	usemapsize = roundup(usemapsize, 8 * sizeof(unsigned long));
+	usemapsize = roundup(usemapsize, BITS_PER_LONG);
 
-	return usemapsize / 8;
+	return usemapsize / BITS_PER_BYTE;
 }
 
 static void __ref setup_usemap(struct zone *zone)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

