From: akpm@linux-foundation.org
Subject: + arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict.patch added to -mm tree
Date: Fri, 26 Apr 2013 15:09:10 -0700
Message-ID: <20130426220910.7774B31C26F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55719 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3DZWJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Apr 2013 18:09:11 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so484308yen.2
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2013 15:09:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dborkman@redhat.com, arnd@arndb.de, nschichan@freebox.fr


The patch titled
     Subject: ARM: bpf_jit: seccomp filtering: fixup merge conflict
has been added to the -mm tree.  Its filename is
     arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Borkmann <dborkman@redhat.com>
Subject: ARM: bpf_jit: seccomp filtering: fixup merge conflict

Commit e4c67f4c0479d8e3cb0 (ARM: net: bpf_jit: make code generation less
dependent on struct sk_filter.) caused a merge conflict with commit
79617801ea0c0e6 (filter: bpf_jit_comp: refactor and unify BPF JIT image
dump output) resulting in a build failure:

arch/arm/net/bpf_jit_32.c: In function '__bpf_jit_compile':
arch/arm/net/bpf_jit_32.c:930:16: error: 'fp' undeclared (first use in this function)
    bpf_jit_dump(fp->len, alloc_size, 2, ctx.target);

Fix this up by using ctx.prog_len that is being set before we enter
__bpf_jit_compile().

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Schichan <nschichan@freebox.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/net/bpf_jit_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/net/bpf_jit_32.c~arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict arch/arm/net/bpf_jit_32.c
--- a/arch/arm/net/bpf_jit_32.c~arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict
+++ a/arch/arm/net/bpf_jit_32.c
@@ -918,7 +918,7 @@ static void __bpf_jit_compile(struct jit
 
 	if (bpf_jit_enable > 1)
 		/* there are 2 passes here */
-		bpf_jit_dump(fp->len, alloc_size, 2, ctx.target);
+		bpf_jit_dump(ctx.prog_len, alloc_size, 2, ctx.target);
 out:
 	kfree(ctx.offsets);
 
_

Patches currently in -mm which might be from dborkman@redhat.com are

linux-next.patch
arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict.patch

