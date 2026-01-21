Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DEA34F49F
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967342; cv=none; b=bHuMODT6RHWLkVMnsJLQtuYXC6bqUu8Vcfqlq+ok2cAQ5ZduAI8e0IPKNzmyCwQVVwdiXeaVB9a7qGRcdlB+oNEBmrQo0WLuAe0Eo+E5YYiKmAwiLgS4PfpmvoITLvIVb8VfHeJ252Ga12zDWLC9tqJjrZWgz/N/X32DElWCVP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967342; c=relaxed/simple;
	bh=v0X5QO3STKqsy0pmzRdR0p6Lp9lZwzLSWDL84v00Uhc=;
	h=Date:To:From:Subject:Message-Id; b=Yyx+P+q57Tnzf50y2mQlHj8/KtTwje1L9NFXohsYKxbMbWK3k8uLj4sw3K/msy8d/CJ/6uJVeaR7ksEc+OqnxmKm4geSsxDtvLtmx6Lytt8TXAUTXFaVLULzRKnteO6i/dCHFPxCkmj9l2ght++6J4xPXy9O0ZAu3OCupTMyl4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PGBjijsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PGBjijsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F930C19423;
	Wed, 21 Jan 2026 03:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967342;
	bh=v0X5QO3STKqsy0pmzRdR0p6Lp9lZwzLSWDL84v00Uhc=;
	h=Date:To:From:Subject:From;
	b=PGBjijsgGUO9yeBmKnhvB+tnvWMQ9WXyFzAOVdIluAjQUVOBDBkSZmLw2T4Xg703h
	 eOft2FmyogsJ0LQTtKuu2dEb6FRWQzxVdgRBVnzXb/L5LNv/pI92gu/Pdz3roXBLjK
	 sxyZ79cB/3NCDaazLNlArbeGjstEzyDifpy9m75k=
Date: Tue, 20 Jan 2026 19:49:01 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kallsyms-cleanup-code-for-appending-the-module-buildid.patch removed from -mm tree
Message-Id: <20260121034902.4F930C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms: cleanup code for appending the module buildid
has been removed from the -mm tree.  Its filename was
     kallsyms-cleanup-code-for-appending-the-module-buildid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kallsyms: cleanup code for appending the module buildid
Date: Fri, 28 Nov 2025 14:59:17 +0100

Put the code for appending the optional "buildid" into a helper function,
It makes __sprint_symbol() better readable.

Also print a warning when the "modname" is set and the "buildid" isn't. 
It might catch a situation when some lookup function in
kallsyms_lookup_buildid() does not handle the "buildid".

Use pr_*_once() to avoid an infinite recursion when the function is called
from printk().  The recursion is rather theoretical but better be on the
safe side.

Link: https://lkml.kernel.org/r/20251128135920.217303-5-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
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
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/kernel/kallsyms.c~kallsyms-cleanup-code-for-appending-the-module-buildid
+++ a/kernel/kallsyms.c
@@ -435,6 +435,37 @@ int lookup_symbol_name(unsigned long add
 	return lookup_module_symbol_name(addr, symname);
 }
 
+#ifdef CONFIG_STACKTRACE_BUILD_ID
+
+static int append_buildid(char *buffer,  const char *modname,
+			  const unsigned char *buildid)
+{
+	if (!modname)
+		return 0;
+
+	if (!buildid) {
+		pr_warn_once("Undefined buildid for the module %s\n", modname);
+		return 0;
+	}
+
+	/* build ID should match length of sprintf */
+#ifdef CONFIG_MODULES
+	static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
+#endif
+
+	return sprintf(buffer, " %20phN", buildid);
+}
+
+#else /* CONFIG_STACKTRACE_BUILD_ID */
+
+static int append_buildid(char *buffer,   const char *modname,
+			  const unsigned char *buildid)
+{
+	return 0;
+}
+
+#endif /* CONFIG_STACKTRACE_BUILD_ID */
+
 /* Look up a kernel symbol and return it in a text buffer. */
 static int __sprint_symbol(char *buffer, unsigned long address,
 			   int symbol_offset, int add_offset, int add_buildid)
@@ -457,15 +488,8 @@ static int __sprint_symbol(char *buffer,
 
 	if (modname) {
 		len += sprintf(buffer + len, " [%s", modname);
-#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
-		if (add_buildid && buildid) {
-			/* build ID should match length of sprintf */
-#if IS_ENABLED(CONFIG_MODULES)
-			static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
-#endif
-			len += sprintf(buffer + len, " %20phN", buildid);
-		}
-#endif
+		if (add_buildid)
+			len += append_buildid(buffer + len, modname, buildid);
 		len += sprintf(buffer + len, "]");
 	}
 
_

Patches currently in -mm which might be from pmladek@suse.com are


