Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CBEC7EE37
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbjFGCh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbjFGCh1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58922E78
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBA2A639D7
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA04C433D2;
        Wed,  7 Jun 2023 02:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105445;
        bh=WHD/3Zi6urCk05IP5KAo1yIt4UYRMtWdOBpkuKtTW5o=;
        h=Date:To:From:Subject:From;
        b=XZrnyj3pLosrHwmlvVClndtkQj6KIYCyn0VbQATUaIhjz1mIy2WEQ2DYOGD3Vb1o1
         RovrSPj2NXNvPKeG1oxyyJ8oATcRfB7QTRSAfeAoB0ebGiA198kDYnH5gVC/W2sQQ2
         13E9D4pmNVaCYqbGLTH8uLf6Hd4khdgpdw4NPJkI=
Date:   Tue, 06 Jun 2023 19:37:24 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch added to mm-unstable branch
Message-Id: <20230607023725.4DA04C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: .gitignore: add mkdirty, va_high_addr_switch
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch

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
Subject: selftests/mm: .gitignore: add mkdirty, va_high_addr_switch
Date: Tue, 6 Jun 2023 00:16:31 -0700

These new build products were left out of .gitignore, so add them now.

Link: https://lkml.kernel.org/r/20230606071637.267103-6-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-gitignore-add-mkdirty-va_high_addr_switch
+++ a/tools/testing/selftests/mm/.gitignore
@@ -39,3 +39,5 @@ local_config.h
 local_config.mk
 ksm_functional_tests
 mdwe_test
+mkdirty
+va_high_addr_switch
\ No newline at end of file
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch
selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-fix-build-failures-due-to-missing-madv_collapse.patch
selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch

