Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5D9C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjHLWFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjHLWFQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F2198E
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9537460BFC
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0AAC433C8;
        Sat, 12 Aug 2023 22:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877919;
        bh=bv69KqzJnq+SaKNKdPqIbmHwhkXy37vgiDohz2S5Yvw=;
        h=Date:To:From:Subject:From;
        b=0enGLBX6Zm+37V0Ja0Z5sYThp/6mc842E7kCyKWQ6SfQuiIWy4akAQkgtMV/0flOJ
         TGOThUpadd+I2Eje6gwhO7xz+ch4W8z5Ac4CTpnr6R9sNo9NqtW8P2mIbdWMIxq7HJ
         WiZTqEA+BgWbDabTQDsQi5mtmYqL/FK9sm2ShREc=
Date:   Sat, 12 Aug 2023 15:05:18 -0700
To:     mm-commits@vger.kernel.org, manfred@colorfullife.com,
        jannh@google.com, dave@stgolabs.net, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-sem-use-flexible-array-in-struct-sem_undo.patch removed from -mm tree
Message-Id: <20230812220518.EE0AAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/sem: use flexible array in 'struct sem_undo'
has been removed from the -mm tree.  Its filename was
     ipc-sem-use-flexible-array-in-struct-sem_undo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ipc/sem: use flexible array in 'struct sem_undo'
Date: Sun, 9 Jul 2023 18:12:55 +0200

Turn 'semadj' in 'struct sem_undo' into a flexible array.

The advantages are:
   - save the size of a pointer when the new undo structure is allocated
   - avoid some always ugly pointer arithmetic to get the address of semadj
   - avoid an indirection when the array is accessed

While at it, use struct_size() to compute the size of the new undo
structure.

Link: https://lkml.kernel.org/r/1ba993d443ad7e16ac2b1902adab1f05ebdfa454.1688918791.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/ipc/sem.c~ipc-sem-use-flexible-array-in-struct-sem_undo
+++ a/ipc/sem.c
@@ -152,7 +152,7 @@ struct sem_undo {
 	struct list_head	list_id;	/* per semaphore array list:
 						 * all undos for one array */
 	int			semid;		/* semaphore set identifier */
-	short			*semadj;	/* array of adjustments */
+	short			semadj[];	/* array of adjustments */
 						/* one per semaphore */
 };
 
@@ -1938,8 +1938,7 @@ static struct sem_undo *find_alloc_undo(
 	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
-	new = kvzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems,
-		       GFP_KERNEL_ACCOUNT);
+	new = kvzalloc(struct_size(new, semadj, nsems), GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
@@ -1967,7 +1966,6 @@ static struct sem_undo *find_alloc_undo(
 		goto success;
 	}
 	/* step 5: initialize & link new undo structure */
-	new->semadj = (short *) &new[1];
 	new->ulp = ulp;
 	new->semid = semid;
 	assert_spin_locked(&ulp->lock);
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


