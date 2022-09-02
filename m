Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60CDECAAD5
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 18:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiIBSsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 14:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiIBSsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 14:48:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4520D4BF6
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 11:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7497CB82D02
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 18:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FFFC433D6;
        Fri,  2 Sep 2022 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662144523;
        bh=eOmxiReBnejJ2XEc/672GTTgFuWLPEr0al46tb06WFs=;
        h=Date:To:From:Subject:From;
        b=w30s9SxTVXxKKzjU/OKZTw+4gnoQ4ij3kp20VXfqz1RSqhUmJNzHIfgsdGDRXa2r5
         RraPwlOwXUXDoEcHJ1oG2p0s+VBPrPP2ikCcDBR7Vh9vbbXdQ9M+usLawD/wLKXlnn
         jTQcw7pCrW/OAOgQK0gshWPgI+UrxCAM22doe+dM=
Date:   Fri, 02 Sep 2022 11:48:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap_pages-save-a-few-cycles-in-get_dev_pagemap.patch added to mm-unstable branch
Message-Id: <20220902184843.33FFFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap_pages: save a few cycles in get_dev_pagemap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap_pages-save-a-few-cycles-in-get_dev_pagemap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap_pages-save-a-few-cycles-in-get_dev_pagemap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-mremap_pages-save-a-few-cycles-in-get_dev_pagemap.patch

