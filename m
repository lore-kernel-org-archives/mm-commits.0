Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BD9C433E5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 16:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97CFB619AD
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 16:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhC1Qmz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 12:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231312AbhC1QmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 12:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D16F61958;
        Sun, 28 Mar 2021 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616949744;
        bh=b9Wd3sWI3wq5qK0jlq8QJ7sEMJPeu8NJxSoBmrirFg8=;
        h=Date:From:To:Subject:From;
        b=zGrF3pg51h7f+QrzKE0wTixNYnR7syrkHfzGRLN4fehh7xEMz1gu5VcO1QHpp9WWX
         40d3KvpKJTyIRHXpNaWn5qqqhd+5/mrNeM3o5RBMBTlMDinSteLdvQahsFJab5JGMZ
         OiuD22lR54GKOklprgOIkN4TwpkdkORZ/bVWW5BI=
Date:   Sun, 28 Mar 2021 09:42:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org
Subject:  [merged]
 ia64-mca-allocate-early-mca-with-gfp_atomic.patch removed from -mm tree
Message-ID: <20210328164224.HReSHSRXa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mca: allocate early mca with GFP_ATOMIC
has been removed from the -mm tree.  Its filename was
     ia64-mca-allocate-early-mca-with-gfp_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: mca: allocate early mca with GFP_ATOMIC

The sleep warning happens at early boot right at secondary CPU activation
bootup:

    smp: Bringing up secondary CPUs ...
    BUG: sleeping function called from invalid context at mm/page_alloc.c:4942
    in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/1
    CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.12.0-rc2-00007-g79e228d0b611-dirty #99

    Call Trace:
     [<a000000100014d10>] show_stack+0x90/0xc0
     [<a000000101111d90>] dump_stack+0x150/0x1c0
     [<a0000001000cbec0>] ___might_sleep+0x1c0/0x2a0
     [<a0000001000cc040>] __might_sleep+0xa0/0x160
     [<a000000100399960>] __alloc_pages_nodemask+0x1a0/0x600
     [<a0000001003b71b0>] alloc_page_interleave+0x30/0x1c0
     [<a0000001003b9b60>] alloc_pages_current+0x2c0/0x340
     [<a00000010038c270>] __get_free_pages+0x30/0xa0
     [<a000000100044730>] ia64_mca_cpu_init+0x2d0/0x3a0
     [<a000000100023430>] cpu_init+0x8b0/0x1440
     [<a000000100054680>] start_secondary+0x60/0x700
     [<a00000010111e1d0>] start_ap+0x750/0x780
    Fixed BSP b0 value from CPU 1

As I understand interrupts are not enabled yet and system has a lot of
memory.  There is little chance to sleep and switch to GFP_ATOMIC should
be a no-op.

Link: https://lkml.kernel.org/r/20210315085045.204414-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/mca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/mca.c~ia64-mca-allocate-early-mca-with-gfp_atomic
+++ a/arch/ia64/kernel/mca.c
@@ -1824,7 +1824,7 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = (void *)__get_free_pages(GFP_KERNEL,
+			data = (void *)__get_free_pages(GFP_ATOMIC,
 							get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-drop-unused-ia64_fw_emu-ifdef.patch

