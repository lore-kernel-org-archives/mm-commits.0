Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B27C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 18:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73E0460F38
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 18:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhJ1TBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhJ1TBi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 15:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88FA601FF;
        Thu, 28 Oct 2021 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635447550;
        bh=KhchXCwJDMy31FZC0pfiuPTsAdvpwIAQ78g6B9qp+Wg=;
        h=Date:From:To:Subject:From;
        b=IO9pGsRFp+KaIHcAIlno8wpOLY/F/enjMKizDv3Qx6jdN6Ty1hfV5t5XiFvcpaiom
         zWEaNFVo2vU2yQKmWE49WhZlLTmZm/fa7AEPKY0LG1oRsjVwojZ+3r8aO0QG++NGOZ
         rob+fH+TMuqJag16Nifyy5bKvtZZcuUktfq1HXuY=
Date:   Thu, 28 Oct 2021 11:59:10 -0700
From:   akpm@linux-foundation.org
To:     dsterba@suse.cz, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [merged]
 make-btrfs-as-broken-due-to-an-inconsistent-api-change.patch removed from
 -mm tree
Message-ID: <20211028185910.qj69aN37S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next: build failure after merge of the btrfs tree
has been removed from the -mm tree.  Its filename was
     make-btrfs-as-broken-due-to-an-inconsistent-api-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the btrfs tree

--Sig_/WBXj/Gqj3ng9sdQkmCFxe+v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

[I am not sure why this error only popped up after I merged Andrew's
patch set ...]

After merging the btrfs tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/string.h:253,
                 from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from arch/x86/include/asm/cpumask.h:5,
                 from arch/x86/include/asm/msr.h:11,
                 from arch/x86/include/asm/processor.h:22,
                 from arch/x86/include/asm/cpufeature.h:5,
                 from arch/x86/include/asm/thread_info.h:53,
                 from include/linux/thread_info.h:60,
                 from arch/x86/include/asm/preempt.h:7,
                 from include/linux/preempt.h:78,
                 from include/linux/spinlock.h:55,
                 from include/linux/wait.h:9,
                 from include/linux/mempool.h:8,
                 from include/linux/bio.h:8,
                 from fs/btrfs/ioctl.c:7:
In function 'memcpy',
    inlined from '_btrfs_ioctl_send' at fs/btrfs/ioctl.c:4846:3:
include/linux/fortify-string.h:219:4: error: call to '__write_overflow' dec=
lared with attribute error: detected write beyond size of object (1st param=
eter)
  219 |    __write_overflow();
      |    ^~~~~~~~~~~~~~~~~~

Caused by commit

  c8d9cdfc766d ("btrfs: send: prepare for v2 protocol")

This changes the "reserved" field of struct btrfs_ioctl_send_args from 4 u6=
4's to 3, but the above memcpy is copying the "reserved" filed from a struc=
t btrfs_ioctl_send_args_32 (4 u64s) into it.

All I could really do at this point was mark BTRFS_FS as BROKEN
(TEST_KMOD selects BTRFS_FS):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 27 Oct 2021 20:53:24 +1100
Subject: [PATCH] make btrfs as BROKEN due to an inconsistent API change

Link: https://lkml.kernel.org/r/20211027210924.22ef5881@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/Kconfig  |    1 +
 lib/Kconfig.debug |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/btrfs/Kconfig~make-btrfs-as-broken-due-to-an-inconsistent-api-change
+++ a/fs/btrfs/Kconfig
@@ -20,6 +20,7 @@ config BTRFS_FS
 	select SRCU
 	depends on !PPC_256K_PAGES	# powerpc
 	depends on !PAGE_SIZE_256KB	# hexagon
+	depends on BROKEN
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
--- a/lib/Kconfig.debug~make-btrfs-as-broken-due-to-an-inconsistent-api-change
+++ a/lib/Kconfig.debug
@@ -2491,6 +2491,7 @@ config TEST_KMOD
 	depends on m
 	depends on NETDEVICES && NET_CORE && INET # for TUN
 	depends on BLOCK
+	depends on BROKEN
 	select TEST_LKM
 	select XFS_FS
 	select TUN
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch
kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch

