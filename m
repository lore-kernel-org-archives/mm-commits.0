Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF22139C9;
	Wed,  7 Jan 2026 23:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767827936; cv=none; b=eX3jXCpEhLif6q14N/kkpChOHxdlVS5rZ2wFSpjzKm+3jF6Y8Oj4yo6AsdpAmByWz0uTcmHhV5rx+32BJDKvHJAx3+jMDGg0ZjsvGhlFFoe4loze2+LxAHUQjRmxi64OePXvIbwk+lSG1qC22prmOVVyx5EHtmJukz9TjEYVr8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767827936; c=relaxed/simple;
	bh=z57Jayz3v9ph2kvEjlRmZ4N1dGGUBo9Jvl/eDn98Rao=;
	h=Date:To:From:Subject:Message-Id; b=Gm49lBD2ll/WbWbNTamVTjpdgZQ+6NZjQj/K+L75872g5CmKoWPLo+PxBU1OlMCTA1x8mSDKsspMKkj3Jrt/JGh7PD8QzEbOG81gW+M8FFueu1jwtJ2asslzSF4mWLmAxMJ0lVN3Ah3xCE584LqiG74dW8nMAfJeYyC93EaWqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kB0Cyi7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kB0Cyi7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1378DC4CEF1;
	Wed,  7 Jan 2026 23:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767827936;
	bh=z57Jayz3v9ph2kvEjlRmZ4N1dGGUBo9Jvl/eDn98Rao=;
	h=Date:To:From:Subject:From;
	b=kB0Cyi7Xw5tsDiImlVmbNhYQbnf5wtfnFMhCxAaHoaYNluOb8mJVfUAXuYT4zpO3W
	 nFxJJ4Bwn8Ef1FOiSEoUDJXsvVMmUqn/J+79k8nuu/EhMIU4gF9ofLG3pDaVd1nPnc
	 Ia61GCjrSXD7Bqvd0bukkW1xjC4ybEWGBXVQbDuw=
Date: Wed, 07 Jan 2026 15:18:55 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jannh@google.com,hpa@zytor.com,glider@google.com,elver@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,bp@alien8.de,andrew.cooper3@citrix.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kfence-avoid-writing-l1tf-vulnerable-ptes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260107231856.1378DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kfence: avoid writing L1TF-vulnerable PTEs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-kfence-avoid-writing-l1tf-vulnerable-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kfence-avoid-writing-l1tf-vulnerable-ptes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: x86/kfence: avoid writing L1TF-vulnerable PTEs
Date: Tue, 6 Jan 2026 18:04:26 +0000

For native, the choice of PTE is fine.  There's real memory backing the
non-present PTE.  However, for XenPV, Xen complains:

  (XEN) d1 L1TF-vulnerable L1e 8010000018200066 - Shadowing

To explain, some background on XenPV pagetables:

  Xen PV guests are control their own pagetables; they choose the new
  PTE value, and use hypercalls to make changes so Xen can audit for
  safety.

  In addition to a regular reference count, Xen also maintains a type
  reference count.  e.g.  SegDesc (referenced by vGDT/vLDT), Writable
  (referenced with _PAGE_RW) or L{1..4} (referenced by vCR3 or a lower
  pagetable level).  This is in order to prevent e.g.  a page being
  inserted into the pagetables for which the guest has a writable mapping.

  For non-present mappings, all other bits become software accessible,
  and typically contain metadata rather a real frame address.  There is
  nothing that a reference count could sensibly be tied to.  As such, even
  if Xen could recognise the address as currently safe, nothing would
  prevent that frame from changing owner to another VM in the future.

  When Xen detects a PV guest writing a L1TF-PTE, it responds by
  activating shadow paging.  This is normally only used for the live phase
  of migration, and comes with a reasonable overhead.

KFENCE only cares about getting #PF to catch wild accesses; it doesn't
care about the value for non-present mappings.  Use a fully inverted PTE,
to avoid hitting the slow path when running under Xen.

While adjusting the logic, take the opportunity to skip all actions if the
PTE is already in the right state, half the number PVOps callouts, and
skip TLB maintenance on a !P -> P transition which benefits non-Xen cases
too.

Link: https://lkml.kernel.org/r/20260106180426.710013-1-andrew.cooper3@citrix.com
Fixes: 1dc0da6e9ec0 ("x86, kfence: enable KFENCE for x86")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kfence.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/kfence.h~x86-kfence-avoid-writing-l1tf-vulnerable-ptes
+++ a/arch/x86/include/asm/kfence.h
@@ -42,10 +42,34 @@ static inline bool kfence_protect_page(u
 {
 	unsigned int level;
 	pte_t *pte = lookup_address(addr, &level);
+	pteval_t val;
 
 	if (WARN_ON(!pte || level != PG_LEVEL_4K))
 		return false;
 
+	val = pte_val(*pte);
+
+	/*
+	 * protect requires making the page not-present.  If the PTE is
+	 * already in the right state, there's nothing to do.
+	 */
+	if (protect != !!(val & _PAGE_PRESENT))
+		return true;
+
+	/*
+	 * Otherwise, invert the entire PTE.  This avoids writing out an
+	 * L1TF-vulnerable PTE (not present, without the high address bits
+	 * set).
+	 */
+	set_pte(pte, __pte(~val));
+
+	/*
+	 * If the page was protected (non-present) and we're making it
+	 * present, there is no need to flush the TLB at all.
+	 */
+	if (!protect)
+		return true;
+
 	/*
 	 * We need to avoid IPIs, as we may get KFENCE allocations or faults
 	 * with interrupts disabled. Therefore, the below is best-effort, and
@@ -53,11 +77,6 @@ static inline bool kfence_protect_page(u
 	 * lazy fault handling takes care of faults after the page is PRESENT.
 	 */
 
-	if (protect)
-		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
-	else
-		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
-
 	/*
 	 * Flush this CPU's TLB, assuming whoever did the allocation/free is
 	 * likely to continue running on this CPU.
_

Patches currently in -mm which might be from andrew.cooper3@citrix.com are

x86-kfence-avoid-writing-l1tf-vulnerable-ptes.patch

