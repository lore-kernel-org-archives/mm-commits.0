Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96CEC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 601BB2313F
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbhAMAmr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391850AbhALXtV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 18:49:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 499A323131;
        Tue, 12 Jan 2021 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495320;
        bh=z0hw0gwbofy4gyaRiI/KcoDxDW0Q7lXq2qlEM5MCeKc=;
        h=Date:From:To:Cc:Subject:From;
        b=zC89ZPNuAhQD7FGGFavW6DYzEqSZQyRcV1Q+Qx2tL0NJq+iTBkPuVqZ23X0feBC2I
         RzqtQzFgx9O3qVnqZexmtBB6PgdWoR1j901bYytvIZ14VC02LJQOfOpXaGQhp9yjUP
         qqD0pT/Buw+y0i0aGnN6fn7DrOfqIemdj3rrLMkU=
Date:   Tue, 12 Jan 2021 15:48:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

10 patches, based on e609571b5ffa3528bf85292de1ceaddac342bc1c.

Subsystems affected by this patch series:

  mm/slub
  mm/pagealloc
  mm/memcg
  mm/kasan
  mm/vmalloc
  mm/migration
  mm/hugetlb
  MAINTAINERS
  mm/memory-failure
  mm/process_vm_access

Subsystem: mm/slub

    Jann Horn <jannh@google.com>:
      mm, slub: consider rest of partial list if acquire_slab() fails

Subsystem: mm/pagealloc

    Hailong liu <liu.hailong6@zte.com.cn>:
      mm/page_alloc: add a missing mm_page_alloc_zone_locked() tracepoint

Subsystem: mm/memcg

    Hugh Dickins <hughd@google.com>:
      mm/memcontrol: fix warning in mem_cgroup_page_lruvec()

Subsystem: mm/kasan

    Hailong Liu <liu.hailong6@zte.com.cn>:
      arm/kasan: fix the array size of kasan_early_shadow_pte[]

Subsystem: mm/vmalloc

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/vmalloc.c: fix potential memory leak

Subsystem: mm/migration

    Jan Stancek <jstancek@redhat.com>:
      mm: migrate: initialize err in do_migrate_pages

Subsystem: mm/hugetlb

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/hugetlb: fix potential missing huge page size info

Subsystem: MAINTAINERS

    Vlastimil Babka <vbabka@suse.cz>:
      MAINTAINERS: add Vlastimil as slab allocators maintainer

Subsystem: mm/memory-failure

    Oscar Salvador <osalvador@suse.de>:
      mm,hwpoison: fix printing of page flags

Subsystem: mm/process_vm_access

    Andrew Morton <akpm@linux-foundation.org>:
      mm/process_vm_access.c: include compat.h

 MAINTAINERS                |    1 +
 include/linux/kasan.h      |    6 +++++-
 include/linux/memcontrol.h |    2 +-
 mm/hugetlb.c               |    2 +-
 mm/kasan/init.c            |    3 ++-
 mm/memory-failure.c        |    2 +-
 mm/mempolicy.c             |    2 +-
 mm/page_alloc.c            |   31 ++++++++++++++++---------------
 mm/process_vm_access.c     |    1 +
 mm/slub.c                  |    2 +-
 mm/vmalloc.c               |    4 +++-
 11 files changed, 33 insertions(+), 23 deletions(-)

