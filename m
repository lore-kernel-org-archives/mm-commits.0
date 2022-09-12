Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3963C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiILDgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiILDdz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B79286D8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E040611AD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C36C433D6;
        Mon, 12 Sep 2022 03:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953456;
        bh=VvrHVGJPGYdUEEFBesN7vKP7yviS38V/myhU0+Te0pg=;
        h=Date:To:From:Subject:From;
        b=WfNPOLPGrT780mzwnM76lW47vaPzXk5mCdrS0aCq69HkTuAbXOgT23ofUHbDSETxn
         edto+eyIKgrrz/3WlzViD1pT8I7JAjltSllrBUv3imt3/fuGUktlvGslopecsKwWOf
         giqVrabrqGZAEuxrHOR3QL5PcPJI1BE8cjqTYu9k=
Date:   Sun, 11 Sep 2022 20:30:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap_pages-save-a-few-cycles-in-get_dev_pagemap.patch removed from -mm tree
Message-Id: <20220912033056.65C36C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap_pages: save a few cycles in get_dev_pagemap()
has been removed from the -mm tree.  Its filename was
     mm-mremap_pages-save-a-few-cycles-in-get_dev_pagemap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm/mremap_pages: save a few cycles in get_dev_pagemap()
Date: Fri, 2 Sep 2022 18:39:52 +0200

Use 'percpu_ref_tryget_live_rcu()' instead of 'percpu_ref_tryget_live()'
to save a few cycles when it is known that the rcu lock is already
taken/released.

Link: https://lkml.kernel.org/r/9ef1562a1975371360f3e263856e9f1c5749b656.1662136782.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c~mm-mremap_pages-save-a-few-cycles-in-get_dev_pagemap
+++ a/mm/memremap.c
@@ -454,7 +454,7 @@ struct dev_pagemap *get_dev_pagemap(unsi
 	/* fall back to slow path lookup */
 	rcu_read_lock();
 	pgmap = xa_load(&pgmap_array, PHYS_PFN(phys));
-	if (pgmap && !percpu_ref_tryget_live(&pgmap->ref))
+	if (pgmap && !percpu_ref_tryget_live_rcu(&pgmap->ref))
 		pgmap = NULL;
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


