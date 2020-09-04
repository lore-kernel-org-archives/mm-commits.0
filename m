Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B7DC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0527C2084D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262498;
	bh=lRAf7W0p+45bEup5xYEqYKnk74WfUaMokx80OOTnNWo=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=nOO/SAl2kZwPx/j+Kb54vIwKpgcEqSSTijzjt7zd7/h4u4KvPXbIyVXTCosT6bq50
	 0h+iH/p+le0hh/EbcmqEDRKFselF+c11uzTWmDHiH0V5iotK/OsAv1SfT7I37i8Rwv
	 23EHFCExmfXrtmby5rAhnVeOAUlJOUIiz90JkJ4M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgIDXe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgIDXe4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:34:56 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A63B2078E;
        Fri,  4 Sep 2020 23:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262495;
        bh=lRAf7W0p+45bEup5xYEqYKnk74WfUaMokx80OOTnNWo=;
        h=Date:From:To:Cc:Subject:From;
        b=Hr8tZLDd49FXh6DT1V8BPYKnb/UVJMmgl4ESR+S6UbqdltIzQ9aRCk7+SLs+XPlVl
         7SpT5WBLxUxoTeXxrchC/wOJcDHA8OAUzBfL5s+ACJsemT+GkK+TVlD0Q4SiUv+9HB
         tXmX8Z9CliEJQxwhdpupsTLZdtn5Q8jvH7Yr4Z/U=
Date:   Fri, 4 Sep 2020 16:34:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

19 patches, based on 59126901f200f5fc907153468b03c64e0081b6e6.

Subsystems affected by this patch series:

  mm/memcg
  mm/slub
  MAINTAINERS
  mm/pagemap
  ipc
  fork
  checkpatch
  mm/madvise
  mm/migration
  mm/hugetlb
  lib

Subsystem: mm/memcg

    Michal Hocko <mhocko@suse.com>:
      memcg: fix use-after-free in uncharge_batch

    Xunlei Pang <xlpang@linux.alibaba.com>:
      mm: memcg: fix memcg reclaim soft lockup

Subsystem: mm/slub

    Eugeniu Rosca <erosca@de.adit-jv.com>:
      mm: slub: fix conversion of freelist_corrupted()

Subsystem: MAINTAINERS

    Robert Richter <rric@kernel.org>:
      MAINTAINERS: update Cavium/Marvell entries

    Nick Desaulniers <ndesaulniers@google.com>:
      MAINTAINERS: add LLVM maintainers

    Randy Dunlap <rdunlap@infradead.org>:
      MAINTAINERS: IA64: mark Status as Odd Fixes only

Subsystem: mm/pagemap

    Joerg Roedel <jroedel@suse.de>:
      mm: track page table modifications in __apply_to_page_range()

Subsystem: ipc

    Tobias Klauser <tklauser@distanz.ch>:
      ipc: adjust proc_ipc_sem_dointvec definition to match prototype

Subsystem: fork

    Tobias Klauser <tklauser@distanz.ch>:
      fork: adjust sysctl_max_threads definition to match prototype

Subsystem: checkpatch

    Mrinal Pandey <mrinalmni@gmail.com>:
      checkpatch: fix the usage of capture group ( ... )

Subsystem: mm/madvise

    Yang Shi <shy828301@gmail.com>:
      mm: madvise: fix vma user-after-free

Subsystem: mm/migration

    Alistair Popple <alistair@popple.id.au>:
      mm/migrate: fixup setting UFFD_WP flag
      mm/rmap: fixup copying of soft dirty and uffd ptes

    Ralph Campbell <rcampbell@nvidia.com>:
    Patch series "mm/migrate: preserve soft dirty in remove_migration_pte()":
      mm/migrate: remove unnecessary is_zone_device_page() check
      mm/migrate: preserve soft dirty in remove_migration_pte()

Subsystem: mm/hugetlb

    Li Xinhai <lixinhai.lxh@gmail.com>:
      mm/hugetlb: try preferred node first when alloc gigantic page from cma

    Muchun Song <songmuchun@bytedance.com>:
      mm/hugetlb: fix a race between hugetlb sysctl handlers

    David Howells <dhowells@redhat.com>:
      mm/khugepaged.c: fix khugepaged's request size in collapse_file

Subsystem: lib

    Jason Gunthorpe <jgg@nvidia.com>:
      include/linux/log2.h: add missing () around n in roundup_pow_of_two()

 MAINTAINERS           |   32 ++++++++++++++++----------------
 include/linux/log2.h  |    2 +-
 ipc/ipc_sysctl.c      |    2 +-
 kernel/fork.c         |    2 +-
 mm/hugetlb.c          |   49 +++++++++++++++++++++++++++++++++++++------------
 mm/khugepaged.c       |    2 +-
 mm/madvise.c          |    2 +-
 mm/memcontrol.c       |    6 ++++++
 mm/memory.c           |   37 ++++++++++++++++++++++++-------------
 mm/migrate.c          |   31 +++++++++++++++++++------------
 mm/rmap.c             |    9 +++++++--
 mm/slub.c             |   12 ++++++------
 mm/vmscan.c           |    8 ++++++++
 scripts/checkpatch.pl |    4 ++--
 14 files changed, 130 insertions(+), 68 deletions(-)

