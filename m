Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F802C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiCVVmN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiCVVmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:42:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF555EDE7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:40:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04DCCB81DB1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750D6C340EC;
        Tue, 22 Mar 2022 21:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985232;
        bh=44P0kXBr6Wmm5QcJbLKop4jEJJGuQ/RbesnXVFSmoiY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ldaxHFRUbsSnpy2BiwtwXQ/D2hAujdDqKxyXk0I8KUR457FA17I9OpUP8VX2Ux3Rp
         +2iW+39RZ4ByD3ZirqehcBsaoQKZ1p90FFNwYJz0LzJIofiVYR/0AlfniR6HCIZsaY
         k+6QTzBPEWl7sfWhOze5KIPrzJUGm6WFICCEQRS8=
Date:   Tue, 22 Mar 2022 14:40:31 -0700
To:     vdavydov.dev@gmail.com, roman.gushchin@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, i.zhbanov@omprussia.ru, hannes@cmpxchg.org,
        rdunlap@infradead.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 040/227] mm/memcontrol: return 1 from cgroup.memory __setup() handler
Message-Id: <20220322214032.750D6C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memcontrol: return 1 from cgroup.memory __setup() handler

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's
environment).

The only reason that this particular __setup handler does not pollute
init's environment is that the setup string contains a '.', as in
"cgroup.memory".  This causes init/main.c::unknown_boottoption() to
consider it to be an "Unused module parameter" and ignore it.  (This is
for parsing of loadable module parameters any time after kernel init.)
Otherwise the string "cgroup.memory=whatever" would be added to init's
environment strings.

Instead of relying on this '.' quirk, just return 1 to indicate that the
boot option has been handled.

Note that there is no warning message if someone enters:
	cgroup.memory=anything_invalid

Link: https://lkml.kernel.org/r/20220222005811.10672-1-rdunlap@infradead.org
Fixes: f7e1cb6ec51b0 ("mm: memcontrol: account socket memory in unified hierarchy memory controller")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-return-1-from-cgroupmemory-__setup-handler
+++ a/mm/memcontrol.c
@@ -7058,7 +7058,7 @@ static int __init cgroup_memory(char *s)
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
 	}
-	return 0;
+	return 1;
 }
 __setup("cgroup.memory=", cgroup_memory);
 
_
