Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3521C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 20:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355173AbiCPUOP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 16:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbiCPUOO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 16:14:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257096564
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 13:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC6FFB81CFA
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 20:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C4FC340E9;
        Wed, 16 Mar 2022 20:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647461576;
        bh=GECopPaU2xeaUSozMuoAcjBJG3NKcGbS9QmuM1BGE60=;
        h=Date:To:From:Subject:From;
        b=S7IRe5q4NXdYUd9CENdpA6meBzgEgeUvI2ku1bTOlAdf9tRnsEi74nK3KnmhRjRTo
         QnBXI8jM96lknGyEU+14zIg80aD1WOoZtlSYbHy2VnhOQ+zXSthYDZnycwnnWYiJk2
         /Y3XjJG28quL+bLSn3Z/nzswhGtTxgONUKWEex/U=
Date:   Wed, 16 Mar 2022 13:12:55 -0700
To:     mm-commits@vger.kernel.org, mingo@kernel.org, masahiroy@kernel.org,
        kmcmarti@redhat.com, akpm@linux-foundation.org,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panicc-remove-config_panic_on_oops_value-indirection.patch added to -mm tree
Message-Id: <20220316201256.76C4FC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: remove CONFIG_PANIC_ON_OOPS_VALUE indirection
has been added to the -mm tree.  Its filename is
     kernel-panicc-remove-config_panic_on_oops_value-indirection.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-panicc-remove-config_panic_on_oops_value-indirection.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-panicc-remove-config_panic_on_oops_value-indirection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/panic.c: remove CONFIG_PANIC_ON_OOPS_VALUE indirection

We have the helper IS_ENABLED(). Use that instead of having an
unnecessary hidden config option.

Link: https://lkml.kernel.org/r/20220316102622.562572-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Kyle McMartin <kmcmarti@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c    |    2 +-
 lib/Kconfig.debug |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/kernel/panic.c~kernel-panicc-remove-config_panic_on_oops_value-indirection
+++ a/kernel/panic.c
@@ -46,7 +46,7 @@
 unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
 #endif /* CONFIG_SMP */
 
-int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
+int panic_on_oops = IS_ENABLED(CONFIG_PANIC_ON_OOPS);
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_GCC_PLUGIN_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
 static int pause_on_oops;
--- a/lib/Kconfig.debug~kernel-panicc-remove-config_panic_on_oops_value-indirection
+++ a/lib/Kconfig.debug
@@ -1005,12 +1005,6 @@ config PANIC_ON_OOPS
 
 	  Say N if unsure.
 
-config PANIC_ON_OOPS_VALUE
-	int
-	range 0 1
-	default 0 if !PANIC_ON_OOPS
-	default 1 if PANIC_ON_OOPS
-
 config PANIC_TIMEOUT
 	int "panic timeout"
 	default 0
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-kthreadh-remove-unused-macros.patch
include-drop-pointless-__compiler_offsetof-indirection.patch
kernel-panicc-remove-config_panic_on_oops_value-indirection.patch

