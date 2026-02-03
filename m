Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB03287276;
	Tue,  3 Feb 2026 02:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770086670; cv=none; b=uRiR6lp8bprdYKWRYRdeqOc5LxKu05vDDiXLFyftIux7Gjw0lIOfiSoGoArusAyD9JsyV1jP/MXIAvpKBs137lkxqqIEuIR9P2DCLPIp/zfc3yQbNirzR6Bw/s6ovCOd8sGn1TI90O7ZWwv8gh24YFp1iOGDcngzuuLnzV3w9Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770086670; c=relaxed/simple;
	bh=u2vaav65jDAgJKk5V0Btf2IIdI/ODFpVvbtnu1xYPmA=;
	h=Date:To:From:Subject:Message-Id; b=eJGIYYhtI0H8us6+cAexPQWFDYTGi1I9QQJqm595mX1nnYNxcS4eYU3r1L9IZbGGHTdxRqiSxmfst4MxLqYdMSrh3Fly+vneOewbq2oRxmeVF3KeYFglJHjRxiTtN3gGu9rsZKZY64T8UOTRm3SqH38ubrijsurjF5PvnP2bpxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LByOla14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LByOla14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BF6C116C6;
	Tue,  3 Feb 2026 02:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086670;
	bh=u2vaav65jDAgJKk5V0Btf2IIdI/ODFpVvbtnu1xYPmA=;
	h=Date:To:From:Subject:From;
	b=LByOla14stHib242H2Qoq8wUxRKBo+kXl6Fs2a0dWz1gUYjWKKb+dRRwOWTp+njsk
	 DVSX/+z5tmFt6IRqe5IXomnvgF1imynFkcL9OfjDWcq3VysFiK8Asua5uuKQMPL94j
	 wQX6JOJ2EEer/llWgQaJXIPCz55Xw14ffB6uD/g0=
Date: Mon, 02 Feb 2026 18:44:29 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,konishi.ryusuke@gmail.com,jannh@google.com,hpa@zytor.com,glider@google.com,elver@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,bp@alien8.de,andrew.cooper3@citrix.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-kfence-fix-booting-on-32bit-non-pae-systems.patch removed from -mm tree
Message-Id: <20260203024430.20BF6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kfence: fix booting on 32bit non-PAE systems
has been removed from the -mm tree.  Its filename was
     x86-kfence-fix-booting-on-32bit-non-pae-systems.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: x86/kfence: fix booting on 32bit non-PAE systems
Date: Mon, 26 Jan 2026 21:10:46 +0000

The original patch inverted the PTE unconditionally to avoid
L1TF-vulnerable PTEs, but Linux doesn't make this adjustment in 2-level
paging.

Adjust the logic to use the flip_protnone_guard() helper, which is a nop
on 2-level paging but inverts the address bits in all other paging modes.

This doesn't matter for the Xen aspect of the original change.  Linux no
longer supports running 32bit PV under Xen, and Xen doesn't support
running any 32bit PV guests without using PAE paging.

Link: https://lkml.kernel.org/r/20260126211046.2096622-1-andrew.cooper3@citrix.com
Fixes: b505f1944535 ("x86/kfence: avoid writing L1TF-vulnerable PTEs")
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Closes: https://lore.kernel.org/lkml/CAKFNMokwjw68ubYQM9WkzOuH51wLznHpEOMSqtMoV1Rn9JV_gw@mail.gmail.com/
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kfence.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kfence.h~x86-kfence-fix-booting-on-32bit-non-pae-systems
+++ a/arch/x86/include/asm/kfence.h
@@ -42,7 +42,7 @@ static inline bool kfence_protect_page(u
 {
 	unsigned int level;
 	pte_t *pte = lookup_address(addr, &level);
-	pteval_t val;
+	pteval_t val, new;
 
 	if (WARN_ON(!pte || level != PG_LEVEL_4K))
 		return false;
@@ -57,11 +57,12 @@ static inline bool kfence_protect_page(u
 		return true;
 
 	/*
-	 * Otherwise, invert the entire PTE.  This avoids writing out an
+	 * Otherwise, flip the Present bit, taking care to avoid writing an
 	 * L1TF-vulnerable PTE (not present, without the high address bits
 	 * set).
 	 */
-	set_pte(pte, __pte(~val));
+	new = val ^ _PAGE_PRESENT;
+	set_pte(pte, __pte(flip_protnone_guard(val, new, PTE_PFN_MASK)));
 
 	/*
 	 * If the page was protected (non-present) and we're making it
_

Patches currently in -mm which might be from andrew.cooper3@citrix.com are


