Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B335A94F
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 19:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726304; cv=none; b=Ust6urkN/2ui4PtDal2xsgKf3cKohfImZKGrM1PE3mOiR/gSrCR58/tu3QggS0NQ9pBUuz/nsq1tvxJVj5ckTkLjoMpIHhBW/oRHtq0plZ4cntbG8Ue/81OAWNSZMyDSWiKMPSlodw0A87xGxXiBJv75Zp2lL9QBK4MRWxjePLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726304; c=relaxed/simple;
	bh=s1T+BDr0yvP2U/6UQKxHXGImI9BNUoBNPuqyiRejCpk=;
	h=Date:To:From:Subject:Message-Id; b=qKn9dRE4cO0K1AxODTSlYC4L0pKyeJFW8EGHDNViMMpD8XvNsireZepZjXmtT8ZzaTrq8gPSaPoRhVo6DBkRsg+Wb8PxSG/+rcjmLbjflDIUAKEiUtOi5Oj5u2YV2PMeo203ZfVLb55zXkQWtzKrpFqX73xo12OULoCHNLilF1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zJZirERe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zJZirERe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A539C116C6;
	Tue,  6 Jan 2026 19:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767726304;
	bh=s1T+BDr0yvP2U/6UQKxHXGImI9BNUoBNPuqyiRejCpk=;
	h=Date:To:From:Subject:From;
	b=zJZirERebKgbw4GMay+JA2hNwG0wsyiOXDVpaejXtw09Cw8Vc/qVz0QnTPqJuKCLS
	 B5OV/n6iJ431C506PYTqawnJXUuG4hVzpWqOfLMYKFWF8/JekZdIWiVXTBjgQ9Iijf
	 jMDMy6CHEZX/MSyPwKs6l8f26U8Hn2giP6eTiqZw=
Date: Tue, 06 Jan 2026 11:05:03 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,pbonzini@redhat.com,mingo@redhat.com,luto@kernel.org,kai.huang@intel.com,hpa@zytor.com,dwmw@amazon.co.uk,dave.hansen@linux.intel.com,bp@alien8.de,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reapply-x86-mm-remove-unused-__set_memory_prot.patch added to mm-nonmm-unstable branch
Message-Id: <20260106190504.3A539C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Reapply "x86/mm: Remove unused __set_memory_prot()"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reapply-x86-mm-remove-unused-__set_memory_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reapply-x86-mm-remove-unused-__set_memory_prot.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

x86-crash-use-set_memory_p-instead-of-__set_memory_prot.patch
reapply-x86-mm-remove-unused-__set_memory_prot.patch

