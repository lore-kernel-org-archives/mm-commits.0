Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6C1C05027
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBQEqM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQEpj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:45:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F3759717
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2631B82B22
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82222C433EF;
        Fri, 17 Feb 2023 04:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609094;
        bh=cAmqXRv2uLU3+TzYVW0zl8np8lrjc5MwwG73rQjQXcw=;
        h=Date:To:From:Subject:From;
        b=SiTk4tI9QYmVsVZasiwEfoSl1YxUjqvCpnzdjCV7YxmnxM28JGdbx4p2cijBk20cx
         7y+FH9mEuFxdI0V9FqeowDCqJXleZj/ZnM+rrvUBGewvq3HomE6+C8EGiX4dC2EXB+
         l1P/uuKQm75wcVz8SqYGw3m91xUXU6zv6m6muoKY=
Date:   Thu, 16 Feb 2023 20:44:53 -0800
To:     mm-commits@vger.kernel.org, vvs@openvz.org, tj@kernel.org,
        roman.gushchin@linux.dev, dennis@kernel.org, cl@linux.com,
        laoar.shao@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-fix-incorrect-size-in-pcpu_obj_full_size.patch removed from -mm tree
Message-Id: <20230217044454.82222C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: percpu: fix incorrect size in pcpu_obj_full_size()
has been removed from the -mm tree.  Its filename was
     mm-percpu-fix-incorrect-size-in-pcpu_obj_full_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


