Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9007DC4167B
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C1E02312E
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLFGOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Dec 2020 01:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgLFGOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 6 Dec 2020 01:14:54 -0500
Date:   Sat, 5 Dec 2020 22:14:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235253;
        bh=1DoLnJ6DKBksKlUKKCIHOBo+kYqreRw6CiYEt8YFw90=;
        h=From:To:Cc:Subject:From;
        b=vQePTx9ZQXnO1tOz3TMV8NNggZsnTw+2CxCOcuRnwrnc8Wl5VAmz4YH80Vt9zBFE2
         yju/c4etz724owR6Qkd7hr14P8vTJ600B4bDmAVHA04EInKHQsYSj9g8DobW8tL2Ep
         Hm/ph2I4jlRAMA04tNF7ZxCFrP9kkWaOnxiiNWFU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

12 patches, based on 33256ce194110874d4bc90078b577c59f9076c59.

Subsystems affected by this patch series:

  lib
  coredump
  mm/memcg
  mm/zsmalloc
  mm/swap
  mailmap
  mm/selftests
  mm/pagecache
  mm/hugetlb
  mm/pagemap

Subsystem: lib

    Randy Dunlap <rdunlap@infradead.org>:
      zlib: export S390 symbols for zlib modules

Subsystem: coredump

    Menglong Dong <dong.menglong@zte.com.cn>:
      coredump: fix core_pattern parse error

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
      mm: memcg/slab: fix obj_cgroup_charge() return value handling

    Yang Shi <shy828301@gmail.com>:
      mm: list_lru: set shrinker map bit when child nr_items is not zero

Subsystem: mm/zsmalloc

    Minchan Kim <minchan@kernel.org>:
      mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

Subsystem: mm/swap

    Qian Cai <qcai@redhat.com>:
      mm/swapfile: do not sleep with a spin lock held

Subsystem: mailmap

    Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>:
      mailmap: add two more addresses of Uwe Kleine-K=F6nig

Subsystem: mm/selftests

    Xingxing Su <suxingxing@loongson.cn>:
      tools/testing/selftests/vm: fix build error

    Axel Rasmussen <axelrasmussen@google.com>:
      userfaultfd: selftests: fix SIGSEGV if huge mmap fails

Subsystem: mm/pagecache

    Alex Shi <alex.shi@linux.alibaba.com>:
      mm/filemap: add static for function __add_to_page_cache_locked

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      hugetlb_cgroup: fix offline of hugetlb cgroup with reservations

Subsystem: mm/pagemap

    Liu Zixian <liuzixian4@huawei.com>:
      mm/mmap.c: fix mmap return value when vma is merged after call_mmap()

 .mailmap                                 |    2 +
 arch/arm/configs/omap2plus_defconfig     |    1=20
 fs/coredump.c                            |    3 +
 include/linux/zsmalloc.h                 |    1=20
 lib/zlib_dfltcc/dfltcc_inflate.c         |    3 +
 mm/Kconfig                               |   13 -------
 mm/filemap.c                             |    2 -
 mm/hugetlb_cgroup.c                      |    8 +---
 mm/list_lru.c                            |   10 ++---
 mm/mmap.c                                |   26 ++++++--------
 mm/slab.h                                |   40 +++++++++++++---------
 mm/swapfile.c                            |    4 +-
 mm/zsmalloc.c                            |   54 --------------------------=
-----
 tools/testing/selftests/vm/Makefile      |    4 ++
 tools/testing/selftests/vm/userfaultfd.c |   25 +++++++++-----
 15 files changed, 75 insertions(+), 121 deletions(-)

