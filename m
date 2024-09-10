Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBED1A2574
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 20:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725999252; cv=none; b=dZP3ZtOMG94qSlSXIj0mqYGys4hgLEenPgJFB9/2wdGiZnxs/2QHKeyflICN9yyQr+HziOPMI+/qK6bpHQyROOXoyLmokpz3TG2ja63H5sehG8YF9W5eutVxZ/yZJkb6sVNuGxrJwVcXwXZGiGY/HwJMnR9w47S/0nD2bXBifWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725999252; c=relaxed/simple;
	bh=dI62mk2HIo+8QnO8RurlaPOrmZWfwqZfKzHa7jjYSrQ=;
	h=Date:To:From:Subject:Message-Id; b=k9i228m+crDZkxv8cDs5cy79euW689afBm4EE6ZAs5E31Z5kCdRwZbi/79keTPXOH90NDSOy5icXk3skhhZre1Euirsxz8+ImD5Km9AwtRC8azdxIMpbfMh7aMyg7H3U2AKzAiWB+AVNnA9fLBGfJxGguNzTHYAlmYF3BcFCqM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVMRNw4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVMRNw4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213FAC4CEC3;
	Tue, 10 Sep 2024 20:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725999252;
	bh=dI62mk2HIo+8QnO8RurlaPOrmZWfwqZfKzHa7jjYSrQ=;
	h=Date:To:From:Subject:From;
	b=MVMRNw4POiKI0fohLY5kzSDeuE4PtxNYlD4Ka3ZLqLS+pSlPPb2Y872mUArmOxFLp
	 kM4+IiYyBQeCKTtxTj2eJDQTVoDvaNkuv1Ov1tDq2hCVnnT7M/4EKiYomqYh41/hSy
	 3QrA2IXmX7cfldgN+6ag12zZAXBdmzrMqGU/S13Q=
Date: Tue, 10 Sep 2024 13:14:11 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-drop-unused-set_pte_safe.patch removed from -mm tree
Message-Id: <20240910201412.213FAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop unused set_pte_safe()
has been removed from the -mm tree.  Its filename was
     mm-drop-unused-set_pte_safe.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: drop unused set_pte_safe()
Date: Tue, 10 Sep 2024 15:40:26 +0530

All set_pte_safe() usage have been dropped after the commit eccd906484d1
("x86/mm: Do not use set_{pud, pmd}_safe() when splitting a large page")
This just drops now unused helper set_pte_safe().

Besides this macro was buggy due to doing direct dereferencing of the pte,
and if it were to be kept, it should have been updated to use a single
call to ptep_get().

Link: https://lkml.kernel.org/r/20240910101026.428808-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/pgtable.h~mm-drop-unused-set_pte_safe
+++ a/include/linux/pgtable.h
@@ -1064,12 +1064,6 @@ static inline int pgd_same(pgd_t pgd_a,
  * same value. Otherwise, use the typical "set" helpers and flush the
  * TLB.
  */
-#define set_pte_safe(ptep, pte) \
-({ \
-	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
-	set_pte(ptep, pte); \
-})
-
 #define set_pmd_safe(pmdp, pmd) \
 ({ \
 	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-use-pxdp_get-for-accessing-page-table-entries.patch

