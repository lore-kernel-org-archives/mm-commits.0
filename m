Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E09B1A01C6
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071104; cv=none; b=EYwQyL899pY6B9Gcn6ph+vt3mrH3r+pCuvnUxYJqBz7u3IpYuNhHSgv2+yezXvXrU32DMP4gqjVhaZO/Ze7CJxKCfPG5N/DQoPRpHee7h+4u3GlRbVX8MvNpYc6ro6YB4BlDkv8W1vk9l95k+eRCpQlH5IrSJw1VbKLS7xL59ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071104; c=relaxed/simple;
	bh=L8vQ7rY5NamDbww27UivcJhV46EtKogupxeXPQn1wx8=;
	h=Date:To:From:Subject:Message-Id; b=tGALWCxgiqy+GIXUK76hVA8bTdgSVzlR5a+mNqyRY79MdDN+8E1DNah+ih3MdbncAIUyONiWFSiSQUtLYXTlmOl+yiYpB7LibNAbxr4a7dw0Po6gwe8ZkQsSrTLYn+JiactT1hP8v/oPddh9UpvrhUV6l6Vp2RJK/fsksiRVm74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yYPJVg26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yYPJVg26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2791BC4AF10;
	Thu,  4 Jul 2024 05:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720071104;
	bh=L8vQ7rY5NamDbww27UivcJhV46EtKogupxeXPQn1wx8=;
	h=Date:To:From:Subject:From;
	b=yYPJVg26RAqZCI7qws1Ntn+JZEuDJUeDa08y3xQYOphhngwih43miuFAOOp1YGhO3
	 oAngJiRe+V/RDzKSyz9JGicgr/PjTpK1kjdWKXMsmrVXZQCCQJHgo+O+ckQAo/vYTq
	 4JqlGsLSiGA4SPYTfZtUQhbwbhh8p+a22leVDrCA=
Date: Wed, 03 Jul 2024 22:31:43 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,lkp@intel.com,kraxel@redhat.com,jgg@nvidia.com,hch@lst.de,david@redhat.com,airlied@redhat.com,shy828301@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-stop-abusing-try_grab_folio-fix.patch removed from -mm tree
Message-Id: <20240704053144.2791BC4AF10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-stop-abusing-try_grab_folio-fix.patch

This patch was dropped because it was folded into mm-gup-stop-abusing-try_grab_folio.patch

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
Date: Fri, 28 Jun 2024 18:58:14 -0700

fix implicit declaration of function try_grab_folio_fast

Link: https://lkml.kernel.org/r/CAHbLzkowMSso-4Nufc9hcMehQsK9PNz3OSu-+eniU-2Mm-xjhA@mail.gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406290729.21FzkVlI-lkp@intel.com/
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@lst.de> (v6)
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  192 ++++++++++++++++++++++++++---------------------------
 1 file changed, 96 insertions(+), 96 deletions(-)

--- a/mm/gup.c~mm-gup-stop-abusing-try_grab_folio-fix
+++ a/mm/gup.c
@@ -427,6 +427,102 @@ static int record_subpages(struct page *
 
 	return nr;
 }
+
+/**
+ * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
+ * @page:  pointer to page to be grabbed
+ * @refs:  the value to (effectively) add to the folio's refcount
+ * @flags: gup flags: these are the FOLL_* flag values.
+ *
+ * "grab" names in this file mean, "look at flags to decide whether to use
+ * FOLL_PIN or FOLL_GET behavior, when incrementing the folio's refcount.
+ *
+ * Either FOLL_PIN or FOLL_GET (or neither) must be set, but not both at the
+ * same time. (That's true throughout the get_user_pages*() and
+ * pin_user_pages*() APIs.) Cases:
+ *
+ *    FOLL_GET: folio's refcount will be incremented by @refs.
+ *
+ *    FOLL_PIN on large folios: folio's refcount will be incremented by
+ *    @refs, and its pincount will be incremented by @refs.
+ *
+ *    FOLL_PIN on single-page folios: folio's refcount will be incremented by
+ *    @refs * GUP_PIN_COUNTING_BIAS.
+ *
+ * Return: The folio containing @page (with refcount appropriately
+ * incremented) for success, or NULL upon failure. If neither FOLL_GET
+ * nor FOLL_PIN was set, that's considered failure, and furthermore,
+ * a likely bug in the caller, so a warning is also emitted.
+ *
+ * It uses add ref unless zero to elevate the folio refcount and must be called
+ * in fast path only.
+ */
+static struct folio *try_grab_folio_fast(struct page *page, int refs,
+					 unsigned int flags)
+{
+	struct folio *folio;
+
+	/* Raise warn if it is not called in fast GUP */
+	VM_WARN_ON_ONCE(!irqs_disabled());
+
+	if (WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == 0))
+		return NULL;
+
+	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
+		return NULL;
+
+	if (flags & FOLL_GET)
+		return try_get_folio(page, refs);
+
+	/* FOLL_PIN is set */
+
+	/*
+	 * Don't take a pin on the zero page - it's not going anywhere
+	 * and it is used in a *lot* of places.
+	 */
+	if (is_zero_page(page))
+		return page_folio(page);
+
+	folio = try_get_folio(page, refs);
+	if (!folio)
+		return NULL;
+
+	/*
+	 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
+	 * right zone, so fail and let the caller fall back to the slow
+	 * path.
+	 */
+	if (unlikely((flags & FOLL_LONGTERM) &&
+		     !folio_is_longterm_pinnable(folio))) {
+		if (!put_devmap_managed_folio_refs(folio, refs))
+			folio_put_refs(folio, refs);
+		return NULL;
+	}
+
+	/*
+	 * When pinning a large folio, use an exact count to track it.
+	 *
+	 * However, be sure to *also* increment the normal folio
+	 * refcount field at least once, so that the folio really
+	 * is pinned.  That's why the refcount from the earlier
+	 * try_get_folio() is left intact.
+	 */
+	if (folio_test_large(folio))
+		atomic_add(refs, &folio->_pincount);
+	else
+		folio_ref_add(folio,
+				refs * (GUP_PIN_COUNTING_BIAS - 1));
+	/*
+	 * Adjust the pincount before re-checking the PTE for changes.
+	 * This is essentially a smp_mb() and is paired with a memory
+	 * barrier in folio_try_share_anon_rmap_*().
+	 */
+	smp_mb__after_atomic();
+
+	node_stat_mod_folio(folio, NR_FOLL_PIN_ACQUIRED, refs);
+
+	return folio;
+}
 #endif	/* CONFIG_ARCH_HAS_HUGEPD || CONFIG_HAVE_GUP_FAST */
 
 #ifdef CONFIG_ARCH_HAS_HUGEPD
@@ -2715,102 +2811,6 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * This code is based heavily on the PowerPC implementation by Nick Piggin.
  */
 #ifdef CONFIG_HAVE_GUP_FAST
-/**
- * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
- * @page:  pointer to page to be grabbed
- * @refs:  the value to (effectively) add to the folio's refcount
- * @flags: gup flags: these are the FOLL_* flag values.
- *
- * "grab" names in this file mean, "look at flags to decide whether to use
- * FOLL_PIN or FOLL_GET behavior, when incrementing the folio's refcount.
- *
- * Either FOLL_PIN or FOLL_GET (or neither) must be set, but not both at the
- * same time. (That's true throughout the get_user_pages*() and
- * pin_user_pages*() APIs.) Cases:
- *
- *    FOLL_GET: folio's refcount will be incremented by @refs.
- *
- *    FOLL_PIN on large folios: folio's refcount will be incremented by
- *    @refs, and its pincount will be incremented by @refs.
- *
- *    FOLL_PIN on single-page folios: folio's refcount will be incremented by
- *    @refs * GUP_PIN_COUNTING_BIAS.
- *
- * Return: The folio containing @page (with refcount appropriately
- * incremented) for success, or NULL upon failure. If neither FOLL_GET
- * nor FOLL_PIN was set, that's considered failure, and furthermore,
- * a likely bug in the caller, so a warning is also emitted.
- *
- * It uses add ref unless zero to elevate the folio refcount and must be called
- * in fast path only.
- */
-static struct folio *try_grab_folio_fast(struct page *page, int refs,
-					 unsigned int flags)
-{
-	struct folio *folio;
-
-	/* Raise warn if it is not called in fast GUP */
-	VM_WARN_ON_ONCE(!irqs_disabled());
-
-	if (WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == 0))
-		return NULL;
-
-	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
-		return NULL;
-
-	if (flags & FOLL_GET)
-		return try_get_folio(page, refs);
-
-	/* FOLL_PIN is set */
-
-	/*
-	 * Don't take a pin on the zero page - it's not going anywhere
-	 * and it is used in a *lot* of places.
-	 */
-	if (is_zero_page(page))
-		return page_folio(page);
-
-	folio = try_get_folio(page, refs);
-	if (!folio)
-		return NULL;
-
-	/*
-	 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
-	 * right zone, so fail and let the caller fall back to the slow
-	 * path.
-	 */
-	if (unlikely((flags & FOLL_LONGTERM) &&
-		     !folio_is_longterm_pinnable(folio))) {
-		if (!put_devmap_managed_folio_refs(folio, refs))
-			folio_put_refs(folio, refs);
-		return NULL;
-	}
-
-	/*
-	 * When pinning a large folio, use an exact count to track it.
-	 *
-	 * However, be sure to *also* increment the normal folio
-	 * refcount field at least once, so that the folio really
-	 * is pinned.  That's why the refcount from the earlier
-	 * try_get_folio() is left intact.
-	 */
-	if (folio_test_large(folio))
-		atomic_add(refs, &folio->_pincount);
-	else
-		folio_ref_add(folio,
-				refs * (GUP_PIN_COUNTING_BIAS - 1));
-	/*
-	 * Adjust the pincount before re-checking the PTE for changes.
-	 * This is essentially a smp_mb() and is paired with a memory
-	 * barrier in folio_try_share_anon_rmap_*().
-	 */
-	smp_mb__after_atomic();
-
-	node_stat_mod_folio(folio, NR_FOLL_PIN_ACQUIRED, refs);
-
-	return folio;
-}
-
 /*
  * Used in the GUP-fast path to determine whether GUP is permitted to work on
  * a specific folio.
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-gup-stop-abusing-try_grab_folio.patch

