Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAEC17578
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118427; cv=none; b=NBSqV6rop7hAvBrc3YyynBJ3bxraOIxHANyIdDk3P6VngQwrpPFhiEGqLQGO6hg0VvWxDn03+KQcXsMPWorKdbarJOg1S2ITzgJtx+c3fDBdb1mCF9qLYprDD4Qwc+xwIbD6vS/ISonwMXpF/nlHbSt+ZKx2efb/Bx/PhawJd7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118427; c=relaxed/simple;
	bh=AUslF1qN8W0qIotd5I+xI1RbbQOmfS7mXyNsmU2pYqY=;
	h=Date:To:From:Subject:Message-Id; b=m9ZbuZFHZ6jxUpe6v+WRYLEo0Fg6gd+DM9QDuqUFZEobVf355ScYD9JuN5lCGmYKZPuoCGOISxqOq4z2oLYkZdlkDasfYnbJM8hN5butP6XoR3jtWk4arRzr172NARec54LSSjO7Ns9a7ZIrUaenfnzgrDr9mH5OzjbXxKVHejM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=awo/0V6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="awo/0V6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5A1C4CEED;
	Tue, 13 May 2025 06:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118427;
	bh=AUslF1qN8W0qIotd5I+xI1RbbQOmfS7mXyNsmU2pYqY=;
	h=Date:To:From:Subject:From;
	b=awo/0V6alEPEU0hSnTWjhd3ISMFr0m/kf0C1RyIPQLDcbCmiKha8T0lNrAkUlxPiq
	 3jkgO45i7F2K8WtEz6kfH4oFbTzXQczzBfGjBq9Nwy67inuF1g8Vy5nUiqV8AILbWr
	 XLCG9XBBXxoy46ocmDOecVmGd39dcXKxoc9ftang=
Date: Mon, 12 May 2025 23:40:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,dwmw@amazon.co.uk,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw2@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-implement-for_each_valid_pfn-for-config_sparsemem-fix.patch removed from -mm tree
Message-Id: <20250513064027.1A5A1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-implement-for_each_valid_pfn-for-config_sparsemem-fix
has been removed from the -mm tree.  Its filename was
     mm-implement-for_each_valid_pfn-for-config_sparsemem-fix.patch

This patch was dropped because it was folded into mm-implement-for_each_valid_pfn-for-config_sparsemem.patch

------------------------------------------------------
From: David Woodhouse <dwmw2@infradead.org>
Subject: mm-implement-for_each_valid_pfn-for-config_sparsemem-fix
Date: Sat, 26 Apr 2025 00:04:46 +0100

fix next_valid_pfn() for sparsemem

Link: https://lkml.kernel.org/r/c15100fcf6781a60b852c4dbb43bdc98a678fcf0.camel@infradead.org
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-implement-for_each_valid_pfn-for-config_sparsemem-fix
+++ a/include/linux/mmzone.h
@@ -2190,10 +2190,10 @@ static inline unsigned long next_valid_p
 	/*
 	 * Either every PFN within the section (or subsection for VMEMMAP) is
 	 * valid, or none of them are. So there's no point repeating the check
-	 * for every PFN; only call first_valid_pfn() the first time, and when
-	 * crossing a (sub)section boundary (i.e. !(pfn & ~PFN_VALID_MASK)).
+	 * for every PFN; only call first_valid_pfn() again when crossing a
+	 * (sub)section boundary (i.e. !(pfn & ~PAGE_{SUB,}SECTION_MASK)).
 	 */
-	if (pfn & (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ?
+	if (pfn & ~(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ?
 		   PAGE_SUBSECTION_MASK : PAGE_SECTION_MASK))
 		return pfn;
 
_

Patches currently in -mm which might be from dwmw2@infradead.org are

mm-implement-for_each_valid_pfn-for-config_sparsemem.patch

