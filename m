Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D7A238C29
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 19:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986287; cv=none; b=KNX+6WhPHcROoyRWN2annxquchEWO3E2QEqqFXi9B4jq35etsJu6w+jgkxuELxGdBdA4gjbfHJQOVtcWMcyPCIyJqC8RrmGHMEAOkhltM0qpfO3jKvoWNnG/5swfHhrCp26WXxyohv/ROfTJQBEGd7F0TJycznPn6Z8hjriUFjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986287; c=relaxed/simple;
	bh=JcHW64e+p17J4IeUpbkLBXqD5RJRwRoWA54GaBjn5HQ=;
	h=Date:To:From:Subject:Message-Id; b=byNhgYKtL+KJh4nas4rsKh2pNq8g02llefLYXsACQeueWx9oreBLSMB76ZLyrPh7FvGtmVGxi9R98cfibrVDpNpCyG5LOXNFtsv00gP4cBkbDJixLmQ9/mIrTjKxTA/EYBuWCKEHGJJGBwU6HLCfA5kibKy1lAidmddQ1cCM+jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B8oWVhsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B8oWVhsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30400C4CEF1;
	Fri,  9 Jan 2026 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767986287;
	bh=JcHW64e+p17J4IeUpbkLBXqD5RJRwRoWA54GaBjn5HQ=;
	h=Date:To:From:Subject:From;
	b=B8oWVhsKA239XZgbq8jyHjAfS0gS2MYr45PN4giPEqamtRbZx6Gpint+5fzASO5IQ
	 6iCLjDAjOkD2lGk4bFegw9FwoJ0LnKg2h/bQ0q5whKJ1F1RSUaHcpAzT/CCyfG/pKP
	 zsc+wipG0Aio73QI0jS6F39nw/n1RBrJO0WNDwDY=
Date: Fri, 09 Jan 2026 11:18:06 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,pbonzini@redhat.com,mingo@redhat.com,luto@kernel.org,kai.huang@intel.com,hpa@zytor.com,dwmw@amazon.co.uk,dave.hansen@linux.intel.com,bp@alien8.de,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] reapply-x86-mm-remove-unused-__set_memory_prot.patch removed from -mm tree
Message-Id: <20260109191807.30400C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Reapply "x86/mm: Remove unused __set_memory_prot()"
has been removed from the -mm tree.  Its filename was
     reapply-x86-mm-remove-unused-__set_memory_prot.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: Reapply "x86/mm: Remove unused __set_memory_prot()"
Date: Tue, 6 Jan 2026 17:50:59 +0800

This reverts commit e1e6cd01d93359e22be84a23c8bb24ee4e04e142 as
__set_memory_prot is unsued (again) after set_memory_p is used instead for
x86_64 kdump LUKS support (CONFIG_CRASH_DM_CRYPT).

Link: https://lkml.kernel.org/r/20260106095100.656292-2-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/set_memory.h |    2 --
 arch/x86/mm/pat/set_memory.c      |   13 -------------
 2 files changed, 15 deletions(-)

--- a/arch/x86/include/asm/set_memory.h~reapply-x86-mm-remove-unused-__set_memory_prot
+++ a/arch/x86/include/asm/set_memory.h
@@ -4,7 +4,6 @@
 
 #include <asm/page.h>
 #include <asm-generic/set_memory.h>
-#include <asm/pgtable.h>
 
 #define set_memory_rox set_memory_rox
 int set_memory_rox(unsigned long addr, int numpages);
@@ -38,7 +37,6 @@ int set_memory_rox(unsigned long addr, i
  * The caller is required to take care of these.
  */
 
-int __set_memory_prot(unsigned long addr, int numpages, pgprot_t prot);
 int _set_memory_uc(unsigned long addr, int numpages);
 int _set_memory_wc(unsigned long addr, int numpages);
 int _set_memory_wt(unsigned long addr, int numpages);
--- a/arch/x86/mm/pat/set_memory.c~reapply-x86-mm-remove-unused-__set_memory_prot
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2145,19 +2145,6 @@ static inline int cpa_clear_pages_array(
 		CPA_PAGES_ARRAY, pages);
 }
 
-/*
- * __set_memory_prot is an internal helper for callers that have been passed
- * a pgprot_t value from upper layers and a reservation has already been taken.
- * If you want to set the pgprot to a specific page protocol, use the
- * set_memory_xx() functions.
- */
-int __set_memory_prot(unsigned long addr, int numpages, pgprot_t prot)
-{
-	return change_page_attr_set_clr(&addr, numpages, prot,
-					__pgprot(~pgprot_val(prot)), 0, 0,
-					NULL);
-}
-
 int _set_memory_uc(unsigned long addr, int numpages)
 {
 	/*
_

Patches currently in -mm which might be from coxu@redhat.com are


