Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1103C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FD64206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194177;
	bh=B1fhprcF/oVb8n8gPm9sYMpl3GqzW5Sl1EAA8GuUJME=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0uq+JQS2I9DRjmBfttvHJGxClnDquwQGzuGPzhlHKKxT5N+/TuZ1f+HpZtKBo48i0
	 WmfHHVtPd5DoHN9oqGX6ed2Ks5q6VBXvmfqjcvMkfOTt/5a8HMmFLoHcesOKd2MCp1
	 0UUgI4jBjSCYdyBGOZYNtS1j1X+Qt3uBS2fk4Yrc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgHLBC5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgHLBC5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:02:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44EBC206B5;
        Wed, 12 Aug 2020 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194176;
        bh=B1fhprcF/oVb8n8gPm9sYMpl3GqzW5Sl1EAA8GuUJME=;
        h=Date:From:To:Subject:From;
        b=qn9aW0HgHXuei/Q4u1Lwz3t9VEOPCo2ushf6vP2nvlx/OBxht1vppaS7GkF3p3wJq
         +27nyTh0y/+khHXtTRvI4RHAS9IqLrmd7s7jeQrOlSUVJju8DU7w4c2HCCWOwCL3dq
         Iib86zr6KsB/ygZ9busWqUSziWtVQrm11QUeRi6Y=
Date:   Tue, 11 Aug 2020 18:02:55 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, linux@roeck-us.net, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix.patch removed from
 -mm tree
Message-ID: <20200812010255.eEG3eUFEG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: don't call addr_limit_user_check for nommu
has been removed from the -mm tree.  Its filename was
     syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix.patch

This patch was dropped because it was folded into syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: arm: don't call addr_limit_user_check for nommu

On arm nommu kernel use the same constant for USER_DS and KERNEL_DS, and
seqment_eq always returns false.  With the current check in
addr_limit_user_check that works by accident, but when replacing
seqment_eq with uaccess_kerne it will fail.  Just remove the not needed
check entirely.

Link: http://lkml.kernel.org/r/20200721045834.GA9613@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/kernel/signal.c~syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix
+++ a/arch/arm/kernel/signal.c
@@ -713,7 +713,9 @@ struct page *get_signal_page(void)
 /* Defer to generic check */
 asmlinkage void addr_limit_check_failed(void)
 {
+#ifdef CONFIG_MMU
 	addr_limit_user_check();
+#endif
 }
 
 #ifdef CONFIG_DEBUG_RSEQ
_

Patches currently in -mm which might be from hch@lst.de are

syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
uaccess-add-force_uaccess_beginend-helpers-v2.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch
kernel-add-a-kernel_wait-helper.patch

