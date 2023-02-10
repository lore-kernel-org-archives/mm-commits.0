Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8716AC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjBJAwo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjBJAwd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FA16ADDF
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F826B822D1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E81C4339B;
        Fri, 10 Feb 2023 00:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990349;
        bh=pUf7bshraZLbpe1OXj85NmGSIbbNbokT//qgJnvTy7A=;
        h=Date:To:From:Subject:From;
        b=YDtyyubxwcfERbXLjkfwimAW5OvgJ0Mq5BavFopK+4W80hHERok2HFgfGZqvZbVrF
         emiBdHk6VLgyEnaPZ9eRpXiae6a+prUHDJ2jFhQsDM4JWsC54+fNJ0xvpka5Mcx9am
         c1aEdfpO1dQx2lIDWGjCT/NeXmLp8WE4cRcbRWR4=
Date:   Thu, 09 Feb 2023 16:52:28 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+502859d610c661e56545@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-mas_prev-and-mas_find-state-handling.patch removed from -mm tree
Message-Id: <20230210005229.31E81C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix mas_prev() and mas_find() state handling
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_prev-and-mas_find-state-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix mas_prev() and mas_find() state handling
Date: Fri, 20 Jan 2023 11:26:07 -0500

When mas_prev() does not find anything, set the state to MAS_NONE.

Handle the MAS_NONE in mas_find() like a MAS_START.

Link: https://lkml.kernel.org/r/20230120162650.984577-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: <syzbot+502859d610c661e56545@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_prev-and-mas_find-state-handling
+++ a/lib/maple_tree.c
@@ -4845,7 +4845,7 @@ static inline void *mas_prev_entry(struc
 
 	if (mas->index < min) {
 		mas->index = mas->last = min;
-		mas_pause(mas);
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 retry:
@@ -5919,6 +5919,7 @@ void *mas_prev(struct ma_state *mas, uns
 	if (!mas->index) {
 		/* Nothing comes before 0 */
 		mas->last = 0;
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 
@@ -6009,6 +6010,9 @@ void *mas_find(struct ma_state *mas, uns
 		mas->index = ++mas->last;
 	}
 
+	if (unlikely(mas_is_none(mas)))
+		mas->node = MAS_START;
+
 	if (unlikely(mas_is_start(mas))) {
 		/* First run or continue */
 		void *entry;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


