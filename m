Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AC8C4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 00:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C668F610A8
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 00:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhHEAce (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Aug 2021 20:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236130AbhHEAce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Aug 2021 20:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E05D61004;
        Thu,  5 Aug 2021 00:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628123540;
        bh=9C4Kvaw+J9PkQbT/dbkEd0uAPwqBaJVPQi3586DE3Tc=;
        h=Date:From:To:Subject:From;
        b=qbmsMu/dMH78IWPq2+D7wufAOnMYjDpI2OdOafbaz77euzplCmEkxDkHWNuVPMqod
         h994qVA0LMAUYnwwfKWG1bSXBWZ98j6RecG64CaUA66mr+majzdgf3T3wjrh/sQF8z
         dSHtjmzFeXI1EUTs2Wd0k9Epdq8NfohtD+622kno=
Date:   Wed, 04 Aug 2021 17:32:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, takedakn@nttdata.co.jp,
        sfr@canb.auug.org.au, serge@hallyn.com, lrizzo@google.com,
        jmorris@namei.org, penguin-kernel@i-love.sakura.ne.jp
Subject:  + add-mmap_assert_locked-annotations-to-find_vma-fix.patch
 added to -mm tree
Message-ID: <20210805003220.gXQAr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: add-mmap_assert_locked-annotations-to-find_vma-fix
has been added to the -mm tree.  Its filename is
     add-mmap_assert_locked-annotations-to-find_vma-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-mmap_assert_locked-annotations-to-find_vma-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-mmap_assert_locked-annotations-to-find_vma-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: add-mmap_assert_locked-annotations-to-find_vma-fix

TOMOYO needs the same protection which get_arg_page() needs.

Link: https://lkml.kernel.org/r/58bb6bf7-a57e-8a40-e74b-39584b415152@i-love.sakura.ne.jp
Cc: Luigi Rizzo <lrizzo@google.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/tomoyo/domain.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/security/tomoyo/domain.c~add-mmap_assert_locked-annotations-to-find_vma-fix
+++ a/security/tomoyo/domain.c
@@ -897,6 +897,9 @@ bool tomoyo_dump_page(struct linux_binpr
 		      struct tomoyo_page_dump *dump)
 {
 	struct page *page;
+#ifdef CONFIG_MMU
+	int ret;
+#endif
 
 	/* dump->data is released by tomoyo_find_next_domain(). */
 	if (!dump->data) {
@@ -909,11 +912,13 @@ bool tomoyo_dump_page(struct linux_binpr
 	/*
 	 * This is called at execve() time in order to dig around
 	 * in the argv/environment of the new proceess
-	 * (represented by bprm).  'current' is the process doing
-	 * the execve().
+	 * (represented by bprm).
 	 */
-	if (get_user_pages_remote(bprm->mm, pos, 1,
-				FOLL_FORCE, &page, NULL, NULL) <= 0)
+	mmap_read_lock(bprm->mm);
+	ret = get_user_pages_remote(bprm->mm, pos, 1,
+				    FOLL_FORCE, &page, NULL, NULL);
+	mmap_read_unlock(bprm->mm);
+	if (ret <= 0)
 		return false;
 #else
 	page = bprm->page[pos / PAGE_SIZE];
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

add-mmap_assert_locked-annotations-to-find_vma-fix.patch
kernel-hung_taskc-monitor-killed-tasks.patch

