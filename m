Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C20C63798
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F0420885
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WugxFehL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgKVGQe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Nov 2020 01:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgKVGQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Nov 2020 01:16:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C802E2078B;
        Sun, 22 Nov 2020 06:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606025791;
        bh=YyQEJ0JYZIARDESaYYbWfZyRbDTdl5/jrfcqgC0huTA=;
        h=Date:From:To:Cc:Subject:From;
        b=WugxFehL5FLp99KbzGjBoiOZSBsf4nnLi8To6U0X4H/+OPWvj+H6X3PoLkTPfoY51
         dZk+9mFaH1mHc6qOU0dynVsx1SSyjSkfAKxOghcukIpy92JaSHIFd1QaK86U2hSmLw
         MmuJhpxfxAE3++2/S3Cu7f+rAg7ie/ZRH42GDQJE=
Date:   Sat, 21 Nov 2020 22:16:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201121221631.948ae4655e913a319d61700a@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

8 patches, based on a349e4c659609fd20e4beea89e5c4a4038e33a95.

Subsystems affected by this patch series:

  mm/madvise
  kbuild
  mm/pagemap
  mm/readahead
  mm/memcg
  mm/userfaultfd
  vfs-akpm
  mm/madvise

Subsystem: mm/madvise

    Eric Dumazet <edumazet@google.com>:
      mm/madvise: fix memory leak from process_madvise

Subsystem: kbuild

    Nick Desaulniers <ndesaulniers@google.com>:
      compiler-clang: remove version check for BPF Tracing

Subsystem: mm/pagemap

    Dan Williams <dan.j.williams@intel.com>:
      mm: fix phys_to_target_node() and memory_add_physaddr_to_nid() exports

Subsystem: mm/readahead

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: fix readahead_page_batch for retry entries

Subsystem: mm/memcg

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcg/slab: fix root memcg vmstats

Subsystem: mm/userfaultfd

    Gerald Schaefer <gerald.schaefer@linux.ibm.com>:
      mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Subsystem: vfs-akpm

    Yicong Yang <yangyicong@hisilicon.com>:
      libfs: fix error cast of negative value in simple_attr_write()

Subsystem: mm/madvise

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: fix madvise WILLNEED performance problem

 arch/ia64/include/asm/sparsemem.h    |    6 ++++++
 arch/powerpc/include/asm/mmzone.h    |    5 +++++
 arch/powerpc/include/asm/sparsemem.h |    5 ++---
 arch/powerpc/mm/mem.c                |    1 +
 arch/x86/include/asm/sparsemem.h     |   10 ++++++++++
 arch/x86/mm/numa.c                   |    2 ++
 drivers/dax/Kconfig                  |    1 -
 fs/libfs.c                           |    6 ++++--
 include/linux/compiler-clang.h       |    2 ++
 include/linux/memory_hotplug.h       |   14 --------------
 include/linux/numa.h                 |   30 +++++++++++++++++++++++++++++-
 include/linux/pagemap.h              |    2 ++
 mm/huge_memory.c                     |    9 ++++-----
 mm/madvise.c                         |    4 +---
 mm/memcontrol.c                      |    9 +++++++--
 mm/memory_hotplug.c                  |   18 ------------------
 16 files changed, 75 insertions(+), 49 deletions(-)

