Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564B3C43460
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 22:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2129761184
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 22:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhDBWBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 18:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhDBWBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 18:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D817661183;
        Fri,  2 Apr 2021 22:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617400896;
        bh=9jEuIfMe1aNLeqluhem1MT1e5jOkQDcTqvv9RObtSe4=;
        h=Date:From:To:Subject:From;
        b=lX2en3CmZXXMWCTrYRWA60SyEzZXLAfedszH73O5qkXC6zKbvy6vxWuPN0gqh1PVU
         w174pVj8DWckGAoEm1okKGh9WSYKVROLGWDLCn9RdTX61LA/gKu1zCxQunf+yJwcXA
         DrdAvYxOjeX1JHJpN76AZaZXP5H8yLybP16fLYuI=
Date:   Fri, 02 Apr 2021 15:01:35 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  +
 vm-test_vmallocsh-adapt-for-updated-driver-interface.patch added to -mm
 tree
Message-ID: <20210402220135.1QZGBgSB0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vm/test_vmalloc.sh: adapt for updated driver interface
has been added to the -mm tree.  Its filename is
     vm-test_vmallocsh-adapt-for-updated-driver-interface.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vm-test_vmallocsh-adapt-for-updated-driver-interface.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vm-test_vmallocsh-adapt-for-updated-driver-interface.patch

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

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-improve-allocation-failure-error-messages-fix.patch
lib-test_vmallocc-remove-two-kvfree_rcu-tests.patch
lib-test_vmallocc-add-a-new-nr_threads-parameter.patch
vm-test_vmallocsh-adapt-for-updated-driver-interface.patch
mm-vmalloc-refactor-the-preloading-loagic.patch
mm-vmalloc-remove-an-empty-line.patch

