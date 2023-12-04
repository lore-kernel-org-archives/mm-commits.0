Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FC9C10DC1
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjLDTde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjLDTde (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:33:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A9D111
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:33:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1AFC433C7;
        Mon,  4 Dec 2023 19:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701718419;
        bh=v1FSalHj982bAPsU1LXn1toTvM7ddm9g5TlWCKWEGv4=;
        h=Date:To:From:Subject:From;
        b=ERvrht3sTGS/3Fo45pCSZ6inSwhu31Iza+SERNJmuQJPgJbVqKFHiqA9JUNdLt4f9
         YPVRS95fzMxTEvwawev4vOcLxyfPEyxBCKzm0frOpzOI9YE63T5GikrZGtQD/stf0o
         e6PPW4Hh2u4N3iaOiBRIjDar7m6ylmkS9HevGyFQ=
Date:   Mon, 04 Dec 2023 11:33:38 -0800
To:     mm-commits@vger.kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, mick@ics.forth.gr, changbin.du@intel.com,
        aou@eecs.berkeley.edu, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch added to mm-nonmm-unstable branch
Message-Id: <20231204193339.3B1AFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv, kexec: fix the ifdeffery for AFLAGS_kexec_relocate.o
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: riscv, kexec: fix the ifdeffery for AFLAGS_kexec_relocate.o
Date: Fri, 1 Dec 2023 14:25:38 +0800

This was introduced in commit fba8a8674f68 ("RISC-V: Add kexec
support").

It should work on CONFIG_KEXEC_CORE, but not CONFIG_KEXEC only, since
we could set CONFIG_KEXEC_FILE=y and CONFIG_KEXEC=N, or only set
CONFIG_CRASH_DUMP=y and disable both CONFIG_KEXEC and CONFIG_KEXEC_FILE.
In these cases, the AFLAGS won't take effect with the current ifdeffery
for AFLAGS_kexec_relocate.o.

So fix it now.

Link: https://lkml.kernel.org/r/20231201062538.27240-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Nick Kossifidis <mick@ics.forth.gr>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/Makefile~riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo
+++ a/arch/riscv/kernel/Makefile
@@ -11,7 +11,7 @@ endif
 CFLAGS_syscall_table.o	+= $(call cc-option,-Wno-override-init,)
 CFLAGS_compat_syscall_table.o += $(call cc-option,-Wno-override-init,)
 
-ifdef CONFIG_KEXEC
+ifdef CONFIG_KEXEC_CORE
 AFLAGS_kexec_relocate.o := -mcmodel=medany $(call cc-option,-mno-relax)
 endif
 
_

Patches currently in -mm which might be from bhe@redhat.com are

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
kexec_core-change-dependency-of-object-files.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

