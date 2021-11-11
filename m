Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EF2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30EDB6134F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhKKEez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhKKEez (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 23:34:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC33C61052;
        Thu, 11 Nov 2021 04:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636605127;
        bh=tO/eIo6XlifGVW8EtIKQR2SpCnZWu11pqnwFaUgF3XY=;
        h=Date:From:To:Cc:Subject:From;
        b=XoBzAqt9YcQaO/8dT0Q/kXQsumgvZrHgZ09adbnO7Era/vN+ngkO0+j+5ZYXS9qkV
         mbNqdJxGC1hYwzohn0UG48HRUhJYH+DQFiC1yvRNKk0C/TyPXsQ9nWjqWBkSicXcZj
         TdutFINf4qmq7uX0Yt4DmC0u1dJPCYssdg9NYjB4=
Date:   Wed, 10 Nov 2021 20:32:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20211110203204.37de96048c3279ab2da758a5@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

The post-linux-next material.

7 patches, based on debe436e77c72fcee804fb867f275e6d31aa999c.

Subsystems affected by this patch series:

  mm/debug
  mm/slab-generic
  mm/migration
  mm/memcg
  mm/kasan

Subsystem: mm/debug

    Yixuan Cao <caoyixuan2019@email.szu.edu.cn>:
      mm/page_owner.c: modify the type of argument "order" in some functions

Subsystem: mm/slab-generic

    Ingo Molnar <mingo@kernel.org>:
      mm: allow only SLUB on PREEMPT_RT

Subsystem: mm/migration

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm: migrate: simplify the file-backed pages validation when migrating its mapping

    Alistair Popple <apopple@nvidia.com>:
      mm/migrate.c: remove MIGRATE_PFN_LOCKED

Subsystem: mm/memcg

    Christoph Hellwig <hch@lst.de>:
    Patch series "unexport memcg locking helpers":
      mm: unexport folio_memcg_{,un}lock
      mm: unexport {,un}lock_page_memcg

Subsystem: mm/kasan

    Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>:
      kasan: add kasan mode messages when kasan init

 Documentation/vm/hmm.rst                 |    2 
 arch/arm64/mm/kasan_init.c               |    2 
 arch/powerpc/kvm/book3s_hv_uvmem.c       |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    2 
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |    4 
 include/linux/migrate.h                  |    1 
 include/linux/page_owner.h               |   12 +-
 init/Kconfig                             |    2 
 lib/test_hmm.c                           |    5 -
 mm/kasan/hw_tags.c                       |   14 ++
 mm/kasan/sw_tags.c                       |    2 
 mm/memcontrol.c                          |    4 
 mm/migrate.c                             |  151 +++++--------------------------
 mm/page_owner.c                          |    6 -
 14 files changed, 61 insertions(+), 150 deletions(-)

