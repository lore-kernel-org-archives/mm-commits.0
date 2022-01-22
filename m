Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897D8C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiAVBXy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiAVBXx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:23:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0521C06173D
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:23:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BFDE61AD1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBC9C340E4;
        Sat, 22 Jan 2022 01:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814631;
        bh=o10jm+UKSJRGLw1kuMoZPqHhKV3ozmcYe8arHie4cS4=;
        h=Date:From:To:Subject:From;
        b=jXMc8JdDkt+ypn089hXkrWbxSAcWJuxlhPmqIa7hezIEX8wt1OuQRWzrLDi4ecrzv
         eQUnsCVPGgW9geKbrVQfPkV0c/79UeFdEMyVKVt5uEsCHLdeRPZJ1ca2gsKeI7wHyr
         PjYPTzqehoDp05XZ8r8Gf249UVHKzPrd/HN/0+Ow=
Date:   Fri, 21 Jan 2022 17:23:51 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, jirislaby@gmail.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-allocat?=
 =?US-ASCII?Q?ion-by-kvmalloc-fixup4.patch?= removed from -mm tree
Message-ID: <20220122012351.MJzX7Yre-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup4
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4.patch

This patch was dropped because it was folded into lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup4

Due to 4e66934eaadc ("lib: add reference counting tracking
infrastructure") landing recently to net-next adding a new stack depot
user in lib/ref_tracker.c we need to add an appropriate call to
stack_depot_init() there as well.

Link: https://lkml.kernel.org/r/45c1b738-1a2f-5b5f-2f6d-86fab206d01c@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Slab <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ref_tracker.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/ref_tracker.h~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4
+++ a/include/linux/ref_tracker.h
@@ -4,6 +4,7 @@
 #include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/stackdepot.h>
 
 struct ref_tracker;
 
@@ -26,6 +27,7 @@ static inline void ref_tracker_dir_init(
 	spin_lock_init(&dir->lock);
 	dir->quarantine_avail = quarantine_count;
 	refcount_set(&dir->untracked, 1);
+	stack_depot_init();
 }
 
 void ref_tracker_dir_exit(struct ref_tracker_dir *dir);
_

Patches currently in -mm which might be from vbabka@suse.cz are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

