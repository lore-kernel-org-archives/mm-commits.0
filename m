Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520F8C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jan 2022 02:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240726AbiAXCnc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 21:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiAXCnc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 21:43:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F240C06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 18:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 910416126F
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 02:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FECC340E3;
        Mon, 24 Jan 2022 02:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642992211;
        bh=5PQ3G9Y6OyRKA9GFSkb4fVUTsLBTZEsXRvi2TIpb+sA=;
        h=Date:From:To:Subject:From;
        b=wNZDtpYRfO7+X99dENTgVM3tEAhk3E9JwCn5/Sxw5Apsz+Jb91XslLT94KXGmsuiG
         Uj0xWvezQ2ly9H0zCpxlNnh8JwRoxOa4DQWY27PCUNfyl21ZC9T8U1hd87mK90BoMj
         QN5llOJdLvOtcYKSlVm04jT7FS3KC8xl8htmTAzs=
Date:   Sun, 23 Jan 2022 18:43:30 -0800
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ztong0001@gmail.com
Subject:  + binfmt_misc-fix-crash-when-load-unload-module.patch
 added to -mm tree
Message-ID: <20220124024330.QVwO_AjFj%akpm@linux-foundation.org>
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
horrible will happen when we load binfmt_misc module again. Also note
that we should keep value returned by register_sysctl_mount_point() and
release it later, otherwise it will leak.

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

Link: https://lkml.kernel.org/r/20220124003342.1457437-1-ztong0001@gmail.com
Fixes: 3ba442d5331f ("fs: move binfmt_misc sysctl to its own file")
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c~binfmt_misc-fix-crash-when-load-unload-module
+++ a/fs/binfmt_misc.c
@@ -817,12 +817,16 @@ static struct file_system_type bm_fs_typ
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
+
+	binfmt_misc_header = register_sysctl_mount_point("fs/binfmt_misc");
+	if (!binfmt_misc_header) {
 		pr_warn("Failed to create fs/binfmt_misc sysctl mount point");
 		return -ENOMEM;
 	}
@@ -831,6 +835,7 @@ static int __init init_misc_binfmt(void)
 
 static void __exit exit_misc_binfmt(void)
 {
+	unregister_sysctl_table(binfmt_misc_header);
 	unregister_binfmt(&misc_format);
 	unregister_filesystem(&bm_fs_type);
 }
_

Patches currently in -mm which might be from ztong0001@gmail.com are

binfmt_misc-fix-crash-when-load-unload-module.patch

