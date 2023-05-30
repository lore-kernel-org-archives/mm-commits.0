Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89BFC7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjE3WGA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjE3WF7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6291BE5
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E86AA63473
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DF2C433D2;
        Tue, 30 May 2023 22:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685484356;
        bh=BpH/79R7MO8GQLfyrF3CCFhYnuL5G2LBzMKbrWtGz7Y=;
        h=Date:To:From:Subject:From;
        b=RTgeR2F9Q6cMu39g9b6/ecvWa2/7aUoLzO5cl3uSeOf4odLLKdMiadRugUwkzBlZl
         eehtqqyMktZK7HArpZ2VzkuzNrmeZu3F9lM9W7w6UpLGYVWHfDcY4OmIfdVM/iOFgY
         JfY1wbNm8O264rji8aYMOQVz/KI5SF/4yVQ/tZG8=
Date:   Tue, 30 May 2023 15:05:55 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        lkp@intel.com, holzheu@linux.vnet.ibm.com, ebiederm@xmission.com,
        bhe@redhat.com, amwang@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-helper-__crash_shrink_memory-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230530220556.48DF2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-add-helper-__crash_shrink_memory-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-add-helper-__crash_shrink_memory-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-helper-__crash_shrink_memory-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: kexec-add-helper-__crash_shrink_memory-fix
Date: Tue May 30 03:04:55 PM PDT 2023

make  __crash_shrink_memory() static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305280717.Pw06aLkz-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kexec_core.c~kexec-add-helper-__crash_shrink_memory-fix
+++ a/kernel/kexec_core.c
@@ -1105,7 +1105,8 @@ ssize_t crash_get_memory_size(void)
 	return size;
 }
 
-int __crash_shrink_memory(struct resource *old_res, unsigned long new_size)
+static int __crash_shrink_memory(struct resource *old_res,
+				 unsigned long new_size)
 {
 	struct resource *ram_res;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

