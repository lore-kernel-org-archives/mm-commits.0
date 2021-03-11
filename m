Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207E4C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 05:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC17E64FC9
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 05:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhCKFdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 00:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhCKFdD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 00:33:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5DFE64FC9;
        Thu, 11 Mar 2021 05:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615440783;
        bh=H85zq/oxYYpuwpebMl2OAGxPglME67MxiH4YCP9jl3k=;
        h=Date:From:To:Subject:From;
        b=jB7j4KKwoMfpJ1lQ0sP6cDEZFkjC+1M9/LpS6I9TXV7drkHKdXeAwZsQbTM/xU/fx
         GREXp3pzU75uFqGBiauoD35bkgN74NRlcuBn3jFEPl1x8uO2BEUsRdhP4dF1scnXLr
         e6+ssbT1eyOWuxTp3UpthCxk2S4+rQ/IXo7ZE6io=
Date:   Wed, 10 Mar 2021 21:33:02 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, jolevequ@microsoft.com, lguohan@gmail.com,
        mm-commits@vger.kernel.org, pmenzel@molgen.mpg.de
Subject:  + kexec-add-kexec-reboot-string.patch added to -mm tree
Message-ID: <20210311053302.KZzCfdbE2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: Add kexec reboot string
has been added to the -mm tree.  Its filename is
     kexec-add-kexec-reboot-string.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kexec-add-kexec-reboot-string.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-kexec-reboot-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe LeVeque <jolevequ@microsoft.com>
Subject: kexec: Add kexec reboot string

The purpose is to notify the kernel module for fast reboot.

Upstream a patch from the SONiC network operating system [1].

[1]: https://github.com/Azure/sonic-linux-kernel/pull/46

Link: https://lkml.kernel.org/r/20210304124626.13927-1-pmenzel@molgen.mpg.de
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

Patches currently in -mm which might be from jolevequ@microsoft.com are

kexec-add-kexec-reboot-string.patch

