Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1546AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA17623E20
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391317AbgLKVgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390903AbgLKVgh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 16:36:37 -0500
Date:   Fri, 11 Dec 2020 13:35:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607722556;
        bh=6lAtr240I9RyBGdjItIaO6oEUlsrEDTw/Pe6YbmaUAs=;
        h=From:To:Cc:Subject:From;
        b=1eLM4XsIx4vnXj++Jsg/7I+WMNhae0GuvUdxQsXa0ylgkINrKPqa5ct2+Pdh9wQhR
         /UcQnvNlA7uZjf/tHyOq3ue0pWxNMDypmRGjk+r4Y/5FScPmGqm09zTZhgkiwdhb2s
         bOctrfRO8q3foBTNOY+eSbSpRpUGffOQcla2FGM8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20201211133555.88407977f082963499ed343c@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

8 patches, based on 33dc9614dc208291d0c4bcdeb5d30d481dcd2c4c.

Subsystems affected by this patch series:

  mm/pagecache
  proc
  selftests
  kbuild
  mm/kasan
  mm/hugetlb

Subsystem: mm/pagecache

    Andrew Morton <akpm@linux-foundation.org>:
      revert "mm/filemap: add static for function __add_to_page_cache_locked"

Subsystem: proc

    Miles Chen <miles.chen@mediatek.com>:
      proc: use untagged_addr() for pagemap_read addresses

Subsystem: selftests

    Arnd Bergmann <arnd@arndb.de>:
      selftest/fpu: avoid clang warning

Subsystem: kbuild

    Arnd Bergmann <arnd@arndb.de>:
      kbuild: avoid static_assert for genksyms
      initramfs: fix clang build failure
      elfcore: fix building with clang

Subsystem: mm/kasan

    Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>:
      kasan: fix object remaining in offline per-cpu quarantine

Subsystem: mm/hugetlb

    Gerald Schaefer <gerald.schaefer@linux.ibm.com>:
      mm/hugetlb: clear compound_nr before freeing gigantic pages

 fs/proc/task_mmu.c        |    8 ++++++--
 include/linux/build_bug.h |    5 +++++
 include/linux/elfcore.h   |   22 ++++++++++++++++++++++
 init/initramfs.c          |    2 +-
 kernel/Makefile           |    1 -
 kernel/elfcore.c          |   26 --------------------------
 lib/Makefile              |    3 ++-
 mm/filemap.c              |    2 +-
 mm/hugetlb.c              |    1 +
 mm/kasan/quarantine.c     |   39 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 77 insertions(+), 32 deletions(-)

