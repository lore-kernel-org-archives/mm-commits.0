Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349F4C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiKIBly (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiKIBkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B110167F7F
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E66A61820
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A509FC433D6;
        Wed,  9 Nov 2022 01:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957965;
        bh=OJcb3NnC3I+93v+yhp2jgYHvHnSzr5zGFfr2mw+JCIg=;
        h=Date:To:From:Subject:From;
        b=tDdStAMUZgv8Z5/yZDmhXyR5nj12YmYOi6h/0DEUmgNK2zb2n95rHO+70YMNhzK1Z
         a4OQgAeqIglDYt09myWEJwwOGkFhBjt+wQsE7xp1Pr8SYUKznaSlGgeguGbI7460nB
         R10axjH13qcqWFXDBX7A1qGzPv8ZZm8xtpBblet0=
Date:   Tue, 08 Nov 2022 17:39:25 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        raven@themaw.net, mike.kravetz@oracle.com, yin31149@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param.patch removed from -mm tree
Message-Id: <20221109013925.A509FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hawkins Jiawei <yin31149@gmail.com>
Subject: hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
Date: Fri, 21 Oct 2022 07:16:08 +0800

Syzkaller reports a null-ptr-deref bug as follows:
======================================================
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:hugetlbfs_parse_param+0x1dd/0x8e0 fs/hugetlbfs/inode.c:1380
[...]
Call Trace:
 <TASK>
 vfs_parse_fs_param fs/fs_context.c:148 [inline]
 vfs_parse_fs_param+0x1f9/0x3c0 fs/fs_context.c:129
 vfs_parse_fs_string+0xdb/0x170 fs/fs_context.c:191
 generic_parse_monolithic+0x16f/0x1f0 fs/fs_context.c:231
 do_new_mount fs/namespace.c:3036 [inline]
 path_mount+0x12de/0x1e20 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 [...]
 </TASK>
======================================================

According to commit "vfs: parse: deal with zero length string value",
kernel will set the param->string to null pointer in vfs_parse_fs_string()
if fs string has zero length.

Yet the problem is that, hugetlbfs_parse_param() will dereference the
param->string, without checking whether it is a null pointer.  To be more
specific, if hugetlbfs_parse_param() parses an illegal mount parameter,
such as "size=,", kernel will constructs struct fs_parameter with null
pointer in vfs_parse_fs_string(), then passes this struct fs_parameter to
hugetlbfs_parse_param(), which triggers the above null-ptr-deref bug.

This patch solves it by adding sanity check on param->string
in hugetlbfs_parse_param().

Link: https://lkml.kernel.org/r/20221020231609.4810-1-yin31149@gmail.com
Reported-by: syzbot+a3e6acd85ded5c16a709@syzkaller.appspotmail.com
Tested-by: syzbot+a3e6acd85ded5c16a709@syzkaller.appspotmail.com
  Link: https://lore.kernel.org/all/0000000000005ad00405eb7148c6@google.com/
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hawkins Jiawei <yin31149@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param
+++ a/fs/hugetlbfs/inode.c
@@ -1378,7 +1378,7 @@ static int hugetlbfs_parse_param(struct
 
 	case Opt_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->max_size_opt = memparse(param->string, &rest);
 		ctx->max_val_type = SIZE_STD;
@@ -1388,7 +1388,7 @@ static int hugetlbfs_parse_param(struct
 
 	case Opt_nr_inodes:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->nr_inodes = memparse(param->string, &rest);
 		return 0;
@@ -1404,7 +1404,7 @@ static int hugetlbfs_parse_param(struct
 
 	case Opt_min_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->min_size_opt = memparse(param->string, &rest);
 		ctx->min_val_type = SIZE_STD;
_

Patches currently in -mm which might be from yin31149@gmail.com are


