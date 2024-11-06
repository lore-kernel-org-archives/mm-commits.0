Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7C1465B8
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854740; cv=none; b=CPDwWOaXWk/AVjDOjhmv/PUb9tj74nw+I/6V7JoIvwwEv1hV287VoF2Q6d8OP/i046udyqz+jwDMRTP4g1XjaZ8gG7636426PLgBWjWW8YaAhAb391v2a19PsGCUzSW59KRHhG2K2NYipSfSmop1fry4ohGO+1l8ytciihbEemI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854740; c=relaxed/simple;
	bh=IIDUAPn+P/dOFu0T1ZvDseclD98fnn0vEokUM9k1qMQ=;
	h=Date:To:From:Subject:Message-Id; b=ZAqqL9LgYPmdW5N1MZ3SnXykORhVOnLFbyQ69KJbzxxpqaQMtMusRqLitzK4nCQZexvAzSrEdDDGR6/sujzUgMUjbN4udl2NfTBme4V4rSkIJ04q/aCDiHt2IoPyHiU1nJyxZ1pq1qB3dhWXiCvG/93ZFCQCGQrZQrfhrqMlCvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=igsxIuAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="igsxIuAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C780C4CECF;
	Wed,  6 Nov 2024 00:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854740;
	bh=IIDUAPn+P/dOFu0T1ZvDseclD98fnn0vEokUM9k1qMQ=;
	h=Date:To:From:Subject:From;
	b=igsxIuAmotSwEtreo/ALHYEAjXYXg5X2uX8suPSzz39o3L31V+dnF7xs2H6R/XVxK
	 /WQ/uR7zStuhRizek8P11InQ+leT+CI9OJbjfIsm4nKZ0LRMVj1EU7ncIOwVmrMJnF
	 IxSW6wSWBu4+O31IzoRpDdGE7rSn5Z/xRicA7p7U=
Date: Tue, 05 Nov 2024 16:59:00 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,david@redhat.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch removed from -mm tree
Message-Id: <20241106005900.9C780C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate LRU_REFS_MASK bits in folio_migrate_flags
has been removed from the -mm tree.  Its filename was
     mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: migrate LRU_REFS_MASK bits in folio_migrate_flags
Date: Thu, 26 Sep 2024 13:06:47 +0800

Bits of LRU_REFS_MASK are not inherited during migration which lead to new
folio start from tier0 when MGLRU enabled.  Try to bring as much bits of
folio->flags as possible since compaction and alloc_contig_range which
introduce migration do happen at times.

Link: https://lkml.kernel.org/r/20240926050647.5653-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   10 ++++++++++
 mm/migrate.c              |    1 +
 2 files changed, 11 insertions(+)

--- a/include/linux/mm_inline.h~mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags
+++ a/include/linux/mm_inline.h
@@ -291,6 +291,12 @@ static inline bool lru_gen_del_folio(str
 	return true;
 }
 
+static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+{
+	unsigned long refs = READ_ONCE(old->flags) & LRU_REFS_MASK;
+
+	set_mask_bits(&new->flags, LRU_REFS_MASK, refs);
+}
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -313,6 +319,10 @@ static inline bool lru_gen_del_folio(str
 	return false;
 }
 
+static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+{
+
+}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
--- a/mm/migrate.c~mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags
+++ a/mm/migrate.c
@@ -695,6 +695,7 @@ void folio_migrate_flags(struct folio *n
 	if (folio_test_idle(folio))
 		folio_set_idle(newfolio);
 
+	folio_migrate_refs(newfolio, folio);
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-optimization-on-page-allocation-when-cma-enabled.patch

