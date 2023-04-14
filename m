Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4058EC77B71
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 20:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjDNUwM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 16:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDNUwK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 16:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEA010DF
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 13:52:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E3C664A4B
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 20:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99E5C433EF;
        Fri, 14 Apr 2023 20:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681505528;
        bh=hiGncxYLjGx5WicEzEZ3ISLHiU45778Qu9LWzKzrYHw=;
        h=Date:To:From:Subject:From;
        b=KkybfKk7OeRNnhSQznAIqsfQiT+WmatdQH+wgDvj3Fu9JtgY6pB7jpqetA98JuIQr
         4ZSLd4vyvIc/Pi3W+8ApUAI1Cg9YZ3RQ52GN/vQ+ZfJIyJXfDtwjA1bDgWtNzSxLWh
         2rLA2mlpOGltl2kIuBOFyz9VSW0fg0sbi87TAbks=
Date:   Fri, 14 Apr 2023 13:52:07 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mark.rutland@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-configure-nr_hugepages-for-arm64.patch added to mm-unstable branch
Message-Id: <20230414205207.E99E5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: configure nr_hugepages for arm64
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-configure-nr_hugepages-for-arm64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-configure-nr_hugepages-for-arm64.patch

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
Subject: selftests/mm: configure nr_hugepages for arm64
Date: Thu, 23 Mar 2023 16:22:42 +0530

Arm64 has a default hugepage size of 512MB when CONFIG_ARM64_64K_PAGES=y
is enabled.  While testing on arm64 platforms having up to 4PB of virtual
address space, a minimum of 6 hugepages were required for all test cases
to pass.  Support for this requirement has been added.

Link: https://lkml.kernel.org/r/20230323105243.2807166-5-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-configure-nr_hugepages-for-arm64
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -236,8 +236,16 @@ if [ $VADDR64 -ne 0 ]; then
 	CATEGORY="hugevm" run_test ./virtual_address_range
 	echo $prev_policy > /proc/sys/vm/overcommit_memory
 
-	# virtual address 128TB switch test
+	# va high address boundary switch test
+	ARCH_ARM64="arm64"
+	prev_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
+	if [ "$ARCH" == "$ARCH_ARM64" ]; then
+		echo 6 > /proc/sys/vm/nr_hugepages
+	fi
 	CATEGORY="hugevm" run_test ./va_high_addr_switch.sh
+	if [ "$ARCH" == "$ARCH_ARM64" ]; then
+		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
+	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are

selftests-mm-add-support-for-arm64-platform-on-va-switch.patch
selftests-mm-rename-va_128tbswitch-to-va_high_addr_switch.patch
selftests-mm-add-platform-independent-in-code-comments.patch
selftests-mm-configure-nr_hugepages-for-arm64.patch
selftests-mm-run-hugetlb-testcases-of-va-switch.patch

