Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF563C7EE23
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 00:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbjFIAlR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 20:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjFIAlQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 20:41:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0068230C8
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 17:41:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89E286526F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 00:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBD0C433D2;
        Fri,  9 Jun 2023 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686271273;
        bh=Hj99F6J9qzGpLUHsAy/P4afEw+uc2LetKKHzoc/h23o=;
        h=Date:To:From:Subject:From;
        b=mg+l6RMCfJlMZr4cJP4dyxU2eNmb9y88g5iqY67fRgg+ji2rCwHONl0vrkWd8xSYh
         89wRt/UyT9/D8+hsNhX3BbQ8CyPQYEHIrSFlg3uRFMZco5KzuBp4Vew9j5YxaxLc3h
         zMRJBmxg0wmE+orxWVlFeURWb0q1gDjJUpJEB+Dc=
Date:   Thu, 08 Jun 2023 17:41:13 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-remove-duplicated-include-in-posix-stubsc.patch added to mm-nonmm-unstable branch
Message-Id: <20230609004113.DCBD0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/time/posix-stubs.c: remove duplicated include
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-remove-duplicated-include-in-posix-stubsc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-remove-duplicated-include-in-posix-stubsc.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: kernel/time/posix-stubs.c: remove duplicated include
Date: Thu, 8 Jun 2023 16:23:12 +0800

./kernel/time/posix-stubs.c: linux/syscalls.h is included more than once.

Link: https://lkml.kernel.org/r/20230608082312.123939-1-yang.lee@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5463
Fixes: c1956519cd7e ("syscalls: add sys_ni_posix_timers prototype")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/posix-stubs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/time/posix-stubs.c~kernel-remove-duplicated-include-in-posix-stubsc
+++ a/kernel/time/posix-stubs.c
@@ -16,7 +16,6 @@
 #include <linux/posix-timers.h>
 #include <linux/time_namespace.h>
 #include <linux/compat.h>
-#include <linux/syscalls.h>
 
 #ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER
 /* Architectures may override SYS_NI and COMPAT_SYS_NI */
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

kernel-remove-duplicated-include-in-posix-stubsc.patch

