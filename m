Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE94C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbiCYWnO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiCYWnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E00208C14
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 711D0B82A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9A2C004DD;
        Fri, 25 Mar 2022 22:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248089;
        bh=s0y34cIcb4nIZFrSw3BhTIN1yTfCLPh9BywBY2X51eA=;
        h=Date:To:From:Subject:From;
        b=lS9HXTKaPlQg/m1ygZT0FhAyapSQevsT7PIM+j+aHZ854wBlwYnnyqXNFiGqqHfpD
         9YA6yAnoaMl5C5Ll/2E7dtptZNuXGFbtS1Fe6a99hjlpD8Fv2b3aWXnP+hyj1iF4Ki
         0AvVKLjb/8h2YdtvfTQ5s4tWLHclVIqjwkkeOYf0=
Date:   Fri, 25 Mar 2022 15:41:28 -0700
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        seanga2@gmail.com, broonie@kernel.org,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch removed from -mm tree
Message-Id: <20220325224129.0D9A2C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: delete invalid duplicate code
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: delete invalid duplicate code

I noticed that there is two invalid lines of duplicate code.  It's better
to delete it.

Link: https://lkml.kernel.org/r/20211213095743.3630-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Mark Brown <broonie@kernel.org>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-delete-invalid-duplicate-code
+++ a/tools/vm/page_owner_sort.c
@@ -227,8 +227,6 @@ static void add_list(char *buf, int len)
 	list[list_size].pid = get_pid(buf);
 	list[list_size].ts_nsec = get_ts_nsec(buf);
 	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
-	memcpy(list[list_size].txt, buf, len);
-	list[list_size].txt[len] = 0;
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are


