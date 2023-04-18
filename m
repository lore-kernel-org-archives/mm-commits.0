Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE85BC77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjDRXjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjDRXhh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:37:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6083B46E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7B9060F25
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0B6C433EF;
        Tue, 18 Apr 2023 23:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860962;
        bh=AuxTl0807IFVWFy8xF0F1tUHuEhaXjzFyKg1xfa6LUw=;
        h=Date:To:From:Subject:From;
        b=jq1m5SaVIgvXAL+BzBvtOunFvc1GnRmLrNb5WgfTdUMLWp13tuuUrjtg5wWxUuLYN
         RGsxnxmXy9MlTfDpWTbjVEdSQvF6zrPuI3Q5Zbw6rS+Vdq/hw3Q7oxVl5whV1CmrSC
         4wF9t4Y3FYtBnwMZOyK7zvJnfoETGZ4m/TIQMXTs=
Date:   Tue, 18 Apr 2023 16:36:01 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mark.rutland@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run-hugetlb-testcases-of-va-switch.patch removed from -mm tree
Message-Id: <20230418233602.1A0B6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: run hugetlb testcases of va switch
has been removed from the -mm tree.  Its filename was
     selftests-mm-run-hugetlb-testcases-of-va-switch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


