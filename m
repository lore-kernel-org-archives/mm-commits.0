Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5503C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244363AbiATVaJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347984AbiATVaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F55DC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D278C618BB
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C23C340E0;
        Thu, 20 Jan 2022 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714207;
        bh=9uuLbMqLtzolb2GCD0Uo/WOwkoOsy1Urtyio8b6Ogvc=;
        h=Date:From:To:Subject:From;
        b=vi3RxEknKtC+YAXQr8mC21KMfuotnAZUGDTuFJwW4tqzg2Xt22VCvVJK3T19McKAd
         Icyc/s2uv0N8gKZ+jsH7b9VcF3c5dq1ibHh4e2mecBLpDd/S6p9Xox2UDZ57PvKbK5
         VhvDHHmJ9xda/rPkfH71MkcWtfQyi+Le5MwdwSg4=
Date:   Thu, 20 Jan 2022 13:30:06 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        andrii@kernel.org, arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?tools-bpf-bpftool-skeleton-replace-bpf=5Fprobe=5Fread=5Fkern?=
 =?US-ASCII?Q?el-with-bpf=5Fprobe=5Fread=5Fkernel=5Fstr-to-get-task-comm.p?=
 =?US-ASCII?Q?atch?= removed from -mm tree
Message-ID: <20220120213006.QGlkwuBiN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/bpf/bpftool/skeleton: replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task comm
has been removed from the -mm tree.  Its filename was
     tools-bpf-bpftool-skeleton-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: tools/bpf/bpftool/skeleton: replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task comm

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then we
don't care about if the dst size is big enough.

Link: https://lkml.kernel.org/r/20211120112738.45980-7-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/bpf/bpftool/skeleton/pid_iter.bpf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c~tools-bpf-bpftool-skeleton-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm
+++ a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
@@ -71,8 +71,8 @@ int iter(struct bpf_iter__task_file *ctx
 
 	e.pid = task->tgid;
 	e.id = get_obj_id(file->private_data, obj_type);
-	bpf_probe_read_kernel(&e.comm, sizeof(e.comm),
-			      task->group_leader->comm);
+	bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm),
+				  task->group_leader->comm);
 	bpf_seq_write(ctx->meta->seq, &e, sizeof(e));
 
 	return 0;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


