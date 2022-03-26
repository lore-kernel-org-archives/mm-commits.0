Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6CDC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 00:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiCZA0P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCZA0P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 20:26:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DC8205D5
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 17:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97D5661811
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 00:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB98C2BBE4;
        Sat, 26 Mar 2022 00:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648254279;
        bh=v4Bpl+lMs30RGP3viQUpHnRCX8oMuC3LJcXzjhMgdg0=;
        h=Date:To:From:Subject:From;
        b=PEquPcJITpunhEeoB8ceWd5c81f9Ys2uXdMDzQElsw3tAA2aO2CAETpthDr4DmcHs
         MCK7S2oL+UwKlEoH585UNKe14ptFu7o/xfh7Ff8FLiXWSm95agoJdpoSpsAHa8uEsK
         6esrLixtHD+5FRjaFAafoX4fbfVDXRuqquKF/Smk=
Date:   Fri, 25 Mar 2022 17:24:38 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch added to -mm tree
Message-Id: <20220326002438.EDB98C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove usage of list iterator variable after the loop body
has been added to the -mm tree.  Its filename is
     ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch
ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch

