Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53E0C77B7A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbjFBCcA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjFBCby (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3687A184
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB3B56385F
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D42EC433D2;
        Fri,  2 Jun 2023 02:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673112;
        bh=t24fS/uTqYccC6oNgEisAy65McntAaZnZ4ZKWoLXjyY=;
        h=Date:To:From:Subject:From;
        b=S31hNddLPEfLIILqoUEtDThqa6xEfBod1hLng3/2CXyad6+xxX9Fw4pZ2Y4r/5d1E
         I+52M+K4LFD+7BGXHgNZGP5qnVqvIfS/tbkR5bEjgq0cms3tpbmXl3u7P1rSmJ14dm
         XQoHU5HzRcybCWnczf1ZYNsKTvCmRSsgkUlJ64Uk=
Date:   Thu, 01 Jun 2023 19:31:51 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch added to mm-unstable branch
Message-Id: <20230602023152.1D42EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix a "possibly uninitialized" warning in pkey-x86.h
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix a "possibly uninitialized" warning in pkey-x86.h
Date: Thu, 1 Jun 2023 18:33:54 -0700

This fixes a real bug, too, because xstate_size()  was assuming that
the stack variable xstate_size was initialized to zero. That's not
guaranteed nor even especially likely.

Link: https://lkml.kernel.org/r/20230602013358.900637-9-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-x86.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pkey-x86.h~selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h
+++ a/tools/testing/selftests/mm/pkey-x86.h
@@ -132,7 +132,7 @@ int pkey_reg_xstate_offset(void)
 	unsigned int ecx;
 	unsigned int edx;
 	int xstate_offset;
-	int xstate_size;
+	int xstate_size = 0;
 	unsigned long XSTATE_CPUID = 0xd;
 	int leaf;
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch
selftests-mm-fix-unused-variable-warning-in-migrationc.patch
selftests-mm-fix-a-char-assignment-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch

