Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93855C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 21:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352606AbiD1Vyk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352681AbiD1Vyb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 17:54:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C255A586
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 14:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A80B8307C
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA487C385AD;
        Thu, 28 Apr 2022 21:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651182657;
        bh=lnF2B9mhkC7T29rxMZj6vu4nP3tnAdb7IPEG4Uu2ewg=;
        h=Date:To:From:Subject:From;
        b=C5Hg0E9JOghSrAKWq4D0vSj47YpesJlK0X4LVlvgOh0FO2p6YIv2yLKLA5zJu1oFn
         ebztE0olXqSUA7Z+CvonLogi17+QuzG1RrBsbtIsj8wZbKKDBIqQ0WB8+Tu5xyS/at
         dOc76aIno6RSpZtpQlykUyWDyzYP+tcFbifSKJpc=
Date:   Thu, 28 Apr 2022 14:50:57 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220428215057.CA487C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes

WARNING: 'succesfully' may be misspelled - perhaps 'successfully'?
#6: 
whether the node was succesfully allocated.
                     ^^^^^^^^^^^

WARNING: 'succesfully' may be misspelled - perhaps 'successfully'?
#64: FILE: mm/memory_hotplug.c:1188:
+ * 0 -> Either the node was already online, or we succesfully registered a new
                                                   ^^^^^^^^^^^

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#97: FILE: mm/memory_hotplug.c:1206:
+	BUG_ON(ret);

total: 0 errors, 3 warnings, 62 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes
+++ a/mm/memory_hotplug.c
@@ -1176,7 +1176,7 @@ static void hotadd_init_pgdat(int nid)
  *
  * Returns:
  * 1 -> The node has been initialized.
- * 0 -> Either the node was already online, or we succesfully registered a new
+ * 0 -> Either the node was already online, or we successfully registered a new
  *      one.
  * -errno -> register_one_node() failed.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mapletree-vs-khugepaged.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

