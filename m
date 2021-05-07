Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B0EC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CAA613B9
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhEGBFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233978AbhEGBFf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51446610FA;
        Fri,  7 May 2021 01:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349476;
        bh=1NoE4aWUG2IAkLD23KS3EuKvqhqphLy8gpQFtMmSOjc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JnXEotvzq/eiG5Df451lT+UqjlUznNETVw2KsxPlY3CnQe4Nso25pBotxn5YeoirA
         nY6ufIaGlqThjPkVnXpmqANMoBvHGbdQ4UEBIprKFDHFTE4Hb01qHQ8CeXHVhpgVAK
         ebcXNVMRJm/g4huZYEoj/oZIFjzqWFZre5vXpOug=
Date:   Thu, 06 May 2021 18:04:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, jolevequ@microsoft.com,
        lguohan@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        pmenzel@molgen.mpg.de, torvalds@linux-foundation.org
Subject:  [patch 49/91] kexec: add kexec reboot string
Message-ID: <20210507010435.nxkpJ8Xsl%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe LeVeque <jolevequ@microsoft.com>
Subject: kexec: Add kexec reboot string

The purpose is to notify the kernel module for fast reboot.

Upstream a patch from the SONiC network operating system [1].

[1]: https://github.com/Azure/sonic-linux-kernel/pull/46

Link: https://lkml.kernel.org/r/20210304124626.13927-1-pmenzel@molgen.mpg.de
Signed-off-by: Joe LeVeque <jolevequ@microsoft.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Guohan Lu <lguohan@gmail.com>
Cc: Joe LeVeque <jolevequ@microsoft.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_core.c~kexec-add-kexec-reboot-string
+++ a/kernel/kexec_core.c
@@ -1165,7 +1165,7 @@ int kernel_kexec(void)
 #endif
 	{
 		kexec_in_progress = true;
-		kernel_restart_prepare(NULL);
+		kernel_restart_prepare("kexec reboot");
 		migrate_to_reboot_cpu();
 
 		/*
_
