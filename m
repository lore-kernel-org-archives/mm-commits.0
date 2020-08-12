Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46721C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 167822054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196186;
	bh=KgncLYKpqu/RmWUdVNRmLaaRy/rMBRfitfw01Ejfz34=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Icxk/ziWw/Ek/shbY7X+osh4oCNI4PtQZTK+frmavv/UkZlrlQBwXQMfnCk8cSjcP
	 KS/Y3/Nn+HntxS8S6JZ+SGbLa7FMbhB2hyNJTMpahl2xHMnVGxQNnj1FAVmbsOq/gb
	 LBdTtmsN3e6IxRn0L5qJ+Rw71Dr7tEyjnGwza1fo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgHLBgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3FBE20658;
        Wed, 12 Aug 2020 01:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196184;
        bh=KgncLYKpqu/RmWUdVNRmLaaRy/rMBRfitfw01Ejfz34=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NaRj0w6hiLBLw9GxjCrOzchy5BOhIv4CykRq8N2igNwN/o/Ur/fjhvfp/bqKH98bs
         35pahhdYnH/SGMPX+zYKmofJXGD2aSa0LzhWPL7WFOa8ecCZTRES8cgCbL0GMmWEzq
         NWKtBDECWuoE7cN15Vm0nbVQm/YV/GvanX0gAIgo=
Date:   Tue, 11 Aug 2020 18:36:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        cyphar@cyphar.com, dvyukov@google.com, ebiggers3@gmail.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 116/165] exec: change uselib(2) IS_SREG() failure
 to EACCES
Message-ID: <20200812013623.YcT2xx-Hb%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
