Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01B1C761AF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCWBdP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCWBdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E812435AD
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 157A5623A1
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AFEC4339B;
        Thu, 23 Mar 2023 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535135;
        bh=RWQio+g5HszZlXvtJl7ld02g59fsE96f8lqTrrIS+Nc=;
        h=Date:To:From:Subject:From;
        b=Fkvil0o3IFuHjPgujmofRLRLY/P5MvesGeYBfzuooUwFuLHs/uTwGFlHK50lJHKxv
         Yy72weSfHYC7MGOKVB5Bsth0CeKX5HxjD7PqIiOETsENXZ8xseEAU23E+qzQ8O9Du2
         Yda1Hgo0EEdQU9cUXMCUQgSmyx47tZbiJ6s3ZFaA=
Date:   Wed, 22 Mar 2023 18:32:14 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, nd@arm.com,
        keescook@chromium.org, joey.gouly@arm.com, izbyshev@ispras.ru,
        catalin.marinas@arm.com, acme@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch removed from -mm tree
Message-Id: <20230323013215.68AFEC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools headers UAPI: sync linux/prctl.h with the kernel sources
has been removed from the -mm tree.  Its filename was
     tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: tools headers UAPI: sync linux/prctl.h with the kernel sources
Date: Wed, 8 Mar 2023 19:04:23 +0000

Sync prctl.h after the changes in b507808ebce ("mm: implement
memory-deny-write-execute as a prctl")

[joey.gouly@arm.com: add commit message]
Link: https://lkml.kernel.org/r/20230308190423.46491-5-joey.gouly@arm.com
Fixes: 4cf1fe34fd18 ("kselftest: vm: add tests for memory-deny-write-execute")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

