Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC32C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 21:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiDZVQ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244733AbiDZVQ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 17:16:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DADA75E5D
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 14:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12137616F8
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 21:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65338C385AA;
        Tue, 26 Apr 2022 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651007599;
        bh=fxpwgAf4KX8werMXgeg57Z91BtKlwdoo4b671DMuHn4=;
        h=Date:To:From:Subject:From;
        b=Q438aKzb0MyHfH9p/CDAYc8otyxrR2W1jjU9hJgWXQj2y/4C3tk9FmyszIxJ1i9Ki
         i33qOBjSvY8SQ9aUHR+9xyk/DhUH82y6hPp694QpNiUIV6rNONg+BNkbx5a87f4lp2
         CqL9GOqYqbVBqrqN/mpPhyRijE0n0XFohlWUk/7s=
Date:   Tue, 26 Apr 2022 14:13:18 -0700
To:     mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        anshuman.khandual@arm.com, liusongtang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot.patch added to -mm tree
Message-Id: <20220426211319.65338C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: use pgprot_val to get value of pgprot
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: liusongtang <liusongtang@huawei.com>
Subject: mm/memory_hotplug: use pgprot_val to get value of pgprot

pgprot.pgprot is non-portable code.  It should be replaced by portable
macro pgprot_val.

Link: https://lkml.kernel.org/r/20220426071302.220646-1-liusongtang@huawei.com
Signed-off-by: liusongtang <liusongtang@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot
+++ a/mm/memory_hotplug.c
@@ -303,7 +303,7 @@ int __ref __add_pages(int nid, unsigned
 	int err;
 	struct vmem_altmap *altmap = params->altmap;
 
-	if (WARN_ON_ONCE(!params->pgprot.pgprot))
+	if (WARN_ON_ONCE(!pgprot_val(params->pgprot)))
 		return -EINVAL;
 
 	VM_BUG_ON(!mhp_range_allowed(PFN_PHYS(pfn), nr_pages * PAGE_SIZE, false));
_

Patches currently in -mm which might be from liusongtang@huawei.com are

mm-memory_hotplug-use-pgprot_val-to-get-value-of-pgprot.patch

