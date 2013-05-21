From: akpm@linux-foundation.org
Subject: [to-be-updated]
 arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict.patch removed from -mm tree
Date: Tue, 21 May 2013 13:04:47 -0700
Message-ID: <519bd35f.Ls/zIViX4lxMFp4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3EUUEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 16:04:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nschichan@freebox.fr, arnd@arndb.de, dborkman@redhat.com

Subject: [to-be-updated] arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict.patch removed from -mm tree
To: dborkman@redhat.com,arnd@arndb.de,nschichan@freebox.fr,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 13:04:47 -0700


The patch titled
     Subject: ARM: bpf_jit: seccomp filtering: fixup merge conflict
has been removed from the -mm tree.  Its filename was
     arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fixup-merge-conflict.patch

This patch was dropped because an updated version will be merged

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
@@ -917,7 +917,7 @@ static void __bpf_jit_compile(struct jit
 
 	if (bpf_jit_enable > 1)
 		/* there are 2 passes here */
-		bpf_jit_dump(fp->len, alloc_size, 2, ctx.target);
+		bpf_jit_dump(ctx.prog_len, alloc_size, 2, ctx.target);
 
 out:
 	kfree(ctx.offsets);
_

Patches currently in -mm which might be from dborkman@redhat.com are

linux-next.patch

