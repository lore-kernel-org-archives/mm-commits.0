Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC336EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjHUUIT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjHUUIN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:08:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34631DF;
        Mon, 21 Aug 2023 13:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14943649ED;
        Mon, 21 Aug 2023 20:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDFDC433CB;
        Mon, 21 Aug 2023 20:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692648490;
        bh=GUMi4IVP5qz7tAVxeR5rxU+5/wC9QGykAubKPk3z9fk=;
        h=Date:To:From:Subject:From;
        b=i2dWwnTnrgcoGLhzGxNruUTw0dXUIKV2To5vE1edv51Q9pdbCtg2aA5ZtooWmdZAf
         jthqnS5B5dKc9p884v9shOu3uX/GE7LWJKKF7CeeZ9axV08ergWvl+L4o7hTane+jR
         XT5z8ZolBA/Ar4UdcnW9+bjV4ELpJIQVyODWK420=
Date:   Mon, 21 Aug 2023 13:08:09 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        palmer@rivosinc.com, hch@lst.de, dylan@andestech.com,
        alexghiti@rivosinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn.patch removed from -mm tree
Message-Id: <20230821200810.6BDFDC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add a call to flush_cache_vmap() in vmap_pfn()
has been removed from the -mm tree.  Its filename was
     mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: mm: add a call to flush_cache_vmap() in vmap_pfn()
Date: Wed, 9 Aug 2023 18:46:33 +0200

flush_cache_vmap() must be called after new vmalloc mappings are installed
in the page table in order to allow architectures to make sure the new
mapping is visible.

It could lead to a panic since on some architectures (like powerpc),
the page table walker could see the wrong pte value and trigger a
spurious page fault that can not be resolved (see commit f1cb8f9beba8
("powerpc/64s/radix: avoid ptesync after set_pte and
ptep_set_access_flags")).

But actually the patch is aiming at riscv: the riscv specification
allows the caching of invalid entries in the TLB, and since we recently
removed the vmalloc page fault handling, we now need to emit a tlb
shootdown whenever a new vmalloc mapping is emitted
(https://lore.kernel.org/linux-riscv/20230725132246.817726-1-alexghiti@rivosinc.com/).
That's a temporary solution, there are ways to avoid that :)

Link: https://lkml.kernel.org/r/20230809164633.1556126-1-alexghiti@rivosinc.com
Fixes: 3e9a9e256b1e ("mm: add a vmap_pfn function")
Reported-by: Dylan Jhong <dylan@andestech.com>
Closes: https://lore.kernel.org/linux-riscv/ZMytNY2J8iyjbPPy@atctrx.andestech.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Dylan Jhong <dylan@andestech.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/vmalloc.c~mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn
+++ a/mm/vmalloc.c
@@ -2979,6 +2979,10 @@ void *vmap_pfn(unsigned long *pfns, unsi
 		free_vm_area(area);
 		return NULL;
 	}
+
+	flush_cache_vmap((unsigned long)area->addr,
+			 (unsigned long)area->addr + count * PAGE_SIZE);
+
 	return area->addr;
 }
 EXPORT_SYMBOL_GPL(vmap_pfn);
_

Patches currently in -mm which might be from alexghiti@rivosinc.com are


