Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461AA71733
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644492; cv=none; b=m+6si/QlwalrKnnjCCPXRwDu0YO5pgbHUVL/mfN5+i0ocLEKGbnM/iVuSnO8qlSn/RZvrmyrtbYA195tBkDM3xKLZipZWFg0hmxuKdQ9dY/zBnyRFrg74FAVYk+tA7JMngllNNeehI+Knn9ez7bAHAYU8P56QfE5M9Robqskd6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644492; c=relaxed/simple;
	bh=qy9S3TmuxkOCzCMciyPPR9DdoAVM+lEz5cT3zUfBllU=;
	h=Date:To:From:Subject:Message-Id; b=fGagUWJmHIzcQIE2bXb4MX9tIdDpx52uILW3lrJP+TDd1w2f3wmPKPbESVBEmlcL/rLDB+YEdt5smO0AYyM1NtnlxzI6wDDK5saeJ2aGA718olvr8O2S5so5jXX6H4jTI7OCna/WKirhi0ZHpj1jytnS4BW32BTv9ek3VmvBZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQYtmadB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQYtmadB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F873C433F1;
	Thu, 22 Feb 2024 23:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644492;
	bh=qy9S3TmuxkOCzCMciyPPR9DdoAVM+lEz5cT3zUfBllU=;
	h=Date:To:From:Subject:From;
	b=aQYtmadBPiOB9PkZFAdi52tv4xyeKMMY8KjqkDbU/AVXcy//8I7tAYUgZ2xpJu2NI
	 T2lPwjyM/Ob5/4z3QZMEAwROFwS0vvZ2CyJiFvnSp5bVpwBsxYMnclu110YAT1RTAK
	 vO8Oa5vBLorkQcQGuXIJJ/zWQlpgPPbpcDcpjXVM=
Date: Thu, 22 Feb 2024 15:28:11 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-convert-ptep_clear-to-ptep_get_and_clear.patch removed from -mm tree
Message-Id: <20240222232812.0F873C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: convert ptep_clear() to ptep_get_and_clear()
has been removed from the -mm tree.  Its filename was
     arm64-mm-convert-ptep_clear-to-ptep_get_and_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: convert ptep_clear() to ptep_get_and_clear()
Date: Thu, 15 Feb 2024 10:31:56 +0000

ptep_clear() is a generic wrapper around the arch-implemented
ptep_get_and_clear().  We are about to convert ptep_get_and_clear() into a
public version and private version (__ptep_get_and_clear()) to support the
transparent contpte work.  We won't have a private version of ptep_clear()
so let's convert it to directly call ptep_get_and_clear().

Link: https://lkml.kernel.org/r/20240215103205.2607016-10-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-convert-ptep_clear-to-ptep_get_and_clear
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -229,7 +229,7 @@ static void clear_flush(struct mm_struct
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		ptep_clear(mm, addr, ptep);
+		ptep_get_and_clear(mm, addr, ptep);
 
 	flush_tlb_range(&vma, saddr, addr);
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


