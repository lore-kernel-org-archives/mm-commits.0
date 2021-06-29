Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC07DC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63DE61D05
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhF2Chg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhF2Chf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED72F61D00;
        Tue, 29 Jun 2021 02:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934108;
        bh=sU0HuV4KjbIrx60Q32gXd86fZZFa3t7Aek70ZXkfMog=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NkE1j0dBQJIDhlnU6gPxrbES6UUXNVVWWbg+aNioY9GZm4aB2RY0RZSbEOm8kbSVk
         dnEeRDGQZDJwwK8xV56dnt8+uSDgqtQmxYOveqK5bM1oMGZ/iCFAePFyJU5od+oVez
         Em9KGwoC3BMjApaaQLBqRgFRgNGo/xyF1f+UGrz4=
Date:   Mon, 28 Jun 2021 19:35:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tangbin@cmss.chinamobile.com,
        torvalds@linux-foundation.org, zhangshengju@cmss.chinamobile.com
Subject:  [patch 035/192] tools/vm/page_owner_sort.c: check
 malloc() return
Message-ID: <20210629023507.bxBh2LOcT%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
