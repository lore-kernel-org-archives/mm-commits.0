Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05970C6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 913F722201
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgLBXMb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgLBXMb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:12:31 -0500
Date:   Wed, 02 Dec 2020 15:11:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606950710;
        bh=sduuDBLlM+ADtMRscHEy+ryeJizdsSJkW8uUvNI08js=;
        h=From:To:Subject:From;
        b=OyRltJbpXccJQ/rEwUhKq/eYq+xvBw2UQGs355CJS/3RMi4L2Ek4ap8B7NH4oDH7u
         uh87WoAdfupqBI4sPX5RsrUj9l3w8a33RCvsxh8Tvk7kDzrRrzKnjHuAR6c469qLQM
         pwJjg0w8mBDyMcFmeIReSnzxCUo1UuJ4xfpAGnH8=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, carver4lio@163.com,
        liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-remove-the-unuseful-else-after-a-return.patch added
 to -mm tree
Message-ID: <20201202231149.r0r0TJO_l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: remove else after a return
has been added to the -mm tree.  Its filename is
     mm-remove-the-unuseful-else-after-a-return.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-unuseful-else-after-a-return.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-unuseful-else-after-a-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hailong Liu <carver4lio@163.com>
Subject: mm/filemap.c: remove else after a return

The `else' is not useful after a `return' in __lock_page_or_retry().

Link: https://lkml.kernel.org/r/20201202154720.115162-1-carver4lio@163.com
Signed-off-by: Hailong Liu<liu.hailong6@zte.com.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/filemap.c~mm-remove-the-unuseful-else-after-a-return
+++ a/mm/filemap.c
@@ -1583,19 +1583,19 @@ int __lock_page_or_retry(struct page *pa
 		else
 			wait_on_page_locked(page);
 		return 0;
-	} else {
-		if (flags & FAULT_FLAG_KILLABLE) {
-			int ret;
-
-			ret = __lock_page_killable(page);
-			if (ret) {
-				mmap_read_unlock(mm);
-				return 0;
-			}
-		} else
-			__lock_page(page);
-		return 1;
 	}
+	if (flags & FAULT_FLAG_KILLABLE) {
+		int ret;
+
+		ret = __lock_page_killable(page);
+		if (ret) {
+			mmap_read_unlock(mm);
+			return 0;
+		}
+	} else
+		__lock_page(page);
+	return 1;
+
 }
 
 /**
_

Patches currently in -mm which might be from carver4lio@163.com are

mm-remove-the-unuseful-else-after-a-return.patch

