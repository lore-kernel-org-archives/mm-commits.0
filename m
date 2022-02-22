Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EC2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 01:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiBVByN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 20:54:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiBVByN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 20:54:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C719E25C4B
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 17:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60821B81823
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 01:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61AFC340E9;
        Tue, 22 Feb 2022 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645494826;
        bh=jBFvKd0JdJkE+YdhtHiPZYi5mLnO3vZNIQZG+POCUIY=;
        h=Date:To:From:Subject:From;
        b=wvf/cD70oppQr8L9LTRGdcysm7Mh8vT8Q9TGGfrXWT+I3lfMTbV/aKwFPHjmgOG3e
         yPoQYvXTVacyIkisDLJLOuIoPB2ut7VjMTZ9HE31QNjYu5XmvSd8w0IoF7ihAuWe1o
         /hW77OQJ6HOegjl+b/NK1wKmazqsgc5B8oWZHnvk=
Date:   Mon, 21 Feb 2022 17:53:45 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        roman.gushchin@linux.dev, mhocko@kernel.org,
        i.zhbanov@omprussia.ru, hannes@cmpxchg.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch added to -mm tree
Message-Id: <20220222015345.E61AFC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: return 1 from cgroup.memory __setup() handler
has been added to the -mm tree.  Its filename is
     mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -7100,7 +7100,7 @@ static int __init cgroup_memory(char *s)
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
 	}
-	return 0;
+	return 1;
 }
 __setup("cgroup.memory=", cgroup_memory);
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

