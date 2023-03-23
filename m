Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ACCC74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCWBdO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCWBdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D6F30B08
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1E37B81EB5
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDC3C433D2;
        Thu, 23 Mar 2023 01:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535134;
        bh=TT/TkEwsIJD8dgC9jzt1+hh0/r9jYhTS5sLFdHi+3pA=;
        h=Date:To:From:Subject:From;
        b=e6SEkkaI5/kZZ6zZ6rpfZRjVFG78t6Ib0kB0+i3YHTT8vmJCJCH3g3ZG9ewQ7Gj+3
         R8R3CCN8G1cczDfDw2Cqln/fcnps75FR2BbbcMsrJNrVRfAPOp/5YAWou7bWpWMfno
         fd+uRPjsEbbUkT/SwkqflD7Quax0R89D7dejS56Y=
Date:   Wed, 22 Mar 2023 18:32:13 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, nd@arm.com,
        keescook@chromium.org, joey.gouly@arm.com, izbyshev@ispras.ru,
        catalin.marinas@arm.com, acme@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kselftest-vm-fix-unused-variable-warning.patch removed from -mm tree
Message-Id: <20230323013214.5CDC3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftest: vm: fix unused variable warning
has been removed from the -mm tree.  Its filename was
     kselftest-vm-fix-unused-variable-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: kselftest: vm: fix unused variable warning
Date: Wed, 8 Mar 2023 19:04:22 +0000

Remove unused variable from the MDWE test.

[joey.gouly@arm.com: add commit message]
Link: https://lkml.kernel.org/r/20230308190423.46491-4-joey.gouly@arm.com
Fixes: 4cf1fe34fd18 ("kselftest: vm: add tests for memory-deny-write-execute")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: nd <nd@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/mm/mdwe_test.c~kselftest-vm-fix-unused-variable-warning
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -163,9 +163,8 @@ TEST_F(mdwe, mprotect_WRITE_EXEC)
 
 TEST_F(mdwe, mmap_FIXED)
 {
-	void *p, *p2;
+	void *p;
 
-	p2 = mmap(NULL, self->size, PROT_READ | PROT_EXEC, self->flags, 0, 0);
 	self->p = mmap(NULL, self->size, PROT_READ, self->flags, 0, 0);
 	ASSERT_NE(self->p, MAP_FAILED);
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

