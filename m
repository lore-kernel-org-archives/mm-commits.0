Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2870EC48BE6
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B629613F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhFKALf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhFKALf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 20:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF9516141F;
        Fri, 11 Jun 2021 00:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623370164;
        bh=LjqQYNjbYpxn/Bx2gc3HUh2k00Gg/Tf8xrJUOblZGXU=;
        h=Date:From:To:Subject:From;
        b=a+dmG5cXats30zOXU/lHZu9VEg7rbI1uRaoHoUE5/OJnQwEYd9u5RHG25mJ6NIL3y
         CYPCWpVQTujg3MzlftakoqgA2JQxmkezHYa+EABUPA6oOihicV87X2jqpi38OPYO5E
         bwV8ys6hB/2UH2cSVTFgdnhlRVHaZ4kWRXCPICuY=
Date:   Thu, 10 Jun 2021 17:09:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        ysato@users.sourceforge.jp
Subject:  + h8300-convert-to-setup_initial_init_mm.patch added to
 -mm tree
Message-ID: <20210611000924.m0AEyoxrB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: convert to setup_initial_init_mm()
has been added to the -mm tree.  Its filename is
     h8300-convert-to-setup_initial_init_mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/h8300-convert-to-setup_initial_init_mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/h8300-convert-to-setup_initial_init_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: h8300: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-7-wangkefeng.wang@huawei.com
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
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch
mm-add-setup_initial_init_mm-helper.patch
arc-convert-to-setup_initial_init_mm.patch
arm-convert-to-setup_initial_init_mm.patch
arm64-convert-to-setup_initial_init_mm.patch
csky-convert-to-setup_initial_init_mm.patch
h8300-convert-to-setup_initial_init_mm.patch
m68k-convert-to-setup_initial_init_mm.patch
nds32-convert-to-setup_initial_init_mm.patch
nios2-convert-to-setup_initial_init_mm.patch
openrisc-convert-to-setup_initial_init_mm.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch

