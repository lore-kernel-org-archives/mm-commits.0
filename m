Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94358C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjBJAwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjBJAwa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96E66ADDF
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 649B8B8239A
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5FDC433D2;
        Fri, 10 Feb 2023 00:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990343;
        bh=8y14qzynJ7nPtQ2biatJlCFdiCXyOhswFHKmKa9uq7I=;
        h=Date:To:From:Subject:From;
        b=wRHnsLMvvt3irRPz3j6uAtP0AhWLG3a0ZOZdfXe7uwGq2C7PphO/ieK1vxwm0zumz
         LaYDymUWXv285Y95QjvFAxzzceyc4wjL39LW9ETLTO4LO5egIBZaHZQzgoHOGFgfew
         qRm9zZbY1zOpJMaXrDUw2f/fA/+3xHJUKhMephgI=
Date:   Thu, 09 Feb 2023 16:52:22 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-potential-rcu-issue.patch removed from -mm tree
Message-Id: <20230210005223.0C5FDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix potential rcu issue
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-potential-rcu-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: fix potential rcu issue
Date: Fri, 20 Jan 2023 11:26:03 -0500

Ensure the node isn't dead after reading the node end.

Link: https://lkml.kernel.org/r/20230120162650.984577-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-potential-rcu-issue
+++ a/lib/maple_tree.c
@@ -4655,13 +4655,13 @@ static inline void *mas_next_nentry(stru
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
 	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	count = ma_data_end(node, type, pivots, mas->max);
 	if (ma_dead_node(node))
 		return NULL;
 
 	if (mas->index > max)
 		return NULL;
 
-	count = ma_data_end(node, type, pivots, mas->max);
 	if (mas->offset > count)
 		return NULL;
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


