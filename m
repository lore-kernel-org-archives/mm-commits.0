Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC295C43216
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F2360FA0
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhHBVkr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhHBVkp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 17:40:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F1CE60FC0;
        Mon,  2 Aug 2021 21:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627940435;
        bh=44PlRUUekMBlZbNUrlrJhPaSH3/QnllvE4P2QrbDb0I=;
        h=Date:From:To:Subject:From;
        b=onMi+K6/7/MwjZtn14EHPetgAnOXVOQqimRmQG0FXVZKnlDasd2k444Eo8EXF1pWc
         42BSsUt2k0lEuaPZEMbiz9XxuHKwAlB5MM457mfPrOyrCg/ehRy4FkGfElF0HYcqDu
         8jIGgJ5KYKalLIUxJg0sUmojzGrnHJ6cU1TjeUdU=
Date:   Mon, 02 Aug 2021 14:40:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        david.oberhollenzer@sigma-star.at, akpm@linux-foundation.org
Subject:  +
 log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch added
 to -mm tree
Message-ID: <20210802214035.4W7_1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix
has been added to the -mm tree.  Its filename is
     log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch

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
Subject: log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix

s/|%s/%s/ in printk text

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/coredump.c~log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix
+++ a/fs/coredump.c
@@ -784,12 +784,12 @@ void do_coredump(const kernel_siginfo_t
 		mnt_userns = file_mnt_user_ns(cprm.file);
 		if (!uid_eq(i_uid_into_mnt(mnt_userns, inode),
 			    current_fsuid())) {
-			pr_info_ratelimited("Core dump to |%s aborted: cannot preserve file owner\n",
+			pr_info_ratelimited("Core dump to %s aborted: cannot preserve file owner\n",
 					    cn.corename);
 			goto close_fail;
 		}
 		if ((inode->i_mode & 0677) != 0600) {
-			pr_info_ratelimited("Core dump to |%s aborted: cannot preserve file permissions\n",
+			pr_info_ratelimited("Core dump to %s aborted: cannot preserve file permissions\n",
 					    cn.corename);
 			goto close_fail;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

