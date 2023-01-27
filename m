Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95134C38142
	for <mm-commits@archiver.kernel.org>; Fri, 27 Jan 2023 23:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjA0XHF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Jan 2023 18:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjA0XHE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2023 18:07:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE512166DE
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2023 15:07:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 343E061DD9
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2023 23:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FA0C433D2;
        Fri, 27 Jan 2023 23:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674860822;
        bh=UPwAp31xpVn+v3tOl1AUZY0HSlNKQ2hBVsf08xn28Kw=;
        h=Date:To:From:Subject:From;
        b=1I3Gy7IgHTdPRVc3V3kNcaDuLCTOupJHdxO4Ru8vFJkC0rJLZKSD/adi1K6Iwxh4I
         09I9LAkHbO2hiCkQdTUtcPOPv81jN6EwcJgVI92+b8gJ2qvISJt4YMFk6yG4KaGu39
         8cHHQ9t5pJ8BUJ1CfEgQ+cyRp6jCZK1gcVnmJWqs=
Date:   Fri, 27 Jan 2023 15:07:01 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        palmer@rivosinc.com, nathan@kernel.org, naresh.kamboju@linaro.org,
        masahiroy@kernel.org, hch@lst.de, gregkh@linuxfoundation.org,
        glaubitz@physik.fu-berlin.de, dennis@ausil.us, dalias@libc.org,
        arnd@arndb.de, ardb@kernel.org, tom.saeger@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-define-runtime_discard_exit.patch added to mm-hotfixes-unstable branch
Message-Id: <20230127230702.81FA0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: define RUNTIME_DISCARD_EXIT
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sh-define-runtime_discard_exit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-define-runtime_discard_exit.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tom Saeger <tom.saeger@oracle.com>
Subject: sh: define RUNTIME_DISCARD_EXIT
Date: Mon, 23 Jan 2023 17:09:35 -0700

sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").

This is similar to fixes for powerpc and s390:
commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
with GNU ld < 2.36").

  $ sh4-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2

  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-

  `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
  defined in discarded section `.exit.text' of crypto/algboss.o
  `.exit.text' referenced in section `__bug_table' of
  drivers/char/hw_random/core.o: defined in discarded section
  `.exit.text' of drivers/char/hw_random/core.o
  make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make[1]: *** [Makefile:1252: vmlinux] Error 2

arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:

	/*
	 * .exit.text is discarded at runtime, not link time, to deal with
	 * references from __bug_table
	 */
	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }

However, EXIT_TEXT is thrown away by
DISCARD(include/asm-generic/vmlinux.lds.h) because
sh does not define RUNTIME_DISCARD_EXIT.

GNU ld 2.40 does not have this issue and builds fine.
This corresponds with Masahiro's comments in a494398bde27:
"Nathan [Chancellor] also found that binutils
commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
issue, so we cannot reproduce it with binutils 2.36+, but it is better
to not rely on it."

Link: https://lkml.kernel.org/r/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com
Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dennis Gilmore <dennis@ausil.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/sh/kernel/vmlinux.lds.S~sh-define-runtime_discard_exit
+++ a/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>
_

Patches currently in -mm which might be from tom.saeger@oracle.com are

sh-define-runtime_discard_exit.patch

