Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6A9C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CBCB61452
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhD3Fc3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3Fc1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F3A3613D8;
        Fri, 30 Apr 2021 05:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760700;
        bh=KNqn5f1g2ul1EgJPQPpx0JUVHbAa0CAv2rc4LvBUPpk=;
        h=Date:From:To:Subject:From;
        b=ImYCUf4BYtqwlDNtG62rxVa6klVHUSp+Iar8KRIXrxdzaT8JbxRBv2TO5UapZUh0T
         wMx3Nn0ZQS3WXo0JtpT0cSwtG2bKefQcwdQv/L3MzLfXlBV7T/HWz1miJsd9zoko5J
         rJRtkyug0fCPWrqLgkzSaHutS2UnrbPlXt735ccQ=
Date:   Thu, 29 Apr 2021 22:31:39 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  [folded-merged]
 lib-test_vmallocc-add-a-new-nr_threads-parameter-fix.patch removed from -mm
 tree
Message-ID: <20210430053139.dNvCZ8iGe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: extend max value of nr_threads parameter
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-add-a-new-nr_threads-parameter-fix.patch

This patch was dropped because it was folded into lib-test_vmallocc-add-a-new-nr_threads-parameter.patch

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: extend max value of nr_threads parameter

Currently a maximum value is set to 1024 workers the user can
create during the test. It might be that for some big systems
it is not enough. Since it is a test thing we can give testers
more flexibility.

Increase that number till USHRT_MAX that corresponds to 65535.

Link: https://lkml.kernel.org/r/20210406124536.19658-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-add-a-new-nr_threads-parameter-fix
+++ a/lib/test_vmalloc.c
@@ -24,7 +24,7 @@
 	MODULE_PARM_DESC(name, msg)				\
 
 __param(int, nr_threads, 0,
-	"Number of workers to perform tests(min: 1 max: 1024)");
+	"Number of workers to perform tests(min: 1 max: USHRT_MAX)");
 
 __param(bool, sequential_test_order, false,
 	"Use sequential stress tests order");
@@ -469,13 +469,13 @@ init_test_configurtion(void)
 {
 	/*
 	 * A maximum number of workers is defined as hard-coded
-	 * value and set to 1024. We add such gap just in case
-	 * and for potential heavy stressing.
+	 * value and set to USHRT_MAX. We add such gap just in
+	 * case and for potential heavy stressing.
 	 */
-	nr_threads = clamp(nr_threads, 1, 1024);
+	nr_threads = clamp(nr_threads, 1, (int) USHRT_MAX);
 
 	/* Allocate the space for test instances. */
-	tdriver = kcalloc(nr_threads, sizeof(*tdriver), GFP_KERNEL);
+	tdriver = kvcalloc(nr_threads, sizeof(*tdriver), GFP_KERNEL);
 	if (tdriver == NULL)
 		return -1;
 
@@ -555,7 +555,7 @@ static void do_concurrent_test(void)
 			i, t->stop - t->start);
 	}
 
-	kfree(tdriver);
+	kvfree(tdriver);
 }
 
 static int vmalloc_test_init(void)
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch
lib-test_vmallocc-add-a-new-nr_threads-parameter.patch
vm-test_vmallocsh-adapt-for-updated-driver-interface.patch
mm-vmalloc-refactor-the-preloading-loagic.patch
mm-vmalloc-remove-an-empty-line.patch

