Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3777C2BB3F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbjKOXa7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbjKOXax (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AA819B;
        Wed, 15 Nov 2023 15:30:50 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F0DC433CD;
        Wed, 15 Nov 2023 23:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091049;
        bh=ouCvXpaR3xeauFIl7IjoyA8aOQVTJYfqHxAv7mNMD6g=;
        h=Date:To:From:Subject:From;
        b=FURw/XUgPCGXWaDHfGbwmDLThKPBqzFIJk2fbAqRscD6Klgq/1UqH0TlhMfTycVE3
         2Rti7pWio20xIfgSXRMCXzYQN6BefDeP+j9G+pWmHmeNboQjRQ6xSREjF8eRjmHJYk
         iQmG1EPqzXPnI4WOw9rxruPfZbzt8HiQpBmz7sBI=
Date:   Wed, 15 Nov 2023 15:30:49 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch removed from -mm tree
Message-Id: <20231115233049.A5F0DC433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: handle tried regions sysfs directory allocation failure
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: handle tried regions sysfs directory allocation failure
Date: Mon, 6 Nov 2023 23:34:07 +0000

DAMOS tried regions sysfs directory allocation function
(damon_sysfs_scheme_regions_alloc()) is not handling the memory allocation
failure.  In the case, the code will dereference NULL pointer.  Handle the
failure to avoid such invalid access.

Link: https://lkml.kernel.org/r/20231106233408.51159-3-sj@kernel.org
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure
+++ a/mm/damon/sysfs-schemes.c
@@ -162,6 +162,9 @@ damon_sysfs_scheme_regions_alloc(void)
 	struct damon_sysfs_scheme_regions *regions = kmalloc(sizeof(*regions),
 			GFP_KERNEL);
 
+	if (!regions)
+		return NULL;
+
 	regions->kobj = (struct kobject){};
 	INIT_LIST_HEAD(&regions->regions_list);
 	regions->nr_regions = 0;
_

Patches currently in -mm which might be from sj@kernel.org are


