Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EC1C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A1B86105A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFHA3R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhFHA3O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CFC16124B;
        Tue,  8 Jun 2021 00:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112030;
        bh=n3VKUl4Q9XHbLVcKmC44BYnI1zulfAHbbmpo+/QZ9cY=;
        h=Date:From:To:Subject:From;
        b=pWEF5g9LLVqS0T9uJ7AIBRDjnMKZh0T4h5c6TRM+KGUeELRhQ5ESEv+hXZiHpRes1
         Q/Y47gGiZaXLu2TROCJYcwMAfdO/AU6uuAo2ccBrAKiPJh4poMbWwyTo6WbNCPKmnp
         lFJb41gxiv4xa7+R2bGptmOKBEGy0JuNb2icyaJc=
Date:   Mon, 07 Jun 2021 17:27:10 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  [failures] s390-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210608002710.sBNfZxjkF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     s390-convert-to-setup_initial_init_mm.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: s390: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210604070633.32363-14-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/s390/kernel/setup.c~s390-convert-to-setup_initial_init_mm
+++ a/arch/s390/kernel/setup.c
@@ -1119,10 +1119,7 @@ void __init setup_arch(char **cmdline_p)
 
         ROOT_DEV = Root_RAM0;
 
-	init_mm.start_code = (unsigned long) _text;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = (unsigned long) _end;
+	setup_initial_init_mm(_text, _etext, _edata, _end);
 
 	if (IS_ENABLED(CONFIG_EXPOLINE_AUTO))
 		nospec_auto_detect();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

