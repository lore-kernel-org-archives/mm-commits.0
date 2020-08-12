Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65CDC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85612207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266200;
	bh=8vLQNDQjMPO7OI441n1CnNImQFp/5hKd7ztltBBV1a8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=eVuk2/ROgTRN2lvgnTSkpQjhWo86FL0MybQd2PvD4rZa8YayrpjoNMWyD4UU+B7RM
	 +nDvREMOLqQtgXTzmZnUye7TsMfEN+CW0hMgVbJik26ca9SGZluX7kMOxe1dx9BKEi
	 ZvoEEIDEKpnJPLPHUrjQwODd+ilJEfHkta0RDcuE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgHLVDU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65F0B2078B;
        Wed, 12 Aug 2020 21:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266199;
        bh=8vLQNDQjMPO7OI441n1CnNImQFp/5hKd7ztltBBV1a8=;
        h=Date:From:To:Subject:From;
        b=Tw21RKNPbi1e65JJ4mcMGzvdNF43CGgLyy2I970+fd+XwHuq4f0f1khWqfGdCwZo3
         VFIymGiKzpcBBvYphIs5ZOv7ERnvLcBlHvx1edG0+bln6JdAEsjPDAZMnNQ1uNdmQS
         r8TzA+vKglKSpKgUSbtljAV/2iNzt5cBmFvVNOAc=
Date:   Wed, 12 Aug 2020 14:03:19 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, geert@linux-m68k.org, green.hu@gmail.com,
        hch@lst.de, mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  [merged] nds32-use-uaccess_kernel-in-show_regs.patch
 removed from -mm tree
Message-ID: <20200812210319.z1RIfCTMM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: use uaccess_kernel in show_regs
has been removed from the -mm tree.  Its filename was
     nds32-use-uaccess_kernel-in-show_regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: nds32: use uaccess_kernel in show_regs

Use the uaccess_kernel helper instead of duplicating it.

Link: http://lkml.kernel.org/r/20200710135706.537715-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Greentime Hu <green.hu@gmail.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nds32/kernel/process.c~nds32-use-uaccess_kernel-in-show_regs
+++ a/arch/nds32/kernel/process.c
@@ -121,7 +121,7 @@ void show_regs(struct pt_regs *regs)
 		regs->uregs[3], regs->uregs[2], regs->uregs[1], regs->uregs[0]);
 	pr_info("  IRQs o%s  Segment %s\n",
 		interrupts_enabled(regs) ? "n" : "ff",
-		segment_eq(get_fs(), KERNEL_DS)? "kernel" : "user");
+		uaccess_kernel() ? "kernel" : "user");
 }
 
 EXPORT_SYMBOL(show_regs);
_

Patches currently in -mm which might be from hch@lst.de are


