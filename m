Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67AAECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiILE5C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiILE4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17890220CE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A988560AF4
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068BDC433D6;
        Mon, 12 Sep 2022 04:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958594;
        bh=ZXSj/joDe33cPQTQOKpAKw2HMYAKoCtHr+EqXgOILvs=;
        h=Date:To:From:Subject:From;
        b=X0c6/prvjudYpEwEoY1cKi/F/nbSvb4oKybjacWZlF5qtGoxNBr2NWhKMrf5up5YV
         ipsAM8tGp5rwRQ600DhmuW8WYU60MOvG3rBOyWSXmP4/YDZEWDg9mJh3sKI2uibmIU
         QPU7VViOVzWQ7cb93EHGTbCpCG/sj60Gce6V9rec=
Date:   Sun, 11 Sep 2022 21:56:33 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch removed from -mm tree
Message-Id: <20220912045634.068BDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: epoll: use try_cmpxchg in list_add_tail_lockless
has been removed from the -mm tree.  Its filename was
     epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: epoll: use try_cmpxchg in list_add_tail_lockless
Date: Thu, 14 Jul 2022 19:32:55 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
list_add_tail_lockless.  x86 CMPXCHG instruction returns success in ZF
flag, so this change saves a compare after cmpxchg (and related move
instruction in front of cmpxchg).

No functional change intended.

Link: https://lkml.kernel.org/r/20220714173255.12987-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/eventpoll.c~epoll-use-try_cmpxchg-in-list_add_tail_lockless
+++ a/fs/eventpoll.c
@@ -1065,7 +1065,7 @@ static inline bool list_add_tail_lockles
 	 * added to the list from another CPU: the winner observes
 	 * new->next == new.
 	 */
-	if (cmpxchg(&new->next, new, head) != new)
+	if (!try_cmpxchg(&new->next, &new, head))
 		return false;
 
 	/*
_

Patches currently in -mm which might be from ubizjak@gmail.com are


