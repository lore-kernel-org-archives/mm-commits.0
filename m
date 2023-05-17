Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DADEC77B75
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 21:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjEQVEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 17:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjEQVEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 17:04:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C6D44A3
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 14:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EF3664AED
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 21:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD18DC433D2;
        Wed, 17 May 2023 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684357485;
        bh=6CPorfx7qBg5Uf1hfbcMQM4WR9U66M8l+r+aSUOFVGY=;
        h=Date:To:From:Subject:From;
        b=MHmPS2VN2Mul+jCub28N9XbYr6RaEhxLU9VfX+J3eIeqQKzp3AZTu1Wvpv8PsPyum
         XyPoTBkod48Tcdo/8zeKfOSl3+RHfzUHUIAKViT5ypMuyfeNjOvKL7UwIa1iJcnquC
         MJs9K2EHv4FvqEPe13FVxzuTs4M+Re+7741KxXy8=
Date:   Wed, 17 May 2023 14:04:44 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tj@kernel.org, tglx@linutronix.de,
        rafael@kernel.org, peterz@infradead.org, pavel@ucw.cz,
        paul@paul-moore.com, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, longman@redhat.com,
        linux@armlinux.org.uk, hca@linux.ibm.com, eparis@redhat.com,
        dennis@kernel.org, deller@gmx.de, cl@linux.com,
        catalin.marinas@arm.com, boqun.feng@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-devmem_is_allowed-include-linux-ioh.patch added to mm-nonmm-unstable branch
Message-Id: <20230517210444.DD18DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: devmem_is_allowed: include linux/io.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-devmem_is_allowed-include-linux-ioh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-devmem_is_allowed-include-linux-ioh.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib: devmem_is_allowed: include linux/io.h
Date: Wed, 17 May 2023 15:10:53 +0200

The devmem_is_allowed() function is defined in a file of the same name,
but the declaration is in asm/io.h, which is not included there, causing a
W=1 warning:

lib/devmem_is_allowed.c:20:5: error: no previous prototype for 'devmem_is_allowed' [-Werror=missing-prototypes]

Include the appropriate header to avoid the warning.

Link: https://lkml.kernel.org/r/20230517131102.934196-6-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devmem_is_allowed.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/devmem_is_allowed.c~lib-devmem_is_allowed-include-linux-ioh
+++ a/lib/devmem_is_allowed.c
@@ -10,6 +10,7 @@
 
 #include <linux/mm.h>
 #include <linux/ioport.h>
+#include <linux/io.h>
 
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
decompressor-provide-missing-prototypes.patch
kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch
mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch
mm-page_poison-always-declare-__kernel_map_pages-function.patch
mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch

