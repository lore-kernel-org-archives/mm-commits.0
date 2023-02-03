Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD561C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjBCF34 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjBCF3r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:29:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1762201A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6563D61D0D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD55C433EF;
        Fri,  3 Feb 2023 05:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402183;
        bh=4+Q9pvLXb0UhdbnDNaCeasm+bjKte9M+db7cE2ScT58=;
        h=Date:To:From:Subject:From;
        b=GUW4u1clhLfSWetzYbaWmOrvzYu0OkmqAxEIugdFFcjfvb9wwVK5dqlbyypNeAHpd
         M+aQr4Ax0Nm5C+qXAK/sUZ1t6zNAgaj0Fx6gfpylk9SMAZqFoGg1+qHn/3a4n1kpyS
         wNNk0+KQujN+nY5258ZW9OMyOtt0g65maA45OpY4=
Date:   Thu, 02 Feb 2023 21:29:43 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch removed from -mm tree
Message-Id: <20230203052943.ADD55C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: skip the uninitilized vmalloc areas
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: skip the uninitilized vmalloc areas
Date: Fri, 13 Jan 2023 11:19:19 +0800

For areas allocated via vmalloc_xxx() APIs, it searches for unmapped area
to reserve and allocates new pages to map into, please see function
__vmalloc_node_range().  During the process, flag VM_UNINITIALIZED is set
in vm->flags to indicate that the pages allocation and mapping haven't
been done, until clear_vm_uninitialized_flag() is called to clear it.

For this kind of area, if VM_UNINITIALIZED is still set, let's ignore it
in vread() because pages newly allocated and being mapped in that area
only contains zero data.  reading them out by aligned_vread() is wasting
time.

Link: https://lkml.kernel.org/r/20230113031921.64716-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-skip-the-uninitilized-vmalloc-areas
+++ a/mm/vmalloc.c
@@ -3660,6 +3660,11 @@ long vread(char *buf, char *addr, unsign
 		if (!vm && !flags)
 			continue;
 
+		if (vm && (vm->flags & VM_UNINITIALIZED))
+			continue;
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+
 		vaddr = (char *) va->va_start;
 		size = vm ? get_vm_area_size(vm) : va_size(va);
 
_

Patches currently in -mm which might be from bhe@redhat.com are

powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

