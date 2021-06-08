Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62744C47094
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45F9A61246
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhFHA25 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhFHA24 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:28:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C21F6105A;
        Tue,  8 Jun 2021 00:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112024;
        bh=7xgNNp9BecwTeQ77WItN6t91V/xMG1PnhjDm0Hpvca8=;
        h=Date:From:To:Subject:From;
        b=1FVQ0ikweGSmEasK+PP2LZt0DOV7v++p5++xSqGW8IG5V6Q/8Q7vWPJ1bnxbDTpcg
         QJnqKYPJpFJ7Ke+6Tt48SD8pOCid4cFZ1ZKrsWRKAeBi7XP11GPloRnNncopR9HnNf
         sBSGXMr2gYfmOHfZ3UKRw2puNqpEE4dckMFKHeT8=
Date:   Mon, 07 Jun 2021 17:27:04 -0700
From:   akpm@linux-foundation.org
To:     jonas@southpole.se, mm-commits@vger.kernel.org, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, wangkefeng.wang@huawei.com
Subject:  [failures]
 openrisc-convert-to-setup_initial_init_mm.patch removed from -mm tree
Message-ID: <20210608002704.U30Z3L-Nn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     openrisc-convert-to-setup_initial_init_mm.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: openrisc: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210604070633.32363-11-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Stafford Horne <shorne@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/openrisc/kernel/setup.c~openrisc-convert-to-setup_initial_init_mm
+++ a/arch/openrisc/kernel/setup.c
@@ -293,10 +293,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	/* process 1's initial memory region is the kernel code/data */
-	init_mm.start_code = (unsigned long)_stext;
-	init_mm.end_code = (unsigned long)_etext;
-	init_mm.end_data = (unsigned long)_edata;
-	init_mm.brk = (unsigned long)_end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start == initrd_end) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

