Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39ED5C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 02:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiJLCGG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 22:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJLCGF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 22:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1B451A07
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 19:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A97E56134C
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 02:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03531C433C1;
        Wed, 12 Oct 2022 02:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665540364;
        bh=taKx81soFPOQBdpzjm70UcTx7D+o58dN0Y5hHN0Dvew=;
        h=Date:To:From:Subject:From;
        b=BkIKQkARin4ns2MD5R1DW/W7/UBgOldglOIvgsKO28FhHdS9j1glTTNBrBQzRKy1J
         BaiJ6I3B5PklNAdvlsrhdzwp8EHs748EMrNQqyzIlBlve8SApgeJoJHW2JbEd2+0bY
         qZAQZ6RaEwpJdxfxM9UbQZfPTSNALhFLuthddgRo=
Date:   Tue, 11 Oct 2022 19:06:03 -0700
To:     mm-commits@vger.kernel.org, 42.hyeyoo@gmail.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch removed from -mm tree
Message-Id: <20221012020604.03531C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: initialize damon_target->list in damon_new_target()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: initialize damon_target->list in damon_new_target()
Date: Sun, 2 Oct 2022 19:31:30 +0000

'struct damon_target' creation function, 'damon_new_target()' is not
initializing its '->list' field, unlike other DAMON structs creator
functions such as 'damon_new_region()'.  Normal users of
'damon_new_target()' initializes the field by adding the target to DAMON
context's targets list, but some code could access the uninitialized
field.

This commit avoids the case by initializing the field in
'damon_new_target()'.

Link: https://lkml.kernel.org/r/20221002193130.8227-1-sj@kernel.org
Fixes: f23b8eee1871 ("mm/damon/core: implement region-based sampling")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-damon_target-list-in-damon_new_target
+++ a/mm/damon/core.c
@@ -313,6 +313,7 @@ struct damon_target *damon_new_target(vo
 	t->pid = NULL;
 	t->nr_regions = 0;
 	INIT_LIST_HEAD(&t->regions_list);
+	INIT_LIST_HEAD(&t->list);
 
 	return t;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


