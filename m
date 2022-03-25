Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD41C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiCYWn0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiCYWnQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A179208C1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AA8DB82A2F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D407CC004DD;
        Fri, 25 Mar 2022 22:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248099;
        bh=eX3+nTJkIqZKI2nPKl1bXysd6Jwx46VLx48KdA4n0YE=;
        h=Date:To:From:Subject:From;
        b=QfX6iZNY3yA03LVh4n905sv9ZpDbE2cDtJUUeZP31wYY8pXn9TKijO3pDHTLvsHqy
         Xzrn62RFbxHL/6D5AImSdi533iOrigLDUhydVTvUIhRonbKPY6sbL6BMYsymApdFnU
         ZwY0szBXUIqdy4URiAFE7m6QeeUxjYa/GcXBEL1g=
Date:   Fri, 25 Mar 2022 15:41:39 -0700
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, sfr@canb.auug.org.au,
        caoyixuan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-add-a-security-check.patch removed from -mm tree
Message-Id: <20220325224139.D407CC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: add a security check
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-add-a-security-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: add a security check

Add a security check after using malloc() to allocate memory.

Link: https://lkml.kernel.org/r/20220301151438.166118-2-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-add-a-security-check
+++ a/tools/vm/page_owner_sort.c
@@ -217,7 +217,13 @@ static void add_list(char *buf, int len)
 		printf("max_size too small??\n");
 		exit(1);
 	}
+
 	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].txt) {
+		printf("Out of memory\n");
+		exit(1);
+	}
+
 	list[list_size].len = len;
 	list[list_size].num = 1;
 	list[list_size].page_num = get_page_num(buf);
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are


