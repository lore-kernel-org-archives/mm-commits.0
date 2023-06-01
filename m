Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CB6C7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 20:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjFAUVg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 16:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjFAUVW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 16:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F26E43
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 13:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AAC4637E5
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 20:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4B6C433EF;
        Thu,  1 Jun 2023 20:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685650829;
        bh=Avf21cynR+AxlWuqh2KqLt+fQUdJUc3fYGzJW32Ow3o=;
        h=Date:To:From:Subject:From;
        b=w+bYopMQ5KjMZTu+lT855zd0n9NiSnvwjWewsy1ZGPZq21kGBlPj9dQNwp4a0jUdQ
         XQ04JkVa/3ituk8Vm0wB8a+Xv8mm1kc/z9SOMic82dgGduQGgTGvEH0nYdtJ5UW9K9
         T2xwum+mhIzbkjBm+PtApQO1nO7YbDcTqJWzLt4Y=
Date:   Thu, 01 Jun 2023 13:20:28 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        lkp@intel.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230601202028.EA4B6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch

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
Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
Date: Thu Jun  1 01:17:06 PM PDT 2023

fix return of unintialized value

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306011435.2BxsHFUE-lkp@intel.com/
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
+++ a/mm/zswap.c
@@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigne
 	 * local cgroup limits.
 	 */
 	objcg = get_obj_cgroup_from_page(page);
-	if (objcg && !obj_cgroup_may_zswap(objcg))
+	if (objcg && !obj_cgroup_may_zswap(objcg)) {
+		ret = -ENOSPC;
 		goto reject;
+	}
 
 	/* reclaim space if needed */
 	if (zswap_is_full()) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-zswap-multiple-zpools-support-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

