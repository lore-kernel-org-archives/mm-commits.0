Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E59C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B93561A1D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhF2Chd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231805AbhF2Chc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1678661A1D;
        Tue, 29 Jun 2021 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934105;
        bh=dc9u2zMjO0eTHghh8btbujdaSiOGNJ1liWXelQc8B9Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h0Im7+dlglw6z1mqp7ydbCEb5B0rqKAMHBa+QWiArtrtuLkI3G2zHatLgBfjc5lTG
         a8grNNP91r5ZdSzGiP0X1OzccnHGZqqGDwzE4j6Rvykmj8YMSsmg/sjyQSgKpUShLd
         6lDAoRkSXlhjq611phgdi5S2Dal36fWgf9YzCvx8=
Date:   Mon, 28 Jun 2021 19:35:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        dan.j.williams@intel.com, jack@suse.cz, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 034/192] dax: fix ENOMEM handling in
 grab_mapping_entry()
Message-ID: <20210629023504.arpzMvPnv%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
