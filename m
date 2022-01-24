Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD03C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 04:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390966AbiAYE4p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 23:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S247042AbiAYDt6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 22:49:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB49C061783
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 15:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B024A60B13
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 23:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16C2C340E4;
        Mon, 24 Jan 2022 23:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643066350;
        bh=H+HzbJN0wMp391FDk9DF5yeSuyIOhzmsi7akDFZxcyU=;
        h=Date:From:To:Subject:From;
        b=p2UgOYDgEL4dtmx/uvC/JDuXknu9VKjPOHCsnb35zKKy9W5TxhmDc392WTmHh9kVX
         2/0g2ti/9qQz+tiIg9brGVofmbrahka+rMTzgg3YxBl2wxCQGEgoFDpu5F9MeKiLb1
         4cGq99ijS+Seapxo4LGE3WS4RIdhdASBs6lxCqXg=
Date:   Mon, 24 Jan 2022 15:19:09 -0800
From:   akpm@linux-foundation.org
To:     brauner@kernel.org, ebiederm@xmission.com, keescook@chromium.org,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, yzaikin@google.com,
        ztong0001@gmail.com
Subject:  + binfmt_misc-fix-crash-when-load-unload-module.patch
 added to -mm tree
Message-ID: <20220124231909.v1-83SLar%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: fix crash when load/unload module
has been added to the -mm tree.  Its filename is
     binfmt_misc-fix-crash-when-load-unload-module.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/binfmt_misc-fix-crash-when-load-unload-module.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/binfmt_misc-fix-crash-when-load-unload-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
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

Patches currently in -mm which might be from ztong0001@gmail.com are

binfmt_misc-fix-crash-when-load-unload-module.patch

