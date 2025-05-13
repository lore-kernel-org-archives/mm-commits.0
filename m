Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154B21EEA27
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119290; cv=none; b=ssGPNZ4e6a5iOOlR0ZXMUFaF5VraB+v/QruGNuQgo6pzpAhwyEHcrPhIdN+GlX5jUgH45+hGVeeR3dyXID8NW6am8AH/0GIJ+/WxdKITycqf8sjFIQTBd+/F1lBsBv9V+YJTliIz458b6nUlea9O+zsMJF3ynsaNlY9kp/pSEdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119290; c=relaxed/simple;
	bh=k0mDSchXUlylJC9rGBoYCrNZptPSweAdQMfnfKEzGsg=;
	h=Date:To:From:Subject:Message-Id; b=hjQIIgv25SYbh4/YxOdguxry29gcwC7hWiulJnnsTcLPffEnMTjZpSMQTJ9fToMKbp4C3n+ycTHjWnBUJnSky3mTLuQjdojuZakhoHv31ue6l82BiJArAnzno4herCoWxLYd4IBqQ8MVeo1a7z45bavb9c42SqCD8heS1g453cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qMXjOjeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qMXjOjeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D994FC4CEE4;
	Tue, 13 May 2025 06:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119289;
	bh=k0mDSchXUlylJC9rGBoYCrNZptPSweAdQMfnfKEzGsg=;
	h=Date:To:From:Subject:From;
	b=qMXjOjeuGqo8L6ydumbLZcOgE86bjCk6cZM0YphmM7TjLUbOMDTckw8RJerXMQSro
	 jDYybhsE1EVRpcIEM+ef0IK7AdQF77GVHCzn6FGxXdAdqs0edN79VL9f8wf62/c1pr
	 d68A/hY6J69K5uw+577shS1GHUFsZ/zUr902T/VI=
Date: Mon, 12 May 2025 23:54:49 -0700
To: mm-commits@vger.kernel.org,mingzhe.yang@ly.com,david@redhat.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers.patch removed from -mm tree
Message-Id: <20250513065449.D994FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: inline folio_test_large_maybe_mapped_shared() into callers
has been removed from the -mm tree.  Its filename was
     mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/rmap: inline folio_test_large_maybe_mapped_shared() into callers
Date: Thu, 24 Apr 2025 23:56:06 +0800

To prevent the function from being used when CONFIG_MM_ID is disabled, we
intend to inline it into its few callers, which also would help maintain
the expected code placement.

Link: https://lkml.kernel.org/r/20250424155606.57488-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    2 +-
 include/linux/page-flags.h |    4 ----
 include/linux/rmap.h       |    2 +-
 mm/memory.c                |    4 ++--
 4 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/include/linux/mm.h
@@ -2111,7 +2111,7 @@ static inline bool folio_maybe_mapped_sh
 	 */
 	if (mapcount <= 1)
 		return false;
-	return folio_test_large_maybe_mapped_shared(folio);
+	return test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids);
 }
 
 #ifndef HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
--- a/include/linux/page-flags.h~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/include/linux/page-flags.h
@@ -1230,10 +1230,6 @@ static inline int folio_has_private(cons
 	return !!(folio->flags & PAGE_FLAGS_PRIVATE);
 }
 
-static inline bool folio_test_large_maybe_mapped_shared(const struct folio *folio)
-{
-	return test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids);
-}
 #undef PF_ANY
 #undef PF_HEAD
 #undef PF_NO_TAIL
--- a/include/linux/rmap.h~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/include/linux/rmap.h
@@ -223,7 +223,7 @@ static inline void __folio_large_mapcoun
 	VM_WARN_ON_ONCE(folio_mm_id(folio, 1) != MM_ID_DUMMY &&
 			folio->_mm_id_mapcount[1] < 0);
 	VM_WARN_ON_ONCE(!folio_mapped(folio) &&
-			folio_test_large_maybe_mapped_shared(folio));
+			test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids));
 }
 
 static __always_inline void folio_set_large_mapcount(struct folio *folio,
--- a/mm/memory.c~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/mm/memory.c
@@ -3768,7 +3768,7 @@ static bool __wp_can_reuse_large_anon_fo
 	 * If all folio references are from mappings, and all mappings are in
 	 * the page tables of this MM, then this folio is exclusive to this MM.
 	 */
-	if (folio_test_large_maybe_mapped_shared(folio))
+	if (test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids))
 		return false;
 
 	VM_WARN_ON_ONCE(folio_test_ksm(folio));
@@ -3791,7 +3791,7 @@ static bool __wp_can_reuse_large_anon_fo
 	folio_lock_large_mapcount(folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_large_mapcount(folio) > folio_ref_count(folio), folio);
 
-	if (folio_test_large_maybe_mapped_shared(folio))
+	if (test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids))
 		goto unlock;
 	if (folio_large_mapcount(folio) != folio_ref_count(folio))
 		goto unlock;
_

Patches currently in -mm which might be from lance.yang@linux.dev are


