Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2C2D59FA
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005866; cv=none; b=ebTm1Re7m1WfLw9VrPuNucgw20RwVqPboqwh00k//imKRrs/nwe8YJJCoB2wm+JRKsbQhAxfcgJ4NoFCeqbAoiUOx/5poIJrRdIB7WjCekpF0b2vgxRRnZcwvy6vQwJNR4qPthnZhfnHwuffexyf9DYXR+lTibWHfffxupJRi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005866; c=relaxed/simple;
	bh=Kqdhum3LItX/W8F4idEsyXL4IDmzTLTqwEWw8luF36I=;
	h=Date:To:From:Subject:Message-Id; b=uU+38wk7cB/zEVzCiDCCXyWKjiRWCHHwincIlXCoQapEM6fPWj6cAzHWcvQxR/XsoBbCcL0o4fZd9mcoJxkG4Ar+/Az4+anrrQn3fupRPofGCZshCc14SKpyfl1xmmFyhj3jitOIyvRdmGRh/I23XYbM96wLfsOj1Xu8/dbzO90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eFhmKgmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eFhmKgmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62687C4CEF5;
	Wed, 17 Dec 2025 21:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766005866;
	bh=Kqdhum3LItX/W8F4idEsyXL4IDmzTLTqwEWw8luF36I=;
	h=Date:To:From:Subject:From;
	b=eFhmKgmWCrfoTtBaTp5obiybYZE0zUFu0LOn7rrCIzGLso/3spah8TCTJPVhlqVh4
	 pIsDy+dbAVIV8lEfr1nawKUkw5FXQAiDDF7I7HYK7JdfO8p8STjode3p35QHj8xzV9
	 ToamE09BcpQ963ujhgME+b6l4uoOJljIRG2ZiIkI=
Date: Wed, 17 Dec 2025 13:11:05 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch added to mm-nonmm-unstable branch
Message-Id: <20251217211106.62687C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch

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
Subject: kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()
Date: Fri, 28 Nov 2025 14:59:19 +0100

__sprint_symbol() might access an invalid pointer when
kallsyms_lookup_buildid() returns a symbol found by
ftrace_mod_address_lookup().

The ftrace lookup function must set both @modname and @modbuildid the same
way as module_address_lookup().

Link: https://lkml.kernel.org/r/20251128135920.217303-7-pmladek@suse.com
Fixes: 9294523e3768 ("module: add printk formats to add module build ID to stacktraces")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h |    6 ++++--
 kernel/kallsyms.c      |    4 ++--
 kernel/trace/ftrace.c  |    5 ++++-
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/ftrace.h~kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup
+++ a/include/linux/ftrace.h
@@ -87,11 +87,13 @@ struct ftrace_hash;
 	defined(CONFIG_DYNAMIC_FTRACE)
 int
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym);
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym);
 #else
 static inline int
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym)
 {
 	return 0;
 }
--- a/kernel/kallsyms.c~kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup
+++ a/kernel/kallsyms.c
@@ -389,8 +389,8 @@ static int kallsyms_lookup_buildid(unsig
 		ret = bpf_address_lookup(addr, symbolsize, offset, namebuf);
 
 	if (!ret)
-		ret = ftrace_mod_address_lookup(addr, symbolsize,
-						offset, modname, namebuf);
+		ret = ftrace_mod_address_lookup(addr, symbolsize, offset,
+						modname, modbuildid, namebuf);
 
 	return ret;
 }
--- a/kernel/trace/ftrace.c~kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup
+++ a/kernel/trace/ftrace.c
@@ -7749,7 +7749,8 @@ ftrace_func_address_lookup(struct ftrace
 
 int
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym)
 {
 	struct ftrace_mod_map *mod_map;
 	int ret = 0;
@@ -7761,6 +7762,8 @@ ftrace_mod_address_lookup(unsigned long
 		if (ret) {
 			if (modname)
 				*modname = mod_map->mod->name;
+			if (modbuildid)
+				*modbuildid = module_buildid(mod_map->mod);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from pmladek@suse.com are

kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch
kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch
module-add-helper-function-for-reading-module_buildid.patch
kallsyms-cleanup-code-for-appending-the-module-buildid.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch
kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch
kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

