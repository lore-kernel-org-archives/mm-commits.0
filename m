Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF733C4743C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1389613AB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFWEcL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhFWEcL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 00:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A485761374;
        Wed, 23 Jun 2021 04:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624422593;
        bh=iPXz4MgiDnPCdTphI2YH95T3patUg9x4/o4Sc2SOPVw=;
        h=Date:From:To:Subject:From;
        b=NGmDYmmtAHFehic9nuMUqwGDPdCnzqa6lwNjiYjt3pIxtmcYAuoaAn0xf70HiiHNX
         s7t3s0kbuYnkRsyD5DwG1OU3iP39RXq7NFrb+sp32fi0kQYaLNT0BIOc95k+ktLoxW
         XOr8bgDjNFDTd8Tf2D71oAQvkxriVpAjYrx0Eve4=
Date:   Tue, 22 Jun 2021 21:29:53 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, jack@suse.cz,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + dax-fix-enomem-handling-in-grab_mapping_entry.patch
 added to -mm tree
Message-ID: <20210623042953.YzHJhE5fU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix ENOMEM handling in grab_mapping_entry()
has been added to the -mm tree.  Its filename is
     dax-fix-enomem-handling-in-grab_mapping_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dax-fix-enomem-handling-in-grab_mapping_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-enomem-handling-in-grab_mapping_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
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

dax-fix-enomem-handling-in-grab_mapping_entry.patch
mm-fix-comments-mentioning-i_mutex.patch

