Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF6DC00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiHRXPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiHRXPo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:15:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27061C7B8B
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C15DCE237B
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5909C433D7;
        Thu, 18 Aug 2022 23:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660864540;
        bh=P4q54w8RR6saD/jw9rJS64QLvTn+8fop7Z5Y+P9IReM=;
        h=Date:To:From:Subject:From;
        b=xD1N5wY+OOnVcGOJn06t6mK639lkmu9oZgRg0SVvM0oJNy0Vxwc7tpuAh+XVTLG0+
         F3DISu5FgS8P1lBraC3shfFE7D8rBP8nmFEEuSVHoNkkdznqWr0Ii8IOUUTUemjVRn
         QtB+vBmws6sg00MsAuKvyXAiKYhviewc22jszlIY=
Date:   Thu, 18 Aug 2022 16:15:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        kent.overstreet@gmail.com, kanie@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch removed from -mm tree
Message-Id: <20220818231540.C5909C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/filemap.c: fix the timing of asignment of prev_pos
has been removed from the -mm tree.  Its filename was
     mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Guixin Liu <kanie@linux.alibaba.com>
Subject: mm/filemap.c: fix the timing of asignment of prev_pos
Date: Wed, 17 Aug 2022 21:51:57 +0800

When I`m running repetitive 4k read io which has same offset, I find that
access to folio_mark_accessed is inevitable in the read process, the
reason is that the prev_pos is assigned after the iocb->ki_pos is
incremented, so that the prev_pos is always not equal to the position
currently visited.

The prev_pos should be assigned before the iocb->ki_pos is incremented, so
that the prev_pos is the exact location of the last visit.

Link: https://lkml.kernel.org/r/1660744317-8183-1-git-send-email-kanie@linux.alibaba.com
Fixes: 06c0444290cec ("mm/filemap.c: generic_file_buffered_read() now uses find_get_pages_contig")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemapc-fix-the-timing-of-asignment-of-prev_pos
+++ a/mm/filemap.c
@@ -2711,8 +2711,8 @@ ssize_t filemap_read(struct kiocb *iocb,
 			copied = copy_folio_to_iter(folio, offset, bytes, iter);
 
 			already_read += copied;
-			iocb->ki_pos += copied;
 			ra->prev_pos = iocb->ki_pos;
+			iocb->ki_pos += copied;
 
 			if (copied < bytes) {
 				error = -EFAULT;
_

Patches currently in -mm which might be from kanie@linux.alibaba.com are


