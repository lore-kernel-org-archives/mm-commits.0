Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C27C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 17 Apr 2022 19:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiDQTnr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Apr 2022 15:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbiDQTnq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Apr 2022 15:43:46 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2990CB87B
        for <mm-commits@vger.kernel.org>; Sun, 17 Apr 2022 12:41:09 -0700 (PDT)
Received: from zn.tnic (p200300ea971b58ab329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:58ab:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 94A8A1EC0426;
        Sun, 17 Apr 2022 21:41:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650224463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nSgyXGjskRdCr6t98/WOjYqSszc1YmqxR/uLtiRQgpI=;
        b=aFYTSEzPTEtdFA5/aKkDPpy5SjWO19yNIl4wJu+j2z+9+EG/JX1QbWfpQNqVLbW4AtkMbf
        tRWn620sCpLiDpZIYTHbFiS/2UhWD4hGFoHoDWYD6VaztkHe1xoMlGWqLKaWsdNxRDdQs+
        3sArvsPvwSs2j7gJguQYTAzXCvLt15I=
Date:   Sun, 17 Apr 2022 21:41:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <YlxtTNFP58TcUHZQ@zn.tnic>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org>
 <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic>
 <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic>
 <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ylsx5PwyUPOainHa@zn.tnic>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Apr 16, 2022 at 11:15:16PM +0200, Borislav Petkov wrote:
> > but wouldn't it be lovely if we could start moving towards a model
> > where we can just inline 'memset' and 'memcpy' like this?
> 
> Yeah, inlined insns without even a CALL insn would be the most optimal
> thing to do.

Here's a diff ontop of Mark's patch, it inlines clear_user() everywhere
and it seems to patch properly

vmlinux has:

ffffffff812ba53e:       0f 87 f8 fd ff ff       ja     ffffffff812ba33c <load_elf_binary+0x60c>
ffffffff812ba544:       90                      nop
ffffffff812ba545:       90                      nop
ffffffff812ba546:       90                      nop
ffffffff812ba547:       4c 89 e7                mov    %r12,%rdi
ffffffff812ba54a:       f3 aa                   rep stos %al,%es:(%rdi)
ffffffff812ba54c:       90                      nop
ffffffff812ba54d:       90                      nop
ffffffff812ba54e:       90                      nop
ffffffff812ba54f:       90                      nop
ffffffff812ba550:       90                      nop
ffffffff812ba551:       90                      nop

which is the rep; stosb and when I boot my guest, it has been patched to:

0xffffffff812ba544 <+2068>:  0f 01 cb        stac   
0xffffffff812ba547 <+2071>:  4c 89 e7        mov    %r12,%rdi
0xffffffff812ba54a <+2074>:  e8 71 9a 15 00  call   0xffffffff81413fc0 <clear_user_rep_good>
0xffffffff812ba54f <+2079>:  0f 01 ca        clac

(stac and clac are also alternative-patched). And there's the call to
rep_good because the guest doesn't advertize FRSM nor ERMS.

Anyway, more playing with this later to make sure it really does what it
should.

---

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index f78e2b3501a1..335d571e8a79 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -405,9 +405,6 @@ strncpy_from_user(char *dst, const char __user *src, long count);
 
 extern __must_check long strnlen_user(const char __user *str, long n);
 
-unsigned long __must_check clear_user(void __user *mem, unsigned long len);
-unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
-
 #ifdef CONFIG_ARCH_HAS_COPY_MC
 unsigned long __must_check
 copy_mc_to_kernel(void *to, const void *from, unsigned len);
@@ -429,6 +426,8 @@ extern struct movsl_mask {
 #define ARCH_HAS_NOCACHE_UACCESS 1
 
 #ifdef CONFIG_X86_32
+unsigned long __must_check clear_user(void __user *mem, unsigned long len);
+unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
 # include <asm/uaccess_32.h>
 #else
 # include <asm/uaccess_64.h>
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 6a4995e4cfae..dc0f2bfc80a4 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -91,28 +91,34 @@ clear_user_rep_good(void __user *addr, unsigned long len);
 __must_check unsigned long
 clear_user_erms(void __user *addr, unsigned long len);
 
-static __always_inline __must_check unsigned long
-___clear_user(void __user *addr, unsigned long len)
+static __always_inline __must_check unsigned long __clear_user(void __user *addr, unsigned long size)
 {
-	unsigned long	ret;
-
 	/*
 	 * No memory constraint because it doesn't change any memory gcc
 	 * knows about.
 	 */
 
 	might_fault();
-	alternative_call_2(
-		clear_user_original,
-		clear_user_rep_good,
-		X86_FEATURE_REP_GOOD,
-		clear_user_erms,
-		X86_FEATURE_ERMS,
-		ASM_OUTPUT2("=a" (ret), "=D" (addr), "=c" (len)),
-		"1" (addr), "2" (len)
-		: "%rdx", "cc");
-	return ret;
+	stac();
+	asm_inline volatile(
+		"1:"
+		ALTERNATIVE_3("rep stosb",
+			      "call clear_user_erms",	  ALT_NOT(X86_FEATURE_FSRM),
+			      "call clear_user_rep_good", ALT_NOT(X86_FEATURE_ERMS),
+			      "call clear_user_original", ALT_NOT(X86_FEATURE_REP_GOOD))
+		"2:"
+	       _ASM_EXTABLE_UA(1b, 2b)
+	       : "+&c" (size), "+&D" (addr), ASM_CALL_CONSTRAINT
+	       : "a" (0));
+
+	clac();
+	return size;
 }
 
-#define __clear_user(d, n)	___clear_user(d, n)
+static __always_inline unsigned long clear_user(void __user *to, unsigned long n)
+{
+	if (access_ok(to, n))
+		return __clear_user(to, n);
+	return n;
+}
 #endif /* _ASM_X86_UACCESS_64_H */
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index abe1f44ea422..b80f710a7f30 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -62,9 +62,7 @@ EXPORT_SYMBOL_GPL(clear_page_erms)
  * Output:
  * rax uncopied bytes or 0 if successful.
  */
-
 SYM_FUNC_START(clear_user_original)
-	ASM_STAC
 	movq %rcx,%rax
 	shrq $3,%rcx
 	andq $7,%rax
@@ -86,7 +84,7 @@ SYM_FUNC_START(clear_user_original)
 	decl %ecx
 	jnz  2b
 
-3:	ASM_CLAC
+3:
 	movq %rcx,%rax
 	RET
 
@@ -105,11 +103,8 @@ EXPORT_SYMBOL(clear_user_original)
  * Output:
  * rax uncopied bytes or 0 if successful.
  */
-
 SYM_FUNC_START(clear_user_rep_good)
-	ASM_STAC
 	movq %rcx,%rdx
-	xorq %rax,%rax
 	shrq $3,%rcx
 	andq $7,%rdx
 
@@ -118,7 +113,7 @@ SYM_FUNC_START(clear_user_rep_good)
 
 1:	rep stosb
 
-3:	ASM_CLAC
+3:
 	movq %rcx,%rax
 	RET
 
@@ -135,15 +130,13 @@ EXPORT_SYMBOL(clear_user_rep_good)
  *
  * Output:
  * rax uncopied bytes or 0 if successful.
+ *
+ * XXX: check for small sizes and call the original version.
+ * Benchmark it first though.
  */
-
 SYM_FUNC_START(clear_user_erms)
-	xorq %rax,%rax
-	ASM_STAC
-
 0:	rep stosb
-
-3:	ASM_CLAC
+3:
 	movq %rcx,%rax
 	RET
 
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 3a2872c9c4a9..8bf04d95dc04 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -14,14 +14,6 @@
  * Zero Userspace
  */
 
-unsigned long clear_user(void __user *to, unsigned long n)
-{
-	if (access_ok(to, n))
-		return __clear_user(to, n);
-	return n;
-}
-EXPORT_SYMBOL(clear_user);
-
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 /**
  * clean_cache_range - write back a cache range with CLWB
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index bd0c2c828940..ea48ee11521f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1019,6 +1019,9 @@ static const char *uaccess_safe_builtin[] = {
 	"copy_mc_fragile_handle_tail",
 	"copy_mc_enhanced_fast_string",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
+	"clear_user_erms",
+	"clear_user_rep_good",
+	"clear_user_original",
 	NULL
 };
 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
