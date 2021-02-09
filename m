Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C54CC433DB
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34BB864E57
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhBIXIA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234028AbhBIWR2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 17:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 993C164E42;
        Tue,  9 Feb 2021 21:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906876;
        bh=sKXdG17vo20kiDzl0NeJEdZEBLZyyJu82VAajeNF8DY=;
        h=Date:From:To:Cc:Subject:From;
        b=VasVPtxre6Ex31URBWWs1tCZI8ErghJp9YQIgl5rUSyeg6tnciO830i3tft86W/41
         +2INjfgfqco/0vu9ZGUyRrV0fqPeKGalpOJ9PvY9ofD0uZQ/FFxUEGIN4LgRafXP/j
         wkBAahcyEIIFtmBi/vDgpKXYt5iAG6nRR/SUxeEE=
Date:   Tue, 9 Feb 2021 13:41:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

14 patches, based on e0756cfc7d7cd08c98a53b6009c091a3f6a50be6.

Subsystems affected by this patch series:

  squashfs
  mm/kasan
  firmware
  mm/mremap
  mm/tmpfs
  mm/selftests
  MAINTAINERS
  mm/memcg
  mm/slub
  nilfs2

Subsystem: squashfs

    Phillip Lougher <phillip@squashfs.org.uk>:
    Patch series "Squashfs: fix BIO migration regression and add sanity checks":
      squashfs: avoid out of bounds writes in decompressors
      squashfs: add more sanity checks in id lookup
      squashfs: add more sanity checks in inode lookup
      squashfs: add more sanity checks in xattr id lookup

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: fix stack traces dependency for HW_TAGS

Subsystem: firmware

    Fangrui Song <maskray@google.com>:
      firmware_loader: align .builtin_fw to 8

Subsystem: mm/mremap

    Arnd Bergmann <arnd@arndb.de>:
      mm/mremap: fix BUILD_BUG_ON() error in get_extent

Subsystem: mm/tmpfs

    Seth Forshee <seth.forshee@canonical.com>:
      tmpfs: disallow CONFIG_TMPFS_INODE64 on s390
      tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha

Subsystem: mm/selftests

    Rong Chen <rong.a.chen@intel.com>:
      selftests/vm: rename file run_vmtests to run_vmtests.sh

Subsystem: MAINTAINERS

    Andrey Ryabinin <ryabinin.a.a@gmail.com>:
      MAINTAINERS: update Andrey Ryabinin's email address

Subsystem: mm/memcg

    Johannes Weiner <hannes@cmpxchg.org>:
      Revert "mm: memcontrol: avoid workload stalls when lowering memory.high"

Subsystem: mm/slub

    Vlastimil Babka <vbabka@suse.cz>:
      mm, slub: better heuristic for number of cpus when calculating slab order

Subsystem: nilfs2

    Joachim Henke <joachim.henke@t-systems.com>:
      nilfs2: make splice write available again

 .mailmap                          |    1 
 Documentation/dev-tools/kasan.rst |    3 -
 MAINTAINERS                       |    2 -
 fs/Kconfig                        |    4 +-
 fs/nilfs2/file.c                  |    1 
 fs/squashfs/block.c               |    8 ++++
 fs/squashfs/export.c              |   41 +++++++++++++++++++----
 fs/squashfs/id.c                  |   40 ++++++++++++++++++-----
 fs/squashfs/squashfs_fs_sb.h      |    1 
 fs/squashfs/super.c               |    6 +--
 fs/squashfs/xattr.h               |   10 +++++
 fs/squashfs/xattr_id.c            |   66 ++++++++++++++++++++++++++++++++------
 include/asm-generic/vmlinux.lds.h |    2 -
 mm/kasan/hw_tags.c                |    8 +---
 mm/memcontrol.c                   |    5 +-
 mm/mremap.c                       |    5 +-
 mm/slub.c                         |   18 +++++++++-
 17 files changed, 172 insertions(+), 49 deletions(-)

