Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E4FC7EE37
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbjFGChr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240771AbjFGChi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FBA19B1
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D88462F11
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08F9C433EF;
        Wed,  7 Jun 2023 02:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105455;
        bh=sTq8mxx1JYWQWzCN4nSP9eudWZKyHXqSbGaTaUUr0Do=;
        h=Date:To:From:Subject:From;
        b=bfo910AwizZbsM1RBydyPPUBkpyRV+LO/8zJOO/iqHp+xZCIq/CdZWfFSKEjgv3FE
         jpJgBVDI1msczlvLj3TPIW33sND+mTpybOrc2OJedwRDst4RiX3OJhihn+662Dwll+
         gkex5vTpI2tFBd9oYqGjbSw4P7k+Yl2j6rCAEglM=
Date:   Tue, 06 Jun 2023 19:37:35 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kselftest-make-headers-is-a-prerequisite.patch added to mm-unstable branch
Message-Id: <20230607023735.D08F9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: kselftest: "make headers" is a prerequisite
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-kselftest-make-headers-is-a-prerequisite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kselftest-make-headers-is-a-prerequisite.patch

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
Subject: Documentation: kselftest: "make headers" is a prerequisite
Date: Tue, 6 Jun 2023 00:16:36 -0700

As per a discussion with Muhammad Usama Anjum [1], the following is how
one is supposed to build selftests:

    make headers && make -C tools/testing/selftests/mm

However, that's not yet documented anywhere. So add it to
Documentation/dev-tools/kselftest.rst .

[1] https://lore.kernel.org/all/bf910fa5-0c96-3707-cce4-5bcc656b6274@collabora.com/

Link: https://lkml.kernel.org/r/20230606071637.267103-11-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kselftest.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/dev-tools/kselftest.rst~documentation-kselftest-make-headers-is-a-prerequisite
+++ a/Documentation/dev-tools/kselftest.rst
@@ -36,6 +36,7 @@ Running the selftests (hotplug tests are
 
 To build the tests::
 
+  $ make headers
   $ make -C tools/testing/selftests
 
 To run the tests::
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

