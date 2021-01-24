Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCA6C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5BD622D0A
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbhAXFBO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:01:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAXFBL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:01:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE3F922581;
        Sun, 24 Jan 2021 05:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464431;
        bh=G8nZht4TirHMlWnbFiZgIsumSAEwcrOr1+23NW1WupU=;
        h=Date:From:To:Cc:Subject:From;
        b=eCoJ6N5ntj/Vku5pL1xtTLeDE35ydsOYfGTXl+lqJWFiIYPsvCrHwHuS23GfmaW5y
         RcL2nLAjWEi9sWgmOAobEsb/8+7Lw2a8gf1yrqnFfhFbsz1dvoePgtqMF6l33n/YJe
         /G+RFb60qOaervUS5LYXhwLfOIcnuvKEzoAhSlhk=
Date:   Sat, 23 Jan 2021 21:00:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

19 patches, based on e1ae4b0be15891faf46d390e9f3dc9bd71a8cae1.

Subsystems affected by this patch series:

  mm/pagealloc
  mm/memcg
  mm/kasan
  ubsan
  mm/memory-failure
  mm/highmem
  proc
  MAINTAINERS

Subsystem: mm/pagealloc

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: fix initialization of struct page for holes in memory layout", v3:
      x86/setup: don't remove E820_TYPE_RAM for pfn 0
      mm: fix initialization of struct page for holes in memory layout

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: optimize objcg stock draining

    Shakeel Butt <shakeelb@google.com>:
      mm: memcg: fix memcg file_dirty numa stat
      mm: fix numa stats for thp migration

    Johannes Weiner <hannes@cmpxchg.org>:
      mm: memcontrol: prevent starvation when writing memory.high

Subsystem: mm/kasan

    Lecopzer Chen <lecopzer@gmail.com>:
      kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow
      kasan: fix incorrect arguments passing in kasan_add_zero_shadow

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: fix HW_TAGS boot parameters
      kasan, mm: fix conflicts with init_on_alloc/free
      kasan, mm: fix resetting page_alloc tags for HW_TAGS

Subsystem: ubsan

    Arnd Bergmann <arnd@arndb.de>:
      ubsan: disable unsigned-overflow check for i386

Subsystem: mm/memory-failure

    Dan Williams <dan.j.williams@intel.com>:
      mm: fix page reference leak in soft_offline_page()

Subsystem: mm/highmem

    Thomas Gleixner <tglx@linutronix.de>:
    Patch series "mm/highmem: Fix fallout from generic kmap_local conversions":
      sparc/mm/highmem: flush cache and TLB
      mm/highmem: prepare for overriding set_pte_at()
      mips/mm/highmem: use set_pte() for kmap_local()
      powerpc/mm/highmem: use __set_pte_at() for kmap_local()

Subsystem: proc

    Xiaoming Ni <nixiaoming@huawei.com>:
      proc_sysctl: fix oops caused by incorrect command parameters

Subsystem: MAINTAINERS

    Nathan Chancellor <natechancellor@gmail.com>:
      MAINTAINERS: add a couple more files to the Clang/LLVM section

 Documentation/dev-tools/kasan.rst  |   27 ++---------
 MAINTAINERS                        |    2 
 arch/mips/include/asm/highmem.h    |    1 
 arch/powerpc/include/asm/highmem.h |    2 
 arch/sparc/include/asm/highmem.h   |    9 ++-
 arch/x86/kernel/setup.c            |   20 +++-----
 fs/proc/proc_sysctl.c              |    7 ++-
 lib/Kconfig.ubsan                  |    1 
 mm/highmem.c                       |    7 ++-
 mm/kasan/hw_tags.c                 |   77 +++++++++++++--------------------
 mm/kasan/init.c                    |   23 +++++----
 mm/memcontrol.c                    |   11 +---
 mm/memory-failure.c                |   20 ++++++--
 mm/migrate.c                       |   27 ++++++-----
 mm/page_alloc.c                    |   86 ++++++++++++++++++++++---------------
 mm/slub.c                          |    7 +--
 16 files changed, 173 insertions(+), 154 deletions(-)

