Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DF6C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A26CC61074
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343703AbhIBVSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245379AbhIBVSB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:18:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1975461059;
        Thu,  2 Sep 2021 21:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617422;
        bh=3Q/ba/sUmv+HsZAUdCMpS/an+CIhp+9Z9fQcTXlP8qE=;
        h=Date:From:To:Subject:From;
        b=mFZNRdAZ0q/YTb8/CiKYUePTQ3QUbBpa6JE3DGt2K1ihcIiSBhsjni54uLIPgKHKz
         XI9iuvpCEySFhA4NUHc7UcXLMTr4ULAORJxQmOWt42LoeDlXLjQRvDH3ppHAtPQTL9
         Nq8rDJ28XYHNXZfy2kxoNScFe4+8pnMWoysvkiKs=
Date:   Thu, 02 Sep 2021 14:17:01 -0700
From:   akpm@linux-foundation.org
To:     jmorris@namei.org, lrizzo@google.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, serge@hallyn.com,
        sfr@canb.auug.org.au, takedakn@nttdata.co.jp
Subject:  [folded-merged]
 add-mmap_assert_locked-annotations-to-find_vma-fix.patch removed from -mm
 tree
Message-ID: <20210902211701.B5C9zS1q_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: add-mmap_assert_locked-annotations-to-find_vma-fix
has been removed from the -mm tree.  Its filename was
     add-mmap_assert_locked-annotations-to-find_vma-fix.patch

This patch was dropped because it was folded into add-mmap_assert_locked-annotations-to-find_vma.patch

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

add-mmap_assert_locked-annotations-to-find_vma.patch
kernel-hung_taskc-monitor-killed-tasks.patch

