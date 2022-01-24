Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FEBC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 00:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351780AbiAYAeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:34:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35562 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384673AbiAXXR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 18:17:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FFE1B815E2
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 23:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00B0C340E4;
        Mon, 24 Jan 2022 23:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643066270;
        bh=8fL/XLqB6WVx5fSITuqCeNpReYjsu4zdOlSJnNYipkc=;
        h=Date:From:To:Subject:From;
        b=YBwBPPB3ptIJxZX2WdeX5F7W1aopwgAQdUgSFdZMA14k8FoQ3DJFOfxA1LbjbI/fw
         5uASLAtFLu1PDxLbFQT1mFSSEeXBLOmghO/5bu4dPUKGDBvNIYve8Lu7tFwF/y/+V6
         5u0Vd3OKnDFQYpfbQQPR4k5KlpxQXR0GOHC+dDNY=
Date:   Mon, 24 Jan 2022 15:17:50 -0800
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ztong0001@gmail.com
Subject:  [to-be-updated]
 binfmt_misc-fix-crash-when-load-unload-module.patch removed from -mm tree
Message-ID: <20220124231750.AdoNDN-QV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: fix crash when load/unload module
has been removed from the -mm tree.  Its filename was
     binfmt_misc-fix-crash-when-load-unload-module.patch

This patch was dropped because an updated version will be merged

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


