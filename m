Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD090EB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjGGTTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjGGTTF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:19:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCD5131
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5947361A39
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBC7C433C7;
        Fri,  7 Jul 2023 19:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688757542;
        bh=4HlTwli32ei83rKoiMV3NMBeAXSaOYCDQO46WVjCMJQ=;
        h=Date:To:From:Subject:From;
        b=JMQXZ3ITE2gV2a+oTyGvlom1h3NJ8Ap1SjPVSIqsASKZbSfNFWOb8QOKD7VLYukzn
         7Fzo0SCpqsAaDkv2yF/qgU0MJ/AxVh8BkGaqUHcH9fU4r3IBC2bZ8lhsjgHk8E+m/Q
         UWygPkhLSL2xr0nMwzT63c0MQUiWAP2enzT46FXg=
Date:   Fri, 07 Jul 2023 12:19:02 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev,
        hannes@cmpxchg.org, mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-drop-kmemlimit_in_bytes-fix.patch added to mm-unstable branch
Message-Id: <20230707191902.AEBC7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-drop-kmemlimit_in_bytes-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-drop-kmemlimit_in_bytes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-drop-kmemlimit_in_bytes-fix.patch

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
From: Michal Hocko <mhocko@suse.com>
Subject: memcg-drop-kmemlimit_in_bytes-fix
Date: Fri, 7 Jul 2023 09:07:47 +0200

restore _KMEM switch case

Link: https://lkml.kernel.org/r/ZKe5wxdbvPi5Cwd7@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memcontrol.c~memcg-drop-kmemlimit_in_bytes-fix
+++ a/mm/memcontrol.c
@@ -3708,6 +3708,9 @@ static u64 mem_cgroup_read_u64(struct cg
 	case _MEMSWAP:
 		counter = &memcg->memsw;
 		break;
+	case _KMEM:
+		counter = &memcg->kmem;
+		break;
 	case _TCP:
 		counter = &memcg->tcpmem;
 		break;
_

Patches currently in -mm which might be from mhocko@suse.com are

memcg-drop-kmemlimit_in_bytes.patch
memcg-drop-kmemlimit_in_bytes-fix.patch

