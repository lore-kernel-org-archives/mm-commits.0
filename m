Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF36EC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95AEB61166
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbhIHWSi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 18:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235647AbhIHWSi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 18:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C3C60F5B;
        Wed,  8 Sep 2021 22:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631139450;
        bh=yIoR1npzLFfOkv6qqQSc8sxUMAokLxr0jIPlYyOkSrI=;
        h=Date:From:To:Cc:Subject:From;
        b=UzxNuoEQVMId/HqqUqBd8vVlOv/q8qDCVhixRZElkbjhASzv5zrBkC6MSH2L8RNbE
         EEvihPACUpI/VY9yyjuXk5273YIGCmM6wKj/HRicZOWTrKFYSFDiLyYyqSpjyOnFU7
         K0vCtncoCPitYNaAlZyW3veU0OjWcTjdtjEuanRA=
Date:   Wed, 8 Sep 2021 15:17:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210908151729.c9a15a9508ba0aed22289c76@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


This is the post-linux-next material, so it is based upon latest
upstream to catch the now-merged dependencies.

10 patches, based on 2d338201d5311bcd79d42f66df4cecbcbc5f4f2c.

Subsystems affected by this patch series:

  mm/vmstat
  mm/migration
  compat

Subsystem: mm/vmstat

    Ingo Molnar <mingo@elte.hu>:
      mm/vmstat: protect per cpu variables with preempt disable on RT

Subsystem: mm/migration

    Baolin Wang <baolin.wang@linux.alibaba.com>:
      mm: migrate: introduce a local variable to get the number of pages
      mm: migrate: fix the incorrect function name in comments
      mm: migrate: change to use bool type for 'page_was_mapped'

Subsystem: compat

    Arnd Bergmann <arnd@arndb.de>:
    Patch series "compat: remove compat_alloc_user_space", v5:
      kexec: move locking into do_kexec_load
      kexec: avoid compat_alloc_user_space
      mm: simplify compat_sys_move_pages
      mm: simplify compat numa syscalls
      compat: remove some compat entry points
      arch: remove compat_alloc_user_space

 arch/arm64/include/asm/compat.h           |    5 
 arch/arm64/include/asm/uaccess.h          |   11 -
 arch/arm64/include/asm/unistd32.h         |   10 -
 arch/arm64/lib/Makefile                   |    2 
 arch/arm64/lib/copy_in_user.S             |   77 ----------
 arch/mips/cavium-octeon/octeon-memcpy.S   |    2 
 arch/mips/include/asm/compat.h            |    8 -
 arch/mips/include/asm/uaccess.h           |   26 ---
 arch/mips/kernel/syscalls/syscall_n32.tbl |   10 -
 arch/mips/kernel/syscalls/syscall_o32.tbl |   10 -
 arch/mips/lib/memcpy.S                    |   11 -
 arch/parisc/include/asm/compat.h          |    6 
 arch/parisc/include/asm/uaccess.h         |    2 
 arch/parisc/kernel/syscalls/syscall.tbl   |    8 -
 arch/parisc/lib/memcpy.c                  |    9 -
 arch/powerpc/include/asm/compat.h         |   16 --
 arch/powerpc/kernel/syscalls/syscall.tbl  |   10 -
 arch/s390/include/asm/compat.h            |   10 -
 arch/s390/include/asm/uaccess.h           |    3 
 arch/s390/kernel/syscalls/syscall.tbl     |   10 -
 arch/s390/lib/uaccess.c                   |   63 --------
 arch/sparc/include/asm/compat.h           |   19 --
 arch/sparc/kernel/process_64.c            |    2 
 arch/sparc/kernel/signal32.c              |   12 -
 arch/sparc/kernel/signal_64.c             |    8 -
 arch/sparc/kernel/syscalls/syscall.tbl    |   10 -
 arch/x86/entry/syscalls/syscall_32.tbl    |    4 
 arch/x86/entry/syscalls/syscall_64.tbl    |    2 
 arch/x86/include/asm/compat.h             |   13 -
 arch/x86/include/asm/uaccess_64.h         |    7 
 include/linux/compat.h                    |   39 +----
 include/linux/uaccess.h                   |   10 -
 include/uapi/asm-generic/unistd.h         |   10 -
 kernel/compat.c                           |   21 --
 kernel/kexec.c                            |  105 +++++---------
 kernel/sys_ni.c                           |    5 
 mm/mempolicy.c                            |  213 +++++++-----------------------
 mm/migrate.c                              |   69 +++++----
 mm/vmstat.c                               |   48 ++++++
 39 files changed, 243 insertions(+), 663 deletions(-)

