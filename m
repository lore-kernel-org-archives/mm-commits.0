Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A6A1C1F05
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274544; cv=none; b=FKaXuktNXIprhCvDz1XLyIel2i5NBVnFXrkbEBrwtld/e83AzZ0xeBUXRPNmdtBXqlF1Z/+2w8WVJl9Z53pmzNRi6GqQhB8x7jajyxpuEjqntHPMLmD/UuaQmiV/semTAgmKtkerdL6QS1MbGV2Uqhct/jNOvN1civahnCORxlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274544; c=relaxed/simple;
	bh=XGyPXaUiIdN3m673DufQlZjigjLPXVcQGdFA4OZSnYA=;
	h=Date:To:From:Subject:Message-Id; b=YevOewKOttMXE+pF3RdXopej8BZu8QST4/GwE/tQg/fg3A5aXXZVT8w2JvAhKqk7R+Sbx9p438SQsozP61UqqkBd/04wHJog+q9gHNs3Bgc5xnXBKik6Wg6UDiqU3rrydtMW0+oFChGL1kTe/bhM2VtGfNZq3j9ZSFZlKOZrKUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n8hWQLCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n8hWQLCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4E8C4CEDD;
	Tue, 18 Mar 2025 05:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274544;
	bh=XGyPXaUiIdN3m673DufQlZjigjLPXVcQGdFA4OZSnYA=;
	h=Date:To:From:Subject:From;
	b=n8hWQLCDrU2fhl48A4Yd3K/ih2DqE5/iPgrIoujiYh+QI5JKqiDKV1Xv1cVrsDpoj
	 o8woR6FOPdi+EDRgQQeFEv4JsY+69IzQ9QhbNobDumx2Wky7v48TBCEuyfycFGOJFM
	 pA6ILRv6vieTRCoTL3kasBTSQMaU145skRNE8Ai0=
Date: Mon, 17 Mar 2025 22:09:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch removed from -mm tree
Message-Id: <20250318050904.9A4E8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Copy-on-Write (COW) reuse support for PTE-mapped THP
has been removed from the -mm tree.  Its filename was
     mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: Copy-on-Write (COW) reuse support for PTE-mapped THP
Date: Mon, 3 Mar 2025 17:30:06 +0100

Currently, we never end up reusing PTE-mapped THPs after fork.  This
wasn't really a problem with PMD-sized THPs, because they would have to be
PTE-mapped first, but it's getting a problem with smaller THP sizes that
are effectively always PTE-mapped.

With our new "mapped exclusively" vs "maybe mapped shared" logic for large
folios, implementing CoW reuse for PTE-mapped THPs is straight forward: if
exclusively mapped, make sure that all references are from these (our)
mappings.  Add some helpful comments to explain the details.

CONFIG_TRANSPARENT_HUGEPAGE selects CONFIG_MM_ID.  If we spot an anon
large folio without CONFIG_TRANSPARENT_HUGEPAGE in that code, something is
seriously messed up.

There are plenty of things we can optimize in the future: For example, we
could remember that the folio is fully exclusive so we could speedup the
next fault further.  Also, we could try "faulting around", turning
surrounding PTEs that map the same folio writable.  But especially the
latter might increase COW latency, so it would need further investigation.

Link: https://lkml.kernel.org/r/20250303163014.1128035-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   83 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 75 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp
+++ a/mm/memory.c
@@ -3727,19 +3727,86 @@ static vm_fault_t wp_page_shared(struct
 	return ret;
 }
 
-static bool wp_can_reuse_anon_folio(struct folio *folio,
-				    struct vm_area_struct *vma)
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
+		struct vm_area_struct *vma)
 {
+	bool exclusive = false;
+
+	/* Let's just free up a large folio if only a single page is mapped. */
+	if (folio_large_mapcount(folio) <= 1)
+		return false;
+
 	/*
-	 * We could currently only reuse a subpage of a large folio if no
-	 * other subpages of the large folios are still mapped. However,
-	 * let's just consistently not reuse subpages even if we could
-	 * reuse in that scenario, and give back a large folio a bit
-	 * sooner.
+	 * The assumption for anonymous folios is that each page can only get
+	 * mapped once into each MM. The only exception are KSM folios, which
+	 * are always small.
+	 *
+	 * Each taken mapcount must be paired with exactly one taken reference,
+	 * whereby the refcount must be incremented before the mapcount when
+	 * mapping a page, and the refcount must be decremented after the
+	 * mapcount when unmapping a page.
+	 *
+	 * If all folio references are from mappings, and all mappings are in
+	 * the page tables of this MM, then this folio is exclusive to this MM.
 	 */
-	if (folio_test_large(folio))
+	if (folio_test_large_maybe_mapped_shared(folio))
 		return false;
 
+	VM_WARN_ON_ONCE(folio_test_ksm(folio));
+	VM_WARN_ON_ONCE(folio_mapcount(folio) > folio_nr_pages(folio));
+	VM_WARN_ON_ONCE(folio_entire_mapcount(folio));
+
+	if (unlikely(folio_test_swapcache(folio))) {
+		/*
+		 * Note: freeing up the swapcache will fail if some PTEs are
+		 * still swap entries.
+		 */
+		if (!folio_trylock(folio))
+			return false;
+		folio_free_swap(folio);
+		folio_unlock(folio);
+	}
+
+	if (folio_large_mapcount(folio) != folio_ref_count(folio))
+		return false;
+
+	/* Stabilize the mapcount vs. refcount and recheck. */
+	folio_lock_large_mapcount(folio);
+	VM_WARN_ON_ONCE(folio_large_mapcount(folio) < folio_ref_count(folio));
+
+	if (folio_test_large_maybe_mapped_shared(folio))
+		goto unlock;
+	if (folio_large_mapcount(folio) != folio_ref_count(folio))
+		goto unlock;
+
+	VM_WARN_ON_ONCE(folio_mm_id(folio, 0) != vma->vm_mm->mm_id &&
+			folio_mm_id(folio, 1) != vma->vm_mm->mm_id);
+
+	/*
+	 * Do we need the folio lock? Likely not. If there would have been
+	 * references from page migration/swapout, we would have detected
+	 * an additional folio reference and never ended up here.
+	 */
+	exclusive = true;
+unlock:
+	folio_unlock_large_mapcount(folio);
+	return exclusive;
+}
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
+static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
+		struct vm_area_struct *vma)
+{
+	BUILD_BUG();
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+static bool wp_can_reuse_anon_folio(struct folio *folio,
+				    struct vm_area_struct *vma)
+{
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
+		return __wp_can_reuse_large_anon_folio(folio, vma);
+
 	/*
 	 * We have to verify under folio lock: these early checks are
 	 * just an optimization to avoid locking the folio and freeing
_

Patches currently in -mm which might be from david@redhat.com are


