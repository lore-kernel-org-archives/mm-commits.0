Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5DDEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 20:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjGJUf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 16:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjGJUf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 16:35:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F35195
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 13:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEF43611AE
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 20:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBB0C433C8;
        Mon, 10 Jul 2023 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689021357;
        bh=Oy7+DNXmipmhX1zZLqaYMqIrmhsJaeyA1P0nUa4JTRE=;
        h=Date:To:From:Subject:From;
        b=p4FA1XIWODSCFKvb4XlQY621Sesx1WpE0ZjS1Z12fhIeN0qGAy+3yxS6P45ZcPJ7J
         G7kN/0sD/zRDjN8Avj4D1OKIk7B13ZJrBYxNhwTp+6BX+WRy5FTEQ/Z7IUzDhHDsqN
         jpJ+kMo1+e5ySJwLbe/deJar8MQb7pfYjKx1yL7s=
Date:   Mon, 10 Jul 2023 13:35:56 -0700
To:     mm-commits@vger.kernel.org, manfred@colorfullife.com,
        jannh@google.com, dave@stgolabs.net, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-use-flexible-array-in-struct-sem_undo.patch added to mm-nonmm-unstable branch
Message-Id: <20230710203557.2BBB0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: use flexible array in 'struct sem_undo'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-sem-use-flexible-array-in-struct-sem_undo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-use-flexible-array-in-struct-sem_undo.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jann Horn <jannh@google.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
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

ipc-sem-use-flexible-array-in-struct-sem_undo.patch

