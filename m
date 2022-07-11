Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BEDC43334
	for <mm-commits@archiver.kernel.org>; Mon, 11 Jul 2022 18:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiGKSjg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jul 2022 14:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiGKSjf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2022 14:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1911A06B
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 11:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 839D9614FD
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 18:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B170FC34115;
        Mon, 11 Jul 2022 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657564769;
        bh=BYsrA8KKx3xlSRmwidRWo7VAKKANq51PxfdGGj5w/xU=;
        h=Date:From:To:Cc:Subject:From;
        b=wAIULtYMBCSOfFG9WOcAig+sNAQLOBCqrWQBewkXN+5P2bKsixfHZeg9Fv1j5tCmg
         3QLQ679/d9eB6tmwMCoCtkVoAubtFGZXN72by8qc+uLd2U5TNQiGKO4XEVIe9C2CWk
         i354kw4L5EtGHm6Fpx6LDJpK0f/qfJ40UMYfNSDs=
Date:   Mon, 11 Jul 2022 11:39:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] hotfixes for 5.19-rc7
Message-Id: <20220711113928.6ff2bf870a502a46eb89f871@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


Linus,

please merge another batch of hotfixes.

The following changes since commit 03c765b0e3b4cb5063276b086c76f7a612856a9a:

  Linux 5.19-rc4 (2022-06-26 14:22:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2022-07-11

for you to fetch changes up to 14c99d65941538aa33edd8dc7b1bbbb593c324a2:

  mm: split huge PUD on wp_huge_pud fallback (2022-07-03 15:42:33 -0700)

----------------------------------------------------------------
Mainly MM fixes.  About half for issues which were introduced after 5.18
and the remainder for longer-term issues.

----------------------------------------------------------------
Axel Rasmussen (1):
      mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages

Bagas Sanjaya (1):
      Documentation: highmem: use literal block for code example in highmem.h comment

Baolin Wang (1):
      mm/damon: use set_huge_pte_at() to make huge pte old

David Hildenbrand (1):
      mm/rmap: fix dereferencing invalid subpage pointer in try_to_migrate_one()

Geert Uytterhoeven (1):
      sh: convert nommu io{re,un}map() to static inline functions

Gowans, James (1):
      mm: split huge PUD on wp_huge_pud fallback

Muchun Song (1):
      mm: sparsemem: fix missing higher order allocation splitting

Ryusuke Konishi (1):
      nilfs2: fix incorrect masking of permission flags for symlinks

YueHaibing (1):
      riscv/mm: fix build error while PAGE_TABLE_CHECK enabled without MMU

 arch/riscv/Kconfig       |  2 +-
 arch/sh/include/asm/io.h |  8 ++++++--
 fs/nilfs2/nilfs.h        |  3 +++
 include/linux/highmem.h  | 18 +++++++++---------
 mm/damon/vaddr.c         |  3 +--
 mm/memory.c              | 27 ++++++++++++++-------------
 mm/rmap.c                | 27 +++++++++++++++++----------
 mm/sparse-vmemmap.c      |  8 ++++++++
 mm/userfaultfd.c         |  5 ++++-
 9 files changed, 63 insertions(+), 38 deletions(-)

