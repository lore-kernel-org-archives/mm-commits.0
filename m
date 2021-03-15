Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7FBC43381
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E175664F67
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhCOXLc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 19:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233472AbhCOXL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 19:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6A5A64F67;
        Mon, 15 Mar 2021 23:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615849886;
        bh=uVXYG0jyhMMEVV0Sa3S4tuMbeUwzf2Ah+2uoEvD6SEk=;
        h=Date:From:To:Subject:From;
        b=iWCaedzoSurRq7oDnu60idVr1US5/FEDNdRzCr6WYGXx6cdHXUVU5lsz+t0ah1WAL
         5zJ/MI0p5HrWb8Lr+x9/I0eE1xPDcRL4JMNv9od3OwXEy4LwGMVWKaYX0rf841orLd
         btxEQkBWuN3J+my6Bhndf8rZE50fORopI3sbi7Uo=
Date:   Mon, 15 Mar 2021 16:11:25 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, vbabka@suse.cz,
        wenyang@linux.alibaba.com, willy@infradead.org,
        xlpang@linux.alibaba.com
Subject:  [nacked] percpu-export-per_cpu_sum.patch removed from -mm
 tree
Message-ID: <20210315231125.vShSK1Lps%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: export per_cpu_sum()
has been removed from the -mm tree.  Its filename was
     percpu-export-per_cpu_sum.patch

This patch was dropped because it was nacked

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

mm-slub-use-percpu-partial-free-counter.patch

