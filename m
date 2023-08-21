Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E8EEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjHUUlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjHUUk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EBEE66
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 379CF64AFF
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B815C433C8;
        Mon, 21 Aug 2023 20:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650398;
        bh=iV9vpnsuhteFhGwhD7Yu80e0uAvq+9AQXLywQDEfHzQ=;
        h=Date:To:From:Subject:From;
        b=qiDwKYD+g2M0HegI51SvsnPhnS3ciH2I87rnH3Qp7UcD4pTrmOA5Oz7V0f73poBCV
         ZolFYCkjML7S1K66NMF39Q1uWzwr2m9Y8pytKU/ImjR/MOyq0vj+/R4Dead/nggXxS
         9V7EmCIOODSdEf5guz4mmfwxwyw4OJJVYJeiilU8=
Date:   Mon, 21 Aug 2023 13:39:58 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch removed from -mm tree
Message-Id: <20230821203958.8B815C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: fix wrong function name above obj_cgroup_charge_zswap()
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: fix wrong function name above obj_cgroup_charge_zswap()
Date: Thu, 3 Aug 2023 20:00:21 +0800

The correct function name is obj_cgroup_may_zswap(). Correct the comment.

Link: https://lkml.kernel.org/r/20230803120021.762279-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap
+++ a/mm/memcontrol.c
@@ -7777,7 +7777,7 @@ bool obj_cgroup_may_zswap(struct obj_cgr
  * @objcg: the object cgroup
  * @size: size of compressed object
  *
- * This forces the charge after obj_cgroup_may_swap() allowed
+ * This forces the charge after obj_cgroup_may_zswap() allowed
  * compression and storage in zwap for this cgroup to go ahead.
  */
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

