Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59223C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBF861483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhD3GAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhD3GAA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4AEB613A9;
        Fri, 30 Apr 2021 05:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762351;
        bh=HMkXvhpK/rCv796c+vumhDVmRwv6JxoVYEHU6GSq8r0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LZExkmbVGyrpdb8wBekRA/vNAYOCO4yYEvPl9/S0E8IEVMnLZyShuSJzH9MeLiDUb
         OxCWOp8UIM4/Z1N9yNiWoLjGkFa1GkbBU8qKM19Bf/HQcHw9FDeTqwxBjztvDnY6Rs
         ZLbDZCozuN3bGmqB9R9xa1QAn2YPUj2S15w4uy8Q=
Date:   Thu, 29 Apr 2021 22:59:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [patch 116/178] lib/test_vmalloc.c: remove two
 kvfree_rcu() tests
Message-ID: <20210430055910.zsL7tc7Cs%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: remove two kvfree_rcu() tests

Remove two test cases related to kvfree_rcu() and SLAB.  Those are
considered as redundant now, because similar test functionality has
recently been introduced in the "rcuscale" RCU test-suite.

Link: https://lkml.kernel.org/r/20210402202237.20334-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-remove-two-kvfree_rcu-tests
+++ a/lib/test_vmalloc.c
@@ -47,8 +47,6 @@ __param(int, run_test_mask, INT_MAX,
 		"\t\tid: 128,  name: pcpu_alloc_test\n"
 		"\t\tid: 256,  name: kvfree_rcu_1_arg_vmalloc_test\n"
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
-		"\t\tid: 1024, name: kvfree_rcu_1_arg_slab_test\n"
-		"\t\tid: 2048, name: kvfree_rcu_2_arg_slab_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -363,42 +361,6 @@ kvfree_rcu_2_arg_vmalloc_test(void)
 	return 0;
 }
 
-static int
-kvfree_rcu_1_arg_slab_test(void)
-{
-	struct test_kvfree_rcu *p;
-	int i;
-
-	for (i = 0; i < test_loop_count; i++) {
-		p = kmalloc(sizeof(*p), GFP_KERNEL);
-		if (!p)
-			return -1;
-
-		p->array[0] = 'a';
-		kvfree_rcu(p);
-	}
-
-	return 0;
-}
-
-static int
-kvfree_rcu_2_arg_slab_test(void)
-{
-	struct test_kvfree_rcu *p;
-	int i;
-
-	for (i = 0; i < test_loop_count; i++) {
-		p = kmalloc(sizeof(*p), GFP_KERNEL);
-		if (!p)
-			return -1;
-
-		p->array[0] = 'a';
-		kvfree_rcu(p, rcu);
-	}
-
-	return 0;
-}
-
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
@@ -415,8 +377,6 @@ static struct test_case_desc test_case_a
 	{ "pcpu_alloc_test", pcpu_alloc_test },
 	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test },
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test },
-	{ "kvfree_rcu_1_arg_slab_test", kvfree_rcu_1_arg_slab_test },
-	{ "kvfree_rcu_2_arg_slab_test", kvfree_rcu_2_arg_slab_test },
 	/* Add a new test case here. */
 };
 
_
