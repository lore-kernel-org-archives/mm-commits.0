Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E8BC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD7F26108D
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347247AbhIHCYE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347218AbhIHCYD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC2F26103D;
        Wed,  8 Sep 2021 02:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067775;
        bh=sCxYn9uAwP7vCX+Zd/msMwfqQI7QJ4ZVUUd0GD137w0=;
        h=Date:From:To:Subject:From;
        b=2AK1KuqOwqZmX2qkr3Yknjas+dTd1uM+GEZVfJ8jeoS0AYyY5p37HZ5UpYBVAVIeX
         qVixh7CdFI9z5kTIEORxL+Y6NhEbHyMG559tnOq7jIyi/bLxzFm4SlpU3XdXyrjdnO
         AozCgPa73ESUFjcAKlx09XbuktM8DbHZlvxKRgrs=
Date:   Tue, 07 Sep 2021 19:22:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david.oberhollenzer@sigma-star.at,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [folded-merged]
 log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
 removed from -mm tree
Message-ID: <20210908022255.s3OpzEILF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix
has been removed from the -mm tree.  Its filename was
     log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch

This patch was dropped because it was folded into log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch

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

log-if-a-core-dump-is-aborted-due-to-changed-file-permissions.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

