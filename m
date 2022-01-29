Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA692C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353166AbiA2Vkc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352738AbiA2Vkb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1C5C061714
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 13:40:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C48BBB827BE
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E44CC340E5;
        Sat, 29 Jan 2022 21:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492427;
        bh=VSYuYPMnftdueoOaTEu60W20vpxs1ei1A87d6b4Xj2o=;
        h=Date:From:To:Cc:Subject:From;
        b=UX799c1yG9A74abq0D89VW+WDI9Ycg37x/QWbSGl0QOp+ODSXKQQFrsfZd58MbMAV
         Kyvzy64hKcN1SXCOm2w9TFk8pG3F/L8ssCwGfVxj1eyAej8+QLx8sMC7ydMhKwscIx
         Ll2YDj/qFpBlagy/gzPCwsIbDTNUUr7a8Eyyj+c0=
Date:   Sat, 29 Jan 2022 13:40:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

12 patches, based on f8c7e4ede46fe63ff10000669652648aab09d112.

Subsystems affected by this patch series:

  sysctl
  binfmt
  ia64
  mm/memory-failure
  mm/folios
  selftests
  mm/kasan
  mm/psi
  ocfs2

Subsystem: sysctl

    Andrew Morton <akpm@linux-foundation.org>:
      include/linux/sysctl.h: fix register_sysctl_mount_point() return type

Subsystem: binfmt

    Tong Zhang <ztong0001@gmail.com>:
      binfmt_misc: fix crash when load/unload module

Subsystem: ia64

    Randy Dunlap <rdunlap@infradead.org>:
      ia64: make IA64_MCA_RECOVERY bool instead of tristate

Subsystem: mm/memory-failure

    Joao Martins <joao.m.martins@oracle.com>:
      memory-failure: fetch compound_head after pgmap_pfn_valid()

Subsystem: mm/folios

    Wei Yang <richard.weiyang@gmail.com>:
      mm: page->mapping folio->mapping should have the same offset

Subsystem: selftests

    Maor Gottlieb <maorg@nvidia.com>:
      tools/testing/scatterlist: add missing defines

Subsystem: mm/kasan

    Marco Elver <elver@google.com>:
      kasan: test: fix compatibility with FORTIFY_SOURCE

    Peter Collingbourne <pcc@google.com>:
      mm, kasan: use compare-exchange operation to set KASAN page tag

Subsystem: mm/psi

    Suren Baghdasaryan <surenb@google.com>:
      psi: fix "no previous prototype" warnings when CONFIG_CGROUPS=n
      psi: fix "defined but not used" warnings when CONFIG_PROC_FS=n

Subsystem: ocfs2

    Joseph Qi <joseph.qi@linux.alibaba.com>:
    Patch series "ocfs2: fix a deadlock case":
      jbd2: export jbd2_journal_[grab|put]_journal_head
      ocfs2: fix a deadlock when commit trans

 arch/ia64/Kconfig                    |    2 
 fs/binfmt_misc.c                     |    8 +--
 fs/jbd2/journal.c                    |    2 
 fs/ocfs2/suballoc.c                  |   25 ++++-------
 include/linux/mm.h                   |   17 +++++--
 include/linux/mm_types.h             |    1 
 include/linux/psi.h                  |   11 ++--
 include/linux/sysctl.h               |    2 
 kernel/sched/psi.c                   |   79 ++++++++++++++++++-----------------
 lib/test_kasan.c                     |    5 ++
 mm/memory-failure.c                  |    6 ++
 tools/testing/scatterlist/linux/mm.h |    3 -
 12 files changed, 91 insertions(+), 70 deletions(-)

