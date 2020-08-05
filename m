Return-Path: <SRS0=JYiv=BP=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68490C433DF
	for <mm-commits@archiver.kernel.org>; Wed,  5 Aug 2020 20:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEA820842
	for <mm-commits@archiver.kernel.org>; Wed,  5 Aug 2020 20:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596660002;
	bh=65b6nBOO2n5o1/R5ohGJ+mRUr9M4PDdxUfogh4uVQzQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OEO/eUHR7CS4gM1XoM1AvfgHigxCJUaQjfz5P434WZv2Pwa6KvDv5Kt/8L5YpYR8D
	 dnaATB17bwWL+lZXaw5OIWN2VZHILfLiQR4z7WDpLSzvIZCKblfZlsfE4gkAZb/rAp
	 Rf+DXtdIQ3H0qefJzLcmz6vorB1CYtZaxK98FrB4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgHEUkB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Aug 2020 16:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgHEUkB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 5 Aug 2020 16:40:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECA29206D4;
        Wed,  5 Aug 2020 20:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596660000;
        bh=65b6nBOO2n5o1/R5ohGJ+mRUr9M4PDdxUfogh4uVQzQ=;
        h=Date:From:To:Subject:From;
        b=IBPTVoWx5T898X0kDlEOTqmwKky9Qmg+VH+c04mkdD9LxsZuyWU7gn9uxeT7V8n/r
         GUa+c4SlckfwLivVk9DhMaQh5L3FE5nDjaADgVVGtS+qSp9nEsqeQIVvfcSh+zodJU
         b2VWXZxzQOY9QSqwzSd57ADicblDBFlzNd+DImoE=
Date:   Wed, 05 Aug 2020 13:39:59 -0700
From:   akpm@linux-foundation.org
To:     andriin@fb.com, anil.s.keshavamurthy@intel.com, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, rostedt@goodmis.org,
        sfr@canb.auug.org.au, songliubraving@fb.com,
        songmuchun@bytedance.com, yhs@fb.com
Subject:  +
 kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace.patch added to
 -mm tree
Message-ID: <20200805203959.4wtIfByaj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: fix compiler warning for !CONFIG_KPROBES_ON_FTRACE
has been added to the -mm tree.  Its filename is
     kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch
kprobes-fix-compiler-warning-for-config_kprobes_on_ftrace.patch

