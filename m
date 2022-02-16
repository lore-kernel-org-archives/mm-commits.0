Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94099C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245160AbiBPAvy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:51:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245172AbiBPAvw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0936688797
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:51:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 884B3616C9
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F94C340EB;
        Wed, 16 Feb 2022 00:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644972699;
        bh=xg0a1+QKnmiS8BtGHy3NhnwcX08jy4rISCqH4PbK6q0=;
        h=Date:To:From:Subject:From;
        b=JVwRHLoR8HiBc1kxF8O88WsUFjJQHvAm+jP1T6r1Y/4vpW0jVCCCgYP9/jXtnNn7o
         ENX+GWCSsyLs+FtpXQ77beDUi5pHO+6cSiuaMongNQue5qkLj3MirsYroe0GcMCKxB
         /gdLcnit+WeUV+JKqoVFvP0wEe6+SxG8A9rs8xt0=
Date:   Tue, 15 Feb 2022 16:51:38 -0800
To:     mm-commits@vger.kernel.org, ztong0001@gmail.com, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-file_table-fix-adding-missing-kmemleak_not_leak.patch added to -mm tree
Message-Id: <20220216005138.D4F94C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/file_table: fix adding missing kmemleak_not_leak()
has been added to the -mm tree.  Its filename is
     fs-file_table-fix-adding-missing-kmemleak_not_leak.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-file_table-fix-adding-missing-kmemleak_not_leak.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-file_table-fix-adding-missing-kmemleak_not_leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs/file_table: fix adding missing kmemleak_not_leak()

Commit b42bc9a3c511 ("Fix regression due to "fs: move binfmt_misc sysctl
to its own file") fixed a regression, however it failed to add a
kmemleak_not_leak().

Link: https://lkml.kernel.org/r/20220215020828.4180911-1-mcgrof@kernel.org
Fixes: b42bc9a3c511 ("Fix regression due to "fs: move binfmt_misc sysctl to its own file")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reported-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/file_table.c~fs-file_table-fix-adding-missing-kmemleak_not_leak
+++ a/fs/file_table.c
@@ -27,6 +27,7 @@
 #include <linux/task_work.h>
 #include <linux/ima.h>
 #include <linux/swap.h>
+#include <linux/kmemleak.h>
 
 #include <linux/atomic.h>
 
@@ -119,8 +120,11 @@ static struct ctl_table fs_stat_sysctls[
 static int __init init_fs_stat_sysctls(void)
 {
 	register_sysctl_init("fs", fs_stat_sysctls);
-	if (IS_ENABLED(CONFIG_BINFMT_MISC))
-		register_sysctl_mount_point("fs/binfmt_misc");
+	if (IS_ENABLED(CONFIG_BINFMT_MISC)) {
+		struct ctl_table_header *hdr;
+		hdr = register_sysctl_mount_point("fs/binfmt_misc");
+		kmemleak_not_leak(hdr);
+	}
 	return 0;
 }
 fs_initcall(init_fs_stat_sysctls);
_

Patches currently in -mm which might be from mcgrof@kernel.org are

fs-file_table-fix-adding-missing-kmemleak_not_leak.patch

