Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79A35A942
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 19:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726302; cv=none; b=n3x0ZeRxV2iRgzlk6GwYwoi+8xaMbatkCCFONFT2tzNDo0gSDCthasZfagz0JSei1nJo1EmBGbpesLE/XDAzSbBhqjsLQovmlRQFOXaln78ADwDNXWlQ4+XxLFHd7Mw0pD+9jeNlMTlNvFN+W8IvmvOzBL2zzUtIhI8iru1GkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726302; c=relaxed/simple;
	bh=zTM00/7BEnIEddMj53IAd8tFr+W0pUU1VMjSoikpQKo=;
	h=Date:To:From:Subject:Message-Id; b=ILEsQ1O7V59JHucyhgfsIjXIf0hk4HFqL6PLoJ/dcUbFhd9wzRGwuluxsY5DNWXaAqD1Elxt4Mr8BC2YX7b2dgty5BSvLIFp+BZktdkZ70sI8XF/cFFZHxhwb6D9yA9Ars9L6e7ec/O0a+RQaMle/4bh2XSc+TuJhioB+BxCbfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OdnXr5tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OdnXr5tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E9AC116C6;
	Tue,  6 Jan 2026 19:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767726302;
	bh=zTM00/7BEnIEddMj53IAd8tFr+W0pUU1VMjSoikpQKo=;
	h=Date:To:From:Subject:From;
	b=OdnXr5tzUaJGUySpWWHafS5wUeLN4ONnDrTLucbQ78Exc09gliKRI2qG0s/TpjS9H
	 5ReBULuLWPkhfUNjnesv42LAvDzIivyDujoef+/yHAsbEvP2w77TAVEoenqbLMDvSV
	 IGVlXk8nJ1enxHmM/oNLzofQLP3fnAuoCfyHCvQ0=
Date: Tue, 06 Jan 2026 11:05:01 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,pbonzini@redhat.com,mingo@redhat.com,luto@kernel.org,kai.huang@intel.com,hpa@zytor.com,dwmw@amazon.co.uk,dave.hansen@linux.intel.com,bp@alien8.de,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-use-set_memory_p-instead-of-__set_memory_prot.patch added to mm-nonmm-unstable branch
Message-Id: <20260106190502.18E9AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/crash: use set_memory_p instead of __set_memory_prot
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-crash-use-set_memory_p-instead-of-__set_memory_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-use-set_memory_p-instead-of-__set_memory_prot.patch

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
Subject: x86/crash: use set_memory_p instead of __set_memory_prot
Date: Tue, 6 Jan 2026 17:50:58 +0800

set_memory_p has been introduced since commit 030ad7af9437 ("x86/mm:
Regularize set_memory_p() parameters and make non-static").  There is no
need to use __set_memory_prot.

Link: https://lkml.kernel.org/r/20260106095100.656292-1-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Coiby Xu <coxu@redhat.com>
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

 arch/x86/kernel/machine_kexec_64.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c~x86-crash-use-set_memory_p-instead-of-__set_memory_prot
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -673,10 +673,7 @@ static void kexec_mark_dm_crypt_keys(boo
 		if (protect)
 			set_memory_np((unsigned long)phys_to_virt(start_paddr), nr_pages);
 		else
-			__set_memory_prot(
-				(unsigned long)phys_to_virt(start_paddr),
-				nr_pages,
-				__pgprot(_PAGE_PRESENT | _PAGE_NX | _PAGE_RW));
+			set_memory_p((unsigned long)phys_to_virt(start_paddr), nr_pages);
 	}
 }
 
_

Patches currently in -mm which might be from coxu@redhat.com are

x86-crash-use-set_memory_p-instead-of-__set_memory_prot.patch
reapply-x86-mm-remove-unused-__set_memory_prot.patch

