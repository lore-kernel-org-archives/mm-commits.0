Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D29E3168E2
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967345; cv=none; b=EaRQkzpegYvXPa/rPMmyHrlxuEw9sKtqWj2FubMQM6lnmztvD+Lkhk6+kgxXnSGw3mgcKpXj6qD8AaosqfIGRfQ/H6i2/sOdGQwHk3IOith1UzLGDkfBYOzoKum4I9ONLlkLxG4j6ov6JiIIjg2j+flMYZ8riq7KUhal7oqHpZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967345; c=relaxed/simple;
	bh=a60HpZtCAlNuoZhfu3WqaLU3vrEDRBM1VcZzNnZXC4Y=;
	h=Date:To:From:Subject:Message-Id; b=sv3rGfnyxJtDtwutQdVVlX7jTX8P1eF434BuCYq95nQsbXawvPKuOUHh6cfSjAPVR9/Ta4VLBpfnBQUqZF4594sjlQrXwkLO63VaX3ABAuZA7sXikRiZ+xvXev5K1MiIPTKYeNgpYSYADLE5Bb6VY5S5pfOOy10ubfAKGvFCSVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w08A68NF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w08A68NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A761AC16AAE;
	Wed, 21 Jan 2026 03:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967343;
	bh=a60HpZtCAlNuoZhfu3WqaLU3vrEDRBM1VcZzNnZXC4Y=;
	h=Date:To:From:Subject:From;
	b=w08A68NFNOPsI4NSb1kdxLycwE4uVec9p9TT9W4Bico+DYwIQf+IYgzbfUVXPXCJ0
	 rEnTvKY7l/g1ofo2n2sPxR5lb9ytt6dRO4f7eDNPORR8ozmT8dH31kVdqKa/prZEgU
	 QCO71ntwYSiHWsrCFqpik3Nxs8qncKLUJY/EN2Rs=
Date: Tue, 20 Jan 2026 19:49:03 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch removed from -mm tree
Message-Id: <20260121034903.A761AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
has been removed from the -mm tree.  Its filename was
     kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix loongarch]
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
 arch/loongarch/net/bpf_jit.c    |    2 +-
 arch/powerpc/net/bpf_jit_comp.c |    2 +-
 include/linux/filter.h          |   26 ++++----------------------
 kernel/bpf/core.c               |    4 ++--
 kernel/kallsyms.c               |    5 ++---
 6 files changed, 11 insertions(+), 30 deletions(-)

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
--- a/arch/loongarch/net/bpf_jit.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup
+++ a/arch/loongarch/net/bpf_jit.c
@@ -1319,7 +1319,7 @@ int bpf_arch_text_poke(void *ip, enum bp
 	/* Only poking bpf text is supported. Since kernel function entry
 	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
 	 */
-	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
+	if (!bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
 		return -ENOTSUPP;
 
 	image = ip - offset;
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


