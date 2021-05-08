Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C4AC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699EE60233
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhEHWwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWws (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF71B60E0B;
        Sat,  8 May 2021 22:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514306;
        bh=XnwvzOZuBUlZesf/3a8XpxXuJ9gbHrrpGd/rgFJUnAw=;
        h=Date:From:To:Subject:From;
        b=uwFMpPiB8kpLK1Yh778ovkVgyWw7qS08kJgsC+redWiQ3/jKIDu+rCeFRvML+pXuw
         4NB17rJYIAYZ7718MFXmr8DAnhxcb02pb3wJmcrcmeY6dqz3ZMv4gsUo3OydcjoJm+
         jH9o8846aYOcz09tsHmCHOq7yX25wLvDOhxOit1Q=
Date:   Sat, 08 May 2021 15:51:45 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        colin.king@canonical.com, gregkh@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged] proc-fix-incorrect-pde_is_permanent-check.patch
 removed from -mm tree
Message-ID: <20210508225145.eUc7KAaFA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/generic.c: fix incorrect pde_is_permanent check
has been removed from the -mm tree.  Its filename was
     proc-fix-incorrect-pde_is_permanent-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: fs/proc/generic.c: fix incorrect pde_is_permanent check

Currently the pde_is_permanent() check is being run on root multiple times
rather than on the next proc directory entry.  This looks like a
copy-paste error.  Fix this by replacing root with next.

Addresses-Coverity: ("Copy-paste error")
Link: https://lkml.kernel.org/r/20210318122633.14222-1-colin.king@canonical.com
Fixes: d919b33dafb3 ("proc: faster open/read/close with "permanent" files")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/generic.c~proc-fix-incorrect-pde_is_permanent-check
+++ a/fs/proc/generic.c
@@ -756,7 +756,7 @@ int remove_proc_subtree(const char *name
 	while (1) {
 		next = pde_subdir_first(de);
 		if (next) {
-			if (unlikely(pde_is_permanent(root))) {
+			if (unlikely(pde_is_permanent(next))) {
 				write_unlock(&proc_subdir_lock);
 				WARN(1, "removing permanent /proc entry '%s/%s'",
 					next->parent->name, next->name);
_

Patches currently in -mm which might be from colin.king@canonical.com are


