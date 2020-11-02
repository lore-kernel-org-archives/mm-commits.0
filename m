Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F82C388F2
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F29223AB
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279218;
	bh=2aQnLfe95+XNZoJqo7Mduite27F6rto7Ym56IVU/Dcw=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=KCxVuV4AMko+wjn43de2N/Cy/IvnMN8J/yGIUMUK41MeGHV/CaUZ1iY5ljsA5WfkQ
	 yz4Y7ML4+CzK/glEUnQy+iOpodRyZrEElZC52bSMxjQ5Vp/uOOHIapJRpt6xXF+V24
	 rMnFuCN+VawdFVohuXiA28iEKkeTZApd+pwm+rjs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgKBBG6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:06:58 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07D3C21D91;
        Mon,  2 Nov 2020 01:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279217;
        bh=2aQnLfe95+XNZoJqo7Mduite27F6rto7Ym56IVU/Dcw=;
        h=Date:From:To:Cc:Subject:From;
        b=uNZFgqX9nwQkFDyW8YaYEYW3mRbYhxFx/DCmW6Lckb8SEKaHz1tpn39YCmFIYCYtn
         KtGJ9zFEJIRJWC6r0kMzPzAW8R1iewffL2wf7RY3OKb1IikiAB9M1DNFIlo2zdAQ3c
         N2B8xf9iyzY1DRP6l4dEe/OIK1pmqkAPPNBtnGE4=
Date:   Sun, 1 Nov 2020 17:06:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

15 patches, based on 3cea11cd5e3b00d91caf0b4730194039b45c5891.

Subsystems affected by this patch series:

  mm/memremap
  mm/memcg
  mm/slab-generic
  mm/kasan
  mm/mempolicy
  signals
  lib
  mm/pagecache
  kthread
  mm/oom-kill
  mm/pagemap
  epoll
  core-kernel

Subsystem: mm/memremap

    Ralph Campbell <rcampbell@nvidia.com>:
      mm/mremap_pages: fix static key devmap_managed_key updates

Subsystem: mm/memcg

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb_cgroup: fix reservation accounting

    zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>:
      mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg

    Roman Gushchin <guro@fb.com>:
      mm: memcg: link page counters to root if use_hierarchy is false

Subsystem: mm/slab-generic

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: adopt KUNIT tests to SW_TAGS mode

Subsystem: mm/mempolicy

    Shijie Luo <luoshijie1@huawei.com>:
      mm: mempolicy: fix potential pte_unmap_unlock pte error

Subsystem: signals

    Oleg Nesterov <oleg@redhat.com>:
      ptrace: fix task_join_group_stop() for the case when current is traced

Subsystem: lib

    Vasily Gorbik <gor@linux.ibm.com>:
      lib/crc32test: remove extra local_irq_disable/enable

Subsystem: mm/pagecache

    Jason Yan <yanaijie@huawei.com>:
      mm/truncate.c: make __invalidate_mapping_pages() static

Subsystem: kthread

    Zqiang <qiang.zhang@windriver.com>:
      kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

Subsystem: mm/oom-kill

    Charles Haithcock <chaithco@redhat.com>:
      mm, oom: keep oom_adj under or at upper limit when printing

Subsystem: mm/pagemap

    Jason Gunthorpe <jgg@nvidia.com>:
      mm: always have io_remap_pfn_range() set pgprot_decrypted()

Subsystem: epoll

    Soheil Hassas Yeganeh <soheil@google.com>:
      epoll: check ep_events_available() upon timeout
      epoll: add a selftest for epoll timeout race

Subsystem: core-kernel

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      kernel/hung_task.c: make type annotations consistent

 fs/eventpoll.c                                                |   16 +
 fs/proc/base.c                                                |    2 
 include/linux/mm.h                                            |    9 
 include/linux/pgtable.h                                       |    4 
 kernel/hung_task.c                                            |    3 
 kernel/kthread.c                                              |    3 
 kernel/signal.c                                               |   19 -
 lib/crc32test.c                                               |    4 
 lib/test_kasan.c                                              |  149 +++++++---
 mm/hugetlb.c                                                  |   20 -
 mm/memcontrol.c                                               |   25 +
 mm/mempolicy.c                                                |    6 
 mm/memremap.c                                                 |   39 +-
 mm/truncate.c                                                 |    2 
 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   95 ++++++
 15 files changed, 290 insertions(+), 106 deletions(-)

