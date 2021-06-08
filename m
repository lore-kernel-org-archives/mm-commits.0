Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3898C4743F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA71560FDA
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhFHA3R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhFHA3Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E1F6105A;
        Tue,  8 Jun 2021 00:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112034;
        bh=pmHIcDoe02lkDuh2pNQWFjRFh6VVhqWjPM/C3d55MsM=;
        h=Date:From:To:Subject:From;
        b=FaProWRabSaQ8nYmNkgE8UXngEdkHxL4zEMwl5iqqZcC4Foxo8+cY9IW5ryxHvW5w
         6IaLdwTvx/jDRUTcq0x8cHzZs8Rld9OInxFpEpEzTQNxhdDDudPTXvhJVESp89bM/y
         aRW51JONHbdJMWqDx/9K07E0yrkwJ3a7mS8Bnr5w=
Date:   Mon, 07 Jun 2021 17:27:14 -0700
From:   akpm@linux-foundation.org
To:     mingo@redhat.com, mm-commits@vger.kernel.org, tglx@linutronix.de,
        wangkefeng.wang@huawei.com
Subject:  [failures] x86-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210608002714.hvya6t5K8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     x86-convert-to-setup_initial_init_mm.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: x86: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210604070633.32363-16-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/x86/kernel/setup.c~x86-convert-to-setup_initial_init_mm
+++ a/arch/x86/kernel/setup.c
@@ -868,10 +868,7 @@ void __init setup_arch(char **cmdline_p)
 
 	if (!boot_params.hdr.root_flags)
 		root_mountflags &= ~MS_RDONLY;
-	init_mm.start_code = (unsigned long) _text;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = _brk_end;
+	setup_initial_init_mm(_text, _etext, _edata, _brk_end);
 
 	code_resource.start = __pa_symbol(_text);
 	code_resource.end = __pa_symbol(_etext)-1;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

