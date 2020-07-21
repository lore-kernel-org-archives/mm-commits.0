Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4F5C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 22:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B48A20771
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 22:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595371212;
	bh=DVox5rkH76fqUqmRfZGRlJhKpm9fMpVIqmOJRl6Daag=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zXhxlXv6GoVKGHlXCt5uxZ+qUjhVO6x8tzYUy2WLGONLCHrnxpT9NBJN1sNSQrHmG
	 oo4rsUUIiuc9E0z/Vi81JPbQtv/PbSrLY5CeWZEE7KAE34sZhUPIckFAlqVmI7j4h8
	 qqixCo+16dWt4LJJ0a8b0SLl0R/4dA5SwXdFLxk4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGUWkL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jul 2020 18:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgGUWkL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jul 2020 18:40:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B280A2073A;
        Tue, 21 Jul 2020 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595371210;
        bh=DVox5rkH76fqUqmRfZGRlJhKpm9fMpVIqmOJRl6Daag=;
        h=Date:From:To:Subject:From;
        b=tKpx7VxD0NalYoh+FiG6DF/LhHDWtJXB+z8rlb88Ygc7sc6gQAUx/elHBCOmm6h+D
         vlSgQKiUW/Y9d7j6j0z3oSclIbdFdFERJIvTUlmBdeCjZa+iZ3whuU5qWDoXIzxlVe
         UbwBqjD7GmJLAd/B58wWvPOTVqP2SN3E4DMJaT0I=
Date:   Tue, 21 Jul 2020 15:40:10 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, linux@roeck-us.net, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix.patch added to -mm
 tree
Message-ID: <20200721224010.2FOnOz5Fx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: don't call addr_limit_user_check for nommu
has been added to the -mm tree.  Its filename is
     syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix.patch

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
syscalls-use-uaccess_kernel-in-addr_limit_user_check-fix.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
uaccess-add-force_uaccess_beginend-helpers-v2.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch
kernel-add-a-kernel_wait-helper.patch

