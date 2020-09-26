Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FB7C2D0A8
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 04:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0DD92078B
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 04:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601093848;
	bh=hDdFxAUufJvelJbwUYXSNZS8BE5jn8qNMcZXTNTuXZg=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=l68qiUmJsrMF9DYWqpfcp6nDhfnA7PSxLIkHrQ/S88wgyNgNMjzgjjsi/1A1NJN99
	 aNIL+1plBLP9+btoTB8xSx6lan1ztTcw7wNiE02Q8ZAM0jPVnpfXUfi5E48+e18ESr
	 GIN+yz5rfrrStLNMOL8xaP5cAfY/REeS3NnAMwFk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgIZER1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 26 Sep 2020 00:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbgIZER1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 26 Sep 2020 00:17:27 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337892076D;
        Sat, 26 Sep 2020 04:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601093846;
        bh=hDdFxAUufJvelJbwUYXSNZS8BE5jn8qNMcZXTNTuXZg=;
        h=Date:From:To:Cc:Subject:From;
        b=OeSaLvMPFTpV4XNlBnHZrY+Omv0dOemLVjSVwhp3Ev2iGLI14RcEHmvhHOwV5KeiN
         0ZZgHpDXyB3sMZ/9YGPwaQ+wd8K3lxM1D8kiCNAKlqYvosvx754qyMO774wiZ1T6hk
         jgAVJaIm3FFbcmnMMSCvYjDeW4dfNVGGqDZE0iig=
Date:   Fri, 25 Sep 2020 21:17:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

9 patches, based on 7c7ec3226f5f33f9c050d85ec20f18419c622ad6.

Subsystems affected by this patch series:

  mm/thp
  mm/memcg
  mm/gup
  mm/migration
  lib
  x86
  mm/memory-hotplug

Subsystem: mm/thp

    Gao Xiang <hsiangkao@redhat.com>:
      mm, THP, swap: fix allocating cluster for swapfile by mistake

Subsystem: mm/memcg

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcontrol: fix missing suffix of workingset_restore

Subsystem: mm/gup

    Vasily Gorbik <gor@linux.ibm.com>:
      mm/gup: fix gup_fast with dynamic page table folding

Subsystem: mm/migration

    Zi Yan <ziy@nvidia.com>:
      mm/migrate: correct thp migration stats

Subsystem: lib

    Nick Desaulniers <ndesaulniers@google.com>:
      lib/string.c: implement stpcpy

    Jason Yan <yanaijie@huawei.com>:
      lib/memregion.c: include memregion.h

Subsystem: x86

    Mikulas Patocka <mpatocka@redhat.com>:
      arch/x86/lib/usercopy_64.c: fix  __copy_user_flushcache() cache writeback

Subsystem: mm/memory-hotplug

    Laurent Dufour <ldufour@linux.ibm.com>:
    Patch series "mm: fix memory to node bad links in sysfs", v3:
      mm: replace memmap_context by meminit_context
      mm: don't rely on system state to detect hot-plug operations

 Documentation/admin-guide/cgroup-v2.rst |   25 ++++++---
 arch/ia64/mm/init.c                     |    6 +-
 arch/s390/include/asm/pgtable.h         |   42 +++++++++++----
 arch/x86/lib/usercopy_64.c              |    2 
 drivers/base/node.c                     |   85 ++++++++++++++++++++------------
 include/linux/mm.h                      |    2 
 include/linux/mmzone.h                  |   11 +++-
 include/linux/node.h                    |   11 ++--
 include/linux/pgtable.h                 |   10 +++
 lib/memregion.c                         |    1 
 lib/string.c                            |   24 +++++++++
 mm/gup.c                                |   18 +++---
 mm/memcontrol.c                         |    4 -
 mm/memory_hotplug.c                     |    5 +
 mm/migrate.c                            |    7 +-
 mm/page_alloc.c                         |   10 +--
 mm/swapfile.c                           |    2 
 17 files changed, 181 insertions(+), 84 deletions(-)

