Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4E1C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 25 Dec 2021 05:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhLYFLb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Dec 2021 00:11:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49536 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLYFLb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Dec 2021 00:11:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37EDCB8072F
        for <mm-commits@vger.kernel.org>; Sat, 25 Dec 2021 05:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7D3C36AE5;
        Sat, 25 Dec 2021 05:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409089;
        bh=VRN6iwyGuJTiUzGcXXCeYcVYJpGRDsWc1daxJ/SvlA8=;
        h=Date:From:To:Cc:Subject:From;
        b=zFtmJcQVjjTtH7Jy5Pm7SRhajq0mg95JgTWCRmafPAMBEaRYWkjsBK2Ot14F4f5Aq
         RCkKgbttKz6lZpIYuhNI1BclC768W49BjWmsjSMDEC9m3rhhCeT6J0d1/SssTI6BLF
         9APVq4ZolgR3TFA4gUY7DGI+94K8USuJIbbiv8uM=
Date:   Fri, 24 Dec 2021 21:11:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

9 patches, based on bc491fb12513e79702c6f936c838f792b5389129.

Subsystems affected by this patch series:

  mm/kfence
  mm/mempolicy
  core-kernel
  MAINTAINERS
  mm/memory-failure
  mm/pagemap
  mm/pagealloc
  mm/damon
  mm/memory-failure

Subsystem: mm/kfence

    Baokun Li <libaokun1@huawei.com>:
      kfence: fix memory leak when cat kfence objects

Subsystem: mm/mempolicy

    Andrey Ryabinin <arbn@yandex-team.com>:
      mm: mempolicy: fix THP allocations escaping mempolicy restrictions

Subsystem: core-kernel

    Philipp Rudo <prudo@redhat.com>:
      kernel/crash_core: suppress unknown crashkernel parameter warning

Subsystem: MAINTAINERS

    Randy Dunlap <rdunlap@infradead.org>:
      MAINTAINERS: mark more list instances as moderated

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm, hwpoison: fix condition in free hugetlb page path

Subsystem: mm/pagemap

    Hugh Dickins <hughd@google.com>:
      mm: delete unsafe BUG from page_cache_add_speculative()

Subsystem: mm/pagealloc

    Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>:
      mm/page_alloc: fix __alloc_size attribute for alloc_pages_exact_nid

Subsystem: mm/damon

    SeongJae Park <sj@kernel.org>:
      mm/damon/dbgfs: protect targets destructions with kdamond_lock

Subsystem: mm/memory-failure

    Liu Shixin <liushixin2@huawei.com>:
      mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()

 MAINTAINERS             |    4 ++--
 include/linux/gfp.h     |    2 +-
 include/linux/pagemap.h |    1 -
 kernel/crash_core.c     |   11 +++++++++++
 mm/damon/dbgfs.c        |    2 ++
 mm/kfence/core.c        |    1 +
 mm/memory-failure.c     |   14 +++++---------
 mm/mempolicy.c          |    3 +--
 8 files changed, 23 insertions(+), 15 deletions(-)

