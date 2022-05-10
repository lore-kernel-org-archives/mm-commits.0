Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B167C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiEJEXb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbiEJEVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D6A1B12D0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B7BB81AFD
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38C8C385C5;
        Tue, 10 May 2022 04:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156246;
        bh=A0PA6Z0Zve7b9PqyOHGfOVyRaPVseq8YzkLxw+fP78w=;
        h=Date:To:From:Subject:From;
        b=MnbXgTPskx8zb0FY259+CHY3604QGAiU8TLuHEM86cYS45jP1jGzK4JKGhEq0dr9l
         P0sVUssZSwyuDUWRXMB0WMzsillsgyeWgaIV2Kc0pRoey7MgDZxeGZgTicJN9gN+EO
         EgfbumFOCWlCMpspGVBsad4jjqh9gbj6Zm5vv1YI=
Date:   Mon, 09 May 2022 21:17:26 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch removed from -mm tree
Message-Id: <20220510041726.D38C8C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: remove usage of list iterator variable after the loop body
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakob Koschel <jakobkoschel@gmail.com>
Subject: ocfs2: remove usage of list iterator variable after the loop body

To move the list iterator variable into the list_for_each_entry_*() macro
in the future it should be avoided to use the list iterator variable after
the loop body.

To *never* use the list iterator variable after the loop it was concluded
to use a separate iterator variable [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Link: https://lkml.kernel.org/r/20220322105014.3626194-1-jakobkoschel@gmail.com
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdebug.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -541,7 +541,7 @@ static void *lockres_seq_start(struct se
 	struct debug_lockres *dl = m->private;
 	struct dlm_ctxt *dlm = dl->dl_ctxt;
 	struct dlm_lock_resource *oldres = dl->dl_res;
-	struct dlm_lock_resource *res = NULL;
+	struct dlm_lock_resource *res = NULL, *iter;
 	struct list_head *track_list;
 
 	spin_lock(&dlm->track_lock);
@@ -556,11 +556,11 @@ static void *lockres_seq_start(struct se
 		}
 	}
 
-	list_for_each_entry(res, track_list, tracking) {
-		if (&res->tracking == &dlm->tracking_list)
-			res = NULL;
-		else
-			dlm_lockres_get(res);
+	list_for_each_entry(iter, track_list, tracking) {
+		if (&iter->tracking != &dlm->tracking_list) {
+			dlm_lockres_get(iter);
+			res = iter;
+		}
 		break;
 	}
 	spin_unlock(&dlm->track_lock);
_

Patches currently in -mm which might be from jakobkoschel@gmail.com are


