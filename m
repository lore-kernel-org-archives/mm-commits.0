Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69117C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJLW52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLW5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B23711C27E
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FA3CB81BDD
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C21C433D6;
        Wed, 12 Oct 2022 22:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615437;
        bh=squJACu32dccme+f/e1reBk2/vjKIirPZrPQDiqDsV0=;
        h=Date:To:From:Subject:From;
        b=lm0iyy7+h+ZVAj+wjIGQEu6QM+1eACQTn6BbHrhoHcgAApUrtnzcjUrme9Vqq3KjF
         zzS+7gcOMtVVhb1OdLviWT7xMAiozAzvJeIVwOMeZdga5lrDyemQe6tWJxH85bf69P
         z2SQv4Rd8pT0nCiSC2ZG/tNWpJELD11T3qjqXtYk=
Date:   Wed, 12 Oct 2022 15:57:16 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-more-vma-cache-removal.patch removed from -mm tree
Message-Id: <20221012225716.E5C21C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: more vma cache removal
has been removed from the -mm tree.  Its filename was
     mm-more-vma-cache-removal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: mm: more vma cache removal
Date: Tue, 11 Oct 2022 20:55:31 +0300

Link: https://lkml.kernel.org/r/Y0WuE3Riv4iy5Jx8@localhost.localdomain
Fixes: 7964cf8caa4d ("mm: remove vmacache")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/sched.h~mm-more-vma-cache-removal
+++ a/include/linux/sched.h
@@ -861,8 +861,6 @@ struct task_struct {
 	struct mm_struct		*mm;
 	struct mm_struct		*active_mm;
 
-	/* Per-thread vma caching: */
-
 #ifdef SPLIT_RSS_COUNTING
 	struct task_rss_stat		rss_stat;
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are


