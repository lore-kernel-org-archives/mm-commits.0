Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E69EC433E8
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0919120792
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564075;
	bh=S27fsh3IrpO7OPrV4aN/BXVLUf9xr2vmwcd55+zU3e8=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=ZWYBp8l82EgiN40r9L5u7qSxUiLOCrg6Hrwfo+nN8miubAWA+RyN1EvrmTmTFvuQU
	 YbiSvYXsWHHXStorb1sw5ls4W58S2KF+YnCao+f0OzBC58MnFh9JX/M9OqqtyzAJVb
	 Gh3tYDuD24qjWrDkL7VUoQso/KtBMQa2wj+3qlWI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgGXEOe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGXEOe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:14:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D33BA20709;
        Fri, 24 Jul 2020 04:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564074;
        bh=S27fsh3IrpO7OPrV4aN/BXVLUf9xr2vmwcd55+zU3e8=;
        h=Date:From:To:Cc:Subject:From;
        b=dnkJghmHFIScanDFtJLYRgb4qkyO+GXMJobOzLOU7O7SviLjndmQqhCZZi9QyPMLt
         Atkk5k5Af0dfaoTAM//5hrXbfmvBlf7jj+PWVfhQaJXoEZDvwESJfuC8ixglNCGX4G
         4HF60wrthtawkrlGVYeyjQfeyYPcuzkmG6nZf5Rk=
Date:   Thu, 23 Jul 2020 21:14:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


15 patches, based on f37e99aca03f63aa3f2bd13ceaf769455d12c4b0.

Subsystems affected by this patch series:

  mm/pagemap
  mm/shmem
  mm/hotfixes
  mm/memcg
  mm/hugetlb
  mailmap
  squashfs
  scripts
  io-mapping
  MAINTAINERS
  gdb

Subsystem: mm/pagemap

    Yang Shi <yang.shi@linux.alibaba.com>:
      mm/memory.c: avoid access flag update TLB flush for retried page fault

    "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>:
      mm/mmap.c: close race between munmap() and expand_upwards()/downwards()

Subsystem: mm/shmem

    Chengguang Xu <cgxu519@mykernel.net>:
      vfs/xattr: mm/shmem: kernfs: release simple xattr entry in a right way

Subsystem: mm/hotfixes

    Tom Rix <trix@redhat.com>:
      mm: initialize return of vm_insert_pages

    Bhupesh Sharma <bhsharma@redhat.com>:
      mm/memcontrol: fix OOPS inside mem_cgroup_get_nr_swap_pages()

Subsystem: mm/memcg

    Hugh Dickins <hughd@google.com>:
      mm/memcg: fix refcount error while moving and swapping

    Muchun Song <songmuchun@bytedance.com>:
      mm: memcg/slab: fix memory leak at non-root kmem_cache destroy

Subsystem: mm/hugetlb

    Barry Song <song.bao.hua@hisilicon.com>:
      mm/hugetlb: avoid hardcoding while checking if cma is enabled

    "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>:
      khugepaged: fix null-pointer dereference due to race

Subsystem: mailmap

    Mike Rapoport <rppt@linux.ibm.com>:
      mailmap: add entry for Mike Rapoport

Subsystem: squashfs

    Phillip Lougher <phillip@squashfs.org.uk>:
      squashfs: fix length field overlap check in metadata reading

Subsystem: scripts

    Pi-Hsun Shih <pihsun@chromium.org>:
      scripts/decode_stacktrace: strip basepath from all paths

Subsystem: io-mapping

    "Michael J. Ruhl" <michael.j.ruhl@intel.com>:
      io-mapping: indicate mapping failure

Subsystem: MAINTAINERS

    Andrey Konovalov <andreyknvl@google.com>:
      MAINTAINERS: add KCOV section

Subsystem: gdb

    Stefano Garzarella <sgarzare@redhat.com>:
      scripts/gdb: fix lx-symbols 'gdb.error' while loading modules

 .mailmap                     |    3 +++
 MAINTAINERS                  |   11 +++++++++++
 fs/squashfs/block.c          |    2 +-
 include/linux/io-mapping.h   |    5 ++++-
 include/linux/xattr.h        |    3 ++-
 mm/hugetlb.c                 |   15 ++++++++++-----
 mm/khugepaged.c              |    3 +++
 mm/memcontrol.c              |   13 ++++++++++---
 mm/memory.c                  |    9 +++++++--
 mm/mmap.c                    |   16 ++++++++++++++--
 mm/shmem.c                   |    2 +-
 mm/slab_common.c             |   35 ++++++++++++++++++++++++++++-------
 scripts/decode_stacktrace.sh |    4 ++--
 scripts/gdb/linux/symbols.py |    2 +-
 14 files changed, 97 insertions(+), 26 deletions(-)

