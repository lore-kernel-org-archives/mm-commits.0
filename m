Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAE5C7EE24
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 22:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbjFEWov (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjFEWon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 18:44:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD978F9
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 15:44:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F23862B75
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 22:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F7DC433EF;
        Mon,  5 Jun 2023 22:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686005081;
        bh=Kaw6FoqkWo94PBUaWGOll/o3ZiOq/3uCZwyHeckyEvk=;
        h=Date:To:From:Subject:From;
        b=KTK1iMOXex9yX+UNFbc5GaMIhG1VgIYlitaXyPBBL+kT+z7FUbWfavCpqblDKxabR
         h4+Jcz00WejNAD9kY0O8PytsDIHBZ+mywoEOnJnpK3t0txT1hAJJjO1OMTJeftIK9N
         yU126lyP92kbpmH8Xs90+e9Fedlkzaohd+/Ip1wg=
Date:   Mon, 05 Jun 2023 15:44:41 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch added to mm-unstable branch
Message-Id: <20230605224441.B1F7DC433EF@smtp.kernel.org>
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
Date: Fri, 2 Jun 2023 19:15:54 -0700

This fixes a real bug, too, because xstate_size()  was assuming that
the stack variable xstate_size was initialized to zero. That's not
guaranteed nor even especially likely.

Link: https://lkml.kernel.org/r/20230603021558.95299-8-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
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

