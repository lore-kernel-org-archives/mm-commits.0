Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473BDC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A372087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816628;
	bh=tjuutfQQSKJ3g0CRo8wnM1bRCb7ZvtDm+NQRiwwfDpI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DwDzHp4fUECOniTRqC5o11u6Y3UU3ngs6JWldfLhni6iH2vnnLjjYQ+WWj/+NVDUb
	 C6pgk1wuMWgVtf/zzq+mumTM56za8ATT8LE8xN9geH4TpF05FvkZaOOp0qJpmSTxVM
	 uBG/8agwu/6uvNrBzO1M+9Dajm/Zn+m8vLkQtBug=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393649AbgJPCu1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388865AbgJPCu1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9A4D214DB;
        Fri, 16 Oct 2020 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816626;
        bh=tjuutfQQSKJ3g0CRo8wnM1bRCb7ZvtDm+NQRiwwfDpI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D9FWjlptTeRQz+pE0v8dwSO+HrY6Ej+/T78LZzRVns9feXLwZgR8IympCGH0LjiwW
         1GN7LJjV4BPpPRgb//tQKnsbSIMkn6Fet9MWntmsD3NYB1wQqqKZqomd9J0y+earxt
         S/eRoM1qecxtA69MRBye8hU8BadHRmrAA3FYkzmw=
Date:   Thu, 15 Oct 2020 19:50:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jan.kiszka@siemens.com,
        kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, riteshh@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 150/156] scripts/gdb/proc: add struct mount &
 struct super_block addr in lx-mounts command
Message-ID: <20201016025025.KYvX2igmq%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
