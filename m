Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A83BC10DCE
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 17:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345220AbjLERVA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 12:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345246AbjLERU7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 12:20:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DD2BA
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 09:21:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF75C433C7;
        Tue,  5 Dec 2023 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701796861;
        bh=AgltV6ReDBsRsaB0rhbyCbYWa5mACTmMX8wc2XtiDus=;
        h=Date:To:From:Subject:From;
        b=DJxuHZV/rXwEeTGQtK7OEA+U6IDP4zlYmgNtMQt5yjy05D6x8rcpIlogRs127wUrk
         JXiZZOW/c8HEo9zONrhanzUgHpjhLnXcHogDowYaE9xQIBXheFLSvmBvZbZOinZbKn
         HmG1MRMUVMASnNywnAkxO3V5g1VLbp8jmTw5tegY=
Date:   Tue, 05 Dec 2023 09:21:01 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, ignat@cloudflare.com, eric_devolder@yahoo.com,
        aou@eecs.berkeley.edu, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-fix-vmallc_start-definition.patch added to mm-hotfixes-unstable branch
Message-Id: <20231205172101.BBF75C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: fix VMALLOC_START definition
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     riscv-fix-vmallc_start-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-fix-vmallc_start-definition.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: riscv: fix VMALLOC_START definition
Date: Tue, 5 Dec 2023 11:02:55 +0800

When below config items are set, compiler complained:

--------------------
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
......
-----------------------

-------------------------------------------------------------------
arch/riscv/kernel/crash_core.c: In function 'arch_crash_save_vmcoreinfo':
arch/riscv/kernel/crash_core.c:11:58: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'int' [-Wformat=]
11 |         vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
   |                                                        ~~^
   |                                                          |
   |                                                          long unsigned int
   |                                                        %x
----------------------------------------------------------------------

This is because on riscv macro VMALLOC_START has different type when
CONFIG_MMU is set or unset.

arch/riscv/include/asm/pgtable.h:
--------------------------------------------------

Changing it to _AC(0, UL) in case CONFIG_MMU=n can fix the warning.

Link: https://lkml.kernel.org/r/ZW7OsX4zQRA3mO4+@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h~riscv-fix-vmallc_start-definition
+++ a/arch/riscv/include/asm/pgtable.h
@@ -899,7 +899,7 @@ static inline pte_t pte_swp_clear_exclus
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
 #define TASK_SIZE		0xffffffffUL
-#define VMALLOC_START		0
+#define VMALLOC_START		_AC(0, UL)
 #define VMALLOC_END		TASK_SIZE
 
 #endif /* !CONFIG_MMU */
_

Patches currently in -mm which might be from bhe@redhat.com are

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
kexec_core-change-dependency-of-object-files.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch
riscv-fix-vmallc_start-definition.patch
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

