Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534BF12EBE7
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118676; cv=none; b=ICgh0fvLmsHlVoBn5m+w3IcVXciqn9h+La5Mgde26SXQcOc8R84TlZDVTECMB0bZUplooGSdTgi+TAjrPqxNkWbl1l9CaqTONFWhANbADANcqHmCj1SjqQ15kMkWZdY3y7OLXgf7Qyv/xPaCBpkN4u6IS7LHToyfQX67JQKzcN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118676; c=relaxed/simple;
	bh=Pad6w4GVYN92dLR9ZVmc73oNgAeHlKSanNdtzRDs36M=;
	h=Date:To:From:Subject:Message-Id; b=h5znJhBqRs6xpjsNMtMPzdpCq4RmWAyEtKvqG5FXwWVoZj/Kt0oJTcig9ieCgk5GqEiTfv1BB1nhDhvTndfX9C7/tmDkoddklcLWp4V7upD95f8Tr2DHCuLgddltYEq1GTY6ZL8Yr4ZppJZ7wmrE7GrQsSUFkTdI8TKx68TVnl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Is2mqNTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Is2mqNTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12C7C4CEED;
	Tue, 13 May 2025 06:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118674;
	bh=Pad6w4GVYN92dLR9ZVmc73oNgAeHlKSanNdtzRDs36M=;
	h=Date:To:From:Subject:From;
	b=Is2mqNTmvSqhedL7TOm5juV2PUkEgwH445OJzlonArM8A2qBFwf6B9qbXAX/5NV+J
	 MCAqBc+OZSnq9SUqW2Aaq4jlcHXqp8nY1a6PWZ5VC+wHQzWhbhBgZYSEshhgPUUTol
	 uXKJpZtOLkpcZouWMC8B/ZYuBgMsWNkhQmiK7KvU=
Date: Mon, 12 May 2025 23:44:34 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,kasong@tencent.com,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch removed from -mm tree
Message-Id: <20250513064434.B12C7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap-do-not-use-folio_contains-for-swap-cache-folios-fix
has been removed from the -mm tree.  Its filename was
     filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch

This patch was dropped because it was folded into filemap-do-not-use-folio_contains-for-swap-cache-folios.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: filemap-do-not-use-folio_contains-for-swap-cache-folios-fix
Date: Wed Apr 30 02:03:35 PM PDT 2025

s/VM_WARN_ON_FOLIO/VM_WARN_ON_ONCE_FOLIO/, per Kairui

Cc: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pagemap.h~filemap-do-not-use-folio_contains-for-swap-cache-folios-fix
+++ a/include/linux/pagemap.h
@@ -941,7 +941,7 @@ static inline struct page *folio_file_pa
  */
 static inline bool folio_contains(struct folio *folio, pgoff_t index)
 {
-	VM_WARN_ON_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	return index - folio->index < folio_nr_pages(folio);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

filemap-do-not-use-folio_contains-for-swap-cache-folios.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

