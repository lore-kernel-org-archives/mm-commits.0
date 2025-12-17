Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB0B2FFDDC
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005862; cv=none; b=ugRntgtyl8O5WCx/3A3++HrZZlF0Q3bjca9xC1tF259+js8jQZtn6bNs3bwT+IlKtkVdmxuWSgdffqskqiF84kOFBtj3+XRtHQriaJiyqRzn5Sj+wDAoLXHJnzGL2xXh8EX/uwJ8FjyFFn9tuzXwPrcKhKywidITGLLzujdedck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005862; c=relaxed/simple;
	bh=wfNGBjMOCW/Zsg7gnD6gcuCqYuAK/7EhRSRkhP/89GQ=;
	h=Date:To:From:Subject:Message-Id; b=CjGpVtE4tt5zSfsFQXRlzAz+gH1aqVaIDHuKRy5pyP9eRGoekN5Bu5z24Tx3ItA6rN3aR8zZ4bfiz8Ap+/iM43EuvBFdIaw9npfJ64Y9lG/cxqyXhcz0L6/FzK5apB7MVCrF3Nr2wJ1lzfVUPYyquvwPhYxrw6vY/U/EI7sY6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YAZwYZSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YAZwYZSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AE8C4CEF5;
	Wed, 17 Dec 2025 21:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766005861;
	bh=wfNGBjMOCW/Zsg7gnD6gcuCqYuAK/7EhRSRkhP/89GQ=;
	h=Date:To:From:Subject:From;
	b=YAZwYZSLssxzflHWmJGXIO/w+Yu/kpz3JfyVzETmWKTD6ciIFELI9GvqprvyhLiMa
	 6rhh27wzQMNw05+s4rPMnlgmtujLwXQhkVHLH2DaE/ye+PkzYBWu/8g6iDhEtljGiw
	 BBlfgxofWUHv+SCSh4UM+I2ZVN6ADdlRkqFSaWWA=
Date: Wed, 17 Dec 2025 13:11:01 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-add-helper-function-for-reading-module_buildid.patch added to mm-nonmm-unstable branch
Message-Id: <20251217211101.95AE8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: add helper function for reading module_buildid()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     module-add-helper-function-for-reading-module_buildid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-add-helper-function-for-reading-module_buildid.patch

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

kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch
kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch
module-add-helper-function-for-reading-module_buildid.patch
kallsyms-cleanup-code-for-appending-the-module-buildid.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch
kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch
kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

