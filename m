Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C1A480DEF
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866013; cv=none; b=clIWzLQsBBqbesc1DjkVGVkb3R2LNpm3IqQE5N/Aha0Knq4kdNBLFoJg2+tx++T/0WvWMGrThCDCFmifCmL2bacPD6TV/0FReqAPS89gs1g43eibGA481GMLnwo+zPHuMvfILgGM7apgQZB/eZQJyiP7NX/FcQDpaM2E3lilqXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866013; c=relaxed/simple;
	bh=GBw8VNWdHVoRfZ/ZkgZCF/mea1fgVjrExWFQgGVd9CA=;
	h=Date:To:From:Subject:Message-Id; b=gYDGQhH1ceVWszdESlQHak8yR8heEEPHc7g0jQvIjAHW+dO2Fq1uIsYaCGmWQACnw2XieQ/00J8kZnmP05Le/ubcUW9aF941318KiCdO5anVa9rLYTCvM5O4Y23cjZPTqTBY0oDOhYHV5EzVheAOVCMTdHdWy2ucvPM1y98/sTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s12TYHI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s12TYHI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFB81F00898;
	Tue, 13 Oct 2026 04:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866010;
	bh=4oCjhC3N6RlRBq4sy65UVrkSiS3iXs1t4dcOvKHLw3w=;
	h=Date:To:From:Subject;
	b=s12TYHI+5XnFpX9/yiY1h31dY+/0ISwpRTNi18hoBxYcunGJdY3/vP7OxNG0SL2nC
	 WvUlOyoW6fSUG+liFCFEL1Jqef2Fzo09Ac+Pl0csj66MxV+94HFGpSrwjAK2XIBwX+
	 ojCSuBJQ7Oj/QEvWhjIfU7PcJord4Z++u2laTbso=
Date: Mon, 12 Oct 2026 21:33:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,pfalcato@suse.de,ljs@kernel.org,david@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-constify-arguments-in-default-pxdp_get.patch removed from -mm tree
Message-Id: <20261013043330.CAFB81F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: constify arguments in default pxdp_get()
has been removed from the -mm tree.  Its filename was
     mm-constify-arguments-in-default-pxdp_get.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: constify arguments in default pxdp_get()
Date: Fri, 18 Sep 2026 12:19:28 +0530

Generic MM default pxdp_get() helpers fetch the values contained in
pgtable entries via READ_ONCE() without modifying them.  Just make their
arguments explicitly 'const' for some additional protection.

Link: https://lore.kernel.org/20260918064928.793742-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
---

 include/linux/pgtable.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-constify-arguments-in-default-pxdp_get
+++ a/include/linux/pgtable.h
@@ -490,35 +490,35 @@ static inline int pudp_set_access_flags(
 #endif
 
 #ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
 #endif
 
 #ifndef pmdp_get
-static inline pmd_t pmdp_get(pmd_t *pmdp)
+static inline pmd_t pmdp_get(const pmd_t *pmdp)
 {
 	return READ_ONCE(*pmdp);
 }
 #endif
 
 #ifndef pudp_get
-static inline pud_t pudp_get(pud_t *pudp)
+static inline pud_t pudp_get(const pud_t *pudp)
 {
 	return READ_ONCE(*pudp);
 }
 #endif
 
 #ifndef p4dp_get
-static inline p4d_t p4dp_get(p4d_t *p4dp)
+static inline p4d_t p4dp_get(const p4d_t *p4dp)
 {
 	return READ_ONCE(*p4dp);
 }
 #endif
 
 #ifndef pgdp_get
-static inline pgd_t pgdp_get(pgd_t *pgdp)
+static inline pgd_t pgdp_get(const pgd_t *pgdp)
 {
 	return READ_ONCE(*pgdp);
 }
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

