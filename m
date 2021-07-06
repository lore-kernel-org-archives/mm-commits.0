Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA07C11F68
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD06361057
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhGFTMC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhGFTMB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB1D61C85;
        Tue,  6 Jul 2021 19:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598562;
        bh=Kcz6msh8ka60nTCR+HEn0pCXfNcJamrF9CIpM4xxmoM=;
        h=Date:From:To:Subject:From;
        b=UtFozc12y9gpI4T4MXbnHzbPADeer3Mc2Y9CA/POIp4bnjYWybUCJmm46FZto9bIb
         5NLS3tU3+YzlAWN6A4APMViHFSq2sFbzoHOcJx2HA3ejuJuzS0pkoWeBtkvhsnmqYS
         rdZBIx4C/bYEQu/yjzFJ5eB04fG/gc1WElSgI/nU=
Date:   Tue, 06 Jul 2021 12:09:22 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, jack@suse.cz,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 dax-fix-enomem-handling-in-grab_mapping_entry.patch removed from -mm tree
Message-ID: <20210706190922.vF3cms7eb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix ENOMEM handling in grab_mapping_entry()
has been removed from the -mm tree.  Its filename was
     dax-fix-enomem-handling-in-grab_mapping_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: dax: fix ENOMEM handling in grab_mapping_entry()

grab_mapping_entry() has a bug in handling of ENOMEM condition.  Suppose
we have a PMD entry at index i which we are downgrading to a PTE entry. 
grab_mapping_entry() will set pmd_downgrade to true, lock the entry, clear
the entry in xarray, and decrement mapping->nrpages.  The it will call:

	entry = dax_make_entry(pfn_to_pfn_t(0), flags);
	dax_lock_entry(xas, entry);

which inserts new PTE entry into xarray.  However this may fail allocating
the new node.  We handle this by:

	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
		goto retry;

however pmd_downgrade stays set to true even though 'entry' returned from
get_unlocked_entry() will be NULL now.  And we will go again through the
downgrade branch.  This is mostly harmless except that mapping->nrpages is
decremented again and we temporarily have an invalid entry stored in
xarray.  Fix the problem by setting pmd_downgrade to false each time we
lookup the entry we work with so that it matches the entry we found.

Link: https://lkml.kernel.org/r/20210622160015.18004-1-jack@suse.cz
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/dax.c~dax-fix-enomem-handling-in-grab_mapping_entry
+++ a/fs/dax.c
@@ -488,10 +488,11 @@ static void *grab_mapping_entry(struct x
 		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
-	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
+	bool pmd_downgrade;	/* splitting PMD entry into PTE entries? */
 	void *entry;
 
 retry:
+	pmd_downgrade = false;
 	xas_lock_irq(xas);
 	entry = get_unlocked_entry(xas, order);
 
_

Patches currently in -mm which might be from jack@suse.cz are


