Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16D1C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA13261208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhKKCrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhKKCrH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8564A60F46;
        Thu, 11 Nov 2021 02:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598657;
        bh=HXvuPM5ShIwpouOb7znjGu0QIoYSEqVJ7F3ZKSJhGtY=;
        h=Date:From:To:Subject:From;
        b=NyXADj6v9mXT7OpsgOs9eBz9jYxe/AeGOiwexhE/gCQOTz8Yvdh/FWg7GegfLxXl9
         hIDa4XWuQ4NQOR3a1KQQm5zpKLR2cuskozsB9hmy4PvUXzt/a07FUfi+PcUyZXeTIT
         fKdj8BWiiYhhm+E+IrIL7AEPLBvOPLykNSOF1EJ0=
Date:   Wed, 10 Nov 2021 18:44:17 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org,
        wangkefeng.wang@huawei.com
Subject:  [merged]
 mm-create-a-new-system-state-and-fix-core_kernel_text.patch removed from
 -mm tree
Message-ID: <20211111024417.Z3srCDwXM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: create a new system state and fix core_kernel_text()
has been removed from the -mm tree.  Its filename was
     mm-create-a-new-system-state-and-fix-core_kernel_text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Link: https://lkml.kernel.org/r/9ecfdee7dd4d741d172cb93ff1d87f1c58127c9a.1633001016.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
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
@@ -1506,6 +1506,8 @@ static int __ref kernel_init(void *unuse
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


