Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E64C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 22:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjFEWoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjFEWok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 18:44:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396B5106
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 15:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C186662B78
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 22:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE7DC433D2;
        Mon,  5 Jun 2023 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686005078;
        bh=jpFBx0/wE1L5yff65bo7WSxYEPeSng2ghQJtfWWbEjA=;
        h=Date:To:From:Subject:From;
        b=RuNWuz/pmMyk67OfD4GYr8BVDlMDp7xSu8iALcouqzI9auNOdASFrlCwc+EjroTka
         N7+aaIPTtcx1TMwC19ZsKIn6y5yYiesrmnadr80gmcLLdpN9F8CNYz6msZ1rwF0PAV
         LfRQE2a3hdjDBYq0LXgPp9koMBi1AhpuG91Wbp2A=
Date:   Mon, 05 Jun 2023 15:44:37 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch added to mm-unstable branch
Message-Id: <20230605224438.1CE7DC433D2@smtp.kernel.org>
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
Date: Fri, 2 Jun 2023 19:15:52 -0700

These new build products were left out of .gitignore, so add them now.

Link: https://lkml.kernel.org/r/20230603021558.95299-6-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
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
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

