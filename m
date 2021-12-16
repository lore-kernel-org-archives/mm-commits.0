Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3360C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbhLPWJq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbhLPWJq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:09:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C4DC061574
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 14:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 901EC61F9F
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAD1C36AE2;
        Thu, 16 Dec 2021 22:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639692585;
        bh=OF4UaC7HrIybEZMjhBBgM0054C3HsmV/ByKbRTQZ7Os=;
        h=Date:From:To:Subject:From;
        b=eAMofn8qpBMOZTtTLCbzCVlN3ahkHUEud+5w7Hme/ZYBVw3iWbKhLkLuwhyU+lcq/
         grxjQW5Vrtt1QohJuV07rF88AKzR2wI9R3jDP0sFSzxJnWllBiZn3OEpYeJNQQO8Dm
         nSnM1YmuDxV09kJt8LnVlQ8UxVEA+zXv5gORZn5s=
Date:   Thu, 16 Dec 2021 14:09:44 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        songmuchun@bytedance.com, mhocko@kernel.org, hannes@cmpxchg.org,
        wangweiyang2@huawei.com
Subject:  + mm-memcg-use-struct_size-helper-in-kzalloc.patch added to
 -mm tree
Message-ID: <20211216220944.TANFr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: use struct_size() helper in kzalloc()
has been added to the -mm tree.  Its filename is
     mm-memcg-use-struct_size-helper-in-kzalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-use-struct_size-helper-in-kzalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-use-struct_size-helper-in-kzalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Weiyang <wangweiyang2@huawei.com>
Subject: mm/memcg: use struct_size() helper in kzalloc()

Make use of the struct_size() helper instead of an open-coded version, in
order to avoid any potential type mistakes or integer overflows that, in
the worst scenario, could lead to heap overflows.

Link: https://github.com/KSPP/linux/issues/160
Link: https://lkml.kernel.org/r/20211216022024.127375-1-wangweiyang2@huawei.com
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-struct_size-helper-in-kzalloc
+++ a/mm/memcontrol.c
@@ -5122,15 +5122,11 @@ static void mem_cgroup_free(struct mem_c
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *memcg;
-	unsigned int size;
 	int node;
 	int __maybe_unused i;
 	long error = -ENOMEM;
 
-	size = sizeof(struct mem_cgroup);
-	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
-
-	memcg = kzalloc(size, GFP_KERNEL);
+	memcg = kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(error);
 
_

Patches currently in -mm which might be from wangweiyang2@huawei.com are

mm-memcg-use-struct_size-helper-in-kzalloc.patch

