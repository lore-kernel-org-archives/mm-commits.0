Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682BCC77B7C
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 03:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbjELDlh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 May 2023 23:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbjELDl1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2023 23:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7EF49F3
        for <mm-commits@vger.kernel.org>; Thu, 11 May 2023 20:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFD8564EA4
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 03:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FF5C433D2;
        Fri, 12 May 2023 03:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683862885;
        bh=E9a2T9U7C3KDIhHeCM0zFOXvkVz6XUC4sT8UQ3kfLU8=;
        h=Date:To:From:Subject:From;
        b=v4JysYPb6T0Osx/8tc9SLiSJDuHacTCM9zu9iBYkIb7A4hVMuwIWiYfgox/fFDzLS
         YdtpMUz3SYz//o304p/qxdXR5iF8/+PKVNZ1xNmlU9u1U7ygErQQrfp+AcvdXYSW9t
         kP+mfIlKvVP71gjQPDmY8yy+L5cg9yUNlXavUaLU=
Date:   Thu, 11 May 2023 20:41:24 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        tsbogend@alpha.franken.de, svens@linux.ibm.com,
        richard.henderson@linaro.org, npiggin@gmail.com,
        mpe@ellerman.id.au, monstr@monstr.eu, mattst88@gmail.com,
        linux@armlinux.org.uk, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hca@linux.ibm.com, hannes@cmpxchg.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org, deller@gmx.de,
        davem@davemloft.net, dalias@libc.org, chris@zankel.net,
        christophe.leroy@csgroup.eu, borntraeger@linux.ibm.com,
        arnd@arndb.de, agordeev@linux.ibm.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cachestat-wire-up-cachestat-for-other-architectures.patch added to mm-unstable branch
Message-Id: <20230512034125.00FF5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cachestat: wire up cachestat for other architectures
has been added to the -mm mm-unstable branch.  Its filename is
     cachestat-wire-up-cachestat-for-other-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cachestat-wire-up-cachestat-for-other-architectures.patch

This patch will later appear in the mm-unstable branch at
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
From: Nhat Pham <nphamcs@gmail.com>
Subject: cachestat: wire up cachestat for other architectures
Date: Wed, 10 May 2023 12:58:06 -0700

cachestat is previously only wired in for x86 (and architectures using
the generic unistd.h table):

https://lore.kernel.org/lkml/20230503013608.2431726-1-nphamcs@gmail.com/

This patch wires cachestat in for all the other architectures.

Link: https://lkml.kernel.org/r/20230510195806.2902878-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Heiko Carstens <hca@linux.ibm.com>		[s390]
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/syscalls/syscall.tbl      |    1 +
 arch/arm/tools/syscall.tbl                  |    1 +
 arch/ia64/kernel/syscalls/syscall.tbl       |    1 +
 arch/m68k/kernel/syscalls/syscall.tbl       |    1 +
 arch/microblaze/kernel/syscalls/syscall.tbl |    1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    1 +
 arch/parisc/kernel/syscalls/syscall.tbl     |    1 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |    1 +
 arch/s390/kernel/syscalls/syscall.tbl       |    1 +
 arch/sh/kernel/syscalls/syscall.tbl         |    1 +
 arch/sparc/kernel/syscalls/syscall.tbl      |    1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    1 +
 14 files changed, 14 insertions(+)

--- a/arch/alpha/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -490,3 +490,4 @@
 558	common	process_mrelease		sys_process_mrelease
 559	common  futex_waitv                     sys_futex_waitv
 560	common	set_mempolicy_home_node		sys_ni_syscall
+561	common	cachestat			sys_cachestat
--- a/arch/arm/tools/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/arm/tools/syscall.tbl
@@ -464,3 +464,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common	futex_waitv			sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/ia64/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -371,3 +371,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common  futex_waitv                     sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/m68k/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -450,3 +450,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common  futex_waitv                     sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -456,3 +456,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common  futex_waitv                     sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -389,3 +389,4 @@
 448	n32	process_mrelease		sys_process_mrelease
 449	n32	futex_waitv			sys_futex_waitv
 450	n32	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	n32	cachestat			sys_cachestat
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -365,3 +365,4 @@
 448	n64	process_mrelease		sys_process_mrelease
 449	n64	futex_waitv			sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	n64	cachestat			sys_cachestat
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -438,3 +438,4 @@
 448	o32	process_mrelease		sys_process_mrelease
 449	o32	futex_waitv			sys_futex_waitv
 450	o32	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	o32	cachestat			sys_cachestat
--- a/arch/parisc/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -448,3 +448,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common	futex_waitv			sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -537,3 +537,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common  futex_waitv                     sys_futex_waitv
 450 	nospu	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/s390/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -453,3 +453,4 @@
 448  common	process_mrelease	sys_process_mrelease		sys_process_mrelease
 449  common	futex_waitv		sys_futex_waitv			sys_futex_waitv
 450  common	set_mempolicy_home_node	sys_set_mempolicy_home_node	sys_set_mempolicy_home_node
+451  common	cachestat		sys_cachestat			sys_cachestat
--- a/arch/sh/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -453,3 +453,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common  futex_waitv                     sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/sparc/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -496,3 +496,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common  futex_waitv                     sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~cachestat-wire-up-cachestat-for-other-architectures
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -421,3 +421,4 @@
 448	common	process_mrelease		sys_process_mrelease
 449	common  futex_waitv                     sys_futex_waitv
 450	common	set_mempolicy_home_node		sys_set_mempolicy_home_node
+451	common	cachestat			sys_cachestat
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-move-lru-update-from-zs_map_object-to-zs_malloc.patch
workingset-refactor-lru-refault-to-expose-refault-recency-check.patch
cachestat-implement-cachestat-syscall.patch
cachestat-implement-cachestat-syscall-fix.patch
cachestat-wire-up-cachestat-for-other-architectures.patch
cachestat-wire-up-cachestat-for-other-architectures-fix.patch
selftests-add-selftests-for-cachestat.patch

