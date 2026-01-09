Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE58238C29
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 19:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986286; cv=none; b=Mkz6lgsTJIPDJHuQaavzCDqXYRDqAiItzZcQS7fBqZ25iy+/lKH5+CYCDNUzj2K3Q0NSsWdjsvvm5a21xiaLPx0XdRTDysZ2QeoPm+gFgta8dxAEUE1ELdf1m9RJYKdvW4ihzCUrMIL32+8kx7wn2oxC1JGNmNNSBmYRn1NmCqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986286; c=relaxed/simple;
	bh=qQ7H4X54i2zDmqI3w5mvxoI+R8LV+swyXgtNAQ/2kx4=;
	h=Date:To:From:Subject:Message-Id; b=My/e4bjjZgX6UFonmjv7K6/e0+UzUtl5sB6nlZjtO0NTWdNDVYL5wSj8PwTdaxukmuPq86uqnl1Usg3lNEs9Odoj1nFrFO6pUpnasewGURitm5zmQlMA8LwDnTv7erNOqc1DkK/80396eVjqvB7fmapjO8CkYryCGvl5agCgiT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zdsETCVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zdsETCVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DD4C4CEF1;
	Fri,  9 Jan 2026 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767986285;
	bh=qQ7H4X54i2zDmqI3w5mvxoI+R8LV+swyXgtNAQ/2kx4=;
	h=Date:To:From:Subject:From;
	b=zdsETCVAMt3rZU7mBv/jU6pTRlzMa37nQFyFzgbTuwj5BCWR+tn32fHKGyL4D1dL/
	 Xb/zt1IFIz+nk7dLuHOkkESM/inWO6hRVTcugs7EiLLnwfecILkY585bhJyenAXk2S
	 gLs7Fit5MmWuKZpQrpaofe6mkcw27jyZlulifKzY=
Date: Fri, 09 Jan 2026 11:18:05 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,pbonzini@redhat.com,mingo@redhat.com,luto@kernel.org,kai.huang@intel.com,hpa@zytor.com,dwmw@amazon.co.uk,dave.hansen@linux.intel.com,bp@alien8.de,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] x86-crash-use-set_memory_p-instead-of-__set_memory_prot.patch removed from -mm tree
Message-Id: <20260109191805.D0DD4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/crash: use set_memory_p instead of __set_memory_prot
has been removed from the -mm tree.  Its filename was
     x86-crash-use-set_memory_p-instead-of-__set_memory_prot.patch

This patch was dropped because an updated version will be issued

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

reapply-x86-mm-remove-unused-__set_memory_prot.patch

