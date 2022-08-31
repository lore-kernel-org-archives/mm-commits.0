Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0794BECAAD1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 21:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiHaVnH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 17:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiHaVnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 17:43:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91197DDB61
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 14:43:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2730061ADE
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 21:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C823C433D6;
        Wed, 31 Aug 2022 21:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661982184;
        bh=VUQiSeRLVWmy578McEDexEmgzQ6bI9leKl3PwjAGKRI=;
        h=Date:To:From:Subject:From;
        b=Kpenu8kRxWrbJd8mmzraXAgVylwxZFQc6MGU/i18OlvwoZm3LUxoNC6dKgDG4KNi2
         4npPmTuIbNA+EV7SFldQr6cKLSvH8/VG4vctL/nfwrzIB2Erh5jxcx+TK4b6GWkc9W
         6JFpQmr9yMfVJgl6ZIu/Dd4Z1ExxpXilb+GBxbaU=
Date:   Wed, 31 Aug 2022 14:43:03 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        vaibhav@linux.ibm.com, tsahu@linux.ibm.com, shuah@kernel.org,
        sbhat@linux.ibm.com, jglisse@redhat.com,
        aneesh.kumar@linux.ibm.com, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch added to mm-unstable branch
Message-Id: <20220831214304.7C823C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: vm: remove orphaned references to local_config.{h,mk}
has been added to the -mm mm-unstable branch.  Its filename is
     kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch

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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: selftest: vm: remove orphaned references to local_config.{h,mk}
Date: Wed, 31 Aug 2022 14:15:26 -0700

Commit b4efb234e53cc60ccdc855190be9f35918687412 ("Kselftests: remove
support of libhugetlbfs from kselftests") removed the rule describing
how to build local_config.{h,mk}, but it left two references to these
files lingering around. The result is, none of the selftests could be
built due to dependencies with no rule for how to build them.

Link: https://lkml.kernel.org/r/20220831211526.2743216-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Tested-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,9 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 
-LOCAL_HDRS += $(selfdir)/vm/local_config.h $(top_srcdir)/mm/gup_test.h
-
-include local_config.mk
+LOCAL_HDRS += $(top_srcdir)/mm/gup_test.h
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
_

Patches currently in -mm which might be from axelrasmussen@google.com are

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch
kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch

