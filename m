Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7226C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E06A206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027248;
	bh=tfCGpamwPOC9hblre1uGHt/DiLU6dVNKZTaDZ78Aa6E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XBwtqegVxMH2zESCJPEILrU5TZAYQhfKIN5kHGS3vSFVWlaLLgqqHML91ppyGfq7w
	 n62kMrStlYdi6oalIXo/96m4l5zQV+HilBT6x9IMoOytpNqfa3RgNk64M2UChpuCYC
	 TbAa1k9pFIc/qxSkoUw2h60ywuEoBqQUCkVDFw6Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCks (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD0A72065D;
        Mon, 10 Aug 2020 02:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027247;
        bh=tfCGpamwPOC9hblre1uGHt/DiLU6dVNKZTaDZ78Aa6E=;
        h=Date:From:To:Subject:From;
        b=IAJ7ED2pMbneutOwJDgW0obQmz6Oh8Lgy96kLwy3i3FHg5QooGAXlEmyJ6Bmpx1xc
         NHO4pMcwkKQUpAziW79gfosdFvh4qiP+X5zWlp0qwoDV7Moa1gWKZwtLzHbBvIuqC4
         /jUwaJhonfN015TYjudfIPV7koDLwR+PsaSPGI3s=
Date:   Sun, 09 Aug 2020 19:40:46 -0700
From:   akpm@linux-foundation.org
To:     andriin@fb.com, anil.s.keshavamurthy@intel.com, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, rostedt@goodmis.org,
        sfr@canb.auug.org.au, songliubraving@fb.com,
        songmuchun@bytedance.com, yhs@fb.com
Subject:  [merged]
 kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace.patch removed
 from -mm tree
Message-ID: <20200810024046.teUgSUgwY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: fix compiler warning for !CONFIG_KPROBES_ON_FTRACE
has been removed from the -mm tree.  Its filename was
     kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: kprobes: fix compiler warning for !CONFIG_KPROBES_ON_FTRACE

Fix compiler warning(as show below) for !CONFIG_KPROBES_ON_FTRACE.

kernel/kprobes.c: In function 'kill_kprobe':
kernel/kprobes.c:1116:33: warning: statement with no effect
[-Wunused-value]
 1116 | #define disarm_kprobe_ftrace(p) (-ENODEV)
      |                                 ^
kernel/kprobes.c:2154:3: note: in expansion of macro
'disarm_kprobe_ftrace'
 2154 |   disarm_kprobe_ftrace(p);

Link: https://lore.kernel.org/r/20200805142136.0331f7ea@canb.auug.org.au

Link: http://lkml.kernel.org/r/20200805172046.19066-1-songmuchun@bytedance.com
Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/kernel/kprobes.c~kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace
+++ a/kernel/kprobes.c
@@ -1111,9 +1111,20 @@ static int disarm_kprobe_ftrace(struct k
 		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
 }
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
-#define prepare_kprobe(p)	arch_prepare_kprobe(p)
-#define arm_kprobe_ftrace(p)	(-ENODEV)
-#define disarm_kprobe_ftrace(p)	(-ENODEV)
+static inline int prepare_kprobe(struct kprobe *p)
+{
+	return arch_prepare_kprobe(p);
+}
+
+static inline int arm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
+
+static inline int disarm_kprobe_ftrace(struct kprobe *p)
+{
+	return -ENODEV;
+}
 #endif
 
 /* Arm a kprobe with text_mutex */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-add-mempolicy-check-in-the-reservation-routine.patch

