Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0F1C46467
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjASW50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjASW5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:57:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC38524E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2975B61D8E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80752C433F0;
        Thu, 19 Jan 2023 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168022;
        bh=5IIR23Fj68jbGffs6cwdoP69zqDHsQBR1VXe/TTYlTg=;
        h=Date:To:From:Subject:From;
        b=a+GbIOCHoEbzfF8myV1+QR5U+R3rc1JnZKZVZXIKt6yUVp+3pzb8Xe5VnYTTm8t8M
         ADmMvGVcu2JsWzlAdtfcOXZbOVcgXAGpO3BPHip6LglkB03JIiqiWzJ/MukBjRey/E
         IvGJm97iT3N2+2tlnQ0joTXcDg6f06eXBwbHafbo=
Date:   Thu, 19 Jan 2023 14:40:21 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        peterz@infradead.org, nathan@kernel.org,
        mirsad.todorovac@alu.unizg.hr, ke.wang@unisoc.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-stack_depot_early_init-for-kmemleak.patch added to mm-unstable branch
Message-Id: <20230119224022.80752C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use stack_depot_early_init for kmemleak
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-stack_depot_early_init-for-kmemleak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-stack_depot_early_init-for-kmemleak.patch

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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: use stack_depot_early_init for kmemleak
Date: Thu, 19 Jan 2023 09:22:25 +0800

Mirsad report the below error which is caused by stack_depot_init()
failure in kvcalloc.  Solve this by having stackdepot use
stack_depot_early_init().

On 1/4/23 17:08, Mirsad Goran Todorovac wrote:
I hate to bring bad news again, but there seems to be a problem with the output of /sys/kernel/debug/kmemleak:

[root@pc-mtodorov ~]# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff951c118568b0 (size 16):
comm "kworker/u12:2", pid 56, jiffies 4294893952 (age 4356.548s)
hex dump (first 16 bytes):
    6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00 memstick0.......
    backtrace:
[root@pc-mtodorov ~]#

Apparently, backtrace of called functions on the stack is no longer printed with the list of memory leaks.
This appeared on Lenovo desktop 10TX000VCR, with AlmaLinux 8.7 and BIOS version M22KT49A (11/10/2022)
and 6.2-rc1 and 6.2-rc2 builds.
This worked on 6.1 with the same CONFIG_KMEMLEAK=y and MGLRU enabled on a vanilla mainstream kernel
from Mr. Torvalds' tree. I don't know if this is deliberate feature for some reason or a bug.
Please find attached the config, lshw and kmemleak output.

Link: https://lore.kernel.org/all/5272a819-ef74-65ff-be61-4d2d567337de@alu.unizg.hr/
Link: https://lkml.kernel.org/r/1674091345-14799-2-git-send-email-zhaoyang.huang@unisoc.com
Fixes: 56a61617dd22 ("mm: use stack_depot for recording kmemleak's backtrace")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/Kconfig.debug~mm-use-stack_depot_early_init-for-kmemleak
+++ a/mm/Kconfig.debug
@@ -219,6 +219,7 @@ config DEBUG_KMEMLEAK
 	select KALLSYMS
 	select CRC32
 	select STACKDEPOT
+	select STACKDEPOT_ALWAYS_INIT if !DEBUG_KMEMLEAK_DEFAULT_OFF
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
--- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
+++ a/mm/kmemleak.c
@@ -2069,8 +2069,10 @@ static int __init kmemleak_boot_config(c
 		return -EINVAL;
 	if (strcmp(str, "off") == 0)
 		kmemleak_disable();
-	else if (strcmp(str, "on") == 0)
+	else if (strcmp(str, "on") == 0) {
 		kmemleak_skip_disable = 1;
+		stack_depot_want_early_init();
+	}
 	else
 		return -EINVAL;
 	return 0;
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch
mm-use-stack_depot_early_init-for-kmemleak.patch

