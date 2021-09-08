Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DB0C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 21:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B2C8610FF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 21:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhIHVuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 17:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231639AbhIHVuI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 17:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F1E60698;
        Wed,  8 Sep 2021 21:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631137739;
        bh=Dg0Xn2eeALxyY8UHCr2P6qZrWluxw7jANi6WF3OCW4c=;
        h=Date:From:To:Subject:From;
        b=0I3dGMLcfn8f/+r7GKXbT3DbwgtsiLyn84LXQhRejtxQMsHcWru7anhn4xpztwYuY
         k1Dj4EVXSvHCTPhFowjCefVmqtF2CeEDRCLSyx1ZLL58NUb4a7Fd7rLYiI6JyZhG/y
         BmbslCU8471gzf2h/IWZsOqDj7LxL++Fnhwz50X4=
Date:   Wed, 08 Sep 2021 14:48:58 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, hca@linux.ibm.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-simplify-compat-numa-syscalls-fix.patch removed from -mm tree
Message-ID: <20210908214858.JFhH94grt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! mm: simplify compat numa syscalls
has been removed from the -mm tree.  Its filename was
     mm-simplify-compat-numa-syscalls-fix.patch

This patch was dropped because it was folded into mm-simplify-compat-numa-syscalls.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fixup! mm: simplify compat numa syscalls

When compat user space asks for more data than the kernel has in its
nodemask, get_mempolicy() now either leaks kernel stack data to user space
or, if either VMAP_STACK or KASAN are enabled, causes a crash like

Unable to handle kernel pointer dereference in virtual kernel address space
Failing address: 0000038003e7c000 TEID: 0000038003e7c803
Fault in home space mode while using kernel ASCE.
AS:00000001fb388007 R3:000000008021c007 S:0000000082142000 P:0000000000000400
Oops: 0011 ilc:3 [#1] SMP
CPU: 0 PID: 1017495 Comm: get_mempolicy Tainted: G           OE     5.14.0-20210730.rc3.git0.4ccc9e2db7ac.300.fc34.s390x+next #1
Hardware name: IBM 2827 H66 708 (LPAR)
Krnl PSW : 0704e00180000000 00000001f9f11000 (compat_put_bitmap+0x48/0xd0)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000810000 0000000000000000 000000007d9df1c0 0000038003e7c008
           0000000000000004 000000007d9df1c4 0000038003e7be40 0000000000010000
           0000000000008000 0000000000000000 0000000000000390 00000000000001c8
           000000020d6ea000 000002aa00401a48 00000001fa0a85fa 0000038003e7bd50
Krnl Code: 00000001f9f10ff4: a7bb0001            aghi    %r11,1
           00000001f9f10ff8: 41303008            la      %r3,8(%r3)
          #00000001f9f10ffc: 41502004            la      %r5,4(%r2)
          >00000001f9f11000: e3103ff8ff04        lg      %r1,-8(%r3)
           00000001f9f11006: 5010f0a4            st      %r1,164(%r15)
           00000001f9f1100a: a50e0081            llilh   %r0,129
           00000001f9f1100e: c8402000f0a4        mvcos   0(%r2),164(%r15),%r4
           00000001f9f11014: 1799                xr      %r9,%r9
Call Trace:
 [<00000001f9f11000>] compat_put_bitmap+0x48/0xd0
 [<00000001fa0a85fa>] kernel_get_mempolicy+0x102/0x178
 [<00000001fa0a86b0>] __s390_sys_get_mempolicy+0x40/0x50
 [<00000001fa92be30>] __do_syscall+0x1c0/0x1e8
 [<00000001fa939148>] system_call+0x78/0xa0
Last Breaking-Event-Address:
 [<0000038003e7bc00>] 0x38003e7bc00
Kernel panic - not syncing: Fatal exception: panic_on_oops

Fix it by copying the correct size in compat mode again.

Link: https://lkml.kernel.org/r/20210730143417.3700653-1-arnd@kernel.org
Link: https://lore.kernel.org/lkml/YQPLG20V3dmOfq3a@osiris/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-simplify-compat-numa-syscalls-fix
+++ a/mm/mempolicy.c
@@ -1438,6 +1438,7 @@ static int copy_nodes_to_user(unsigned l
 		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
 			return -EFAULT;
 		copy = nbytes;
+		maxnode = nr_node_ids;
 	}
 
 	if (compat)
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-move-locking-into-do_kexec_load.patch
kexec-avoid-compat_alloc_user_space.patch
mm-simplify-compat_sys_move_pages.patch
mm-simplify-compat-numa-syscalls.patch
compat-remove-some-compat-entry-points.patch
arch-remove-compat_alloc_user_space.patch

