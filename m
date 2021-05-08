Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF088C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B10396143B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhEHWyi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89F2D61430;
        Sat,  8 May 2021 22:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514415;
        bh=Gnrz/4yMczyHegiuCevLP7b/HY8arR0wJxVjrirg4SE=;
        h=Date:From:To:Subject:From;
        b=LdRA+kcLURZTWOJGGtlostApF69voLC8SdQCkIXfk2uIGdpjFadrH1TS4st68Rr2n
         l5joD8Nz++IF9EfibsL3+ARmGzA4WHy6pGx588C2n8LluTgLi2p5UKl9P6x9e9+5vk
         bZ+nWyODZmhoOmaoPLteKQJS9zuPKjOAVtgipqB0=
Date:   Sat, 08 May 2021 15:53:35 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, jolevequ@microsoft.com, lguohan@gmail.com,
        mm-commits@vger.kernel.org, pmenzel@molgen.mpg.de
Subject:  [merged] kexec-add-kexec-reboot-string.patch removed from
 -mm tree
Message-ID: <20210508225335.BNh84cBPS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add kexec reboot string
has been removed from the -mm tree.  Its filename was
     kexec-add-kexec-reboot-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jolevequ@microsoft.com are


