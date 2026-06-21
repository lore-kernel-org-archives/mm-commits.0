Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666A325B0A6
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067096; cv=none; b=a/qoUEIj6y0+938VyJnCOw0p9bjd5OqMSSbp0ZFAzvr5FxcqZ8V1m3tPwQrIbX6UDSoqpJhOkoK7bNWRxX/Es6zUOcPCZqNBK1fhM79r70Veb5Vbp3U8A5bzQm82su7+9KPa3XIJ3YiTcvCQ5jOUL5b68UOJBU2ldBcKdLbS1rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067096; c=relaxed/simple;
	bh=8TG8VGHSr6jvc4jfZQOdF5jE4alNCGj9dwCCTFxH3wE=;
	h=Date:To:From:Subject:Message-Id; b=TJib+ptRM8AMZPB/fp1ShzEsyWCArouC9iAqAjQtqbH4zHLC6oxUYESm0qEPdaCc4IsALK1Cxg7yK7363hVck4LlCxBqUwAXxmWpFUoxIKob2suBsEmS5EtndIC6XLhTai7xtl87Cm1hhWg4zL8EismP47uJpLx+MzfXSO0yDUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uMGcWdsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uMGcWdsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4174A1F000E9;
	Sun, 21 Jun 2026 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067095;
	bh=5iv2MArzgQ81iHFAdm71RT3Iyn5lQhwaKURz2Z9cJ3E=;
	h=Date:To:From:Subject;
	b=uMGcWdsdWc3XlVDR9lzdLoQFeV0+rExBA0zf3KxAOfh58vhk187Uq/2QuuEJJeChE
	 s1UO9FP2Isy0SYC2+dBeu+pDA0N47NDMKMoeN51+e2CkXQK6aedYrwSJDvcER5iGbD
	 vrYuEn58GaakqCn5UMsv/O91h5mWZ+mDTfM3Sm5k=
Date: Sun, 21 Jun 2026 11:38:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-read_only_thp_for_fs-check.patch removed from -mm tree
Message-Id: <20260621183815.4174A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-read_only_thp_for_fs-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Sun, 17 May 2026 09:54:03 -0400

Patch series "Remove CONFIG_READ_ONLY_THP_FOR_FS and enable file THP for
writable files", v6.


This patch (of 14):

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. 
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_folio_support() for FSes supporting
large folio with at least PMD_ORDER.

Link: https://lore.kernel.org/20260517135416.1434539-1-ziy@nvidia.com
Link: https://lore.kernel.org/20260517135416.1434539-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   27 +++++++++++++++++++++++++++
 mm/khugepaged.c         |   10 ++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check
+++ a/include/linux/pagemap.h
@@ -513,6 +513,33 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+/**
+ * mapping_pmd_folio_support() - Check if a mapping supports PMD-sized folio
+ * @mapping: The address_space
+ *
+ * While some mappings support large folios, they might not support PMD-sized
+ * folios. This function checks whether a mapping supports PMD-sized folios.
+ * For example, khugepaged needs this information before attempting to
+ * collapsing THPs.
+ *
+ * Return: True if PMD-sized folios are supported, otherwise false.
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_min_folio_order(mapping) <= PMD_ORDER &&
+	       mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+#else
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	return false;
+}
+#endif
+
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 {
--- a/mm/khugepaged.c~mm-khugepaged-remove-read_only_thp_for_fs-check
+++ a/mm/khugepaged.c
@@ -2246,8 +2246,14 @@ static enum scan_result collapse_file(st
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/*
+	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
+	 *
+	 * TODO: once shmem always calls mapping_set_large_folios() on its
+	 * mapping, the shmem check can be removed.
+	 */
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
_

Patches currently in -mm which might be from ziy@nvidia.com are


