Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85782C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F316113E
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhJRWQx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhJRWQx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:16:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32C3560F57;
        Mon, 18 Oct 2021 22:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595281;
        bh=Kp71fi2d0d+90qdsNfMztqZnaQDdGb/8lInLXl39fEg=;
        h=Date:From:To:Cc:Subject:From;
        b=xuumPZMSiSSygrfAZL+i6u9/eXQAjTkGxzliSvKbi830MLRKNDdVizHZ/WeF0Gzcq
         eceY0oH6ie8hnA6GosguMSPKsPzAVulyQ3sngQcxtpJqKzINuILJ32fcch+/WBl43P
         bzU5wEVqNDMF1tmUuzRKAWMMW2td9Chm3DJAUy9g=
Date:   Mon, 18 Oct 2021 15:14:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


19 patches, based on 519d81956ee277b4419c723adfb154603c2565ba.

Subsystems affected by this patch series:

  mm/userfaultfd
  mm/migration
  ocfs2
  mm/memblock
  mm/mempolicy
  mm/slub
  binfmt
  vfs
  mm/secretmem
  mm/thp
  misc

Subsystem: mm/userfaultfd

    Peter Xu <peterx@redhat.com>:
      mm/userfaultfd: selftests: fix memory corruption with thp enabled

    Nadav Amit <namit@vmware.com>:
      userfaultfd: fix a race between writeprotect and exit_mmap()

Subsystem: mm/migration

    Dave Hansen <dave.hansen@linux.intel.com>:
    Patch series "mm/migrate: 5.15 fixes for automatic demotion", v2:
      mm/migrate: optimize hotplug-time demotion order updates
      mm/migrate: add CPU hotplug to demotion #ifdef

    Huang Ying <ying.huang@intel.com>:
      mm/migrate: fix CPUHP state to update node demotion order

Subsystem: ocfs2

    Jan Kara <jack@suse.cz>:
      ocfs2: fix data corruption after conversion from inline format

    Valentin Vidic <vvidic@valentin-vidic.from.hr>:
      ocfs2: mount fails with buffer overflow in strlen

Subsystem: mm/memblock

    Peng Fan <peng.fan@nxp.com>:
      memblock: check memory total_size

Subsystem: mm/mempolicy

    Eric Dumazet <edumazet@google.com>:
      mm/mempolicy: do not allow illegal MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()

Subsystem: mm/slub

    Miaohe Lin <linmiaohe@huawei.com>:
    Patch series "Fixups for slub":
      mm, slub: fix two bugs in slab_debug_trace_open()
      mm, slub: fix mismatch between reconstructed freelist depth and cnt
      mm, slub: fix potential memoryleak in kmem_cache_open()
      mm, slub: fix potential use-after-free in slab_debugfs_fops
      mm, slub: fix incorrect memcg slab count for bulk free

Subsystem: binfmt

    Lukas Bulwahn <lukas.bulwahn@gmail.com>:
      elfcore: correct reference to CONFIG_UML

Subsystem: vfs

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      vfs: check fd has read access in kernel_read_file_from_fd()

Subsystem: mm/secretmem

    Sean Christopherson <seanjc@google.com>:
      mm/secretmem: fix NULL page->mapping dereference in page_is_secretmem()

Subsystem: mm/thp

    Marek Szyprowski <m.szyprowski@samsung.com>:
      mm/thp: decrease nr_thps in file's mapping on THP split

Subsystem: misc

    Andrej Shadura <andrew.shadura@collabora.co.uk>:
      mailmap: add Andrej Shadura

 .mailmap                                 |    2 +
 fs/kernel_read_file.c                    |    2 -
 fs/ocfs2/alloc.c                         |   46 ++++++-----------------
 fs/ocfs2/super.c                         |   14 +++++--
 fs/userfaultfd.c                         |   12 ++++--
 include/linux/cpuhotplug.h               |    4 ++
 include/linux/elfcore.h                  |    2 -
 include/linux/memory.h                   |    5 ++
 include/linux/secretmem.h                |    2 -
 mm/huge_memory.c                         |    6 ++-
 mm/memblock.c                            |    2 -
 mm/mempolicy.c                           |   16 ++------
 mm/migrate.c                             |   62 ++++++++++++++++++-------------
 mm/page_ext.c                            |    4 --
 mm/slab.c                                |    4 +-
 mm/slub.c                                |   31 ++++++++++++---
 tools/testing/selftests/vm/userfaultfd.c |   23 ++++++++++-
 17 files changed, 138 insertions(+), 99 deletions(-)

