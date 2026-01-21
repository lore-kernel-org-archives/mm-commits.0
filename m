Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4414B342CAD
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967342; cv=none; b=Kkwi00L5LA/wtjmBQT/oHN+/myDxgMZbthRukmFjZmW21mD7BOMWOdze+jVnJS3ZZ+8Kt8pfOYdx09OQG88ZEKeQNZ2m9wv5LLda/5QI1cF+Au5TRuKSbq5Y9dAG/M/bI0BDdWgbNllwwfqbJktCmqmTqKNozRcoZtLo2g+Ucuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967342; c=relaxed/simple;
	bh=DFvC3bkMtOUrPw6ffFhfawTSRH1WlsaY5kGYawyUZFw=;
	h=Date:To:From:Subject:Message-Id; b=KrL+sfAx76igVCwkDhXuZIXF/d6EwT8mgYM9Tknff82vyZjquUmp/GbQwZam8bi4yEgTByE33q0le7tm+FYV/WF9+0JYHGPgaB/LtiaOi6hpCIX1kqcnigK5D8HVFUzlFxoR96ZURmhUFpuU7oJd4YcUXiATHW4Q5s7c6xk3j28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ir24yzLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ir24yzLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06738C16AAE;
	Wed, 21 Jan 2026 03:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967341;
	bh=DFvC3bkMtOUrPw6ffFhfawTSRH1WlsaY5kGYawyUZFw=;
	h=Date:To:From:Subject:From;
	b=ir24yzLn+2+Bpqh7SdCsoyDX2TCl0elG6bIun7eTKncK8z697Eakf62NWKGh+J07v
	 01zA9eejmXl7ny6NFk6w1E4MRKQllPs86PsFAiusGxS11aFmAZRAz2VfDIkwVmY0lq
	 HZ5KLu01kuPRGUtmuv7cJwIV9tMSEPH3v94OZXhw=
Date: Tue, 20 Jan 2026 19:49:00 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] module-add-helper-function-for-reading-module_buildid.patch removed from -mm tree
Message-Id: <20260121034901.06738C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: module: add helper function for reading module_buildid()
has been removed from the -mm tree.  Its filename was
     module-add-helper-function-for-reading-module_buildid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: module: add helper function for reading module_buildid()
Date: Fri, 28 Nov 2025 14:59:16 +0100

Add a helper function for reading the optional "build_id" member of struct
module.  It is going to be used also in ftrace_mod_address_lookup().

Use "#ifdef" instead of "#if IS_ENABLED()" to match the declaration of the
optional field in struct module.

Link: https://lkml.kernel.org/r/20251128135920.217303-4-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h   |    9 +++++++++
 kernel/module/kallsyms.c |    9 ++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/include/linux/module.h~module-add-helper-function-for-reading-module_buildid
+++ a/include/linux/module.h
@@ -748,6 +748,15 @@ static inline void __module_get(struct m
 	__mod ? __mod->name : "kernel";		\
 })
 
+static inline const unsigned char *module_buildid(struct module *mod)
+{
+#ifdef CONFIG_STACKTRACE_BUILD_ID
+	return mod->build_id;
+#else
+	return NULL;
+#endif
+}
+
 /* Dereference module function descriptor */
 void *dereference_module_function_descriptor(struct module *mod, void *ptr);
 
--- a/kernel/module/kallsyms.c~module-add-helper-function-for-reading-module_buildid
+++ a/kernel/module/kallsyms.c
@@ -334,13 +334,8 @@ int module_address_lookup(unsigned long
 	if (mod) {
 		if (modname)
 			*modname = mod->name;
-		if (modbuildid) {
-#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
-			*modbuildid = mod->build_id;
-#else
-			*modbuildid = NULL;
-#endif
-		}
+		if (modbuildid)
+			*modbuildid = module_buildid(mod);
 
 		sym = find_kallsyms_symbol(mod, addr, size, offset);
 
_

Patches currently in -mm which might be from pmladek@suse.com are


