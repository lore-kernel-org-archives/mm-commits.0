Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED122690D1
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 21:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749589911; cv=none; b=JEpq36yiFgth3Z3e+1OCXp7OuYrBbDze6yhCKw7dt54gBcVua40Qmoe+tD6qdqwk+hurc4geb31e/eWKFX5XoAu9qR2DsINiq5p1PxxhXMc9Y9hXevvag1ltn5uNqgqpUiwynk+A+vH/9LzXajx/ZTKSOUo4VxW6KroON3v/ogY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749589911; c=relaxed/simple;
	bh=Kn3jg+nlzams5YX7qDVcL8kiZicyd3cBN5V8jgy3bW8=;
	h=Date:To:From:Subject:Message-Id; b=N7aArgkCi/BuhKaiYDhOWuHYqB+W/YRehQlZm3shpuTqNJCMa3kQ3BYuQm8ys4Bozv+e+3d4i0H9GHCcRkJK4vxEkvwnHm/sx3S5roK14+meCCnUWKTrP4QM7bU2BL5SeWxAj9Ei08FeyoRaJEI26wCafsFxU203gT2oncaAy8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SI+2Dh1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SI+2Dh1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE65CC4CEED;
	Tue, 10 Jun 2025 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749589910;
	bh=Kn3jg+nlzams5YX7qDVcL8kiZicyd3cBN5V8jgy3bW8=;
	h=Date:To:From:Subject:From;
	b=SI+2Dh1QyUMF6WkzsEpyAawcA9KTRQMcnHWJxoik6QJD/nU26zEhexRmJcfb5AEiJ
	 nwyH1PNAiUvKRMnupswg7h9tDTUZl8zyNMPivNgUo/jrKPWJeuhdm9YkhvXkEQExo2
	 FcfHhw1R10hO2gWCaQnic9uzv1pzCYsrTYSvVtqI=
Date: Tue, 10 Jun 2025 14:11:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch added to mm-unstable branch
Message-Id: <20250610211150.CE65CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: add a BUG_ON() to ensure caller is not sibling
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: xarray: add a BUG_ON() to ensure caller is not sibling
Date: Wed, 4 Jun 2025 09:45:33 +0530

Suppose xas is pointing somewhere near the end of the multi-entry batch. 
Then it may happen that the computed slot already falls beyond the batch,
thus breaking the loop due to !xa_is_sibling(), and computing the wrong
order.

For example, suppose we have a shift-6 node having an order-9 entry => 8 -
1 = 7 siblings, so assume the slots are at offset 0 till 7 in this node. 
If xas->xa_offset is 6, then the code will compute order as 1 +
xas->xa_node->shift = 7.  Therefore, the order computation must start from
the beginning of the multi-slot entries, that is, the non-sibling entry.

Thus ensure that the caller is aware of this by triggering a BUG when the
entry is a sibling entry.  Note that this BUG_ON() is only active while
running selftests, so there is no overhead in a running kernel.

Link: https://lkml.kernel.org/r/20250604041533.91198-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/xarray.c~xarray-add-a-bug_on-to-ensure-caller-is-not-sibling
+++ a/lib/xarray.c
@@ -1910,6 +1910,7 @@ EXPORT_SYMBOL(xa_store_range);
  * @xas: XArray operation state.
  *
  * Called after xas_load, the xas should not be in an error state.
+ * The xas should not be pointing to a sibling entry.
  *
  * Return: A number between 0 and 63 indicating the order of the entry.
  */
@@ -1920,6 +1921,8 @@ int xas_get_order(struct xa_state *xas)
 	if (!xas->xa_node)
 		return 0;
 
+	XA_NODE_BUG_ON(xas->xa_node, xa_is_sibling(xa_entry(xas->xa,
+		       xas->xa_node, xas->xa_offset)));
 	for (;;) {
 		unsigned int slot = xas->xa_offset + (1 << order);
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch

