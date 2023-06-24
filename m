Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E721C001B1
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjFXAEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjFXAEh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9202B1715
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7370761B45
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2D9C433C0;
        Sat, 24 Jun 2023 00:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687565075;
        bh=rABsU0Ut8rHvP88GLJanzDNnYGH8LgDZx7PGXHYixyw=;
        h=Date:To:From:Subject:From;
        b=atW3mVCPqQC6MpxVhNJDr90MesW+WbSK1OHS4srOlSKiPupah8Pj6jJpNvxQaaenm
         Z8Z0wvZeT3gvR2RkgdYRIjAgbo8QGBg2IOu7OqoiwPF/IWFiVxi2dxk4mVG12NXHBL
         +QNdqhis6GvMZ4T5Do4xX5qfDLxxiqy6yzr3JVxU=
Date:   Fri, 23 Jun 2023 17:04:35 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-remove-duplicated-include-in-posix-stubsc.patch removed from -mm tree
Message-Id: <20230624000435.CD2D9C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/time/posix-stubs.c: remove duplicated include
has been removed from the -mm tree.  Its filename was
     kernel-remove-duplicated-include-in-posix-stubsc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


