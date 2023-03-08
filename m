Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D285BC678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCHUIz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjCHUIy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:08:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748E074A41
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:08:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF6B61944
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63818C433EF;
        Wed,  8 Mar 2023 20:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678306131;
        bh=0a8ONkgJvMeucfrFeSyTeUbyYC3DImCfIYpGAh/Ipmc=;
        h=Date:To:From:Subject:From;
        b=IiDQOpIyP1AJ4nx8X+tizyWYJOfhRcQtbfj90NPTk4/56CPGKXOzrR7EQA2c1O700
         9t/+kElGeYnImbHXhwSe2OEmfaBKXMh3ye3556ZWkhQ5tdEEqcqNJB5hEApSljDWSY
         iuQz60Njk3XKB0dD0dpaH7jY67eLjdnE9YQvrFQU=
Date:   Wed, 08 Mar 2023 12:08:50 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, nd@arm.com,
        keescook@chromium.org, joey.gouly@arm.com, izbyshev@ispras.ru,
        catalin.marinas@arm.com, acme@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch added to mm-hotfixes-unstable branch
Message-Id: <20230308200851.63818C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools headers UAPI: Sync linux/prctl.h with the kernel sources
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Peter Xu <peterx@redhat.com>
Subject: tools headers UAPI: Sync linux/prctl.h with the kernel sources
Date: Wed, 8 Mar 2023 19:04:23 +0000

Sync prctl.h after the changes in b507808ebce ("mm: implement
memory-deny-write-execute as a prctl")

[joey.gouly@arm.com: add commit message]
Link: https://lkml.kernel.org/r/20230308190423.46491-5-joey.gouly@arm.com
Fixes: 4cf1fe34fd18 ("kselftest: vm: add tests for memory-deny-write-execute")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Kees Cook <keescook@chromium.org>
Cc: nd <nd@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/include/uapi/linux/prctl.h~tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources
+++ a/tools/include/uapi/linux/prctl.h
@@ -281,6 +281,12 @@ struct prctl_mm_map {
 # define PR_SME_VL_LEN_MASK		0xffff
 # define PR_SME_VL_INHERIT		(1 << 17) /* inherit across exec */
 
+/* Memory deny write / execute */
+#define PR_SET_MDWE			65
+# define PR_MDWE_REFUSE_EXEC_GAIN	1
+
+#define PR_GET_MDWE			66
+
 #define PR_SET_VMA		0x53564d41
 # define PR_SET_VMA_ANON_NAME		0
 
_

Patches currently in -mm which might be from peterx@redhat.com are

kselftest-vm-fix-unused-variable-warning.patch
tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch

