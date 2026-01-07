Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F0B3A0B1D
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809441; cv=none; b=oMw5GN5Vfpe3JvnoSvRrVBzN3zG+948HocYry5u2v/I00GMjxz5OqFk+3ymOcOBX4Ak2r3jfDpYOKqJx2+Z7tJdcilYbcJCI1oRDzYpD1s9MBqdNZYpf51xC70bNV2MRW+Gk+1Hz6MQYc5XOh/4c025tgSvUfuiE7AIa+SLmzwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809441; c=relaxed/simple;
	bh=RNNPR/lk3hWbVf0MvVCyrl0U+w3Fe50QPvICc8ciRh8=;
	h=Date:To:From:Subject:Message-Id; b=f3i088RPWDozPV8U94rFEVe7qiibV7igloP54XmpTdtuC9XxYZKxYAuD8Xdx1VUHZIBQIQ6ZjYNR+FR0XSQ6jPqlWwOwBwcJ3ePvAeDFCE/rHWA+1CcUUt7LV5nosE5k1lLA6UsNc8aXaXqe+NdeevebZT/7VtbXhGvm/sJlOA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PxFpgYpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PxFpgYpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560EAC4CEF1;
	Wed,  7 Jan 2026 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809441;
	bh=RNNPR/lk3hWbVf0MvVCyrl0U+w3Fe50QPvICc8ciRh8=;
	h=Date:To:From:Subject:From;
	b=PxFpgYpl3duH3ZeK24U9X4dUpbaHClK+zjXCoJT0k1KWyW3SJYTaLQBNAtirCOjwV
	 ubLeL+oH9h0hMfhgGQoE4BF+l38Wg9W1u5UxO1Os1nLY6o+4seDZ+nAzHlWRdbkIre
	 Mq6dj4vRkpgg7NQVFABSTt1cXBtnecMVs9Lbie1w=
Date: Wed, 07 Jan 2026 10:10:40 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-simplify-clear_page_.patch added to mm-unstable branch
Message-Id: <20260107181041.560EAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: simplify clear_page_*
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-simplify-clear_page_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-simplify-clear_page_.patch

This patch will later appear in the mm-unstable branch at
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
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: x86/mm: simplify clear_page_*
Date: Tue, 6 Jan 2026 23:20:05 -0800

clear_page_rep() and clear_page_erms() are wrappers around "REP; STOS"
variations.  Inlining gets rid of an unnecessary CALL/RET (which isn't
free when using RETHUNK speculative execution mitigations.) Fixup and
rename clear_page_orig() to adapt to the changed calling convention.

Also add a comment from Dave Hansen detailing various clearing mechanisms
used in clear_page().

Link: https://lkml.kernel.org/r/20260107072009.1615991-5-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_32.h |    6 ++
 arch/x86/include/asm/page_64.h |   67 ++++++++++++++++++++++++-------
 arch/x86/lib/clear_page_64.S   |   39 +++---------------
 3 files changed, 66 insertions(+), 46 deletions(-)

--- a/arch/x86/include/asm/page_32.h~x86-mm-simplify-clear_page_
+++ a/arch/x86/include/asm/page_32.h
@@ -17,6 +17,12 @@ extern unsigned long __phys_addr(unsigne
 
 #include <linux/string.h>
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
 	memset(page, 0, PAGE_SIZE);
--- a/arch/x86/include/asm/page_64.h~x86-mm-simplify-clear_page_
+++ a/arch/x86/include/asm/page_64.h
@@ -48,26 +48,63 @@ static inline unsigned long __phys_addr_
 
 #define __phys_reloc_hide(x)	(x)
 
-void clear_page_orig(void *page);
-void clear_page_rep(void *page);
-void clear_page_erms(void *page);
-KCFI_REFERENCE(clear_page_orig);
-KCFI_REFERENCE(clear_page_rep);
-KCFI_REFERENCE(clear_page_erms);
+void __clear_pages_unrolled(void *page);
+KCFI_REFERENCE(__clear_pages_unrolled);
 
-static inline void clear_page(void *page)
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @addr: address of kernel page
+ *
+ * Switch between three implementations of page clearing based on CPU
+ * capabilities:
+ *
+ *  - __clear_pages_unrolled(): the oldest, slowest and universally
+ *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
+ *    to write a 64-byte cacheline in each loop iteration.
+ *
+ *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
+ *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
+ *    trusted. The instruction writes 8-byte per REP iteration but
+ *    CPUs can internally batch these together and do larger writes.
+ *
+ *  - "REP; STOSB": used on CPUs with "enhanced REP MOVSB/STOSB",
+ *    which enumerate 'ERMS' and provide an implementation which
+ *    unlike "REP; STOSQ" above wasn't overly picky about alignment.
+ *    The instruction writes 1-byte per REP iteration with CPUs
+ *    internally batching these together into larger writes and is
+ *    generally fastest of the three.
+ *
+ * Note that when running as a guest, features exposed by the CPU
+ * might be mediated by the hypervisor. So, the STOSQ variant might
+ * be in active use on some systems even when the hardware enumerates
+ * ERMS.
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_page(void *addr)
 {
+	u64 len = PAGE_SIZE;
 	/*
 	 * Clean up KMSAN metadata for the page being cleared. The assembly call
-	 * below clobbers @page, so we perform unpoisoning before it.
+	 * below clobbers @addr, so perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, PAGE_SIZE);
-	alternative_call_2(clear_page_orig,
-			   clear_page_rep, X86_FEATURE_REP_GOOD,
-			   clear_page_erms, X86_FEATURE_ERMS,
-			   "=D" (page),
-			   "D" (page),
-			   "cc", "memory", "rax", "rcx");
+	kmsan_unpoison_memory(addr, len);
+
+	/*
+	 * The inline asm embeds a CALL instruction and usually that is a no-no
+	 * due to the compiler not knowing that and thus being unable to track
+	 * callee-clobbered registers.
+	 *
+	 * In this case that is fine because the registers clobbered by
+	 * __clear_pages_unrolled() are part of the inline asm register
+	 * specification.
+	 */
+	asm volatile(ALTERNATIVE_2("call __clear_pages_unrolled",
+				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+				   "rep stosb", X86_FEATURE_ERMS)
+			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
+			: "a" (0)
+			: "cc", "memory");
 }
 
 void copy_page(void *to, void *from);
--- a/arch/x86/lib/clear_page_64.S~x86-mm-simplify-clear_page_
+++ a/arch/x86/lib/clear_page_64.S
@@ -6,30 +6,15 @@
 #include <asm/asm.h>
 
 /*
- * Most CPUs support enhanced REP MOVSB/STOSB instructions. It is
- * recommended to use this when possible and we do use them by default.
- * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
- * Otherwise, use original.
+ * Zero page aligned region.
+ * %rdi	- dest
+ * %rcx	- length
  */
-
-/*
- * Zero a page.
- * %rdi	- page
- */
-SYM_TYPED_FUNC_START(clear_page_rep)
-	movl $4096/8,%ecx
-	xorl %eax,%eax
-	rep stosq
-	RET
-SYM_FUNC_END(clear_page_rep)
-EXPORT_SYMBOL_GPL(clear_page_rep)
-
-SYM_TYPED_FUNC_START(clear_page_orig)
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+SYM_TYPED_FUNC_START(__clear_pages_unrolled)
+	shrq   $6, %rcx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	decq	%rcx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
@@ -43,16 +28,8 @@ SYM_TYPED_FUNC_START(clear_page_orig)
 	jnz	.Lloop
 	nop
 	RET
-SYM_FUNC_END(clear_page_orig)
-EXPORT_SYMBOL_GPL(clear_page_orig)
-
-SYM_TYPED_FUNC_START(clear_page_erms)
-	movl $4096,%ecx
-	xorl %eax,%eax
-	rep stosb
-	RET
-SYM_FUNC_END(clear_page_erms)
-EXPORT_SYMBOL_GPL(clear_page_erms)
+SYM_FUNC_END(__clear_pages_unrolled)
+EXPORT_SYMBOL_GPL(__clear_pages_unrolled)
 
 /*
  * Default clear user-space.
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-introduce-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-clear-pages-sequentially.patch
mm-folio_zero_user-clear-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

