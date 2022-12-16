Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733C9C3DA79
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLPAi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLPAi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:38:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C32A3720E
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:38:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D0E461FA5
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A71AC433EF;
        Fri, 16 Dec 2022 00:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151137;
        bh=w5NzoiqhNHPkhEJOAQIyJ/eZgrI12F1yW4OlXQOZt2w=;
        h=Date:To:From:Subject:From;
        b=p6llpF0akTekhnTqPl/6DExhcvIcazqNoSqNS8R68dHAQ+Y+iFZ5Fy5Pe5prMYi+G
         HlUMckwGr4xXEHs2XjcRGc5Ji/02kfWZ6QOEkHKJqOctnoLBkE8e3brNd+oKW/1cbf
         u9HMEPAfFII/y0PKSrBXxUnFUUjaJ8+7LiASG+6g=
Date:   Thu, 15 Dec 2022 16:38:56 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-mas_find_rev-comment.patch removed from -mm tree
Message-Id: <20221216003857.7A71AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix mas_find_rev() comment
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_find_rev-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_find_rev() comment
Date: Tue, 25 Oct 2022 17:38:14 +0000

mas_find_rev() uses mas_prev_entry(), not mas_next_entry(), correct comment.

Link: https://lkml.kernel.org/r/20221025173756.2719616-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_find_rev-comment
+++ a/lib/maple_tree.c
@@ -6062,7 +6062,7 @@ void *mas_find_rev(struct ma_state *mas,
 	if (mas->index < min)
 		return NULL;
 
-	/* Retries on dead nodes handled by mas_next_entry */
+	/* Retries on dead nodes handled by mas_prev_entry */
 	return mas_prev_entry(mas, min);
 }
 EXPORT_SYMBOL_GPL(mas_find_rev);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


