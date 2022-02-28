Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EE3C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiB1Fi2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbiB1FiX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:38:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6BA21E3C
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:37:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFD0C60FA5
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105F4C340F0;
        Mon, 28 Feb 2022 05:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646026663;
        bh=QMYJTrXUVn5WhXQ2UfiZmk/XGgh7NGN1ts4nsgh6OAY=;
        h=Date:To:From:Subject:From;
        b=TeGByTloQcdMWz8m6VmNTr2Y/c5fEXlSMPqvI0st+zErfsN4gL3kTMCSaAZ4KuG3T
         EQUwkza28lJAeH0OTxilux/JSiqoPf4UIkc+ScovX8Va86av20pLs1K72cinx7aMPK
         mXFCKVVwxdeMkyzWxALDGuPGV10kGlIUUA+EWED8=
Date:   Sun, 27 Feb 2022 21:37:42 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        roman.gushchin@linux.dev, mhocko@kernel.org,
        i.zhbanov@omprussia.ru, hannes@cmpxchg.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch added to -mm tree
Message-Id: <20220228053743.105F4C340F0@smtp.kernel.org>
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
@@ -7058,7 +7058,7 @@ static int __init cgroup_memory(char *s)
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
mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
inith-improve-__setup-and-early_param-documentation.patch
init-mainc-return-1-from-handled-__setup-functions.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

