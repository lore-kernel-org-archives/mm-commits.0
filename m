Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE40C61DA4
	for <mm-commits@archiver.kernel.org>; Tue, 14 Feb 2023 21:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBNVmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Feb 2023 16:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBNVmU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2023 16:42:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9398B28D31
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 13:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30EEB61901
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 21:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88601C433D2;
        Tue, 14 Feb 2023 21:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676410938;
        bh=g/Oj7lBBtl9LKPAYliXML8UL5Li8R4vArbMybvPdgXA=;
        h=Date:To:From:Subject:From;
        b=oAwpOdEnBYqPlMeq/B7pEZVBcn4FWOTVnkI/LTZmzILUgPXryJleusC7O0AVvqf3/
         OdsvD7tAyCHxL1pP8lKnLoZ0LzxX9A8IwL3ag4s9onn7D35nsUdcoVioYXklre8DL/
         6kGYdnXkwSMZ5RMAQNj69p0usJyY74VTT+lm/Dpk=
Date:   Tue, 14 Feb 2023 13:42:17 -0800
To:     mm-commits@vger.kernel.org, vvs@openvz.org, tj@kernel.org,
        roman.gushchin@linux.dev, dennis@kernel.org, cl@linux.com,
        laoar.shao@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-fix-incorrect-size-in-pcpu_obj_full_size.patch added to mm-unstable branch
Message-Id: <20230214214218.88601C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: percpu: fix incorrect size in pcpu_obj_full_size()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-fix-incorrect-size-in-pcpu_obj_full_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-fix-incorrect-size-in-pcpu_obj_full_size.patch

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
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm: percpu: fix incorrect size in pcpu_obj_full_size()
Date: Tue, 14 Feb 2023 15:35:49 +0000

The extra space which is used to store the obj_cgroup membership is only
valid when kmemcg is enabled.  The kmemcg can be disabled via the kernel
parameter "cgroup.memory=nokmem" at boot time.  This helper is also used
in non-memcg code, for example the tracepoint, so we should fix it.

It was found by code review when I was implementing bpf memory usage[1]. 
No real issue happens in production environment.

[1]. https://lwn.net/Articles/921991/

Link: https://lkml.kernel.org/r/20230214153549.12291-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Vasily Averin <vvs@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/percpu-internal.h~mm-percpu-fix-incorrect-size-in-pcpu_obj_full_size
+++ a/mm/percpu-internal.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
+#include <linux/memcontrol.h>
 
 /*
  * pcpu_block_md is the metadata block struct.
@@ -118,14 +119,15 @@ static inline int pcpu_chunk_map_bits(st
  * @size: size of area to allocate in bytes
  *
  * For each accounted object there is an extra space which is used to store
- * obj_cgroup membership. Charge it too.
+ * obj_cgroup membership if kmemcg is not disabled. Charge it too.
  */
 static inline size_t pcpu_obj_full_size(size_t size)
 {
 	size_t extra_size = 0;
 
 #ifdef CONFIG_MEMCG_KMEM
-	extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+	if (!mem_cgroup_kmem_disabled())
+		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
 #endif
 
 	return size * num_possible_cpus() + extra_size;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-percpu-fix-incorrect-size-in-pcpu_obj_full_size.patch

