Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D69FC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D2F20738
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597970494;
	bh=uW8KJd6odtnbEZH4bxoIqvF5nVTInVRGUsuuwV78clo=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=TW66UApV9IrkkTyu4O+WAUBtOWAQEdR3s7iLb4Yqy8LcaOR2rhTSwueOMm1XCM6Sz
	 6Bubo2F5u+rMtj6YgcHAGPKW2ddLwSk6ke1p8axpVF9EMtOzkJb7mMpjt7hMoQjDrR
	 YlijaljlqxiBvpnS0tT/LD+AQ1cliJezfEhx692k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgHUAld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgHUAld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 20:41:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 901CC20738;
        Fri, 21 Aug 2020 00:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970492;
        bh=uW8KJd6odtnbEZH4bxoIqvF5nVTInVRGUsuuwV78clo=;
        h=Date:From:To:Cc:Subject:From;
        b=rdr30KV/8qSy7HLSs7kKXnRb1cgGHFWM6VpU3BHz+8Tm1AvDV1fIpzG8fqiVHrnuJ
         B8mLsFweapglt23kkJbCvtyNa4Mz84mee7e1oxOqDLGzRJHFdBN3YA+7B43HkdRv3A
         EQGaaDRlc7MjSx0lYZ8fMkLUrw2A4IBL0MtxqZ/8=
Date:   Thu, 20 Aug 2020 17:41:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

11 patches, based on 7eac66d0456fe12a462e5c14c68e97c7460989da.

Subsystems affected by this patch series:

  misc
  mm/hugetlb
  mm/vmalloc
  mm/misc
  romfs
  relay
  uprobes
  squashfs
  mm/cma
  mm/pagealloc

Subsystem: misc

    Nick Desaulniers <ndesaulniers@google.com>:
      mailmap: add Andi Kleen

Subsystem: mm/hugetlb

    Xu Wang <vulab@iscas.ac.cn>:
      hugetlb_cgroup: convert comma to semicolon

    Hugh Dickins <hughd@google.com>:
      khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

Subsystem: mm/vmalloc

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm/vunmap: add cond_resched() in vunmap_pmd_range

Subsystem: mm/misc

    Leon Romanovsky <leonro@nvidia.com>:
      mm/rodata_test.c: fix missing function declaration

Subsystem: romfs

    Jann Horn <jannh@google.com>:
      romfs: fix uninitialized memory leak in romfs_dev_read()

Subsystem: relay

    Wei Yongjun <weiyongjun1@huawei.com>:
      kernel/relay.c: fix memleak on destroy relay channel

Subsystem: uprobes

    Hugh Dickins <hughd@google.com>:
      uprobes: __replace_page() avoid BUG in munlock_vma_page()

Subsystem: squashfs

    Phillip Lougher <phillip@squashfs.org.uk>:
      squashfs: avoid bio_alloc() failure with 1Mbyte blocks

Subsystem: mm/cma

    Doug Berger <opendmb@gmail.com>:
      mm: include CMA pages in lowmem_reserve at boot

Subsystem: mm/pagealloc

    Charan Teja Reddy <charante@codeaurora.org>:
      mm, page_alloc: fix core hung in free_pcppages_bulk()

 .mailmap                |    1 +
 fs/romfs/storage.c      |    4 +---
 fs/squashfs/block.c     |    6 +++++-
 kernel/events/uprobes.c |    2 +-
 kernel/relay.c          |    1 +
 mm/hugetlb_cgroup.c     |    4 ++--
 mm/khugepaged.c         |    2 +-
 mm/page_alloc.c         |    7 ++++++-
 mm/rodata_test.c        |    1 +
 mm/vmalloc.c            |    2 ++
 10 files changed, 21 insertions(+), 9 deletions(-)

