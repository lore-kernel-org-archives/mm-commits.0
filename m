Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D06C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 02:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiA2COV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jan 2022 21:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiA2COU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jan 2022 21:14:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC22C061714
        for <mm-commits@vger.kernel.org>; Fri, 28 Jan 2022 18:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FA89B8276A
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 02:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D409C340E7;
        Sat, 29 Jan 2022 02:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643422457;
        bh=o9FJcR3CE2EuiyMRNdDYsWdrJgrEoJgxM4P+Gb4bVug=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1YJ2AlvySrpmMn1jKd5IKJAjGFz7ZRgdyMuT5TFAYwkCurKAgrKO92ty5hmZMbqd+
         y7KmlQnAuhLX2jTOlVZkE6UuauM5cMqJb1jpC90WDr/bsGbkSpK1a8La2CyWR4cEff
         r+ONAEvquDPp84ezyxJEWxx9HpJ0c42pGnn4uLAU=
Date:   Fri, 28 Jan 2022 18:14:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brauner@kernel.org,
        ebiederm@xmission.com, keescook@chromium.org, linux-mm@kvack.org,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yzaikin@google.com,
        ztong0001@gmail.com
Subject:  [patch 2/7] binfmt_misc: fix crash when load/unload
 module
Message-ID: <20220129021417.-McVoYDIW%akpm@linux-foundation.org>
In-Reply-To: <20220128181341.2103de95948608a65958ae40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>
Subject: binfmt_misc: fix crash when load/unload module

We should unregister the table upon module unload otherwise something
horrible will happen when we load binfmt_misc module again.  Also note
that we should keep value returned by register_sysctl_mount_point() and
release it later, otherwise it will leak.

Also, per Christian's comment, to fully restore the old behavior that
won't break userspace the check(binfmt_misc_header) should be eliminated.

reproduce:
modprobe binfmt_misc
modprobe -r binfmt_misc
modprobe binfmt_misc
modprobe -r binfmt_misc
modprobe binfmt_misc

[   18.032038] Call Trace:
[   18.032108]  <TASK>
[   18.032169]  dump_stack_lvl+0x34/0x44
[   18.032273]  __register_sysctl_table+0x6f4/0x720
[   18.032397]  ? preempt_count_sub+0xf/0xb0
[   18.032508]  ? 0xffffffffc0040000
[   18.032600]  init_misc_binfmt+0x2d/0x1000 [binfmt_misc]
[   18.042520] binfmt_misc: Failed to create fs/binfmt_misc sysctl mount point
modprobe: can't load module binfmt_misc (kernel/fs/binfmt_misc.ko): Cannot allocate memory
[   18.063549] binfmt_misc: Failed to create fs/binfmt_misc sysctl mount point
[   18.204779] BUG: unable to handle page fault for address: fffffbfff8004802

Link: https://lkml.kernel.org/r/20220124181812.1869535-2-ztong0001@gmail.com
Fixes: 3ba442d5331f ("fs: move binfmt_misc sysctl to its own file")
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Co-developed-by: Christian Brauner<brauner@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/binfmt_misc.c~binfmt_misc-fix-crash-when-load-unload-module
+++ a/fs/binfmt_misc.c
@@ -817,20 +817,20 @@ static struct file_system_type bm_fs_typ
 };
 MODULE_ALIAS_FS("binfmt_misc");
 
+static struct ctl_table_header *binfmt_misc_header;
+
 static int __init init_misc_binfmt(void)
 {
 	int err = register_filesystem(&bm_fs_type);
 	if (!err)
 		insert_binfmt(&misc_format);
-	if (!register_sysctl_mount_point("fs/binfmt_misc")) {
-		pr_warn("Failed to create fs/binfmt_misc sysctl mount point");
-		return -ENOMEM;
-	}
+	binfmt_misc_header = register_sysctl_mount_point("fs/binfmt_misc");
 	return 0;
 }
 
 static void __exit exit_misc_binfmt(void)
 {
+	unregister_sysctl_table(binfmt_misc_header);
 	unregister_binfmt(&misc_format);
 	unregister_filesystem(&bm_fs_type);
 }
_
