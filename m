Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5030C601
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005865; cv=none; b=GlujIvmQo6SG2XysJ4NSFuabquNYnXCnE99/el6gCKSkOY2bxwXxJb09qm5xgD3udHBz695hj+YMBwtvRRI53qDk11iMIG8K3TDVyOmzwrSiDDffeOJuNUh7kMu+dcorppb6/Nh/68ZmPA+M94EhdFN6juG1CJQgGMXvLM8rfZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005865; c=relaxed/simple;
	bh=T72wmSHLGFSU+T16ZkZF/VxUIhXg1OIR3ReUEKCiVrI=;
	h=Date:To:From:Subject:Message-Id; b=Q6pppMDlPUVRg0mRj97h82SKFdRQ2jYLIQ9HQc5poAa1OIi4vDzPQsDq9t1ERP9NhVCabKO/tcbsanUV7O7ORskFbOrV/eLK1MQ28ATuFPFQ8KiefLS04Fhp5Ic/MvYO7NRQ0ByCwPlmjVObyoVP7BYetfHjXR9jN0Ip5eI6GyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d+4tfheY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d+4tfheY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B561C4CEF5;
	Wed, 17 Dec 2025 21:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766005864;
	bh=T72wmSHLGFSU+T16ZkZF/VxUIhXg1OIR3ReUEKCiVrI=;
	h=Date:To:From:Subject:From;
	b=d+4tfheYc7euL8TNLGd5QxiLb8gAUKI25kuqJ+x+pYUWIS6wInvoK73zTpXqvrEdh
	 zUYrmRPRDCyN+q4jxPcsD0KlFCLKww/r0/sHxVO5DgiVnmPzVb0lACIWr+qmIgeict
	 F+ecg/2W50wSFC0tXPCKKcoY9IwSp5DEnCl+vlmg=
Date: Wed, 17 Dec 2025 13:11:03 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch added to mm-nonmm-unstable branch
Message-Id: <20251217211104.8B561C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch

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
From: Petr Mladek <pmladek@suse.com>
Subject: kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
Date: Fri, 28 Nov 2025 14:59:18 +0100

bpf_address_lookup() has been used only in kallsyms_lookup_buildid().  It
was supposed to set @modname and @modbuildid when the symbol was in a
module.

But it always just cleared @modname because BPF symbols were never in a
module.  And it did not clear @modbuildid because the pointer was not
passed.

The wrapper is no longer needed.  Both @modname and @modbuildid are now
always initialized to NULL in kallsyms_lookup_buildid().

Remove the wrapper and rename __bpf_address_lookup() to
bpf_address_lookup() because this variant is used everywhere.

Link: https://lkml.kernel.org/r/20251128135920.217303-6-pmladek@suse.com
Fixes: 9294523e3768 ("module: add printk formats to add module build ID to stacktraces")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/net/bpf_jit_comp.c   |    2 +-
 arch/powerpc/net/bpf_jit_comp.c |    2 +-
 include/linux/filter.h          |   26 ++++----------------------
 kernel/bpf/core.c               |    4 ++--
 kernel/kallsyms.c               |    5 ++---
 5 files changed, 10 insertions(+), 29 deletions(-)

--- a/arch/arm64/net/bpf_jit_comp.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup
+++ a/arch/arm64/net/bpf_jit_comp.c
@@ -2951,7 +2951,7 @@ int bpf_arch_text_poke(void *ip, enum bp
 	u64 plt_target = 0ULL;
 	bool poking_bpf_entry;
 
-	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
+	if (!bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
 		/* Only poking bpf text is supported. Since kernel function
 		 * entry is set up by ftrace, we reply on ftrace to poke kernel
 		 * functions.
--- a/arch/powerpc/net/bpf_jit_comp.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup
+++ a/arch/powerpc/net/bpf_jit_comp.c
@@ -1122,7 +1122,7 @@ int bpf_arch_text_poke(void *ip, enum bp
 	bpf_func = (unsigned long)ip;
 
 	/* We currently only support poking bpf programs */
-	if (!__bpf_address_lookup(bpf_func, &size, &offset, name)) {
+	if (!bpf_address_lookup(bpf_func, &size, &offset, name)) {
 		pr_err("%s (0x%lx): kernel/modules are not supported\n", __func__, bpf_func);
 		return -EOPNOTSUPP;
 	}
--- a/include/linux/filter.h~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup
+++ a/include/linux/filter.h
@@ -1375,24 +1375,13 @@ static inline bool bpf_jit_kallsyms_enab
 	return false;
 }
 
-int __bpf_address_lookup(unsigned long addr, unsigned long *size,
-				 unsigned long *off, char *sym);
+int bpf_address_lookup(unsigned long addr, unsigned long *size,
+		       unsigned long *off, char *sym);
 bool is_bpf_text_address(unsigned long addr);
 int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		    char *sym);
 struct bpf_prog *bpf_prog_ksym_find(unsigned long addr);
 
-static inline int
-bpf_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
-{
-	int ret = __bpf_address_lookup(addr, size, off, sym);
-
-	if (ret && modname)
-		*modname = NULL;
-	return ret;
-}
-
 void bpf_prog_kallsyms_add(struct bpf_prog *fp);
 void bpf_prog_kallsyms_del(struct bpf_prog *fp);
 
@@ -1431,8 +1420,8 @@ static inline bool bpf_jit_kallsyms_enab
 }
 
 static inline int
-__bpf_address_lookup(unsigned long addr, unsigned long *size,
-		     unsigned long *off, char *sym)
+bpf_address_lookup(unsigned long addr, unsigned long *size,
+		   unsigned long *off, char *sym)
 {
 	return 0;
 }
@@ -1453,13 +1442,6 @@ static inline struct bpf_prog *bpf_prog_
 	return NULL;
 }
 
-static inline int
-bpf_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
-{
-	return 0;
-}
-
 static inline void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
 }
--- a/kernel/bpf/core.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup
+++ a/kernel/bpf/core.c
@@ -714,8 +714,8 @@ static struct bpf_ksym *bpf_ksym_find(un
 	return n ? container_of(n, struct bpf_ksym, tnode) : NULL;
 }
 
-int __bpf_address_lookup(unsigned long addr, unsigned long *size,
-				 unsigned long *off, char *sym)
+int bpf_address_lookup(unsigned long addr, unsigned long *size,
+		       unsigned long *off, char *sym)
 {
 	struct bpf_ksym *ksym;
 	int ret = 0;
--- a/kernel/kallsyms.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup
+++ a/kernel/kallsyms.c
@@ -345,7 +345,7 @@ int kallsyms_lookup_size_offset(unsigned
 		return 1;
 	}
 	return !!module_address_lookup(addr, symbolsize, offset, NULL, NULL, namebuf) ||
-	       !!__bpf_address_lookup(addr, symbolsize, offset, namebuf);
+	       !!bpf_address_lookup(addr, symbolsize, offset, namebuf);
 }
 
 static int kallsyms_lookup_buildid(unsigned long addr,
@@ -386,8 +386,7 @@ static int kallsyms_lookup_buildid(unsig
 	ret = module_address_lookup(addr, symbolsize, offset,
 				    modname, modbuildid, namebuf);
 	if (!ret)
-		ret = bpf_address_lookup(addr, symbolsize,
-					 offset, modname, namebuf);
+		ret = bpf_address_lookup(addr, symbolsize, offset, namebuf);
 
 	if (!ret)
 		ret = ftrace_mod_address_lookup(addr, symbolsize,
_

Patches currently in -mm which might be from pmladek@suse.com are

kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch
kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch
module-add-helper-function-for-reading-module_buildid.patch
kallsyms-cleanup-code-for-appending-the-module-buildid.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch
kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch
kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

