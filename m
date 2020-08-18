Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6045FC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A0820789
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597795005;
	bh=vcnBzZjR8FbRLsZnoNIXk4U3toP5op85EywbCnDI2Ik=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=r4PVJLdXyQQMAOUD3OKSjsRLA/f2y2Or6g7Zv1k4TmJ9ORoJHR5BJwTovs5/nrSJr
	 thdvuv6lSM0RIGkMorxRB3jI3eh+MMdSJI5U93DydA1JAsnOo3LVmfeWeHJL698jnH
	 OUKG49MxVU8t+GdEnNZzaWG69qtPn1xQ1j2cjVgU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHRX4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgHRX4o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:56:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04B4D20772;
        Tue, 18 Aug 2020 23:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597795003;
        bh=vcnBzZjR8FbRLsZnoNIXk4U3toP5op85EywbCnDI2Ik=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OyAmg+f0SLlVdGlgvd4/5B0Vrx+K+BgKeEnHazFlrvfrGgzMiCRCBTH4KQbSD1vM6
         Xw+s/h+SxIYtkbl33nLcLe3vvaEy9So2L3ZOGPv+sQoMjIxkmXHjf8h3ojOUca6BAo
         IWX8zbSWQgZi3h3+4lL5QsZPt7UpOnNGafTYvcPE=
Date:   Tue, 18 Aug 2020 16:56:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, riteshh@linux.ibm.com
Subject:  +
 proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch
 added to -mm tree
Message-ID: <20200818235642.Q_FusksPg%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/proc: add struct mount & struct super_block addr in lx-mounts command
has been added to the -mm tree.  Its filename is
     proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch
tasks-add-headers-and-improve-spacing-format.patch

