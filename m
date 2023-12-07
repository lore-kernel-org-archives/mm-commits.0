Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFABC10F05
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 18:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjLGS2v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 13:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjLGS2u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 13:28:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C4C10E7
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 10:28:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9BCC433C9;
        Thu,  7 Dec 2023 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701973737;
        bh=f9m/8qZ+1Mx/mQ6Rq6/VjdKDXKC744C5hM1dFmIeh7E=;
        h=Date:To:From:Subject:From;
        b=pb4Kz+kNg8phUoEkz3pI/nuF2Xt09d+qshv9rXXjKGUQCBnpbIvvCFiU6jEQM+SFE
         VEPhspsWRdm70YRv4yxwmIRQm/8uC+u3wCQDa9C482axXhYS1RMr1exFwnvSkD+To7
         BXs/2+iEY+6RxxdEuIhFxjYw4jZV0FpE7x1yT2oU=
Date:   Thu, 07 Dec 2023 10:28:56 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, ignat@cloudflare.com,
        agordeev@linux.ibm.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch removed from -mm tree
Message-Id: <20231207182856.DD9BCC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv, kexec: fix dependency of two items
has been removed from the -mm tree.  Its filename was
     kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch

This patch was dropped because it was folded into kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump.patch

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

kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump.patch
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

