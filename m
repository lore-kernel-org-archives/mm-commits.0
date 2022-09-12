Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85663ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiILAgF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiILAgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:36:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF65252BA
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCF75B802BD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF8FC433D6;
        Mon, 12 Sep 2022 00:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662942961;
        bh=Y+GMSBU39j+nWXoRWF4pzpq8YL4Clym5hYFfW8AXcB4=;
        h=Date:To:From:Subject:From;
        b=VSqAT8hmrRWRK11QI4Tpl6s/xa9S2ZKascgzO6LqwSShwkpL1Lfo9SfpJQaC2QVp5
         LZN/U4nBLHIDdUG+SODgD0AGjX//DnKByXPee9ZoxS0mokSqGKoNRMXwHRll5wbPJQ
         W6842ZwzZV+4JtBOdxLayjgyV7p60fex8grLDW1g=
Date:   Sun, 11 Sep 2022 17:36:00 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        vaibhav@linux.ibm.com, tsahu@linux.ibm.com, shuah@kernel.org,
        sbhat@linux.ibm.com, jglisse@redhat.com,
        aneesh.kumar@linux.ibm.com, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch removed from -mm tree
Message-Id: <20220912003601.7CF8FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest: vm: remove orphaned references to local_config.{h,mk}
has been removed from the -mm tree.  Its filename was
     kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch

This patch was dropped because it was folded into kselftests-removing-support-of-libhugetlbfs-from-kselftests.patch

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
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch
kselftests-removing-support-of-libhugetlbfs-from-kselftests.patch

