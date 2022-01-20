Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD62C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358170AbiATCIX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCIX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EBAC061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:08:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DF1B81B3B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C98C004E1;
        Thu, 20 Jan 2022 02:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644500;
        bh=tFW0FK1ojJK0LsR0XGbRFSzvte188Y9QFYEMuwYToDU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=khQsMkP28PioDQdhf1aXpzOFqSyfBDN8n6WtqzUoRZD+prAWc0+5hlM9EPK1DBuOS
         W8hq4yUuAq9ugIVWP8ewDQjl+moQqL+ljVvCS8rii/V6Nw/u939uuAlww4mpK2NrH1
         Yp5KD3+zzI5uvS8LIKltkTNYAqYvzIajoRe12NpE=
Date:   Wed, 19 Jan 2022 18:08:19 -0800
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
Subject:  [patch 12/55] fs/exec: replace strlcpy with strscpy_pad
 in __set_task_comm
Message-ID: <20220120020819.PDvLM2xkw%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: fs/exec: replace strlcpy with strscpy_pad in __set_task_comm

Patch series "task comm cleanups", v2.

This patchset is part of the patchset "extend task comm from 16 to 24"[1].
Now we have different opinion that dynamically allocates memory to store
kthread's long name into a separate pointer, so I decide to take the
useful cleanups apart from the original patchset and send it
separately[2].

These useful cleanups can make the usage around task comm less
error-prone.  Furthermore, it will be useful if we want to extend task
comm in the future.

[1]. https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
[2]. https://lore.kernel.org/lkml/CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com/


This patch (of 7):

strlcpy() can trigger out-of-bound reads on the source string[1], we'd
better use strscpy() instead.  To make it be robust against full tsk->comm
copies that got noticed in other places, we should make sure it's zero
padded.

[1] https://github.com/KSPP/linux/issues/89

Link: https://lkml.kernel.org/r/20211120112738.45980-1-laoar.shao@gmail.com
Link: https://lkml.kernel.org/r/20211120112738.45980-2-laoar.shao@gmail.com
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

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exec.c~fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm
+++ a/fs/exec.c
@@ -1222,7 +1222,7 @@ void __set_task_comm(struct task_struct
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk, exec);
 }
_
