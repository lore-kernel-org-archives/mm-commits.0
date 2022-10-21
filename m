Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A74FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJUUo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiJUUof (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:44:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C3E24E384
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4761B82A2F
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB1EC433D6;
        Fri, 21 Oct 2022 20:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666384978;
        bh=MlEtcdML/U1VLppbRWrYbmJ7erk5bgaeOCwd9fErOqg=;
        h=Date:To:From:Subject:From;
        b=x8rdJuZV0TKmBk0S8L9j9dkVJ4cgsQkifpldKhri/S/t8nszCXFixBwdcTamkFjpr
         w/aLeWxzgGxMasbn1YQhFmfMxW1K3oIAU639aW4/9/VKQNW1DtgQ0bJRyU4oP8ys7D
         EX02Qj8qatBSXg+mb8J6ce+npvB2VcFbkwGOdigY=
Date:   Fri, 21 Oct 2022 13:42:57 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        raven@themaw.net, mike.kravetz@oracle.com, yin31149@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param.patch added to mm-unstable branch
Message-Id: <20221021204258.7DB1EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Hawkins Jiawei <yin31149@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param
+++ a/fs/hugetlbfs/inode.c
@@ -1377,7 +1377,7 @@ static int hugetlbfs_parse_param(struct
 
 	case Opt_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->max_size_opt = memparse(param->string, &rest);
 		ctx->max_val_type = SIZE_STD;
@@ -1387,7 +1387,7 @@ static int hugetlbfs_parse_param(struct
 
 	case Opt_nr_inodes:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->nr_inodes = memparse(param->string, &rest);
 		return 0;
@@ -1403,7 +1403,7 @@ static int hugetlbfs_parse_param(struct
 
 	case Opt_min_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->min_size_opt = memparse(param->string, &rest);
 		ctx->min_val_type = SIZE_STD;
_

Patches currently in -mm which might be from yin31149@gmail.com are

hugetlbfs-fix-null-ptr-deref-in-hugetlbfs_parse_param.patch

