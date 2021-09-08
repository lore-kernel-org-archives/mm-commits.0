Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E98C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5DA161090
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347014AbhIHCWs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhIHCWp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20FDF6103D;
        Wed,  8 Sep 2021 02:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067698;
        bh=ZFqo5yP1cjLZNEdghjWje5JYNjfZGx3mSWmmkTL7LhY=;
        h=Date:From:To:Subject:From;
        b=gGl7IlzvcoJcEO/cwEDRBJ5gC8rmKKlNpNlAqRCsBWUA8q29/a5F/ArmNNu0ndsEH
         U0jMcP+2YKIv2VvzxTZkQcS2YQkJtXe/b4veZGmAWvKpDHoZPqJQYFzHcCTYPtboFS
         bSQHKVWLcm7Ja4alwo+tiqDJstlrZ4sq5pM7vH8Y=
Date:   Tue, 07 Sep 2021 19:21:37 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        efremov@linux.com, joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 checkpatch-improve-git_commit_id-test-fix.patch removed from -mm tree
Message-ID: <20210908022137.il8UAfygQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-improve-git_commit_id-test-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-git_commit_id-test-fix.patch

This patch was dropped because it was folded into checkpatch-improve-git_commit_id-test.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-improve-git_commit_id-test-fix

add missing &&

Cc: Denis Efremov <efremov@linux.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-git_commit_id-test-fix
+++ a/scripts/checkpatch.pl
@@ -3181,7 +3181,7 @@ sub process {
 # possible SHA-1 matches.
 # A commit match can span multiple lines so this block attempts to find a
 # complete typical commit on a maximum of 3 lines
-		if ($perl_version_ok
+		if ($perl_version_ok &&
 		    $in_commit_log && !$commit_log_possible_stack_dump &&
 		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink|base-commit):/i &&
 		    $line !~ /^This reverts commit [0-9a-f]{7,40}/ &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

checkpatch-improve-git_commit_id-test.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

