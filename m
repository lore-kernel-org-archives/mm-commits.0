Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D4AC77B73
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 20:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDNUwN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 16:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDNUwM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 16:52:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B58F3C07
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 13:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3994E64A4D
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 20:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB11C433D2;
        Fri, 14 Apr 2023 20:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681505529;
        bh=0ws5AN2NbIH4ST4sswkZCQyFuWCFWPmANU062Qgn9eg=;
        h=Date:To:From:Subject:From;
        b=dPSXqszxcd2rDk++fqeMZ9CPjxRcp9g4VybIywC7ocwjCayd2A66Q4/Y3DkqU2Adj
         zJAEvX5VwwW8K655GaA62yYUbLP4Y4dXxcnooJoKfRoKyV009qW0nhJ8sPzctmHIxt
         y63UZVJttGa1S+ZbymLXIRapR1LkpQfrds14xcLg=
Date:   Fri, 14 Apr 2023 13:52:08 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mark.rutland@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run-hugetlb-testcases-of-va-switch.patch added to mm-unstable branch
Message-Id: <20230414205209.8CB11C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: run hugetlb testcases of va switch
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-run-hugetlb-testcases-of-va-switch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run-hugetlb-testcases-of-va-switch.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Subject: selftests/mm: run hugetlb testcases of va switch
Date: Thu, 23 Mar 2023 16:22:43 +0530

The va_high_addr_switch selftest is used to test mmap across 128TB
boundary.  It divides the selftest cases into two main categories on the
basis of size.  One set is used to create mappings that are multiples of
PAGE_SIZE while the other creates mappings that are multiples of
HUGETLB_SIZE.

In order to run the hugetlb testcases the binary must be appended with
"--run-hugetlb" but the file that used to run the test only invokes the
binary, thereby completely skipping the hugetlb testcases.  Hence, the
required statement has been added.

Link: https://lkml.kernel.org/r/20230323105243.2807166-6-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-run-hugetlb-testcases-of-va-switch
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -52,3 +52,7 @@ check_test_requirements()
 
 check_test_requirements
 ./va_high_addr_switch
+
+# In order to run hugetlb testcases, "--run-hugetlb" must be appended
+# to the binary.
+./va_high_addr_switch --run-hugetlb
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are

selftests-mm-add-support-for-arm64-platform-on-va-switch.patch
selftests-mm-rename-va_128tbswitch-to-va_high_addr_switch.patch
selftests-mm-add-platform-independent-in-code-comments.patch
selftests-mm-configure-nr_hugepages-for-arm64.patch
selftests-mm-run-hugetlb-testcases-of-va-switch.patch

