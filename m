Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60546C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 23:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 491D9613A6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 23:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243325AbhI1XfU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243336AbhI1XfB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 19:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 786E86136F;
        Tue, 28 Sep 2021 23:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632872001;
        bh=CoSEoc7P9D2Hsq3NvGGOc8BF9Z8bs50bYsFNh9WH2iI=;
        h=Date:From:To:Subject:From;
        b=YOOJLsXPuFLp9HEaSNthYwMMv3QMgi70Xt7iN3qHtiY3oZjYyxXpxvkolFCylPC0J
         WLU9QzBChIoy2P1NdNH5hkQ4pkunnfg4JWazDK+sACQlR11N0LyAB8aaOTAqDvfpvh
         Sk6UW0KTg/ZK1DYvZXxel8/QXfzfyipD3qAjncBY=
Date:   Tue, 28 Sep 2021 16:33:20 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, heiko.carstens@de.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org
Subject:  +
 mm-create-a-new-system-state-and-fix-core_kernel_text.patch added to -mm
 tree
Message-ID: <20210928233320.FadO9xhS8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: create a new system state and fix core_kernel_text()
has been added to the -mm tree.  Its filename is
     mm-create-a-new-system-state-and-fix-core_kernel_text.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-create-a-new-system-state-and-fix-core_kernel_text.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-create-a-new-system-state-and-fix-core_kernel_text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: create a new system state and fix core_kernel_text()

core_kernel_text() considers that until system_state in at least
SYSTEM_RUNNING, init memory is valid.

But init memory is freed a few lines before setting SYSTEM_RUNNING, so we
have a small period of time when core_kernel_text() is wrong.

Create an intermediate system state called SYSTEM_FREEING_INIT that is set
before starting freeing init memory, and use it in core_kernel_text() to
report init memory invalid earlier.

Link: https://lkml.kernel.org/r/ffa99e8e91e756b081427b27e408f275b7d43df7.1632813331.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 init/main.c            |    2 ++
 kernel/extable.c       |    2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/kernel.h~mm-create-a-new-system-state-and-fix-core_kernel_text
+++ a/include/linux/kernel.h
@@ -248,6 +248,7 @@ extern bool early_boot_irqs_disabled;
 extern enum system_states {
 	SYSTEM_BOOTING,
 	SYSTEM_SCHEDULING,
+	SYSTEM_FREEING_INITMEM,
 	SYSTEM_RUNNING,
 	SYSTEM_HALT,
 	SYSTEM_POWER_OFF,
--- a/init/main.c~mm-create-a-new-system-state-and-fix-core_kernel_text
+++ a/init/main.c
@@ -1505,6 +1505,8 @@ static int __ref kernel_init(void *unuse
 	kernel_init_freeable();
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
+
+	system_state = SYSTEM_FREEING_INITMEM;
 	kprobe_free_init_mem();
 	ftrace_free_init_mem();
 	kgdb_free_init_mem();
--- a/kernel/extable.c~mm-create-a-new-system-state-and-fix-core_kernel_text
+++ a/kernel/extable.c
@@ -76,7 +76,7 @@ int notrace core_kernel_text(unsigned lo
 	    addr < (unsigned long)_etext)
 		return 1;
 
-	if (system_state < SYSTEM_RUNNING &&
+	if (system_state < SYSTEM_FREEING_INITMEM &&
 	    init_kernel_text(addr))
 		return 1;
 	return 0;
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-create-a-new-system-state-and-fix-core_kernel_text.patch
mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch
powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

