Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A321AC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 22:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbiCWWnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240626AbiCWWnf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 18:43:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4302690249
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 15:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0FD5617B8
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 22:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E25C340E9;
        Wed, 23 Mar 2022 22:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648075324;
        bh=XGuyk1S6VoiaeOuuUqvyp7DSKIzWqNeSWcriOmK40Ag=;
        h=Date:To:From:Subject:From;
        b=EcojCrUNOCfHXEvRET0YgGhyTyYCxU7ruyBHr2B/sunpCUFnAET36AXxU71TZuZEz
         XzDTg4i4rCd2hsf6/CeqaKTvxCQuV3dBVczbOJ//XE8pn90K3tT9TPrp0pw0IL8KzH
         euZ5yyiDCkOXqoaKidHX/DEzRGoMcHhUgihd3MaY=
Date:   Wed, 23 Mar 2022 15:42:03 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, keescook@chromium.org,
        jamorris@linux.microsoft.com, haolee.swjtu@gmail.com,
        christian.brauner@ubuntu.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch removed from -mm tree
Message-Id: <20220323224204.31E25C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix
has been removed from the -mm tree.  Its filename was
     proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch

This patch was dropped because it was folded into proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix

remove now-unneeded cast

Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Hao Lee <haolee.swjtu@gmail.com>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix
+++ a/fs/proc/base.c
@@ -1764,7 +1764,7 @@ out:
 
 static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
-	char *tmp = (char *)kmalloc(PATH_MAX, GFP_KERNEL);
+	char *tmp = kmalloc(PATH_MAX, GFP_KERNEL);
 	char *pathname;
 	int len;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

