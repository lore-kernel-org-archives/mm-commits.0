Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8F5C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8BBC2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196222;
	bh=NxD6VGEmdeemBeKXC+QnU9KYiy6Z6wCYBJpjwhSQToE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cRwVb+Uo9B3ySreab8DvttIjtLiPjiu3m0oU8kVpr8i1fWz2fxgulsHJSEY3jA76w
	 hL+j0opTQO8C7gWBE7yfYvkglJY+q01K+SmAlBwK6aDTqbnfhb9XrWOOo5WtRCIcS/
	 GTRETsiXrPNEthkNzgfxfDADdyeg+Tvaaqv0V724=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgHLBhB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLBhB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8108B20658;
        Wed, 12 Aug 2020 01:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196219;
        bh=NxD6VGEmdeemBeKXC+QnU9KYiy6Z6wCYBJpjwhSQToE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XR0H8d5/HNAOmZmOiAlJqcUY/8IP0o4FOqAAPH+hVdFQkHQwNpYUVJHYkNJQHh6VU
         kUkqVAqd/TsRpkRnZmM9J1PeLbw2bb5jFgKwJn0bSrRusGYZP33sAUDAl4JUY4vXtZ
         NjAI8bAjE++p0LWTVvpPn8g4+xF/QIm9CfE4S7NM=
Date:   Tue, 11 Aug 2020 18:36:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        hulkci@huawei.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, weiyongjun1@huawei.com
Subject:  [patch 127/165] kcov: make some symbols static
Message-ID: <20200812013659.4PfL3CDWL%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
