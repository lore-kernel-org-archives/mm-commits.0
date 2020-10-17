Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855E4C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D71A20878
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975808;
	bh=aRzCmHuVwQEOBya5tVnXi2GHuQwNpCTD74wS6hGWOEA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nM5Mqs3qEyn1QWZrL+NAX6P1pxKpLzEqcEOzyB3Yn6iDkTIjFHr6gg1YgCXOvM5Vc
	 yiqupHVwteEdiTbCaRYI6u2y6yU4StQA0VTjEXzktkV5m2SWqm0iktKJAF4Xx5pE46
	 wuz7BD6aQueHahRC5fKlipcOhgeLgYUIiAJ3si+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438728AbgJQXD1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:03:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4404620878;
        Sat, 17 Oct 2020 23:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975807;
        bh=aRzCmHuVwQEOBya5tVnXi2GHuQwNpCTD74wS6hGWOEA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1OtOUJ0xcVhzjy/aVTQ+ArlvJ12VNL5Igb3oaXg7kgCcr5X6Opqk6Nq2KsyHIgDQT
         6l/neQ6Sr03+zE5UYjQCaDtVMWMw7UyzHk5HuYvcqPbRbtCxxoyTgwNJLSD9Rw2k41
         bPMwWYt0OU5hk+nWpLQcesQ4rJp/Tb8OfdzAperM=
Date:   Sat, 17 Oct 2020 16:03:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch removed
 from -mm tree
Message-ID: <20201017230326.dtg7eTHNQ%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix an improper dependency upon executable script permissions
has been removed from the -mm tree.  Its filename was
     selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch

This patch was dropped because it was folded into selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: fix an improper dependency upon executable script permissions

commit 30fb9454ab23 ("selftests/vm: hmm-tests: remove the libhugetlbfs
dependency") created the new check_config.sh file without the execute bit
set.  This is a problem because that same commit caused the Makefile to
invoke it "./check_config.sh", so now "make" is failing in that directory.

Scripts are not supposed to depend on the executable bit being set,
because patch(1) doesn't set it, and using patch to install a kernel is
supported.  Therefore, this fix involves two parts:

1) Invoke the new script via /bin/sh, to fix the problem, and

2) As an nice touch, make check_config.sh executable as well.

Link: https://lkml.kernel.org/r/20201003002142.32671-2-jhubbard@nvidia.com
Fixes: commit 30fb9454ab23 ("selftests/vm: hmm-tests: remove the libhugetlbfs dependency")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -138,7 +138,7 @@ $(OUTPUT)/hmm-tests: local_config.h
 $(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXTRA_LIBS)
 
 local_config.mk local_config.h: check_config.sh
-	./check_config.sh $(CC)
+	/bin/sh ./check_config.sh $(CC)
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-10x-speedup-for-hmm-tests.patch

