Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE2FC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B76C61107
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhGFTMF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhGFTMD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 705956192B;
        Tue,  6 Jul 2021 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598564;
        bh=dCud1LZZazWT5ws4pRe+ThyKbSSocmAIbujKdPo9H20=;
        h=Date:From:To:Subject:From;
        b=pjmnoHZ8qAY7kxyfDZ5Wom8F7A4is/9cdFLdwv0gZBY62qPV1CkvKv2a3T3nxxDvG
         IRs+8huql0+SAO5PsKiSHZfBj1zUcKqjoLWKaejcgXShS0st7ygNd7wLLcfdHNTB1X
         uwt0pisyaFYU7ysQSSElfU6r2tMbARmlmkGjSQ1Y=
Date:   Tue, 06 Jul 2021 12:09:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tangbin@cmss.chinamobile.com,
        zhangshengju@cmss.chinamobile.com
Subject:  [merged]
 tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk.patch
 removed from -mm tree
Message-ID: <20210706190924.gveOwW5MG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: check malloc() return
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Bin <tangbin@cmss.chinamobile.com>
Subject: tools/vm/page_owner_sort.c: check malloc() return

Link: https://lkml.kernel.org/r/20210506131402.10416-1-tangbin@cmss.chinamobile.com
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk
+++ a/tools/vm/page_owner_sort.c
@@ -132,6 +132,10 @@ int main(int argc, char **argv)
 	qsort(list, list_size, sizeof(list[0]), compare_txt);
 
 	list2 = malloc(sizeof(*list) * list_size);
+	if (!list2) {
+		printf("Out of memory\n");
+		exit(1);
+	}
 
 	printf("culling\n");
 
_

Patches currently in -mm which might be from tangbin@cmss.chinamobile.com are


