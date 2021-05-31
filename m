Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E0CC47080
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46166124B
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhEaXRy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 19:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231144AbhEaXRx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 19:17:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C7261186;
        Mon, 31 May 2021 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622502972;
        bh=E/O2EhZsX/BOn709+oRfB9Jx08vk5APtJdvC7tJebJE=;
        h=Date:From:To:Subject:From;
        b=1xYEhDEJX1TwK3PdAdWk7ldpcCcyuCF3jv0Y6OAgncNaIqlTywPLOARUrOUqZ3tBr
         8s10vuZcOBwBbWdDj7UyPzL2BP2b9ZNv06wGAVCOIDl/TyFChYwsWPJrJBaqZGY7BT
         yPAjp19ERItmdOlTy9iv0RhTgKZGywezTuz5Hbdg=
Date:   Mon, 31 May 2021 16:16:11 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sunnanyong@huawei.com,
        wangkefeng.wang@huawei.com, yang.shi@linux.alibaba.com,
        ziy@nvidia.com
Subject:  + khugepaged-selftests-remove-debug_cow.patch added to
 -mm tree
Message-ID: <20210531231611.9fnhQQQ3K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: selftests: remove debug_cow
has been added to the -mm tree.  Its filename is
     khugepaged-selftests-remove-debug_cow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/khugepaged-selftests-remove-debug_cow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-selftests-remove-debug_cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: khugepaged: selftests: remove debug_cow

The debug_cow attribute had been removed since commit 4958e4d86ecb01 ("mm:
thp: remove debug_cow switch"), so remove it in selftest code too,
otherwise the khugepaged test will fail.

Link: https://lkml.kernel.org/r/20210430051117.400189-1-sunnanyong@huawei.com
Fixes: 4958e4d86ecb01 ("mm: thp: remove debug_cow switch")
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~khugepaged-selftests-remove-debug_cow
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -86,7 +86,6 @@ struct settings {
 	enum thp_enabled thp_enabled;
 	enum thp_defrag thp_defrag;
 	enum shmem_enabled shmem_enabled;
-	bool debug_cow;
 	bool use_zero_page;
 	struct khugepaged_settings khugepaged;
 };
@@ -95,7 +94,6 @@ static struct settings default_settings
 	.thp_enabled = THP_MADVISE,
 	.thp_defrag = THP_DEFRAG_ALWAYS,
 	.shmem_enabled = SHMEM_NEVER,
-	.debug_cow = 0,
 	.use_zero_page = 0,
 	.khugepaged = {
 		.defrag = 1,
@@ -268,7 +266,6 @@ static void write_settings(struct settin
 	write_string("defrag", thp_defrag_strings[settings->thp_defrag]);
 	write_string("shmem_enabled",
 			shmem_enabled_strings[settings->shmem_enabled]);
-	write_num("debug_cow", settings->debug_cow);
 	write_num("use_zero_page", settings->use_zero_page);
 
 	write_num("khugepaged/defrag", khugepaged->defrag);
@@ -304,7 +301,6 @@ static void save_settings(void)
 		.thp_defrag = read_string("defrag", thp_defrag_strings),
 		.shmem_enabled =
 			read_string("shmem_enabled", shmem_enabled_strings),
-		.debug_cow = read_num("debug_cow"),
 		.use_zero_page = read_num("use_zero_page"),
 	};
 	saved_settings.khugepaged = (struct khugepaged_settings) {
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

khugepaged-selftests-remove-debug_cow.patch

