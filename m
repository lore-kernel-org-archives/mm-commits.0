Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4331EC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 23:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442592AbiDUXiC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 19:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442599AbiDUXiB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 19:38:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC3847044
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 16:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D5A61EBF
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 23:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDF6C385A5;
        Thu, 21 Apr 2022 23:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650584109;
        bh=V8vOEB4GGqGY+tfy8ZG9cDVzN2PqjqeTYwr3y57LTKw=;
        h=Date:From:To:Cc:Subject:From;
        b=aQp+xIJIh+aoq5B6CpFJAlhH34vK1kcFCWyrj8bI2JMgGDUJIck5VAhAGyP+yMMgW
         Y4vuQCF7Mpf5gOAqTPXCsX2qiJgrB8dkD+9UPExmResIQ3RmUidugdYZsnITI+oNrW
         j8oUD3OFKyVmVyBW2PL7JI4T4rUWeIH9e3rczeTU=
Date:   Thu, 21 Apr 2022 16:35:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        patches@lists.linux.dev
Subject: incoming
Message-Id: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

13 patches, based on b253435746d9a4a701b5f09211b9c14d3370d0da.

Subsystems affected by this patch series:

  mm/memory-failure
  mm/memcg
  mm/userfaultfd
  mm/hugetlbfs
  mm/mremap
  mm/oom-kill
  mm/kasan
  kcov
  mm/hmm

Subsystem: mm/memory-failure

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()

    Xu Yu <xuyu@linux.alibaba.com>:
      mm/memory-failure.c: skip huge_zero_page in memory_failure()

Subsystem: mm/memcg

    Shakeel Butt <shakeelb@google.com>:
      memcg: sync flush only if periodic flush is delayed

Subsystem: mm/userfaultfd

    Nadav Amit <namit@vmware.com>:
      userfaultfd: mark uffd_wp regardless of VM_WRITE flag

Subsystem: mm/hugetlbfs

    Christophe Leroy <christophe.leroy@csgroup.eu>:
      mm, hugetlb: allow for "high" userspace addresses

Subsystem: mm/mremap

    Sidhartha Kumar <sidhartha.kumar@oracle.com>:
      selftest/vm: verify mmap addr in mremap_test
      selftest/vm: verify remap destination address in mremap_test
      selftest/vm: support xfail in mremap_test
      selftest/vm: add skip support to mremap_test

Subsystem: mm/oom-kill

    Nico Pache <npache@redhat.com>:
      oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup

Subsystem: mm/kasan

    Vincenzo Frascino <vincenzo.frascino@arm.com>:
      MAINTAINERS: add Vincenzo Frascino to KASAN reviewers

Subsystem: kcov

    Aleksandr Nogikh <nogikh@google.com>:
      kcov: don't generate a warning on vm_insert_page()'s failure

Subsystem: mm/hmm

    Alistair Popple <apopple@nvidia.com>:
      mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()

 MAINTAINERS                               |    1 
 fs/hugetlbfs/inode.c                      |    9 -
 include/linux/hugetlb.h                   |    6 +
 include/linux/memcontrol.h                |    5 
 include/linux/mm.h                        |    8 +
 include/linux/sched.h                     |    1 
 include/linux/sched/mm.h                  |    8 +
 kernel/kcov.c                             |    7 -
 mm/hugetlb.c                              |   10 +
 mm/memcontrol.c                           |   12 ++
 mm/memory-failure.c                       |  158 ++++++++++++++++++++++--------
 mm/mmap.c                                 |    8 -
 mm/mmu_notifier.c                         |   14 ++
 mm/oom_kill.c                             |   54 +++++++---
 mm/userfaultfd.c                          |   15 +-
 mm/workingset.c                           |    2 
 tools/testing/selftests/vm/mremap_test.c  |   85 +++++++++++++++-
 tools/testing/selftests/vm/run_vmtests.sh |   11 +-
 18 files changed, 327 insertions(+), 87 deletions(-)

