Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6254C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 22:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0ABA61183
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 22:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhDBWBc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 18:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhDBWBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 18:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FBE8610C7;
        Fri,  2 Apr 2021 22:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617400890;
        bh=uEgges69Bp8xC2fEXzU7ZMJ3Bv1TyepG2CnOXNBTcbo=;
        h=Date:From:To:Subject:From;
        b=PQfNK0YY73nzvAFVnQIpmywrqlWhn+FCJYxWbwrBN1oECJa/Rm5zu/L4dUQ8ywFJ4
         3Hu9JTIQpuNtfb5AISIcovAw5vbjwXKDP5P5+H/qi8C3ZjZCwuYG6GE+oG43qKMHq7
         VX+9xwsSQYs4H8+RKIM9hWjp6SryrKOqR5j/J4bk=
Date:   Fri, 02 Apr 2021 15:01:29 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  + lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch
 added to -mm tree
Message-ID: <20210402220129.rvMKdHi2c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: remove two kvfree_rcu() tests
has been added to the -mm tree.  Its filename is
     lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-improve-allocation-failure-error-messages-fix.patch
lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch
lib-test_vmallocc-add-a-new-nr_threads-parameter.patch
vm-test_vmallocsh-adapt-for-updated-driver-interface.patch
mm-vmalloc-refactor-the-preloading-loagic.patch
mm-vmalloc-remove-an-empty-line.patch

