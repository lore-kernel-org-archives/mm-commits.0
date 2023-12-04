Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F8AC46CA0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjLDTks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjLDTks (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:40:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738B0B6
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:40:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10898C433C7;
        Mon,  4 Dec 2023 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701718854;
        bh=acCNkc8dxwbkwe4OmJ3QDvtky8Lb9TmlWHSuC25B7bY=;
        h=Date:To:From:Subject:From;
        b=br6XWFan9FaxsH683UvG/2qFKxPlzEA2U1/gOW1kZRWqHAKakAHFRDvUOJ/QTGGdg
         Kk+hFE5V1TWlZh2pwH5ha4i65vvQmw9X4vovukGXcRGuYkacn+2U/6TwG880ZVe9Zj
         1jzvLB4EBlHgkePPh0ZnHaI8rrG/OKK6uq+b3YfI=
Date:   Mon, 04 Dec 2023 11:40:53 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, ignat@cloudflare.com,
        agordeev@linux.ibm.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20231204194054.10898C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv, kexec: fix dependency of two items
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch

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
Subject: riscv, kexec: fix dependency of two items
Date: Mon, 4 Dec 2023 10:23:23 +0800

Drop the dependency on MMU from ARCH_SUPPORTS_KEXEC and
ARCH_SUPPORTS_KEXEC_FILE because CONFIG_MMU could be disabled while people
may still want to have KEXEC/KEXEC_FILE functionality.

Link: https://lkml.kernel.org/r/ZW04G/SKnhbE5mnX@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig~kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2
+++ a/arch/riscv/Kconfig
@@ -685,7 +685,7 @@ config RISCV_BOOT_SPINWAIT
 	  If unsure what to do here, say N.
 
 config ARCH_SUPPORTS_KEXEC
-	def_bool MMU
+	def_bool y
 
 config ARCH_SELECTS_KEXEC
 	def_bool y
@@ -693,7 +693,7 @@ config ARCH_SELECTS_KEXEC
 	select HOTPLUG_CPU if SMP
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool 64BIT && MMU
+	def_bool 64BIT
 
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
_

Patches currently in -mm which might be from bhe@redhat.com are

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
kexec_core-change-dependency-of-object-files.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch
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

