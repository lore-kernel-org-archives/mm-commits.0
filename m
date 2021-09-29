Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250F1C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 03:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05E74613E6
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 03:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243349AbhI2Dcy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243950AbhI2Dcy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 23:32:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCEE6136A;
        Wed, 29 Sep 2021 03:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632886273;
        bh=LGVZQF4sRRuAmk4GSwvlvivmf6dwXxfSbMgJ+iXLAmo=;
        h=Date:From:To:Subject:From;
        b=yFd02AJQiVH4B9uHjeLwfL5t6AepAP0DWWGEmBXRUKBb1iA7EkemJJSUACe38fSGH
         5Km7wlXAAfD8/Hn9iYtnb+JNSe9cvSUTAUSP+klZGxVJLWTIVeXsk8lRt3h66eR32K
         L/KIGmoBS7IyNeEMdOiIl7ndM/2UwVwEkjuPnO10=
Date:   Tue, 28 Sep 2021 20:31:13 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org, sfr@canb.auug.org.au
Subject:  [to-be-updated]
 mm-create-a-new-system-state-and-fix-core_kernel_text.patch removed from
 -mm tree
Message-ID: <20210929033113.cyzBvlSDR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: create a new system state and fix core_kernel_text()
has been removed from the -mm tree.  Its filename was
     mm-create-a-new-system-state-and-fix-core_kernel_text.patch

This patch was dropped because an updated version will be merged

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
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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

mm-make-generic-arch_is_kernel_initmem_freed-do-what-it-says.patch
powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch
s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

