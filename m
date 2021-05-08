Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1654C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B447B6141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWoZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9740B61421;
        Sat,  8 May 2021 22:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513803;
        bh=pc55oGkDiUZGUWq7JNWAyU17Wkn9J3HeJ8V+uBuNH1Y=;
        h=Date:From:To:Subject:From;
        b=vaIM1SbE52/jCsjcjSTZNcUvWDj4PV7wl40LaDSO2TTdlec1CIbhZj2dS2V3CAL2j
         W3n6JzrRznHV3A3XwEEBlwQBC7BF8tBT/x4WwzUmEKCXLnpR2RJ057KaErCbIXR1cT
         POIuHLDPpnBxmLgdOYM6aZhlxXvkMUCOmoZvIQG8=
Date:   Sat, 08 May 2021 15:43:23 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch removed from -mm tree
Message-ID: <20210508224323.8CJbsR9DZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: remove two kvfree_rcu() tests
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from urezki@gmail.com are


