Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14082C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5C72077D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594417661;
	bh=VNN7aFzSF++YM9APYD/k0KKIqNabdiWCfx20I/jL9Yg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jLAwDlwKrOH5HGLOxrynzydGKo+u1v4evD0GhvtItedD0HioAlqULdujytQyfVUb3
	 kpFubHVQkXluWlgRuSSKFRkqugdEg1zUfUzUqGnL6X89OyQo1JbmXP8Nxga5YbW1re
	 OZDgHEZW24ZpFsdDcluY2u4mzSyJgCqT4wjEUh0k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgGJVrl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgGJVrl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:47:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D96E62075D;
        Fri, 10 Jul 2020 21:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594417661;
        bh=VNN7aFzSF++YM9APYD/k0KKIqNabdiWCfx20I/jL9Yg=;
        h=Date:From:To:Subject:From;
        b=oSWAc6cwkyi0cxAZJfH/bYhfFVjxCF1cZ98r0Ne82Cxm4cewZ3Kj/JM1s67NuxvKA
         VfUiZ1TsXK4Ee5ugCksU3gwJBPZ8/YvtAJccNLRFs57B43aAN6Sa47bu1Jw6GDC4vS
         Lx/k5G15PEsuVRYKOW7oUQxbLgs/p4E0HvwufIMs=
Date:   Fri, 10 Jul 2020 14:47:40 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com, hch@lst.de,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  + nds32-use-uaccess_kernel-in-show_regs.patch added to
 -mm tree
Message-ID: <20200710214740.JYnLdIa5A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: use uaccess_kernel in show_regs
has been added to the -mm tree.  Its filename is
     nds32-use-uaccess_kernel-in-show_regs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nds32-use-uaccess_kernel-in-show_regs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nds32-use-uaccess_kernel-in-show_regs.patch

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
Subject: nds32: use uaccess_kernel in show_regs

Use the uaccess_kernel helper instead of duplicating it.

Link: http://lkml.kernel.org/r/20200710135706.537715-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
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

syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch

