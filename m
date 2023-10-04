Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F4DE936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244499AbjJDUZR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244937AbjJDUYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:24:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA86610F5
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:24:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8E7C433C7;
        Wed,  4 Oct 2023 20:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451041;
        bh=OpNMI9W43QrCBF5FyYqImpu02N4/twd2GOz7+cMzh+A=;
        h=Date:To:From:Subject:From;
        b=Hmcgz2aFW4LyT3WsglQNR+NcgkcLp1H11bgDpItGUY6ZENFrEDHD5h6NvVIf0q9oX
         7tbWQXqOowogfD8drmCqhz7hv//SuUUM65fkyAVXfkPGldOZ+22nsaEFQHyW7yPHFc
         WfjKWZVySSaobFret0FXs+mEGKTnEtmyIzXw75sU=
Date:   Wed, 04 Oct 2023 13:23:59 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch removed from -mm tree
Message-Id: <20231004202401.4A8E7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: crash_core: change parse_crashkernel() to support crashkernel=,high|low parsing
has been removed from the -mm tree.  Its filename was
     crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
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


