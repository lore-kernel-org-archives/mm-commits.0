Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52104C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358171AbiATCI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCI0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB30C061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09121B81C9E
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40683C004E1;
        Thu, 20 Jan 2022 02:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644503;
        bh=O6zypJLFMy0RfX3u7/FHbhcHAHSZNrmmm76fs+WWiCc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R7L777ivrFhH57I1Up2QjUcfhxO6t5AUswPbVTi+8jito10Gv0Qu05mzbADYkz1pp
         2FiAIBTiPT6uPStdRkdQ9tKlN79GmPD9YOTVZNyqzDkE0NTwNTIZNaA1VgwF+DwVrO
         2QLlJudQGDVJWePD2eAFiCLagaLsFeMu/W7K/dcY=
Date:   Wed, 19 Jan 2022 18:08:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexei.starovoitov@gmail.com,
        andrii.nakryiko@gmail.com, andrii@kernel.org,
        arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mirq-linux@rere.qmqm.pl,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 13/55] fs/exec: replace strncpy with strscpy_pad
 in __get_task_comm
Message-ID: <20220120020822.I2yQQ39wx%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: fs/exec: replace strncpy with strscpy_pad in __get_task_comm

If the dest buffer size is smaller than sizeof(tsk->comm), the buffer will
be without null ternimator, that may cause problem.  Using strscpy_pad()
instead of strncpy() in __get_task_comm() can make the string always nul
ternimated and zero padded.

Link: https://lkml.kernel.org/r/20211120112738.45980-3-laoar.shao@gmail.com
Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/exec.c~fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm
+++ a/fs/exec.c
@@ -1207,7 +1207,8 @@ static int unshare_sighand(struct task_s
 char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 {
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, buf_size);
+	/* Always NUL terminated and zero-padded */
+	strscpy_pad(buf, tsk->comm, buf_size);
 	task_unlock(tsk);
 	return buf;
 }
_
