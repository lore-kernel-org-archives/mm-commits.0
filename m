Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A283C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F87207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266345;
	bh=rLgYRu/i2L1mXlv2102CJVDwgCUcEDzvPriitp6oxZM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=S/SLmCIyn3JVNbn73RHA7/67V59K76ZYc0oI9XxDl7PCn1bSB/93nwfWdSv3jwPdq
	 wXbRiwwcHWOfl6WfaMJnAHn7HAADtsEyzZGhnqKzuOT5ht5BN6yJMIA+I1stb8gOva
	 uY4ksM7/6EQgVDetzEpjj9eZkEKvF1ObkvnoTKt4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHLVFp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVFo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74B7A20774;
        Wed, 12 Aug 2020 21:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266344;
        bh=rLgYRu/i2L1mXlv2102CJVDwgCUcEDzvPriitp6oxZM=;
        h=Date:From:To:Subject:From;
        b=iqnYBufzi7O6KGWBmDiFv5jemjlAQ87fvVDDfKKl3lOOkQzduh9bxnjXrkZTuN/NV
         ElO/pxANMn3Zht1Z93cb0HpcMKGaFQvDeehnp2SOZRiMNE4C6jRX0jC575LLRXuVIo
         mfEgN1cuIr9NmmiQgLgctGc2/998yr0qe8o3wfqQ=
Date:   Wed, 12 Aug 2020 14:05:44 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, hulkci@huawei.com,
        mm-commits@vger.kernel.org, weiyongjun1@huawei.com
Subject:  [merged] kcov-make-some-symbols-static.patch removed from
 -mm tree
Message-ID: <20200812210544.N3grjK3dQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: make some symbols static
has been removed from the -mm tree.  Its filename was
     kcov-make-some-symbols-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: kcov: make some symbols static

Fix sparse build warnings:

kernel/kcov.c:99:1: warning:
 symbol '__pcpu_scope_kcov_percpu_data' was not declared. Should it be static?
kernel/kcov.c:778:6: warning:
 symbol 'kcov_remote_softirq_start' was not declared. Should it be static?
kernel/kcov.c:795:6: warning:
 symbol 'kcov_remote_softirq_stop' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200702115501.73077-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/kcov.c~kcov-make-some-symbols-static
+++ a/kernel/kcov.c
@@ -96,7 +96,7 @@ struct kcov_percpu_data {
 	int			saved_sequence;
 };
 
-DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data);
+static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data);
 
 /* Must be called with kcov_remote_lock locked. */
 static struct kcov_remote *kcov_remote_find(u64 handle)
@@ -775,7 +775,7 @@ static inline bool kcov_mode_enabled(uns
 	return (mode & ~KCOV_IN_CTXSW) != KCOV_MODE_DISABLED;
 }
 
-void kcov_remote_softirq_start(struct task_struct *t)
+static void kcov_remote_softirq_start(struct task_struct *t)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 	unsigned int mode;
@@ -792,7 +792,7 @@ void kcov_remote_softirq_start(struct ta
 	}
 }
 
-void kcov_remote_softirq_stop(struct task_struct *t)
+static void kcov_remote_softirq_stop(struct task_struct *t)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


