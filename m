Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82CBC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjBJAwb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjBJAwa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977556ADDC
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322E261C11
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B4C433EF;
        Fri, 10 Feb 2023 00:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990344;
        bh=LJPZ3wAtegDf0T6yaKvvC+dxQ5m3LZEKdIsO5T0ZfVw=;
        h=Date:To:From:Subject:From;
        b=MpyZ/Kc3YJmTnjhXuymptsS/04CSgJfjzchs/Cybe9rJpdu4RDYkcqhCjtcT9QXRV
         DoPnc+YwXVeSitC2ZNBI3+FG2QzR63XPNhnPV5Nu2qdioE6GghUa+Bivv+SC4qxdUY
         DpLVKJoGe0KuV9nwlOELy4UgPUULOgfpuC92qM28=
Date:   Thu, 09 Feb 2023 16:52:24 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-reduce-user-error-potential.patch removed from -mm tree
Message-Id: <20230210005224.890B4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: reduce user error potential
has been removed from the -mm tree.  Its filename was
     maple_tree-reduce-user-error-potential.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: reduce user error potential
Date: Fri, 20 Jan 2023 11:26:04 -0500

When iterating, a user may operate on the tree and cause the maple state
to be altered and left in an unintuitive state.  Detect this scenario and
correct it by setting to the limit and invalidating the state.

Link: https://lkml.kernel.org/r/20230120162650.984577-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/lib/maple_tree.c~maple_tree-reduce-user-error-potential
+++ a/lib/maple_tree.c
@@ -4732,6 +4732,11 @@ static inline void *mas_next_entry(struc
 	unsigned long last;
 	enum maple_type mt;
 
+	if (mas->index > limit) {
+		mas->index = mas->last = limit;
+		mas_pause(mas);
+		return NULL;
+	}
 	last = mas->last;
 retry:
 	offset = mas->offset;
@@ -4838,6 +4843,11 @@ static inline void *mas_prev_entry(struc
 {
 	void *entry;
 
+	if (mas->index < min) {
+		mas->index = mas->last = min;
+		mas_pause(mas);
+		return NULL;
+	}
 retry:
 	while (likely(!mas_is_none(mas))) {
 		entry = mas_prev_nentry(mas, min, mas->index);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


