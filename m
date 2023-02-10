Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D17C636D6
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjBJA5K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjBJAz0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1346F8DB
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2950B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4C3C433EF;
        Fri, 10 Feb 2023 00:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990464;
        bh=Lzq33y8cNbMvbZnZ0X8HVewrsp4qQq9zETX7Msam9MI=;
        h=Date:To:From:Subject:From;
        b=xWjdJYK3jRIPCXbxt8iiMwXIyz5KmYT4DssABN1Jxz6zhddOQ35oO3Rw4LD5vPQpu
         Cxlj1GYN7Fcgo0KbDaKvLArQ12HHhkgm4K6pnzrQS4DTWRoinYGnFfpCHO0+b7aOvu
         de3i6zvNs5EI5gaHcnamQKVd5NHfXdt1GH+RPwMo=
Date:   Thu, 09 Feb 2023 16:54:24 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch removed from -mm tree
Message-Id: <20230210005424.AC4C3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: mm: add VM_IOREMAP flag to the vmalloc area
has been removed from the -mm tree.  Its filename was
     powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: powerpc: mm: add VM_IOREMAP flag to the vmalloc area
Date: Mon, 6 Feb 2023 16:40:19 +0800

Currently, for vmalloc areas with flag VM_IOREMAP set, except of the
specific alignment clamping in __get_vm_area_node(), they will be

 1) Shown as ioremap in /proc/vmallocinfo;

 2) Ignored by /proc/kcore reading via vread()

So for the io mapping in ioremap_phb() of ppc, we should set VM_IOREMAP in
flag to make it handled correctly as above.

Link: https://lkml.kernel.org/r/20230206084020.174506-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/pci_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/pci_64.c~powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area
+++ a/arch/powerpc/kernel/pci_64.c
@@ -132,7 +132,7 @@ void __iomem *ioremap_phb(phys_addr_t pa
 	 * address decoding but I'd rather not deal with those outside of the
 	 * reserved 64K legacy region.
 	 */
-	area = __get_vm_area_caller(size, 0, PHB_IO_BASE, PHB_IO_END,
+	area = __get_vm_area_caller(size, VM_IOREMAP, PHB_IO_BASE, PHB_IO_END,
 				    __builtin_return_address(0));
 	if (!area)
 		return NULL;
_

Patches currently in -mm which might be from bhe@redhat.com are


