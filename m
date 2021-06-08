Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3057C47094
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA63A61260
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhFHA2v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhFHA2u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:28:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82BD261246;
        Tue,  8 Jun 2021 00:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112016;
        bh=TqOC/uPiw6eYbcADd0ZS/R6lMZdspK5AFmH+tqaPROo=;
        h=Date:From:To:Subject:From;
        b=FkdLF6CaOxNrRFG/3twd11a8ytYU2Q4690+lc/4PhRtmLlIjq35ThtwAQPl/qW7f2
         f/cXXJ4uhqOFBvza0QW987SS5pAIq/SIQ1zsLK7pkAEjmQkOBKwkf2wFgq1iqsgxQK
         XfdxJTfoyVt65sL4ym6e73SmXSwkJkgkifGXqS10=
Date:   Mon, 07 Jun 2021 17:26:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        ysato@users.sourceforge.jp
Subject:  [failures] h8300-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210608002656.gzCY8Il1d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     h8300-convert-to-setup_initial_init_mm.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: h8300: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210604070633.32363-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/h8300/kernel/setup.c~h8300-convert-to-setup_initial_init_mm
+++ a/arch/h8300/kernel/setup.c
@@ -95,10 +95,7 @@ void __init setup_arch(char **cmdline_p)
 {
 	unflatten_and_copy_device_tree();
 
-	init_mm.start_code = (unsigned long) _stext;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = (unsigned long) 0;
+	setup_initial_init_mm(_stext, _etext, _edata, NULL);
 
 	pr_notice("\r\n\nuClinux " CPU "\n");
 	pr_notice("Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne\n");
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
m68k-convert-to-setup_initial_init_mm.patch
nds32-convert-to-setup_initial_init_mm.patch
nios2-convert-to-setup_initial_init_mm.patch
openrisc-convert-to-setup_initial_init_mm.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

