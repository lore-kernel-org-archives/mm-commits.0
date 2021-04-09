Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95EFC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA20C61108
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhDIU0r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234076AbhDIU0r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F13610A8;
        Fri,  9 Apr 2021 20:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617999993;
        bh=TGM1H1hzsI3Vj+2HnOXvwfjJ3RcGByaatUsZV98h5DA=;
        h=Date:From:To:Cc:Subject:From;
        b=gUyA7+IurR1W0uobgF+EGgDlOEjZCK5oH53rgJLfl/G2K6Cria82g1d9VSG/9Z0ta
         nnrd8i3Hf2Yjcw+mBw58akYYEJLvimQaJJOmPB/+KWenKodiL8eU8EMgjgm8+s/NMF
         RAuyIlWCkneBSLrtZujkJGbk7qASQkpBYlIAM5mA=
Date:   Fri, 9 Apr 2021 13:26:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

16 patches, based on 17e7124aad766b3f158943acb51467f86220afe9.

Subsystems affected by this patch series:

  MAINTAINERS
  mailmap
  mm/kasan
  mm/gup
  nds32
  gcov
  ocfs2
  ia64
  mm/pagecache
  mm/kasan
  mm/kfence
  lib

Subsystem: MAINTAINERS

    Marek Beh=FAn <kabel@kernel.org>:
      MAINTAINERS: update CZ.NIC's Turris information
      treewide: change my e-mail address, fix my name

Subsystem: mailmap

    Jordan Crouse <jordan@cosmicpenguin.net>:
      mailmap: update email address for Jordan Crouse

    Matthew Wilcox <willy@infradead.org>:
      .mailmap: fix old email addresses

Subsystem: mm/kasan

    Arnd Bergmann <arnd@arndb.de>:
      kasan: fix hwasan build for gcc

    Walter Wu <walter-zh.wu@mediatek.com>:
      kasan: remove redundant config option

Subsystem: mm/gup

    Aili Yao <yaoaili@kingsoft.com>:
      mm/gup: check page posion status for coredump.

Subsystem: nds32

    Mike Rapoport <rppt@linux.ibm.com>:
      nds32: flush_dcache_page: use page_mapping_file to avoid races with s=
wapoff

Subsystem: gcov

    Nick Desaulniers <ndesaulniers@google.com>:
      gcov: re-fix clang-11+ support

Subsystem: ocfs2

    Wengang Wang <wen.gang.wang@oracle.com>:
      ocfs2: fix deadlock between setattr and dio_end_io_write

Subsystem: ia64

    Sergei Trofimovich <slyfox@gentoo.org>:
      ia64: fix user_stack_pointer() for ptrace()

Subsystem: mm/pagecache

    Jack Qiu <jack.qiu@huawei.com>:
      fs: direct-io: fix missing sdio->boundary

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: fix conflict with page poisoning

    Andrew Morton <akpm@linux-foundation.org>:
      lib/test_kasan_module.c: suppress unused var warning

Subsystem: mm/kfence

    Marco Elver <elver@google.com>:
      kfence, x86: fix preemptible warning on KPTI-enabled systems

Subsystem: lib

    Julian Braha <julianbraha@gmail.com>:
      lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS

 .mailmap                                                            |    7=
 ++
 Documentation/ABI/testing/debugfs-moxtet                            |    4=
 -
 Documentation/ABI/testing/debugfs-turris-mox-rwtm                   |    2=
=20
 Documentation/ABI/testing/sysfs-bus-moxtet-devices                  |    6=
 +-
 Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia       |    2=
=20
 Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm            |   10=
 +--
 Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml |    2=
=20
 MAINTAINERS                                                         |   13=
 +++-
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts              |    2=
=20
 arch/arm64/kernel/sleep.S                                           |    2=
=20
 arch/ia64/include/asm/ptrace.h                                      |    8=
 --
 arch/nds32/mm/cacheflush.c                                          |    2=
=20
 arch/x86/include/asm/kfence.h                                       |    7=
 ++
 arch/x86/kernel/acpi/wakeup_64.S                                    |    2=
=20
 drivers/bus/moxtet.c                                                |    4=
 -
 drivers/firmware/turris-mox-rwtm.c                                  |    4=
 -
 drivers/gpio/gpio-moxtet.c                                          |    4=
 -
 drivers/leds/leds-turris-omnia.c                                    |    4=
 -
 drivers/mailbox/armada-37xx-rwtm-mailbox.c                          |    4=
 -
 drivers/watchdog/armada_37xx_wdt.c                                  |    4=
 -
 fs/direct-io.c                                                      |    5=
 +
 fs/ocfs2/aops.c                                                     |   11=
 ---
 fs/ocfs2/file.c                                                     |    8=
 ++
 include/dt-bindings/bus/moxtet.h                                    |    2=
=20
 include/linux/armada-37xx-rwtm-mailbox.h                            |    2=
=20
 include/linux/kasan.h                                               |    2=
=20
 include/linux/moxtet.h                                              |    2=
=20
 kernel/gcov/clang.c                                                 |   29=
 ++++++----
 lib/Kconfig.debug                                                   |    6=
 +-
 lib/Kconfig.kasan                                                   |    9=
 ---
 lib/test_kasan_module.c                                             |    2=
=20
 mm/gup.c                                                            |    4=
 +
 mm/internal.h                                                       |   20=
 ++++++
 mm/kasan/common.c                                                   |    2=
=20
 mm/kasan/kasan.h                                                    |    2=
=20
 mm/kasan/report_generic.c                                           |    2=
=20
 mm/page_poison.c                                                    |    4=
 +
 scripts/Makefile.kasan                                              |   18=
 ++++--
 security/Kconfig.hardening                                          |    4=
 -
 39 files changed, 136 insertions(+), 91 deletions(-)

