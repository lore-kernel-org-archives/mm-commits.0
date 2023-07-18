Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AB8EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 19:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjGRTbk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 15:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjGRTbj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 15:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14D019A9;
        Tue, 18 Jul 2023 12:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BDF0616E3;
        Tue, 18 Jul 2023 19:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68FAC433C7;
        Tue, 18 Jul 2023 19:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689708692;
        bh=k6ybf95Kck6r/aYDJhF/8qTRpOXpZ9otsT5FxLWYk3E=;
        h=Date:From:To:Cc:Subject:From;
        b=rHg3+Uj72PRb9m+HAMI7ZCFfoKX3r2MPg9XQFHXiEktgWRpngxreC13ddXGTPHc/Q
         HNPPMPoMSAPpFt97j581kSs2+1vKVfo2hLGCCUB42GimTB7seblEA7bua06vyJx4EY
         IlnC/n0qqTSRWKmOBUcOgK05nHqiWp4CFJLI1TOE=
Date:   Tue, 18 Jul 2023 12:31:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.5-rc2
Message-Id: <20230718123131.5ec065527c2127a568e5754c@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5:

  Linux 6.5-rc1 (2023-07-09 13:53:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2023-07-18-12-28

for you to fetch changes up to ef5c3de5211b5a3a8102b25aa83eb4cde65ac2fd:

  maple_tree: fix node allocation testing on 32 bit (2023-07-17 12:53:22 -0700)

----------------------------------------------------------------
Seven hotfixes, six of which are cc:stable and one of which addresses a
post-6.5 issue.

----------------------------------------------------------------
Colin Ian King (1):
      selftests/mm: mkdirty: fix incorrect position of #endif

Liam R. Howlett (3):
      mm/mlock: fix vma iterator conversion of apply_vma_lock_flags()
      maple_tree: fix 32 bit mas_next testing
      maple_tree: fix node allocation testing on 32 bit

Miguel Ojeda (1):
      prctl: move PR_GET_AUXV out of PR_MCE_KILL

Peng Zhang (1):
      maple_tree: set the node limit when creating a new root node

Ryan Roberts (1):
      selftests/mm: give scripts execute permission

 kernel/sys.c                                           | 10 +++++-----
 lib/maple_tree.c                                       |  3 ++-
 lib/test_maple_tree.c                                  |  5 ++++-
 mm/mlock.c                                             |  9 +++++----
 tools/testing/radix-tree/maple.c                       |  6 +++---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |  0
 tools/testing/selftests/mm/check_config.sh             |  0
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |  0
 tools/testing/selftests/mm/mkdirty.c                   |  2 +-
 tools/testing/selftests/mm/run_vmtests.sh              |  0
 tools/testing/selftests/mm/test_hmm.sh                 |  0
 tools/testing/selftests/mm/test_vmalloc.sh             |  0
 tools/testing/selftests/mm/va_high_addr_switch.sh      |  0
 tools/testing/selftests/mm/write_hugetlb_memory.sh     |  0
 14 files changed, 20 insertions(+), 15 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/mm/charge_reserved_hugetlb.sh
 mode change 100644 => 100755 tools/testing/selftests/mm/check_config.sh
 mode change 100644 => 100755 tools/testing/selftests/mm/hugetlb_reparenting_test.sh
 mode change 100644 => 100755 tools/testing/selftests/mm/run_vmtests.sh
 mode change 100644 => 100755 tools/testing/selftests/mm/test_hmm.sh
 mode change 100644 => 100755 tools/testing/selftests/mm/test_vmalloc.sh
 mode change 100644 => 100755 tools/testing/selftests/mm/va_high_addr_switch.sh
 mode change 100644 => 100755 tools/testing/selftests/mm/write_hugetlb_memory.sh

