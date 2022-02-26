Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CB3C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 03:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiBZDK7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 22:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBZDK6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 22:10:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721502668E1
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 19:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B059CE2810
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 03:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11E0C340E7;
        Sat, 26 Feb 2022 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645845021;
        bh=X9K1RtKXnTPztiBiPSH1TdtbY3ruIsuPnQZPoa8WRx4=;
        h=Date:From:To:Cc:Subject:From;
        b=kkK13gk8ZAr5j4ZGnI+2juMqgXoJVmRcylApvpMIz8gf0Kc0mbKSevg7Gjm1jPWNb
         QIw7Hlmdi5QmczRMN3+YZzVrfrvDjW2auMGLaU5Qt78JLXWo2gTUnY+R5o5EPX/14B
         BOBtLxK7LoMunDtDwd2MM0WrU85RdP6uCZNXHfXc=
Date:   Fri, 25 Feb 2022 19:10:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

12 patches, based on c47658311d60be064b839f329c0e4d34f5f0735b.

Subsystems affected by this patch series:

  MAINTAINERS
  mm/hugetlb
  mm/kasan
  mm/hugetlbfs
  mm/pagemap
  mm/selftests
  mm/memcg
  m/slab
  mailmap
  memfd

Subsystem: MAINTAINERS

    Luis Chamberlain <mcgrof@kernel.org>:
      MAINTAINERS: add sysctl-next git tree

Subsystem: mm/hugetlb

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm/hugetlb: fix kernel crash with hugetlb mremap

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: test: prevent cache merging in kmem_cache_double_destroy

Subsystem: mm/hugetlbfs

    Liu Yuntao <liuyuntao10@huawei.com>:
      hugetlbfs: fix a truncation issue in hugepages parameter

Subsystem: mm/pagemap

    Suren Baghdasaryan <surenb@google.com>:
      mm: fix use-after-free bug when mm->mmap is reused after being freed

Subsystem: mm/selftests

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      selftest/vm: fix map_fixed_noreplace test failure

Subsystem: mm/memcg

    Roman Gushchin <roman.gushchin@linux.dev>:
      MAINTAINERS: add Roman as a memcg co-maintainer

    Vladimir Davydov <vdavydov.dev@gmail.com>:
      MAINTAINERS: remove Vladimir from memcg maintainers

    Shakeel Butt <shakeelb@google.com>:
      MAINTAINERS: add Shakeel as a memcg co-maintainer

Subsystem: m/slab

    Vlastimil Babka <vbabka@suse.cz>:
      MAINTAINERS, SLAB: add Roman as reviewer, git tree

Subsystem: mailmap

    Roman Gushchin <roman.gushchin@linux.dev>:
      mailmap: update Roman Gushchin's email

Subsystem: memfd

    Mike Kravetz <mike.kravetz@oracle.com>:
      selftests/memfd: clean up mapping in mfd_fail_write

 .mailmap                                         |    3 +
 MAINTAINERS                                      |    6 ++
 lib/test_kasan.c                                 |    5 +-
 mm/hugetlb.c                                     |   11 ++---
 mm/mmap.c                                        |    1 
 tools/testing/selftests/memfd/memfd_test.c       |    1 
 tools/testing/selftests/vm/map_fixed_noreplace.c |   49 +++++++++++++++++------
 7 files changed, 56 insertions(+), 20 deletions(-)

