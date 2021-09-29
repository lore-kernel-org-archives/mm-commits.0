Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A211C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB5B61406
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347497AbhI2XWV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 19:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347487AbhI2XWV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Sep 2021 19:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5329461528;
        Wed, 29 Sep 2021 23:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632957639;
        bh=Sb7MNy+u1NskEPB+ZQntzY+sUg72M9z1FomveCIO43A=;
        h=Date:From:To:Subject:From;
        b=x0JhxOZNYpVhX8b5hS3I4rMp6XeiXjhEtfnD8WBgw7LeW6L3uEZrixcP89+nETsLZ
         nQQltHfIx0R09i1ovYqA87qqLtpqp1VKqEoTJRLNzlBHFyWmz6TNZCECvPlm/PFpu8
         /XJI4MvrH32ME7Urh7bCw6YyXqnhsILkUyte+AM0=
Date:   Wed, 29 Sep 2021 16:20:38 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, fweimer@redhat.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  + procfs-do-not-list-tid-0-in-proc-pid-task.patch added
 to -mm tree
Message-ID: <20210929232038.o0_ct-q8J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: do not list TID 0 in /proc/<pid>/task
has been added to the -mm tree.  Its filename is
     procfs-do-not-list-tid-0-in-proc-pid-task.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/procfs-do-not-list-tid-0-in-proc-pid-task.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/procfs-do-not-list-tid-0-in-proc-pid-task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Florian Weimer <fweimer@redhat.com>
Subject: procfs: do not list TID 0 in /proc/<pid>/task

If a task exits concurrently, task_pid_nr_ns may return 0.

Link: https://lkml.kernel.org/r/8735pn5dx7.fsf@oldenburg.str.redhat.com
Signed-off-by: Florian Weimer <fweimer@redhat.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/base.c~procfs-do-not-list-tid-0-in-proc-pid-task
+++ a/fs/proc/base.c
@@ -3800,6 +3800,9 @@ static int proc_task_readdir(struct file
 		char name[10 + 1];
 		unsigned int len;
 		tid = task_pid_nr_ns(task, ns);
+		if (!tid)
+			/* The task has just exited. */
+			continue;
 		len = snprintf(name, sizeof(name), "%u", tid);
 		if (!proc_fill_cache(file, ctx, name, len,
 				proc_task_instantiate, task, NULL)) {
_

Patches currently in -mm which might be from fweimer@redhat.com are

procfs-do-not-list-tid-0-in-proc-pid-task.patch

