Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCCEEEAA68
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241612AbjINSvi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242191AbjINSvV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:51:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68002132
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:47:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F41DC433C7;
        Thu, 14 Sep 2023 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694717231;
        bh=jLjMBG319q9J36okAzjJiThFZAgnAdhZDpEUtwdFpzM=;
        h=Date:To:From:Subject:From;
        b=wIz4+eF5vv+Ln7CaRg8Y/ItsaojvsNd3Uafa8IAjXiIwpAjWDy2Zr7Nej1MLGjz9Y
         f2tUWa7STYwXOKlC3rb4wLNniawtW6YRRCHL7oqcI3pHl9fXcxrjy2JT+fD/qxq5r+
         JjuEKHb/7rkYNJVg4TnzqEf/32Tsiw2LlNsNqJQo=
Date:   Thu, 14 Sep 2023 11:47:10 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch added to mm-nonmm-unstable branch
Message-Id: <20230914184711.4F41DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_core: change parse_crashkernel() to support crashkernel=,high|low parsing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: crash_core: change parse_crashkernel() to support crashkernel=,high|low parsing
Date: Thu, 14 Sep 2023 11:31:36 +0800

Now parse_crashkernel() is a real entry point for all kinds of crahskernel
parsing on any architecture.

And wrap the crahskernel=,high|low handling inside
CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION ifdeffery scope.

Link: https://lkml.kernel.org/r/20230914033142.676708-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |    6 +++++
 kernel/crash_core.c        |   36 ++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

--- a/include/linux/crash_core.h~crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing
+++ a/include/linux/crash_core.h
@@ -79,6 +79,12 @@ Elf_Word *append_elf_note(Elf_Word *buf,
 			  void *data, size_t data_len);
 void final_note(Elf_Word *buf);
 
+#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+#ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
+#define DEFAULT_CRASH_KERNEL_LOW_SIZE  (128UL << 20)
+#endif
+#endif
+
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base,
 		unsigned long long *low_size, bool *high);
--- a/kernel/crash_core.c~crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing
+++ a/kernel/crash_core.c
@@ -283,6 +283,9 @@ static int __init __parse_crashkernel(ch
 /*
  * That function is the entry point for command line parsing and should be
  * called from the arch-specific code.
+ *
+ * If crashkernel=,high|low is supported on architecture, non-NULL values
+ * should be passed to parameters 'low_size' and 'high'.
  */
 int __init parse_crashkernel(char *cmdline,
 			     unsigned long long system_ram,
@@ -296,10 +299,37 @@ int __init parse_crashkernel(char *cmdli
 	/* crashkernel=X[@offset] */
 	ret = __parse_crashkernel(cmdline, system_ram, crash_size,
 				crash_base, NULL);
-	if (!high)
-		return ret;
+#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+	/*
+	 * If non-NULL 'high' passed in and no normal crashkernel
+	 * setting detected, try parsing crashkernel=,high|low.
+	 */
+	if (high && ret == -ENOENT) {
+		ret = __parse_crashkernel(cmdline, 0, crash_size,
+				crash_base, suffix_tbl[SUFFIX_HIGH]);
+		if (ret || !*crash_size)
+			return -EINVAL;
 
-	return 0;
+		/*
+		 * crashkernel=Y,low can be specified or not, but invalid value
+		 * is not allowed.
+		 */
+		ret = __parse_crashkernel(cmdline, 0, low_size,
+				crash_base, suffix_tbl[SUFFIX_LOW]);
+		if (ret == -ENOENT) {
+			*low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
+			ret = 0;
+		} else if (ret) {
+			return ret;
+		}
+
+		*high = true;
+	}
+#endif
+	if (!*crash_size)
+		ret = -EINVAL;
+
+	return ret;
 }
 
 int __init parse_crashkernel_high(char *cmdline,
_

Patches currently in -mm which might be from bhe@redhat.com are

crash_corec-remove-unnecessary-parameter-of-function.patch
crash_core-change-the-prototype-of-function-parse_crashkernel.patch
crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch
crash_core-add-generic-function-to-do-reservation.patch
crash_core-move-crashk_res-definition-into-crash_corec.patch
x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code.patch
arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash_corec-remove-unneeded-functions.patch

