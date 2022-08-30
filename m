Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A582EECAAD4
	for <mm-commits@archiver.kernel.org>; Tue, 30 Aug 2022 23:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiH3XBF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 19:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiH3XA5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 19:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E48C96749
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 16:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8229861604
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 23:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AABC433D7;
        Tue, 30 Aug 2022 23:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661900445;
        bh=+7s6M6WfJuS+95K2kebsqr7VVsx1Bi72Gv8PibjF+eg=;
        h=Date:To:From:Subject:From;
        b=qltwV5Y+qDNHZ2M4tVDaE+5wZVjF4Gpn25yJ33ddUcZ8U2WUk7lYadUGNjy1bnfeM
         3KirEHlYlqs8cYF2euAm79q9AUFxLwGnnSHdIYtbRSo1r3FtZB7Z2MN37GOCdOwvAO
         zsfIWcgIjmGKcZhkb/UzQasShxz586kwqS0PTHJE=
Date:   Tue, 30 Aug 2022 16:00:45 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-support-page-table-walks-fix.patch added to mm-unstable branch
Message-Id: <20220830230045.D5AABC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-multi-gen-lru-support-page-table-walks-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-support-page-table-walks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-support-page-table-walks-fix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm-multi-gen-lru-support-page-table-walks-fix
Date: Tue, 30 Aug 2022 16:25:24 -0600

avoid including sched.h in mm_types.h

Link: https://lkml.kernel.org/r/CAOUHufZrb_gkxaWfCLuFodRtCwGGdYjo2wvFW7kTiTkRbg4XNQ@mail.gmail.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/mm_types.h~mm-multi-gen-lru-support-page-table-walks-fix
+++ a/include/linux/mm_types.h
@@ -3,7 +3,6 @@
 #define _LINUX_MM_TYPES_H
 
 #include <linux/mm_types_task.h>
-#include <linux/sched.h>
 
 #include <linux/auxvec.h>
 #include <linux/kref.h>
@@ -742,11 +741,7 @@ static inline void lru_gen_init_mm(struc
 
 static inline void lru_gen_use_mm(struct mm_struct *mm)
 {
-	/* unlikely but not a bug when racing with lru_gen_migrate_mm() */
-	VM_WARN_ON_ONCE(list_empty(&mm->lru_gen.list));
-
-	if (!(current->flags & PF_KTHREAD))
-		WRITE_ONCE(mm->lru_gen.bitmap, -1);
+	WRITE_ONCE(mm->lru_gen.bitmap, -1);
 }
 
 #else /* !CONFIG_LRU_GEN */
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-support-page-table-walks-fix.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

