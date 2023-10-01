Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CCCE78486
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbjJATjl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbjJATjl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:39:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF22BF
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:39:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136BFC433C8;
        Sun,  1 Oct 2023 19:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696189179;
        bh=P4A85VJjXdPdCbyJVHJWQ38/3tVAbNMH5U2KYZPO9RQ=;
        h=Date:To:From:Subject:From;
        b=xF5aItISY6ITdHpJIDNpIt2x7gW7eNWVw0+L5//vSj6RDqBU3NUeCFhnm0H9YJ0Fw
         ie2Q4M2sQCfETKP6iB9/zGhvaprtR4qsKX5BKCtcmuQcYN8lLjo7kzUcQ3SC5MVRmP
         WAtIku4lKb3FbR8edz6usF6a1axA7N/+dGNtkpHY=
Date:   Sun, 01 Oct 2023 12:39:38 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-add-direct-objcg-pointer-to-task_struct-fix.patch added to mm-unstable branch
Message-Id: <20231001193939.136BFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmem-add-direct-objcg-pointer-to-task_struct-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-add-direct-objcg-pointer-to-task_struct-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-add-direct-objcg-pointer-to-task_struct-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm-kmem-add-direct-objcg-pointer-to-task_struct-fix
Date: Sun, 1 Oct 2023 09:42:54 -0700

fix sparse complaint

Link: https://lkml.kernel.org/r/ZRmhjpGvKIdGj162@P9FQF9L96D.lan

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-kmem-add-direct-objcg-pointer-to-task_struct-fix
+++ a/mm/memcontrol.c
@@ -3053,7 +3053,7 @@ static struct obj_cgroup *current_objcg_
 	rcu_read_lock();
 	do {
 		/* Atomically drop the update bit, */
-		WARN_ON_ONCE(cmpxchg(&current->objcg, tmp, 0) != tmp);
+		WARN_ON_ONCE(cmpxchg(&current->objcg, tmp, NULL) != tmp);
 
 		/* ...obtain the new objcg pointer */
 		memcg = mem_cgroup_from_task(current);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch

