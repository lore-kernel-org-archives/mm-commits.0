Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D1DC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiCZD3H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiCZD3H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:29:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC75A15E8AB
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7677B82AE5
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D0EC004DD;
        Sat, 26 Mar 2022 03:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648265248;
        bh=NoC/6WOtoDgOBfOv6omcns5v9kc/1DFoZeWIh9Xf0Og=;
        h=Date:To:From:Subject:From;
        b=emDVNdrrY+3Nkot1lCm/21Swcj8oSWuh+6xtId7NyCcbzTOYMVp775gqBNdH3AOQa
         NqMOcctfoIXQZpFlLQrJssFUQp1CxlKs0o2mEgsk3MkELQZ5Sppbyx+/6rrXkT+SBC
         NS784CLhzlEFvfJA3n8DPf/Pfq937GDcoLdEz9gI=
Date:   Fri, 25 Mar 2022 20:27:27 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch added to -mm tree
Message-Id: <20220326032728.43D0EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

