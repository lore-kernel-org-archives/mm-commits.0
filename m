Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCF9C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 01:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344147AbiCaBoJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCaBoJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 21:44:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6083483A5
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 18:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18601CE1D08
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 01:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7696DC340EC;
        Thu, 31 Mar 2022 01:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648690939;
        bh=tdPZJCa5Lv5MKIP4tELpKJTiSrqiB/xGpAJgAOca5L8=;
        h=Date:To:From:Subject:From;
        b=nbANjMnXJL/r+2fhsZAm4sAXbAnLE3skxzS4cNH6vbORb11r3b6GPDwKC5aYAnhOD
         5pJqJWoyzjCyzsRt6tSUHKsSY6Y3v6HOlzNL9x7YO4cZKpnoYIL2qbkvTqA1kgb42G
         WKP1xmHwDk2lklid+mxmDk+N0EfR5WmkJ4HKrptI=
Date:   Wed, 30 Mar 2022 18:42:18 -0700
To:     mm-commits@vger.kernel.org, jof@thejof.com,
        hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-fat-messages-to-printk-index-checkpatch-fixes.patch added to -mm tree
Message-Id: <20220331014219.7696DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: add-fat-messages-to-printk-index-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     add-fat-messages-to-printk-index-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-fat-messages-to-printk-index-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-fat-messages-to-printk-index-checkpatch-fixes.patch

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

mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

