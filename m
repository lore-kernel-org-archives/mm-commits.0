Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B85C4707F
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 20:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE9460FF1
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 20:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhEYUSI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 16:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232744AbhEYUSH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 16:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9FF160FF1;
        Tue, 25 May 2021 20:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621973797;
        bh=kGnFKwppmtl+OYZMEp7y/5vpnRyT+loVNxjQ4l+MUxg=;
        h=Date:From:To:Subject:From;
        b=gkzAYCS3eRvZXKVL8cM7uOqxTfXxD2lyaxkzURBAn4TlvtHNiNVH6O7gFQZgp51v8
         dd8YlmA2+Q6ESONU1uiMuizrSZLKNNLP3gC2h40mxrylpougcuCESFJSgi3AChhbl7
         uoWcE1lucbg/BvJIe5CosDIzbAyhmEyv82kW+x30=
Date:   Tue, 25 May 2021 13:16:37 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + exec-remove-checks-in-__register_bimfmt.patch added to
 -mm tree
Message-ID: <20210525201637.d-7wyYfJR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: remove checks in __register_bimfmt()
has been added to the -mm tree.  Its filename is
     exec-remove-checks-in-__register_bimfmt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/exec-remove-checks-in-__register_bimfmt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/exec-remove-checks-in-__register_bimfmt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: exec: remove checks in __register_bimfmt()

Delete NULL check, all callers pass valid pointer.

Delete ->load_binary check -- failure to provide hook in a custom module
will be very noticeable at the very first execve call.

Link: https://lkml.kernel.org/r/YK1Gy1qXaLAR+tPl@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/exec.c~exec-remove-checks-in-__register_bimfmt
+++ a/fs/exec.c
@@ -84,9 +84,6 @@ static DEFINE_RWLOCK(binfmt_lock);
 
 void __register_binfmt(struct linux_binfmt * fmt, int insert)
 {
-	BUG_ON(!fmt);
-	if (WARN_ON(!fmt->load_binary))
-		return;
 	write_lock(&binfmt_lock);
 	insert ? list_add(&fmt->lh, &formats) :
 		 list_add_tail(&fmt->lh, &formats);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

exec-remove-checks-in-__register_bimfmt.patch

