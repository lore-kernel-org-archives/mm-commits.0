Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C164EC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJUEXl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJUEXk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:23:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0065115DB3E
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9108761D7E
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EBAC433D6;
        Fri, 21 Oct 2022 04:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326212;
        bh=tTgOaeeAFxV83fAb5RlC0xYEl+gALa3m01bCL3GtUBI=;
        h=Date:To:From:Subject:From;
        b=g71D0URg8ugFCAAkvNZpOuOBB/vPLyKRIcT8voet90+Tj59CRdUW63i2r5Ug4iVPO
         aNtAtLSRe8J61leSIc9b02wwCpfiLavVGKw//yZdSzBHh6H26FWP6lpi0XceYL5+FH
         N9yq6e0KeNuExKrk6vXDPWkxMiYuTmpNZ46grt6Y=
Date:   Thu, 20 Oct 2022 21:23:30 -0700
To:     mm-commits@vger.kernel.org, jiebin.sun@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msgc-fix-percpu_counter-use-after-free.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021042331.E6EBAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg.c: fix percpu_counter use after free
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ipc-msgc-fix-percpu_counter-use-after-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msgc-fix-percpu_counter-use-after-free.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc/msg.c: fix percpu_counter use after free
Date: Thu Oct 20 09:19:22 PM PDT 2022

These percpu counters are referenced in free_ipcs->freeque, so destroy
them later.

Fixes: 72d1e611082e ("ipc/msg: mitigate the lock contention with percpu counter")
Reported-by: syzbot+96e659d35b9d6b541152@syzkaller.appspotmail.com
Cc: Jiebin Sun <jiebin.sun@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/ipc/msg.c~ipc-msgc-fix-percpu_counter-use-after-free
+++ a/ipc/msg.c
@@ -1329,11 +1329,11 @@ fail_msg_bytes:
 #ifdef CONFIG_IPC_NS
 void msg_exit_ns(struct ipc_namespace *ns)
 {
-	percpu_counter_destroy(&ns->percpu_msg_bytes);
-	percpu_counter_destroy(&ns->percpu_msg_hdrs);
 	free_ipcs(ns, &msg_ids(ns), freeque);
 	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 	rhashtable_destroy(&ns->ids[IPC_MSG_IDS].key_ht);
+	percpu_counter_destroy(&ns->percpu_msg_bytes);
+	percpu_counter_destroy(&ns->percpu_msg_hdrs);
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch
ipc-msgc-fix-percpu_counter-use-after-free.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

