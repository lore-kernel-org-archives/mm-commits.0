Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9BE40855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917835; cv=none; b=n0Iv6MSGzElD5hnArPcOhhFe8MW2b9sIFcVzAXMi3NpT9ypEXYhEKgZHo3DRuP+zDMYbIopJhPZAnznyQWN239bBdBjoLXMhJKAosNUYCOm8m+qg9kclSBm1SSPYxxSyJp62YLjdqtXi9mxgWz3EKUSsLpKO5H715LDuGRaDCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917835; c=relaxed/simple;
	bh=+2hPejmzBTyGr23v73UorZDAqVBCHEaanWz7yp2PTtc=;
	h=Date:To:From:Subject:Message-Id; b=EDE3qpgMyWT4rKWhd9vBpTlG2DuCgSlczjILyMZhIjWp3FssXJ1Kkmy/OPuqlfi/1QZ2Z36Kx3RAM8NZNBx+1FdqkVJd0aZQkMNwfnno0ry+DpgvVNuNXLF1Lik6u2Hypr3yjTyhcyon66Sp3MT/qTB26yn9Rc8yF7NnRPC9U8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F2h5OLHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F2h5OLHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81524C4CEF7;
	Tue, 31 Mar 2026 00:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917835;
	bh=+2hPejmzBTyGr23v73UorZDAqVBCHEaanWz7yp2PTtc=;
	h=Date:To:From:Subject:From;
	b=F2h5OLHEkQv5GaU31S0aXe4Amc+U+j3QtHa1n3V/kwJd/RJZEuqIanqbOMf5KJ/il
	 qSiljfTxLZs4z33Ag/L9OT0NE0E+/TyF9KAGaTvVqG1QXkb1EvHGzymOV48ZkYy5pB
	 FZ3liIFGtIaxvgbuZl8nGKO+kaMiCqSApYoub0HY=
Date: Mon, 30 Mar 2026 17:43:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio.patch removed from -mm tree
Message-Id: <20260331004355.81524C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()
has been removed from the -mm tree.  Its filename was
     mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()
Date: Fri, 20 Mar 2026 18:07:28 +0000

Separate pmd_is_valid_softleaf() into separate components, then use the
pmd_is_valid_softleaf() predicate to implement pmd_to_softleaf_folio().

This returns the folio associated with a softleaf entry at PMD level. It
expects this to be valid for a PMD entry.

If CONFIG_DEBUG_VM is set, then assert on this being an invalid entry, and
either way return NULL in this case.

This lays the ground for further refactorings.

Link: https://lkml.kernel.org/r/b677592596274fa3fd701890497948e4b0e07cec.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leafops.h |   39 ++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

--- a/include/linux/leafops.h~mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio
+++ a/include/linux/leafops.h
@@ -607,7 +607,20 @@ static inline bool pmd_is_migration_entr
 }
 
 /**
- * pmd_is_valid_softleaf() - Is this PMD entry a valid leaf entry?
+ * softleaf_is_valid_pmd_entry() - Is the specified softleaf entry obtained from
+ * a PMD one that we support at PMD level?
+ * @entry: Entry to check.
+ * Returns: true if the softleaf entry is valid at PMD, otherwise false.
+ */
+static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
+{
+	/* Only device private, migration entries valid for PMD. */
+	return softleaf_is_device_private(entry) ||
+		softleaf_is_migration(entry);
+}
+
+/**
+ * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
  * @pmd: PMD entry.
  *
  * PMD leaf entries are valid only if they are device private or migration
@@ -620,9 +633,27 @@ static inline bool pmd_is_valid_softleaf
 {
 	const softleaf_t entry = softleaf_from_pmd(pmd);
 
-	/* Only device private, migration entries valid for PMD. */
-	return softleaf_is_device_private(entry) ||
-		softleaf_is_migration(entry);
+	return softleaf_is_valid_pmd_entry(entry);
+}
+
+/**
+ * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
+ * @pmd: PMD entry.
+ *
+ * The PMD entry is expected to be a valid PMD softleaf entry.
+ *
+ * Returns: the folio the softleaf entry references if this is a valid softleaf
+ * entry, otherwise NULL.
+ */
+static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
+{
+	const softleaf_t entry = softleaf_from_pmd(pmd);
+
+	if (!softleaf_is_valid_pmd_entry(entry)) {
+		VM_WARN_ON_ONCE(true);
+		return NULL;
+	}
+	return softleaf_to_folio(entry);
 }
 
 #endif  /* CONFIG_MMU */
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

