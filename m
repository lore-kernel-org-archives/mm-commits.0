Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE43C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 03:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA2DB2076E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 03:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597981909;
	bh=+CoxoMKiSB0ABcM9WA+mUXvqp65s1Tz1JiKP/lvcZaw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=smRKks8symaAPw7Q3hrpJwXbTuv3TjLSMmsEy0yOHa8XRb9vPMsL3HRjoOo7QSQ41
	 kaOi/vBcyP8q89NocJVwcMENQuyf5q2Gg/n2fKfPF8xQgtDaAK+6c8NPXCTDxa9nNM
	 Q4lG/qHYxyKXD+W2gE0f9/TW7ySbQhbcv1MFEbik=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHUDvs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 23:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgHUDvn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 23:51:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC9520714;
        Fri, 21 Aug 2020 03:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597981902;
        bh=+CoxoMKiSB0ABcM9WA+mUXvqp65s1Tz1JiKP/lvcZaw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ye5Np3QFxDjceCOf2G77Wwh7Zy/llwHIpxsH84S3QwZ7e8wK16+YOQTV3RGqMqFdL
         TyQOBQ10JPFqulSQp8pM6ekszLyYE1ULc2qCOvLVFk2ZSKqtO0hdYPhUsv9K8is5Pe
         OchUdI+t7FpeYdyPbXj0r5/zOA+osnhkEMgkrcTg=
Date:   Thu, 20 Aug 2020 20:51:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ckennelly@google.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?fs-binfmt=5Felf-use-pt=5Fload-p=5Falign-values-for-suitable?=
 =?US-ASCII?Q?-start-address-fix.patch?= added to -mm tree
Message-ID: <20200821035142.Ju_Rtg5Gv%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix

fix max() warning

Cc: Chris Kennelly <ckennelly@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix
+++ a/fs/binfmt_elf.c
@@ -429,10 +429,12 @@ static unsigned long maximum_alignment(s
 
 	for (i = 0; i < nr; i++) {
 		if (cmds[i].p_type == PT_LOAD) {
+			unsigned long p_align = cmds[i].p_align;
+
 			/* skip non-power of two alignments */
-			if (!is_power_of_2(cmds[i].p_align))
+			if (!is_power_of_2(p_align))
 				continue;
-			alignment = max(alignment, cmds[i].p_align);
+			alignment = max(alignment, p_align);
 		}
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

