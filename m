Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9A1284B3F
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126249; cv=none; b=uagOqH7gViQe1mI9clmSHLOwNzhl/h+IfVwA2HlAE2KZiid0Y99lPMJfJboSpXrIJnF744/uc1hak/gPaGOYKKE5SfXTB4YC3O0f2YAK+iowGJmXJe0ifvwvAV4RMNO0Fl0MqM0smBGMPRTlaEE1gpMLLTz2Eu2y1pjLBN65QJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126249; c=relaxed/simple;
	bh=FM3c51XN1m39dMGwuH1kd0tNqOpNmMtufViODEGGv/k=;
	h=Date:To:From:Subject:Message-Id; b=DlIvY6sjZJBmcIokJFIu8RqIgfqVsfWdnaS8j3SYAZPHyqUyJiHcoFByCqOWKBYOTWOBNTWAVRSQfX+AGMABVmQKZE9JfA5cfeafqZz5o9UbxFXCgkttUHhaew4F2S9pcEnZdKgLiy5tHKgOfPGGrg9JWAYgMm+u2gZ0DuLXnCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TxkWVaR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TxkWVaR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3462C4CEE3;
	Thu, 10 Jul 2025 05:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126249;
	bh=FM3c51XN1m39dMGwuH1kd0tNqOpNmMtufViODEGGv/k=;
	h=Date:To:From:Subject:From;
	b=TxkWVaR/Fxbyg36zpybERv5DL5sRIeuJpEYSxD0LB+LZB9Mc1mQbEnCGD17co22ql
	 PfuvT41u0MIlI8Vp0V9bAeIVG8w1kYnThPIGACPxqsMt/Cp/qVf/Z8G6ielUHUZ2Mo
	 sEBoGxLvp9qlupq6A/Y6KxoChWuTOTzjWazEkKAE=
Date: Wed, 09 Jul 2025 22:44:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch removed from -mm tree
Message-Id: <20250710054409.B3462C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: add a BUG_ON() to ensure caller is not sibling
has been removed from the -mm tree.  Its filename was
     xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple-tree-add-some-comments.patch
khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch
khugepaged-generalize-alloc_charge_folio.patch

