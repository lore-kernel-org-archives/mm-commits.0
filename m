Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D156ACD8CAE
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbjJJSTi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbjJJSTh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:19:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B802A9D
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:19:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DA7C433C7;
        Tue, 10 Oct 2023 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696961975;
        bh=BpyDn4VNCXNhj/uSjREtrK0/bd9vAq3qQ/U6ttKjzwA=;
        h=Date:To:From:Subject:From;
        b=a7O18YsXZItQMkZPBl27dk1zEksE2ptQ0CLlDjzw6C6bIq18HNghSzNTEuxiwomV9
         AlZuOe9QHJJomXubVfgWu64zVcRucibXBsTYP5V+0S0WpAEABO/XsdbgXDlffVK1zd
         8i6mVam2O0Xo8NEBfbTLNMxxTGcAWfhfWOEHp3gg=
Date:   Tue, 10 Oct 2023 11:19:24 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        lucymielke@icloud.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch added to mm-unstable branch
Message-Id: <20231010181933.A0DA7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix
Date: Tue Oct 10 11:03:09 AM PDT 2023

fix shrinker_alloc() as welll per Qi Zheng

Link: https://lkml.kernel.org/r/822387b7-4895-4e64-5806-0f56b5d6c447@bytedance.com
Cc: Lucy Mielke <lucymielke@icloud.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/shrinker.h~mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix
+++ a/include/linux/shrinker.h
@@ -131,6 +131,7 @@ struct shrinker {
  */
 #define SHRINKER_NONSLAB	BIT(4)
 
+__printf(2, 3)
 struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...);
 void shrinker_register(struct shrinker *shrinker);
 void shrinker_free(struct shrinker *shrinker);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch

