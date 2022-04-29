Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84143C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356882AbiD2Uww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347507AbiD2Uwu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91870852D4
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 343EC62048
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87586C385A4;
        Fri, 29 Apr 2022 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651265370;
        bh=mBh1RDyfuLN6xTZcVmRBy6qhqNyv3Ufo27Wmag9UkRM=;
        h=Date:To:From:Subject:From;
        b=TYQyHaZr04bTQKxaX0wu13XtXRssAp9ALVDmZiAVBRUcfrkZcSCXlUT1IdUabMSXF
         IIbuKbjM84+s57cQPb/D53dHnUq/2mTcATHA2vlOzBIdLJXljx0gedw6QVH1hZexNm
         ExitRNgDjJFft4ymwONN9MocKoaQjujKZBOvDFE0=
Date:   Fri, 29 Apr 2022 13:49:29 -0700
To:     mm-commits@vger.kernel.org, jof@thejof.com,
        hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] add-fat-messages-to-printk-index-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220429204930.87586C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: add-fat-messages-to-printk-index-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     add-fat-messages-to-printk-index-checkpatch-fixes.patch

This patch was dropped because it was folded into add-fat-messages-to-printk-index.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: add-fat-messages-to-printk-index-checkpatch-fixes

WARNING: 'changable' may be misspelled - perhaps 'changeable'?
#7: 
changable ad-hoc format strings (as they always have; no change of
^^^^^^^^^

ERROR: space required before the open parenthesis '('
#41: FILE: fs/fat/fat.h:442:
+} while(0)

total: 1 errors, 1 warnings, 43 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/add-fat-messages-to-printk-index.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jonathan Lassoff <jof@thejof.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/fat.h~add-fat-messages-to-printk-index-checkpatch-fixes
+++ a/fs/fat/fat.h
@@ -439,7 +439,7 @@ void __fat_fs_error(struct super_block *
 do {									\
 	printk_index_subsys_emit(FAT_PRINTK_PREFIX, level, fmt, ##args);\
 	_fat_msg(sb, level, fmt, ##args);				\
-} while(0)
+} while (0)
 __printf(3, 4) __cold
 void _fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 #define fat_msg_ratelimit(sb, level, fmt, args...)	\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
add-fat-messages-to-printk-index.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

