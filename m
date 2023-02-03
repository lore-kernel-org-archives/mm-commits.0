Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAA8C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjBCF34 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjBCF3t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:29:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAFE2201A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CCCBB827B1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B0BC4339B;
        Fri,  3 Feb 2023 05:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402185;
        bh=BnbW3UG8owFjP/qT+FVOUmgmWSFr6/FjK7agDDTrBaU=;
        h=Date:To:From:Subject:From;
        b=ib7M03D4sy4IUM0Mk2JttTmpqfc3pLUt/uSIpnlOj/x1jZgs6es4gIGhax/Mbt/yD
         WOu46izf8JX1Bbd8bE3j2n33pdbs6tCB7YzDZGVqakEhudigvs6xG8zvopCuwmZCqV
         kKlSsYto6d6mrsrWZF1sca1NSgtskwcDG5e52kvY=
Date:   Thu, 02 Feb 2023 21:29:45 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch removed from -mm tree
Message-Id: <20230203052945.C5B0BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: mm: set VM_IOREMAP flag to the vmalloc area
has been removed from the -mm tree.  Its filename was
     sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: sh: mm: set VM_IOREMAP flag to the vmalloc area
Date: Fri, 13 Jan 2023 11:19:21 +0800

Currently, for vmalloc areas with flag VM_IOREMAP set, except of the
specific alignment clamping in __get_vm_area_node(), they will be

1) Shown as ioremap in /proc/vmallocinfo;
2) Ignored by /proc/kcore reading via vread()

So for the ioremap in __sq_remap() of sh, we should set VM_IOREMAP
in flag to make it handled correctly as above.

Link: https://lkml.kernel.org/r/20230113031921.64716-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/sh/kernel/cpu/sh4/sq.c~sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area
+++ a/arch/sh/kernel/cpu/sh4/sq.c
@@ -103,7 +103,7 @@ static int __sq_remap(struct sq_mapping
 #if defined(CONFIG_MMU)
 	struct vm_struct *vma;
 
-	vma = __get_vm_area_caller(map->size, VM_ALLOC, map->sq_addr,
+	vma = __get_vm_area_caller(map->size, VM_IOREMAP, map->sq_addr,
 			SQ_ADDRMAX, __builtin_return_address(0));
 	if (!vma)
 		return -ENOMEM;
_

Patches currently in -mm which might be from bhe@redhat.com are


