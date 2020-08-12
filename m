Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD07DC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94820206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196016;
	bh=CG/U2p3T2OwqzNlDzXg0/ZXdyc0IFk29QMduACtniwQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ey/hiqefqs6afSyAKzT23SuDPNwlgi/sxDLjUNXo0OfaUxyfjoqb000NXAbdTNSWp
	 Ihyik+i5iU1DqASyd0Pvmbi1lD4OvqzcxNedSkl4ymfDPsmtRHhVrz4+Tmt36wRk/V
	 V8RWm1sh5KbcOPH7izz7Zbc8LbfQxNxUEopb9Amc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHLBdg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHLBdg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36AD82076C;
        Wed, 12 Aug 2020 01:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196015;
        bh=CG/U2p3T2OwqzNlDzXg0/ZXdyc0IFk29QMduACtniwQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZsMRZfU7RrB8I/A3oJKjxZLq3zSLh0XbCH9Z7tfcUStoDeFIiHqkZjrOUYJAiQbP+
         IfbqewCkqy6ZlfDNdLTOi5BRkKnZUI26n+YjcPV4FsTABWf1ldDScmVpH9GsFNbxXi
         OErz+PlIw/NCSytRBvvEdcuSYPTtgTke+fGsx7iw=
Date:   Tue, 11 Aug 2020 18:33:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deanbo422@gmail.com,
        geert@linux-m68k.org, green.hu@gmail.com, hch@lst.de,
        linux-mm@kvack.org, linux@roeck-us.net, mm-commits@vger.kernel.org,
        nickhu@andestech.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  [patch 063/165] syscalls: use uaccess_kernel in
 addr_limit_user_check
Message-ID: <20200812013334.txdfnVKD7%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: syscalls: use uaccess_kernel in addr_limit_user_check

Patch series "clean up address limit helpers", v2.

In preparation for eventually phasing out direct use of set_fs(), this
series removes the segment_eq() arch helper that is only used to implement
or duplicate the uaccess_kernel() API, and then adds descriptive helpers
to force the kernel address limit.


This patch (of 6):

Use the uaccess_kernel helper instead of duplicating it.

[hch@lst.de: arm: don't call addr_limit_user_check for nommu]
  Link: http://lkml.kernel.org/r/20200721045834.GA9613@lst.de
Link: http://lkml.kernel.org/r/20200714105505.935079-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200710135706.537715-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200710135706.537715-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/signal.c |    2 ++
 include/linux/syscalls.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/signal.c~syscalls-use-uaccess_kernel-in-addr_limit_user_check
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
--- a/include/linux/syscalls.h~syscalls-use-uaccess_kernel-in-addr_limit_user_check
+++ a/include/linux/syscalls.h
@@ -263,7 +263,7 @@ static inline void addr_limit_user_check
 		return;
 #endif
 
-	if (CHECK_DATA_CORRUPTION(!segment_eq(get_fs(), USER_DS),
+	if (CHECK_DATA_CORRUPTION(uaccess_kernel(),
 				  "Invalid address limit on user-mode return"))
 		force_sig(SIGKILL);
 
_
