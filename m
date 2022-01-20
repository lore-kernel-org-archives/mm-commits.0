Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48278C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377919AbiATVaC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39402 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347984AbiATVaC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEF0617CF
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB08C340E0;
        Thu, 20 Jan 2022 21:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714201;
        bh=dUQiyaGLWay2Iuya/ZXpsRuAp52evdBKc9F6DE0fsTQ=;
        h=Date:From:To:Subject:From;
        b=WBhZwBNLVHA4vlzdOGgm1289d5P+DKeEv/Vwj8/LPeNKpuKJPaL8T0ut9HlFkBfDU
         YkJVIyJDGZUR8spbr+OsguXhf7PNyhPoZr0XZOILoHza/LQcm+899gC/AbpiHfi8HP
         rw883NFwjIaUMh6w6lLl4hB8LsWl6ryszsvgWkXs=
Date:   Thu, 20 Jan 2022 13:30:00 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        andrii@kernel.org, arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm.patch
 removed from -mm tree
Message-ID: <20220120213000.FBy8pQvSB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: replace open-coded string copy with get_task_comm
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: fs/binfmt_elf: replace open-coded string copy with get_task_comm

It is better to use get_task_comm() instead of the open coded string copy
as we do in other places.

struct elf_prpsinfo is used to dump the task information in userspace
coredump or kernel vmcore. Below is the verification of vmcore,

crash> ps
   PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
      0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
      0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]

It works well as expected.

Some comments are added to explain why we use the hard-coded 16.

Link: https://lkml.kernel.org/r/20211120112738.45980-5-laoar.shao@gmail.com
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c                |    2 +-
 include/linux/elfcore-compat.h |    5 +++++
 include/linux/elfcore.h        |    5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm
+++ a/fs/binfmt_elf.c
@@ -1585,7 +1585,7 @@ static int fill_psinfo(struct elf_prpsin
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
+	get_task_comm(psinfo->pr_fname, p);
 
 	return 0;
 }
--- a/include/linux/elfcore-compat.h~fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm
+++ a/include/linux/elfcore-compat.h
@@ -43,6 +43,11 @@ struct compat_elf_prpsinfo
 	__compat_uid_t			pr_uid;
 	__compat_gid_t			pr_gid;
 	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	/*
+	 * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
+	 * changed as it is exposed to userspace. We'd better make it hard-coded
+	 * here.
+	 */
 	char				pr_fname[16];
 	char				pr_psargs[ELF_PRARGSZ];
 };
--- a/include/linux/elfcore.h~fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm
+++ a/include/linux/elfcore.h
@@ -65,6 +65,11 @@ struct elf_prpsinfo
 	__kernel_gid_t	pr_gid;
 	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	/* Lots missing */
+	/*
+	 * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
+	 * changed as it is exposed to userspace. We'd better make it hard-coded
+	 * here.
+	 */
 	char	pr_fname[16];	/* filename of executable */
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
 };
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


