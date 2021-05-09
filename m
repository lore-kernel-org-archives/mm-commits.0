Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A5FC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4247961400
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEIAtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEIAtu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A44EB61155;
        Sun,  9 May 2021 00:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620521328;
        bh=yP+25KcFZ9CqaYGxxZHiwzvaOdlM28Uz6GdwPBptdNo=;
        h=Date:From:To:Subject:From;
        b=w8o+y0zTcz07QtzmNHVdk/I3d3HZEgGQB3Gwz2fFzS4WUrDe0rk+FTBEhSmZk5e0J
         JFYp0+bnFJx/qBQT/YDLIx622H2q2lBeTUsLPmvgxEWGkX86WRrTXUrmbpKnoAmyzO
         5cMvBB1hGql5DgUm7ClCQlIXgPYitUBq+noAhXgU=
Date:   Sat, 08 May 2021 17:48:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tangbin@cmss.chinamobile.com,
        zhangshengju@cmss.chinamobile.com
Subject:  +
 tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk.patch added
 to -mm tree
Message-ID: <20210509004848.3uYusJiEs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: check malloc return
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Bin <tangbin@cmss.chinamobile.com>
Subject: tools/vm/page_owner_sort.c: check malloc return

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

tools-vm-page_owner_sortc-fix-the-potential-stack-overflow-risk.patch

