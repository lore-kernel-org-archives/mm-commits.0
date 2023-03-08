Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86735C64EC4
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCHUIy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCHUIx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:08:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234F473AC0
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E119618D9
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E45C433EF;
        Wed,  8 Mar 2023 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678306129;
        bh=ineQvNJec/pkRYilB09vlRgM4HnHxf7A1KQ1g6JO8Hs=;
        h=Date:To:From:Subject:From;
        b=1iXISA3ip8k08PSvlQV2jz0vAHDByHafeoLyujB1tK0yxjOKYflWRej50MIGjWDbj
         JVY8ODZPxzSLN3mIvdsOqIi6R5uLTgvyeoHW8IpcZTiIuF8Wp0HA+cX3/M9bl1V7n8
         jDWD+NWTd/mptWsLba2Jn6m3gdFlbx2kr0S+NMXo=
Date:   Wed, 08 Mar 2023 12:08:49 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, nd@arm.com,
        keescook@chromium.org, joey.gouly@arm.com, izbyshev@ispras.ru,
        catalin.marinas@arm.com, acme@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-fix-unused-variable-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20230308200849.97E45C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest: vm: fix unused variable warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kselftest-vm-fix-unused-variable-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-vm-fix-unused-variable-warning.patch

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
Subject: kselftest: vm: fix unused variable warning
Date: Wed, 8 Mar 2023 19:04:22 +0000

Remove unused variable from the MDWE test.

[joey.gouly@arm.com: add commit message]
Link: https://lkml.kernel.org/r/20230308190423.46491-4-joey.gouly@arm.com
Fixes: 4cf1fe34fd18 ("kselftest: vm: add tests for memory-deny-write-execute")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

kselftest-vm-fix-unused-variable-warning.patch
tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch

