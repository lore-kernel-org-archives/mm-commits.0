Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D2CC54FB9
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 15:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345385AbjKPPCf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 10:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345349AbjKPPCe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 10:02:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6198FB5
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 07:02:30 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F70C433C9;
        Thu, 16 Nov 2023 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700146950;
        bh=pOzTpEJEjdEAz56DpI5bXcVPGKOxmR7DFv4e5XjOouw=;
        h=Date:To:From:Subject:From;
        b=QerH7nbiGqlYoaNZgvO4MqASgtSoyvmYgEjoMhrTjON0aZubANiQUpVnGI3fXrh/1
         TMKip0IGjpLhkp1AlTTEUOLVq9bfYCdQ48bxiNXILMEJ5OrS0MUu4crwyrRhBZeeyr
         BcokkEJoZMaWPGulERjFbkaAnH3UPqJRcfpFB23Q=
Date:   Thu, 16 Nov 2023 07:02:28 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        erhard_f@mailbox.org, dennis@kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20231116150230.03F70C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix
Date: Thu, 16 Nov 2023 08:04:18 +0100

remove redundant assignment

Link: https://lkml.kernel.org/r/4bd106d5-c3e3-6731-9a74-cff81e2392de@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Erhard Furtner <erhard_f@mailbox.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix
+++ a/mm/memcontrol.c
@@ -3177,7 +3177,6 @@ from_memcg:
 		objcg = rcu_dereference_check(memcg->objcg, 1);
 		if (likely(objcg))
 			break;
-		objcg = NULL;
 	}
 
 	return objcg;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix.patch

