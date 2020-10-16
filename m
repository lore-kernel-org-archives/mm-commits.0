Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D60FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14A75221FD
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881714;
	bh=M9qg9qFs4IzccZrkDsqj846kvQs03qw7UZqFrogLs9Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m84pJi7kBRtPGobEh2cT5mZ2CFN5U9zw56iDT6MBb1oNAAPNPnMOg2D+2u7BjjHyH
	 nSaYmmHkuBTUNOtmS/dYiYk006vQxe1w5hNIXp4RCbnsP0LhUNhkFLzBKSDel6VpeW
	 rhFTZjVRi302vlzgNnAdINL2TVDhbe52JyOZoaQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409443AbgJPUzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUzN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:55:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD53216C4;
        Fri, 16 Oct 2020 20:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881712;
        bh=M9qg9qFs4IzccZrkDsqj846kvQs03qw7UZqFrogLs9Q=;
        h=Date:From:To:Subject:From;
        b=kPbJ+8hH2pxzGBnjFoAyUxdhEWTX6t0SLa29ec5NRjj/XgSHggPA94MjjVdelUaVS
         SvW5c38m/XdvQrDOtM6AzuLMEQeq3FghNEy1hEVWYVTvob4MTEuVyq7YKtfAfApiSu
         hzADkiNNuG1aauvfcnJDY7dDLA5SPTu4IpYryK/8=
Date:   Fri, 16 Oct 2020 13:55:12 -0700
From:   akpm@linux-foundation.org
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, riteshh@linux.ibm.com
Subject:  [merged]
 proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch
 removed from -mm tree
Message-ID: <20201016205512.WGWC4XgY5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/proc: add struct mount & struct super_block addr in lx-mounts command
has been removed from the -mm tree.  Its filename was
     proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ritesh Harjani <riteshh@linux.ibm.com>
Subject: scripts/gdb/proc: add struct mount & struct super_block addr in lx-mounts command

This is many times found useful while debugging some FS related
issue.

<e.g. output>
      mount          super_block     devname pathname fstype options
0xffff888a0bfa4b40 0xffff888a0bfc1000 none / rootfs rw 0 0
0xffff888a033f75c0 0xffff8889fcf65000 /dev/root / ext4 rw,relatime 0 0
0xffff8889fc8ce040 0xffff888a0bb51000 devtmpfs /dev devtmpfs rw,relatime 0 0

Link: http://lkml.kernel.org/r/a3c4177e1597b3e06d66d55e07d72c0c46a03571.1597742951.git.riteshh@linux.ibm.com
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/scripts/gdb/linux/proc.py~proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command
+++ a/scripts/gdb/linux/proc.py
@@ -167,6 +167,9 @@ values of that process namespace"""
         if not namespace:
             raise gdb.GdbError("No namespace for current process")
 
+        gdb.write("{:^18} {:^15} {:>9} {} {} options\n".format(
+                  "mount", "super_block", "devname", "pathname", "fstype"))
+
         for vfs in lists.list_for_each_entry(namespace['list'],
                                              mount_ptr_type, "mnt_list"):
             devname = vfs['mnt_devname'].string()
@@ -190,14 +193,10 @@ values of that process namespace"""
             m_flags = int(vfs['mnt']['mnt_flags'])
             rd = "ro" if (s_flags & constants.LX_SB_RDONLY) else "rw"
 
-            gdb.write(
-                "{} {} {} {}{}{} 0 0\n"
-                .format(devname,
-                        pathname,
-                        fstype,
-                        rd,
-                        info_opts(FS_INFO, s_flags),
-                        info_opts(MNT_INFO, m_flags)))
+            gdb.write("{} {} {} {} {} {}{}{} 0 0\n".format(
+                      vfs.format_string(), superblock.format_string(), devname,
+                      pathname, fstype, rd, info_opts(FS_INFO, s_flags),
+                      info_opts(MNT_INFO, m_flags)))
 
 
 LxMounts()
_

Patches currently in -mm which might be from riteshh@linux.ibm.com are


