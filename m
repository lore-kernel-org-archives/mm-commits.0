Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BF8C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F582151B
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgLWUXi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 15:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbgLWUXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 15:23:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AB952151B;
        Wed, 23 Dec 2020 20:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608754977;
        bh=ABkFH/9bT8KlaJgu4sExlOLMud1UAuI6haZbpSEeaSY=;
        h=Date:From:To:Subject:From;
        b=rpsXGiWsIwJ3x01hI8pPyl8i1r7Z3XJcMsp+jxFRK7KbrkTpvuPUDV82s0Yfz7zRM
         QfKiEkINID5aD4Kftutq4YZFCXwNUytAzPv4rCjyI4r0MWTd+t+VUqPP5z+xjdDDoN
         g5b+QhRW+C2Tu0SkShmPWT5gkqsXt3iyWLJxlaBE=
Date:   Wed, 23 Dec 2020 12:22:55 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        adobriyan@gmail.com, linf@wangsu.com
Subject:  +
 sysctlc-fix-underflow-value-setting-risk-in-vm_table.patch added to -mm tree
Message-ID: <20201223202255.k0nsg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl.c: fix underflow value setting risk in vm_table
has been added to the -mm tree.  Its filename is
     sysctlc-fix-underflow-value-setting-risk-in-vm_table.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctlc-fix-underflow-value-setting-risk-in-vm_table.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctlc-fix-underflow-value-setting-risk-in-vm_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lin Feng <linf@wangsu.com>
Subject: sysctl.c: fix underflow value setting risk in vm_table

Apart from subsystem specific .proc_handler handler, all ctl_tables with
extra1 and extra2 members set should use proc_dointvec_minmax instead of
proc_dointvec, or the limit set in extra* never work and potentially echo
underflow values(negative numbers) is likely make system unstable.

Especially vfs_cache_pressure and zone_reclaim_mode, -1 is apparently not
a valid value, but we can set to them.  And then kernel may crash.

# echo -1 > /proc/sys/vm/vfs_cache_pressure

Link: https://lkml.kernel.org/r/20201223105535.2875-1-linf@wangsu.com
Signed-off-by: Lin Feng <linf@wangsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sysctl.c~sysctlc-fix-underflow-value-setting-risk-in-vm_table
+++ a/kernel/sysctl.c
@@ -2962,7 +2962,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
@@ -2970,7 +2970,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
@@ -2980,7 +2980,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 #endif
@@ -2990,7 +2990,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &node_reclaim_mode,
 		.maxlen		= sizeof(node_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
_

Patches currently in -mm which might be from linf@wangsu.com are

sysctlc-fix-underflow-value-setting-risk-in-vm_table.patch

