Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49019C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FFB20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266318;
	bh=/UBDhNKncAH9tRXBJWgjSsCqq8wf1zLslgz2+vHmzPw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TMAItOLCPl1H/ESUAYkaaVtk/pRQ7oND//dUDqVcEkPMVvMk/mQeiE+8KAiVIlMsR
	 IxiE+CnFLocLlWB06bo6FuUprDUNY4eI1KJkjatX+ee30j+nJdOnHvi12QUpe3GMW5
	 CsPlx/965dy9PHQs5TaCqCBOw7McQeJDuCdiksqk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHLVFR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgHLVFR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A87C92078B;
        Wed, 12 Aug 2020 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266317;
        bh=/UBDhNKncAH9tRXBJWgjSsCqq8wf1zLslgz2+vHmzPw=;
        h=Date:From:To:Subject:From;
        b=rnSriTPXgtUbrkD40B8aWiysxE+d68dVUB46pSwRjxhyjQuCU0SuTE5OL8gkrFBI4
         hojcC3RzhYDSnYYIVdZuPqRu2xD+qA8fDh0ENL43d50ZLMeVKjrRsmtAqNRhCCGV5o
         Xi3Fa7WCrfxCw3+8hw7oUfdyx3zU16jW/WAJ6NQ8=
Date:   Wed, 12 Aug 2020 14:05:16 -0700
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, cyphar@cyphar.com,
        dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 exec-change-uselib2-is_sreg-failure-to-eacces.patch removed from -mm tree
Message-ID: <20200812210516.q9DhqgF2g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: change uselib(2) IS_SREG() failure to EACCES
has been removed from the -mm tree.  Its filename was
     exec-change-uselib2-is_sreg-failure-to-eacces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: change uselib(2) IS_SREG() failure to EACCES

Patch series "Relocate execve() sanity checks", v2.

While looking at the code paths for the proposed O_MAYEXEC flag, I saw
some things that looked like they should be fixed up.

  exec: Change uselib(2) IS_SREG() failure to EACCES
	This just regularizes the return code on uselib(2).

  exec: Move S_ISREG() check earlier
	This moves the S_ISREG() check even earlier than it was already.

  exec: Move path_noexec() check earlier
	This adds the path_noexec() check to the same place as the
	S_ISREG() check.


This patch (of 3):

Change uselib(2)' S_ISREG() error return to EACCES instead of EINVAL so
the behavior matches execve(2), and the seemingly documented value.  The
"not a regular file" failure mode of execve(2) is explicitly
documented[1], but it is not mentioned in uselib(2)[2] which does,
however, say that open(2) and mmap(2) errors may apply.  The documentation
for open(2) does not include a "not a regular file" error[3], but mmap(2)
does[4], and it is EACCES.

[1] http://man7.org/linux/man-pages/man2/execve.2.html#ERRORS
[2] http://man7.org/linux/man-pages/man2/uselib.2.html#ERRORS
[3] http://man7.org/linux/man-pages/man2/open.2.html#ERRORS
[4] http://man7.org/linux/man-pages/man2/mmap.2.html#ERRORS

Link: http://lkml.kernel.org/r/20200605160013.3954297-1-keescook@chromium.org
Link: http://lkml.kernel.org/r/20200605160013.3954297-2-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/exec.c~exec-change-uselib2-is_sreg-failure-to-eacces
+++ a/fs/exec.c
@@ -141,11 +141,10 @@ SYSCALL_DEFINE1(uselib, const char __use
 	if (IS_ERR(file))
 		goto out;
 
-	error = -EINVAL;
+	error = -EACCES;
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
 
-	error = -EACCES;
 	if (path_noexec(&file->f_path))
 		goto exit;
 
_

Patches currently in -mm which might be from keescook@chromium.org are


