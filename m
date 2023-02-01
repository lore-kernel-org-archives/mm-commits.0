Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5E6C636CC
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjBAApx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbjBAAp2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:45:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46DF521FA
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DB726174D
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9262EC433D2;
        Wed,  1 Feb 2023 00:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212322;
        bh=wylgXZyDE9ppJV958iIpHZu5i8a3VsTxLwg4FeaRtuY=;
        h=Date:To:From:Subject:From;
        b=I3jfqU9TMbA3AmI1+TWlui+8Ity6LBN8TybzaVtgJeOkjRajeuTR2zzItp0+/0vPF
         7r7sJ0A7CdYyw/NfOfOaBjO0YTecm0eFAU5SotvgZCXQp/5hxs769hGVtbMyoxVJZB
         9vsEW4CaL/E8SjhcJu/jpBipbR85u5JSAOL6nirQ=
Date:   Tue, 31 Jan 2023 16:45:22 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        peterz@infradead.org, nathan@kernel.org,
        mirsad.todorovac@alu.unizg.hr, ke.wang@unisoc.com,
        catalin.marinas@arm.com, bp@alien8.de, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-use-stack_depot_early_init-for-kmemleak.patch removed from -mm tree
Message-Id: <20230201004522.9262EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use stack_depot_early_init for kmemleak
has been removed from the -mm tree.  Its filename was
     mm-use-stack_depot_early_init-for-kmemleak.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Apparently, backtrace of called functions on the stack is no longer
printed with the list of memory leaks.  This appeared on Lenovo desktop
10TX000VCR, with AlmaLinux 8.7 and BIOS version M22KT49A (11/10/2022) and
6.2-rc1 and 6.2-rc2 builds.  This worked on 6.1 with the same
CONFIG_KMEMLEAK=y and MGLRU enabled on a vanilla mainstream kernel from
Mr.  Torvalds' tree.  I don't know if this is deliberate feature for some
reason or a bug.  Please find attached the config, lshw and kmemleak
output.

[vbabka@suse.cz: remove stack_depot_init() call]
Link: https://lore.kernel.org/all/5272a819-ef74-65ff-be61-4d2d567337de@alu.unizg.hr/
Link: https://lkml.kernel.org/r/1674091345-14799-2-git-send-email-zhaoyang.huang@unisoc.com
Fixes: 56a61617dd22 ("mm: use stack_depot for recording kmemleak's backtrace")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 mm/kmemleak.c     |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/lib/Kconfig.debug~mm-use-stack_depot_early_init-for-kmemleak
+++ a/lib/Kconfig.debug
@@ -754,6 +754,7 @@ config DEBUG_KMEMLEAK
 	select KALLSYMS
 	select CRC32
 	select STACKDEPOT
+	select STACKDEPOT_ALWAYS_INIT if !DEBUG_KMEMLEAK_DEFAULT_OFF
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
--- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
+++ a/mm/kmemleak.c
@@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(c
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
@@ -2093,7 +2095,6 @@ void __init kmemleak_init(void)
 	if (kmemleak_error)
 		return;
 
-	stack_depot_init();
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch

