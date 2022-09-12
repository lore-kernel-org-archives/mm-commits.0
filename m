Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F9CECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiILE4Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiILE4V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDBC220FD
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B68B60D28
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5436C433D7;
        Mon, 12 Sep 2022 04:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958578;
        bh=3rDZTijQ7DEl3PRKexYF1Vu3T0EkJvL2X62cZsgIJJ0=;
        h=Date:To:From:Subject:From;
        b=vrOX1O+REbdxWXLXb81WYl6c4hkkJauOMraiFpEnSB73btEHXbbBH3oMYe/az3rQP
         L0fBi3zQAmxuqw/7NxcH0dtrQ2Np73yLHm0RcLewHk6t2eClEPUPsXz+zFxteVa9Tw
         EeqW9rtI9AkdZdnFdn8aKGs9rQEJDgFTC8rW66MM=
Date:   Sun, 11 Sep 2022 21:56:17 -0700
To:     mm-commits@vger.kernel.org, longman@redhat.com,
        ebiederm@xmission.com, dave@stgolabs.net, 1vier1@web.de,
        manfred@colorfullife.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-utilc-cleanup-and-improve-sysvipc_find_ipc-v3.patch removed from -mm tree
Message-Id: <20220912045617.E5436C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/util.c: cleanup and improve sysvipc_find_ipc()
has been removed from the -mm tree.  Its filename was
     ipc-utilc-cleanup-and-improve-sysvipc_find_ipc-v3.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/util.c: cleanup and improve sysvipc_find_ipc()
Date: Fri, 5 Aug 2022 13:57:33 +0200

sysvipc_find_ipc() can be simplified further:

- It uses a for() loop to locate the next entry in the idr.
  This can be replaced with idr_get_next().

- It receives two parameters (pos - which is actually
  an idr index and not a position, and new_pos, which
  is really a position).
  One parameter is sufficient.

Link: https://lore.kernel.org/all/20210903052020.3265-3-manfred@colorfullife.com/
Link: https://lkml.kernel.org/r/20220805115733.104763-1-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Waiman Long <longman@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: <1vier1@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   53 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

--- a/ipc/util.c~ipc-utilc-cleanup-and-improve-sysvipc_find_ipc-v3
+++ a/ipc/util.c
@@ -782,28 +782,37 @@ struct pid_namespace *ipc_seq_pid_ns(str
 	return iter->pid_ns;
 }
 
-/*
- * This routine locks the ipc structure found at least at position pos.
+/**
+ * sysvipc_find_ipc - Find and lock the ipc structure based on seq pos
+ * @ids: ipc identifier set
+ * @pos: expected position
+ *
+ * The function finds an ipc structure, based on the sequence file
+ * position @pos. If there is no ipc structure at position @pos, then
+ * the successor is selected.
+ * If a structure is found, then it is locked (both rcu_read_lock() and
+ * ipc_lock_object()) and  @pos is set to the position needed to locate
+ * the found ipc structure.
+ * If nothing is found (i.e. EOF), @pos is not modified.
+ *
+ * The function returns the found ipc structure, or NULL at EOF.
  */
-static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
-					      loff_t *new_pos)
+static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t *pos)
 {
-	struct kern_ipc_perm *ipc = NULL;
-	int max_idx = ipc_get_maxidx(ids);
+	int tmpidx;
+	struct kern_ipc_perm *ipc;
+
+	/* convert from position to idr index -> "-1" */
+	tmpidx = *pos - 1;
 
-	if (max_idx == -1 || pos > max_idx)
-		goto out;
+	ipc = idr_get_next(&ids->ipcs_idr, &tmpidx);
+	if (ipc != NULL) {
+		rcu_read_lock();
+		ipc_lock_object(ipc);
 
-	for (; pos <= max_idx; pos++) {
-		ipc = idr_find(&ids->ipcs_idr, pos);
-		if (ipc != NULL) {
-			rcu_read_lock();
-			ipc_lock_object(ipc);
-			break;
-		}
+		/* convert from idr index to position  -> "+1" */
+		*pos = tmpidx + 1;
 	}
-out:
-	*new_pos = pos + 1;
 	return ipc;
 }
 
@@ -817,11 +826,13 @@ static void *sysvipc_proc_next(struct se
 	if (ipc && ipc != SEQ_START_TOKEN)
 		ipc_unlock(ipc);
 
-	return sysvipc_find_ipc(&iter->ns->ids[iface->ids], *pos, pos);
+	/* Next -> search for *pos+1 */
+	(*pos)++;
+	return sysvipc_find_ipc(&iter->ns->ids[iface->ids], pos);
 }
 
 /*
- * File positions: pos 0 -> header, pos n -> ipc id = n - 1.
+ * File positions: pos 0 -> header, pos n -> ipc idx = n - 1.
  * SeqFile iterator: iterator value locked ipc pointer or SEQ_TOKEN_START.
  */
 static void *sysvipc_proc_start(struct seq_file *s, loff_t *pos)
@@ -846,8 +857,8 @@ static void *sysvipc_proc_start(struct s
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	/* Find the (pos-1)th ipc */
-	return sysvipc_find_ipc(ids, *pos - 1, pos);
+	/* Otherwise return the correct ipc structure */
+	return sysvipc_find_ipc(ids, pos);
 }
 
 static void sysvipc_proc_stop(struct seq_file *s, void *it)
_

Patches currently in -mm which might be from manfred@colorfullife.com are


