Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55644C001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjHLWG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjHLWGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB8919A7
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C574D620D2
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A813C433C8;
        Sat, 12 Aug 2023 22:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877969;
        bh=Hnpv4q8iEshe5+IqsaPeGX1fLJj6iBh7ukI9TEvwMWQ=;
        h=Date:To:From:Subject:From;
        b=rEKs9bzjAY5h8mR9VHhtV8Si0n71CTuNQavlNvCCLrx5uwCdsZwlkeH3S//LhNV9O
         23NOI5hTpniNDRu3KGbjO42pifSG9fs7c0RxITNXpZUCtGBDimDasMlHO4Cgh6TB9d
         7WeE8bABT050EC0gUZ1n2UX32V87gE95P1lgFds4=
Date:   Sat, 12 Aug 2023 15:06:08 -0700
To:     mm-commits@vger.kernel.org, sohil.mehta@intel.com,
        nogikh@google.com, mingo@elte.hu, kirill.shutemov@linux.intel.com,
        keescook@google.com, heng.su@intel.com, dvyukov@google.com,
        pengfei.xu@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-kernel-increase-kcov-coverage-under-arch-x86-kernel-folder.patch removed from -mm tree
Message-Id: <20230812220609.2A813C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/kernel: increase kcov coverage under arch/x86/kernel folder
has been removed from the -mm tree.  Its filename was
     x86-kernel-increase-kcov-coverage-under-arch-x86-kernel-folder.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pengfei Xu <pengfei.xu@intel.com>
Subject: x86/kernel: increase kcov coverage under arch/x86/kernel folder
Date: Mon, 31 Jul 2023 11:04:18 +0800

Currently kcov instrument is disabled for object files under
arch/x86/kernel folder.

For object files under arch/x86/kernel, actually just disabling the kcov
instrument of files:"head32.o or head64.o and sev.o" could achieve
successful booting and provide kcov coverage for object files that do not
disable kcov instrument.  The additional kcov coverage collected from
arch/x86/kernel folder helps kernel fuzzing efforts to find bugs.

Link to related improvement discussion is below:
https://groups.google.com/g/syzkaller/c/Dsl-RYGCqs8/m/x-tfpTyFBAAJ Related
ticket is as follow: https://bugzilla.kernel.org/show_bug.cgi?id=198443

Link: https://lkml.kernel.org/r/06c0bb7b5f61e5884bf31180e8c122648c752010.1690771380.git.pengfei.xu@intel.com
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Pengfei Xu <pengfei.xu@intel.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: <heng.su@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <keescook@google.com>,
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/Makefile~x86-kernel-increase-kcov-coverage-under-arch-x86-kernel-folder
+++ a/arch/x86/kernel/Makefile
@@ -33,11 +33,10 @@ KCSAN_SANITIZE := n
 KMSAN_SANITIZE_head$(BITS).o				:= n
 KMSAN_SANITIZE_nmi.o					:= n
 
-# If instrumentation of this dir is enabled, boot hangs during first second.
-# Probably could be more selective here, but note that files related to irqs,
-# boot, dumpstack/stacktrace, etc are either non-interesting or can lead to
-# non-deterministic coverage.
-KCOV_INSTRUMENT		:= n
+# If instrumentation of the following files is enabled, boot hangs during
+# first second.
+KCOV_INSTRUMENT_head$(BITS).o				:= n
+KCOV_INSTRUMENT_sev.o					:= n
 
 CFLAGS_irq.o := -I $(srctree)/$(src)/../include/asm/trace
 
_

Patches currently in -mm which might be from pengfei.xu@intel.com are


