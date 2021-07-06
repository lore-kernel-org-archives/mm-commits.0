Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D966BC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E0261C85
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhGFTTn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhGFTTm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A4161C87;
        Tue,  6 Jul 2021 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599022;
        bh=Kj9n5qcSh7MLhuSLpIyqTgonoAxM1TvKLziOdI/QQgk=;
        h=Date:From:To:Subject:From;
        b=H8zrEKFZccd/NrA/wlqyMXSoNfWBpqL8+IMXeWiaybwedMgVYGeBl7dyb1WUY8cIt
         iRo8CLQgkfY8efPCikFWAJGNhKAsI2uWWs/QmBJUPfC9RYUgRBD7pk8NOiXVgIrnU/
         tMheu40yleLAd/7LExcS3LLSxKKzFm5MfS+d+VQw=
Date:   Tue, 06 Jul 2021 12:17:02 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sunnanyong@huawei.com,
        wangkefeng.wang@huawei.com, yang.shi@linux.alibaba.com,
        ziy@nvidia.com
Subject:  [merged] khugepaged-selftests-remove-debug_cow.patch
 removed from -mm tree
Message-ID: <20210706191702.0feJDXuto%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: selftests: remove debug_cow
has been removed from the -mm tree.  Its filename was
     khugepaged-selftests-remove-debug_cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


