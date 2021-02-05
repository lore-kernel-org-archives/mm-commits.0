Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383A9C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C7B64FBD
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhBECcY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:32:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhBECcX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:32:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9480164E8C;
        Fri,  5 Feb 2021 02:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492296;
        bh=5+AMRqtNofpPIx9RCpk7xAR3sOl3spI/PYJE+SCx5RY=;
        h=Date:From:To:Cc:Subject:From;
        b=1wy0TMbloQkuBBrf8WkbqZi5S5UvU1LSSex1VgwhFhrPSoGWD3KPDKcDrIuhkkZwl
         c1X/px5WCyK8Xd+EuKUM/No19TJrhHjYRXK3PLUJeFdxiQbiAg7qQOtPmlrLbzxiyD
         G3qhVc5wue30RDSPQ3p4k3pGw1Tx9KtMuw70XjDw=
Date:   Thu, 4 Feb 2021 18:31:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

18 patches, based on 5c279c4cf206e03995e04fd3404fa95ffd243a97.

Subsystems affected by this patch series:

  mm/hugetlb
  mm/compaction
  mm/vmalloc
  gcov
  mm/shmem
  mm/memblock
  mailmap
  mm/pagecache
  mm/kasan
  ubsan
  mm/hugetlb
  MAINTAINERS

Subsystem: mm/hugetlb

    Muchun Song <songmuchun@bytedance.com>:
      mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
      mm: hugetlb: fix a race between freeing and dissolving the page
      mm: hugetlb: fix a race between isolating and freeing page
      mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active
      mm: migrate: do not migrate HugeTLB page whose refcount is one

Subsystem: mm/compaction

    Rokudo Yan <wu-yan@tcl.com>:
      mm, compaction: move high_pfn to the for loop scope

Subsystem: mm/vmalloc

    Rick Edgecombe <rick.p.edgecombe@intel.com>:
      mm/vmalloc: separate put pages and flush VM flags

Subsystem: gcov

    Johannes Berg <johannes.berg@intel.com>:
      init/gcov: allow CONFIG_CONSTRUCTORS on UML to fix module gcov

Subsystem: mm/shmem

    Hugh Dickins <hughd@google.com>:
      mm: thp: fix MADV_REMOVE deadlock on shmem THP

Subsystem: mm/memblock

    Roman Gushchin <guro@fb.com>:
      memblock: do not start bottom-up allocations with kernel_end

Subsystem: mailmap

    Viresh Kumar <viresh.kumar@linaro.org>:
      mailmap: fix name/email for Viresh Kumar

    Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>:
      mailmap: add entries for Manivannan Sadhasivam

Subsystem: mm/pagecache

    Waiman Long <longman@redhat.com>:
      mm/filemap: add missing mem_cgroup_uncharge() to __add_to_page_cache_locked()

Subsystem: mm/kasan

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
    Patch series "kasan: Fix metadata detection for KASAN_HW_TAGS", v5:
      kasan: add explicit preconditions to kasan_report()
      kasan: make addr_has_metadata() return true for valid addresses

Subsystem: ubsan

    Nathan Chancellor <nathan@kernel.org>:
      ubsan: implement __ubsan_handle_alignment_assumption

Subsystem: mm/hugetlb

    Muchun Song <songmuchun@bytedance.com>:
      mm: hugetlb: fix missing put_page in gather_surplus_pages()

Subsystem: MAINTAINERS

    Nathan Chancellor <nathan@kernel.org>:
      MAINTAINERS/.mailmap: use my @kernel.org address

 .mailmap                |    5 ++++
 MAINTAINERS             |    2 -
 fs/hugetlbfs/inode.c    |    3 +-
 include/linux/hugetlb.h |    2 +
 include/linux/kasan.h   |    7 ++++++
 include/linux/vmalloc.h |    9 +-------
 init/Kconfig            |    1 
 init/main.c             |    8 ++++++-
 kernel/gcov/Kconfig     |    2 -
 lib/ubsan.c             |   31 ++++++++++++++++++++++++++++
 lib/ubsan.h             |    6 +++++
 mm/compaction.c         |    3 +-
 mm/filemap.c            |    4 +++
 mm/huge_memory.c        |   37 ++++++++++++++++++++-------------
 mm/hugetlb.c            |   53 ++++++++++++++++++++++++++++++++++++++++++------
 mm/kasan/kasan.h        |    2 -
 mm/memblock.c           |   49 +++++---------------------------------------
 mm/migrate.c            |    6 +++++
 18 files changed, 153 insertions(+), 77 deletions(-)

