Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145C4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 01:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiEJB3w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 21:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiEJB3s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 21:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362E8101CD
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 18:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C20F26159D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 01:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DB9C385C2;
        Tue, 10 May 2022 01:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652145951;
        bh=rw0gtSI8vHgRUUtKC/4GgKJbwNTSVJPFi5a4kjcwr64=;
        h=Date:To:From:Subject:From;
        b=HjbLeEU1a1KSTyYUfuoP3aOF6izvzOnFqD/S/IVEjEBJWdIXvVOvsqNv1QQvndKwq
         xPpgKmC0Zw2a+gxAwDdHfOpqY2d80ssdJSEpy6XxIkKEwvnvRZ7BMhDMo7LFDwdPVk
         1B3ylPo4RKnwWfIK2umLrIwfuh+71UFDwaMNseMY=
Date:   Mon, 09 May 2022 18:25:50 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220510012551.15DB9C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch

This patch was dropped because it was folded into proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#31: FILE: fs/proc/generic.c:452:
+	if ((*parent)->proc_dops == &proc_net_dentry_ops) {
+		pde_force_lookup(ent);
+	}

total: 0 errors, 1 warnings, 19 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/proc/generic.c~proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes
+++ a/fs/proc/generic.c
@@ -449,9 +449,8 @@ static struct proc_dir_entry *__proc_cre
 
 	ent->proc_dops = &proc_misc_dentry_ops;
 	/* Revalidate everything under /proc/${pid}/net */
-	if ((*parent)->proc_dops == &proc_net_dentry_ops) {
+	if ((*parent)->proc_dops == &proc_net_dentry_ops)
 		pde_force_lookup(ent);
-	}
 
 out:
 	return ent;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

