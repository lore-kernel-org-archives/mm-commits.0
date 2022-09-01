Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0647FECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 22:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiIAWOg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 18:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiIAWOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 18:14:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2D925DA
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 15:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AB72CE2977
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 22:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1CDC433D6;
        Thu,  1 Sep 2022 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662070461;
        bh=BxbQcx6fSw2oTLFoBfizwdc4KwhzMGKJeuZYbEEc11k=;
        h=Date:To:From:Subject:From;
        b=f+AGShXzFD/aIYk/JUxTnhjRuhpJshtsM75uZTaWznv9Ommu1yYoCj8LcnLyTnU2A
         3GQ3S5gvE4Y3asuEkfM9LJb4Td5fPDLETVx1hGIIZiDwnzQJK4nH+SMb8APELCU9eU
         tXu/Xve643H/D+Z9ZKqemwpl2C9GlzmOf3xv8cEE=
Date:   Thu, 01 Sep 2022 15:14:20 -0700
To:     mm-commits@vger.kernel.org, axelrasmussen@google.com,
        tsahu@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-remove-deleted-local_config-from-gitignore.patch added to mm-unstable branch
Message-Id: <20220901221421.3B1CDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: vm: remove deleted local_config.* from .gitignore
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-vm-remove-deleted-local_config-from-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-vm-remove-deleted-local_config-from-gitignore.patch

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
From: Tarun Sahu <tsahu@linux.ibm.com>
Subject: selftest: vm: remove deleted local_config.* from .gitignore
Date: Thu, 1 Sep 2022 14:53:15 +0530

Commit d2d6cba5d6623245a80cc151008cce825c8b6248 ("selftest: vm: remove
orphaned references to local_config.{h,mk}") took care of removing
orphaned references. This commit remove local_config from .gitignore.

Parent Patch
Commit 69007f156ba7aead6c75b0046958ad3396f5aed1 ("Kselftests: remove
support of libhugetlbfs from kselftests")

Link: https://lkml.kernel.org/r/20220901092315.33619-1-tsahu@linux.ibm.com
Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/.gitignore~selftest-vm-remove-deleted-local_config-from-gitignore
+++ a/tools/testing/selftests/vm/.gitignore
@@ -30,7 +30,6 @@ map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
 memfd_secret
-local_config.*
 soft-dirty
 split_huge_page_test
 ksm_tests
_

Patches currently in -mm which might be from tsahu@linux.ibm.com are

kselftests-removing-support-of-libhugetlbfs-from-kselftests.patch
selftest-vm-remove-deleted-local_config-from-gitignore.patch

