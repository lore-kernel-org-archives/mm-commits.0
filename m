Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70981149C6F
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 19:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764271340; cv=none; b=pFonVLYEU2tXabaWuQaXOsOojdRLksTSkAq5Pq42UQTrrr+Ob3TmE2l8+4pIxec2v6ZmRcP5mdkBF1JK8KK/9zrNlBE0504kc00bC4ZPNLEJ1H0hd/7i3yDqGTZwU974ICneGa3PIhXq7x0HGGQBUyOMhWDlko5RAphOW6x+n2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764271340; c=relaxed/simple;
	bh=dw1Bd4QRWi8CpulUNfSyerpxsGAI7ot/M7y7PqPl0kw=;
	h=Date:To:From:Subject:Message-Id; b=ghDRnyNf3owBnNcyoUxZk25Xu4fXbosseXmr7EExePcbGZXcOXxjWdod7pV+HMIf57Ef0lM6+3CpOpEtF/DJakaHiqf2iFxUT9SJRHrhQSrAgJFwnun+FmglgVJc/KWcSp6M6XUcFDszm4+CT/JxHi+C/X9dnor2D17bNl8BMYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ftvcv+BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ftvcv+BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E242CC4CEF8;
	Thu, 27 Nov 2025 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764271340;
	bh=dw1Bd4QRWi8CpulUNfSyerpxsGAI7ot/M7y7PqPl0kw=;
	h=Date:To:From:Subject:From;
	b=Ftvcv+BDInrkqhVShVEQoweTvuPDgpk8gAxJievVoK1ZARl8ZtJGzJWAAdpKtgIha
	 FQcjwSg/jj4NUBqzY4TBwhFEyEkLLoJxs8VBvBu5JhgHsCM5sBAt/RZWhDzAcOjoZj
	 SWXiKQ1KP4hBfTrVBUDFOdiOKa68NCJHu65utABc=
Date: Thu, 27 Nov 2025 11:22:19 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,catalin.marinas@arm.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4.patch added to mm-nonmm-unstable branch
Message-Id: <20251127192219.E242CC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4
Date: Thu, 27 Nov 2025 12:27:00 +0000

add comment

Link: https://lkml.kernel.org/r/20251127122700.103927-1-ranxiaokai627@163.com
Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1370,6 +1370,14 @@ static __init int kho_init(void)
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
 		unsigned long pfn;
 
+		/*
+		 * When debug_pagealloc is enabled, __free_pages() clears the
+		 * corresponding PRESENT bit in the kernel page table.
+		 * Subsequent kmemleak scans of these pages cause the
+		 * non-PRESENT page faults.
+		 * Mark scratch areas with kmemleak_ignore_phys() to exclude
+		 * them from kmemleak scanning.
+		 */
 		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
 		     pfn += pageblock_nr_pages)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch
kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages-v4.patch

