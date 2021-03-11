Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40668C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1046364F87
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCKWPh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhCKWPH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 152A664F87;
        Thu, 11 Mar 2021 22:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615500907;
        bh=4IPho4kNmKS94robFSwIlwE3bBVQMjraB8KA7yRHdJo=;
        h=Date:From:To:Subject:From;
        b=VbrRwH8HWmuD2PbbH33gOcp89kPp/6803UD3Ldr4GYmpVURh0ryqB5XJ4UYu58BHS
         P+sjKOKRRfjH0TxOkyZvCJ5OU90tKxD5VGa5/TGrGE0QLnbPpFmDHXUvLBseMAYv/h
         d1fNtRNoL4Wy69N2ANPrYkQy+tg3QSXWV5ENLUVk=
Date:   Thu, 11 Mar 2021 14:15:06 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, vbabka@suse.cz,
        wenyang@linux.alibaba.com, willy@infradead.org,
        xlpang@linux.alibaba.com
Subject:  + percpu-export-per_cpu_sum.patch added to -mm tree
Message-ID: <20210311221506.lyRhQ-aQh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: export per_cpu_sum()
has been added to the -mm tree.  Its filename is
     percpu-export-per_cpu_sum.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/percpu-export-per_cpu_sum.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/percpu-export-per_cpu_sum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xunlei Pang <xlpang@linux.alibaba.com>
Subject: percpu: export per_cpu_sum()

per_cpu_sum() is useful, and deserves to be exported.

Link: https://lkml.kernel.org/r/1615303512-35058-4-git-send-email-xlpang@linux.alibaba.com
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Tested-by: James Wang <jnwang@linux.alibaba.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shu Ming <sming56@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h   |   10 ++++++++++
 kernel/locking/percpu-rwsem.c |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-export-per_cpu_sum
+++ a/include/linux/percpu-defs.h
@@ -220,6 +220,16 @@ do {									\
 	(void)__vpp_verify;						\
 } while (0)
 
+#define per_cpu_sum(var)						\
+({									\
+	typeof(var) __sum = 0;						\
+	int cpu;							\
+	compiletime_assert_atomic_type(__sum);				\
+	for_each_possible_cpu(cpu)					\
+		__sum += per_cpu(var, cpu);				\
+	__sum;								\
+})
+
 #ifdef CONFIG_SMP
 
 /*
--- a/kernel/locking/percpu-rwsem.c~percpu-export-per_cpu_sum
+++ a/kernel/locking/percpu-rwsem.c
@@ -178,16 +178,6 @@ bool __percpu_down_read(struct percpu_rw
 }
 EXPORT_SYMBOL_GPL(__percpu_down_read);
 
-#define per_cpu_sum(var)						\
-({									\
-	typeof(var) __sum = 0;						\
-	int cpu;							\
-	compiletime_assert_atomic_type(__sum);				\
-	for_each_possible_cpu(cpu)					\
-		__sum += per_cpu(var, cpu);				\
-	__sum;								\
-})
-
 /*
  * Return true if the modular sum of the sem->read_count per-CPU variable is
  * zero.  If this sum is zero, then it is stable due to the fact that if any
_

Patches currently in -mm which might be from xlpang@linux.alibaba.com are

mm-slub-introduce-two-counters-for-partial-objects.patch
mm-slub-get-rid-of-count_partial.patch
percpu-export-per_cpu_sum.patch
mm-slub-use-percpu-partial-free-counter.patch

