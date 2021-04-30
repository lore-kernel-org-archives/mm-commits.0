Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5385EC43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3837C61492
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhD3GAH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhD3GAE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E34B56147E;
        Fri, 30 Apr 2021 05:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762357;
        bh=uMEJYTEu8JWJO1lnJvorbm9oMad5wo21avFne0sz66w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=x3KKo2phOBjj+sNnHj2Sz3jwybGI7QFgHnSHDgTCk2LaQ5KPLlM+nk3fg6qjLgoqC
         Oqhw00YhbTdt8nUiLgPuBPvJA0QmR3nL49zD7GBih4DmQ22AJJj3yNf4T5BceCuDOa
         u8jaRdwB3gUxUE4hD0V+Vh3R54qgtNt0jLDaayiE=
Date:   Thu, 29 Apr 2021 22:59:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [patch 118/178] vm/test_vmalloc.sh: adapt for updated
 driver interface
Message-ID: <20210430055916.WnQUXIvXC%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vm/test_vmalloc.sh: adapt for updated driver interface

A 'single_cpu_test' parameter is odd and it does not exist anymore. 
Instead there was introduced a 'nr_threads' one.  If it is not set it
behaves as the former parameter.

That is why update a "stress mode" according to this change specifying
number of workers which are equal to number of CPUs.  Also update an
output of help message based on a new interface.

Link: https://lkml.kernel.org/r/20210402202237.20334-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/test_vmalloc.sh |   21 +++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/vm/test_vmalloc.sh~vm-test_vmallocsh-adapt-for-updated-driver-interface
+++ a/tools/testing/selftests/vm/test_vmalloc.sh
@@ -11,6 +11,7 @@
 
 TEST_NAME="vmalloc"
 DRIVER="test_${TEST_NAME}"
+NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
 
 # 1 if fails
 exitcode=1
@@ -22,9 +23,9 @@ ksft_skip=4
 # Static templates for performance, stressing and smoke tests.
 # Also it is possible to pass any supported parameters manualy.
 #
-PERF_PARAM="single_cpu_test=1 sequential_test_order=1 test_repeat_count=3"
-SMOKE_PARAM="single_cpu_test=1 test_loop_count=10000 test_repeat_count=10"
-STRESS_PARAM="test_repeat_count=20"
+PERF_PARAM="sequential_test_order=1 test_repeat_count=3"
+SMOKE_PARAM="test_loop_count=10000 test_repeat_count=10"
+STRESS_PARAM="nr_threads=$NUM_CPUS test_repeat_count=20"
 
 check_test_requirements()
 {
@@ -58,8 +59,8 @@ run_perfformance_check()
 
 run_stability_check()
 {
-	echo "Run stability tests. In order to stress vmalloc subsystem we run"
-	echo "all available test cases on all available CPUs simultaneously."
+	echo "Run stability tests. In order to stress vmalloc subsystem all"
+	echo "available test cases are run by NUM_CPUS workers simultaneously."
 	echo "It will take time, so be patient."
 
 	modprobe $DRIVER $STRESS_PARAM > /dev/null 2>&1
@@ -92,17 +93,17 @@ usage()
 	echo "# Shows help message"
 	echo "./${DRIVER}.sh"
 	echo
-	echo "# Runs 1 test(id_1), repeats it 5 times on all online CPUs"
-	echo "./${DRIVER}.sh run_test_mask=1 test_repeat_count=5"
+	echo "# Runs 1 test(id_1), repeats it 5 times by NUM_CPUS workers"
+	echo "./${DRIVER}.sh nr_threads=$NUM_CPUS run_test_mask=1 test_repeat_count=5"
 	echo
 	echo -n "# Runs 4 tests(id_1|id_2|id_4|id_16) on one CPU with "
 	echo "sequential order"
-	echo -n "./${DRIVER}.sh single_cpu_test=1 sequential_test_order=1 "
+	echo -n "./${DRIVER}.sh sequential_test_order=1 "
 	echo "run_test_mask=23"
 	echo
-	echo -n "# Runs all tests on all online CPUs, shuffled order, repeats "
+	echo -n "# Runs all tests by NUM_CPUS workers, shuffled order, repeats "
 	echo "20 times"
-	echo "./${DRIVER}.sh test_repeat_count=20"
+	echo "./${DRIVER}.sh nr_threads=$NUM_CPUS test_repeat_count=20"
 	echo
 	echo "# Performance analysis"
 	echo "./${DRIVER}.sh performance"
_
