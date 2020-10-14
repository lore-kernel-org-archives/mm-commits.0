Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF842C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 607E92224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709203;
	bh=tjpw5BhEZmXaX4ADD9FAIrTHS/QjaUq5ZeUAZdY5MEk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Hxpc52Sai8hnrmEnoplIiRy2qcuYq0KxKjCV76AmDdnvK7TzweuCygGU3KBE0tcXw
	 eEobliFq9Yoeb1fWLmRUBchbfDyOs2TSNWWhZZZAXU4TZ2p8Ivddc4xIggffRj7AZ1
	 hol89DInvnidqAvnqsPFoY5/Z3QEFYy++hUoRuU0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgJNVAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVAC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC882068E;
        Wed, 14 Oct 2020 21:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709202;
        bh=tjpw5BhEZmXaX4ADD9FAIrTHS/QjaUq5ZeUAZdY5MEk=;
        h=Date:From:To:Subject:From;
        b=XHCg4A+9k4b/tWoT6oBl6fqUeAZHRGUkptHkV5fgAjEjsHDGEKiKfMqjKUxZYMIOU
         v2xdELD4Wy1GqWYdeK9cbFxrZxyrooUmj0R/KAwrfKKpM/2oQnsN06YsbtQ8DrYqHo
         LRsrbUmVF6MKFAMphGMls1/Gb9G5F00I8ZR7tgE8=
Date:   Wed, 14 Oct 2020 14:00:01 -0700
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch removed from -mm
 tree
Message-ID: <20201014210001.ma92zru7p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use flex_array_size() helper in memcpy()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: memcontrol: use flex_array_size() helper in memcpy()

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer overflows,
while at the same time makes it explicitly clear that we are dealing with
a flexible array member.

Also, remove unnecessary braces.

Link: https://lkml.kernel.org/r/ddd60dae2d9aea1ccdd2be66634815c93696125e.1596214831.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-flex_array_size-helper-in-memcpy
+++ a/mm/memcontrol.c
@@ -4255,10 +4255,9 @@ static int __mem_cgroup_usage_register_e
 	new->size = size;
 
 	/* Copy thresholds (if any) to new array */
-	if (thresholds->primary) {
-		memcpy(new->entries, thresholds->primary->entries, (size - 1) *
-				sizeof(struct mem_cgroup_threshold));
-	}
+	if (thresholds->primary)
+		memcpy(new->entries, thresholds->primary->entries,
+		       flex_array_size(new, entries, size - 1));
 
 	/* Add new threshold */
 	new->entries[size - 1].eventfd = eventfd;
_

Patches currently in -mm which might be from gustavoars@kernel.org are


