Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FBFC77B71
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 20:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDNUwD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 16:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjDNUwD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 16:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B53030D8
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 13:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A37FF64942
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 20:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2121C433EF;
        Fri, 14 Apr 2023 20:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681505521;
        bh=Q7DUimJT0YMCpVO7spvrANPp2zIrijV/gzmuk11/5uI=;
        h=Date:To:From:Subject:From;
        b=wescn1FT0MeflS4Hh0lT5+DBWsQF535xe66mUcAxshumJ/3Ska2ms0QdYAjGTYcFW
         T2XxmPph4orr3ZITrTUwGJHPCjyxVXQGsKzVT/jX9K0Y/ZgWd6yZR1OlvvcRKVn4FQ
         rioV1B51w8qqcofQrXztBeCzBp926xki8nFRoPiM=
Date:   Fri, 14 Apr 2023 13:52:00 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mark.rutland@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-support-for-arm64-platform-on-va-switch.patch added to mm-unstable branch
Message-Id: <20230414205200.F2121C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add support for arm64 platform on va switch
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-support-for-arm64-platform-on-va-switch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-support-for-arm64-platform-on-va-switch.patch

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
Subject: selftests/mm: add support for arm64 platform on va switch
Date: Thu, 23 Mar 2023 16:22:39 +0530

Patch series "selftests/mm: Implement support for arm64 on va".

The va_128TBswitch selftest is designed and implemented for PowerPC and
x86 architectures which support a 128TB switch, up to 256TB of virtual
address space and hugepage sizes of 16MB and 2MB respectively.  Arm64
platforms on the other hand support a 256Tb switch, up to 4PB of virtual
address space and a default hugepage size of 512MB when 64k pagesize is
enabled.

These architectural differences require introducing support for arm64
platforms, after which a more generic naming convention is suggested.  The
in code comments are amended to provide a more platform independent
explanation of the working of the code and nr_hugepages are configured as
required.  Finally, the file running the testcase is modified in order to
prevent skipping of hugetlb testcases of va_high_addr_switch.


This patch (of 5):

Arm64 platforms have the ability to support 64kb pagesize, 512MB default
hugepage size and up to 4PB of virtual address space.  The address switch
occurs at 256TB as opposed to 128TB.  Hence, the necessary support has
been added.

Link: https://lkml.kernel.org/r/20230323105243.2807166-1-chaitanyas.prakash@arm.com
Link: https://lkml.kernel.org/r/20230323105243.2807166-2-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_128TBswitch.c |   26 ++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/va_128TBswitch.c~selftests-mm-add-support-for-arm64-platform-on-va-switch
+++ a/tools/testing/selftests/mm/va_128TBswitch.c
@@ -17,6 +17,13 @@
  * This will work with 16M and 2M hugepage size
  */
 #define HUGETLB_SIZE	(16 << 20)
+#elif __aarch64__
+/*
+ * The default hugepage size for 64k base pagesize
+ * is 512MB.
+ */
+#define PAGE_SIZE	(64 << 10)
+#define HUGETLB_SIZE	(512 << 20)
 #else
 #define PAGE_SIZE	(4 << 10)
 #define HUGETLB_SIZE	(2 << 20)
@@ -26,9 +33,22 @@
  * >= 128TB is the hint addr value we used to select
  * large address space.
  */
-#define ADDR_SWITCH_HINT (1UL << 47)
+
+#define ADDR_MARK_128TB	(1UL << 47)
+#define ADDR_MARK_256TB	(1UL << 48)
+
+#define HIGH_ADDR_128TB	((void *) (1UL << 48))
+#define HIGH_ADDR_256TB	((void *) (1UL << 49))
+
 #define LOW_ADDR	((void *) (1UL << 30))
-#define HIGH_ADDR	((void *) (1UL << 48))
+
+#ifdef __aarch64__
+#define ADDR_SWITCH_HINT ADDR_MARK_256TB
+#define HIGH_ADDR	 HIGH_ADDR_256TB
+#else
+#define ADDR_SWITCH_HINT ADDR_MARK_128TB
+#define HIGH_ADDR	 HIGH_ADDR_128TB
+#endif
 
 struct testcase {
 	void *addr;
@@ -270,6 +290,8 @@ static int supported_arch(void)
 	return 1;
 #elif defined(__x86_64__)
 	return 1;
+#elif defined(__aarch64__)
+	return 1;
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are

selftests-mm-add-support-for-arm64-platform-on-va-switch.patch
selftests-mm-rename-va_128tbswitch-to-va_high_addr_switch.patch
selftests-mm-add-platform-independent-in-code-comments.patch
selftests-mm-configure-nr_hugepages-for-arm64.patch
selftests-mm-run-hugetlb-testcases-of-va-switch.patch

