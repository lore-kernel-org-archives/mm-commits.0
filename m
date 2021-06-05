Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C337C4743D
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7385613EA
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhFEDC2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 23:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhFEDC2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 23:02:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2687613F3;
        Sat,  5 Jun 2021 03:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862040;
        bh=tOTXbaodCf5wRXySuViL24kvwq/aO/82AqGN6CcHIZY=;
        h=Date:From:To:Cc:Subject:From;
        b=p5YArqDmNi/VkSmwJhtqISho3TXK85x/nW8LL2bGg/9Qvc0cvWwKgDSKtQ87P60+Q
         ABvlHquMURugA/vK4X1c3OLAaMluXs8gP8YwoltLU8AydHsPCaU8U3v5OR8brGqB8/
         fPt0Rt3SsG6VBAFXY/aW7gFWDEl5W8Wib4EwROQY=
Date:   Fri, 4 Jun 2021 20:00:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

13 patches, based on 16f0596fc1d78a1f3ae4628cff962bb297dc908c.

Subsystems affected by this patch series:

  mips
  mm/kfence
  init
  mm/debug
  mm/pagealloc
  mm/memory-hotplug
  mm/hugetlb
  proc
  mm/kasan
  mm/hugetlb
  lib
  ocfs2
  mailmap

Subsystem: mips

    Thomas Bogendoerfer <tsbogend@alpha.franken.de>:
      Revert "MIPS: make userspace mapping young by default"

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence: use TASK_IDLE when awaiting allocation

Subsystem: init

    Mark Rutland <mark.rutland@arm.com>:
      pid: take a reference when initializing `cad_pid`

Subsystem: mm/debug

    Gerald Schaefer <gerald.schaefer@linux.ibm.com>:
      mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()

Subsystem: mm/pagealloc

    Ding Hui <dinghui@sangfor.com.cn>:
      mm/page_alloc: fix counting of free pages after take off from buddy

Subsystem: mm/memory-hotplug

    David Hildenbrand <david@redhat.com>:
      drivers/base/memory: fix trying offlining memory blocks with memory holes on aarch64

Subsystem: mm/hugetlb

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      hugetlb: pass head page to remove_hugetlb_page()

Subsystem: proc

    David Matlack <dmatlack@google.com>:
      proc: add .gitignore for proc-subset-pid selftest

Subsystem: mm/kasan

    Yu Kuai <yukuai3@huawei.com>:
      mm/kasan/init.c: fix doc warning

Subsystem: mm/hugetlb

    Mina Almasry <almasrymina@google.com>:
      mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

Subsystem: lib

    YueHaibing <yuehaibing@huawei.com>:
      lib: crc64: fix kernel-doc warning

Subsystem: ocfs2

    Junxiao Bi <junxiao.bi@oracle.com>:
      ocfs2: fix data corruption by fallocate

Subsystem: mailmap

    Michel Lespinasse <michel@lespinasse.org>:
      mailmap: use private address for Michel Lespinasse

 .mailmap                                |    3 +
 arch/mips/mm/cache.c                    |   30 ++++++++---------
 drivers/base/memory.c                   |    6 +--
 fs/ocfs2/file.c                         |   55 +++++++++++++++++++++++++++++---
 include/linux/pgtable.h                 |    8 ++++
 init/main.c                             |    2 -
 lib/crc64.c                             |    2 -
 mm/debug_vm_pgtable.c                   |    4 +-
 mm/hugetlb.c                            |   16 +++++++--
 mm/kasan/init.c                         |    4 +-
 mm/kfence/core.c                        |    6 +--
 mm/memory.c                             |    4 ++
 mm/page_alloc.c                         |    2 +
 tools/testing/selftests/proc/.gitignore |    1 
 14 files changed, 107 insertions(+), 36 deletions(-)

