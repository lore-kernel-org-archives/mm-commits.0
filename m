Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241282EF652
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005861; cv=none; b=YDVX/RrjazS+JZqR1tLS3Wq7K49LdRrD9Vbr3SGAFkuvOdtNAZrsM5KdIulKNLeUEPji8Xo1IeKaX0rat7NCjI3sWO3bNyLFYfLls259IBOLIZh3TRK1MQR3a31pCl7SJ1vZxo0V7W2mkzzamcpCfeSIX++4t+afOYaUbA5nL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005861; c=relaxed/simple;
	bh=E99+zwn0yyxqlZnj/nPeVlzL5VXJh88JFFEl3Jf4W68=;
	h=Date:To:From:Subject:Message-Id; b=fpdQSSrDFu7WBoCzwW4ZXBB4J5fUz8pJ33QK3Dd5Ri0LifyywYfWTUlDUrZYqkNXctYnyJS034ortYIede9UJokhn6mW5WDkF8ckiVcDmyAWB591IPLVTEEIl4b8d0cjIp2GBuclwtReLjBy3mVKZTxxnvHqHp4MQey078bVXYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RhzxFfHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RhzxFfHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A37C4CEF5;
	Wed, 17 Dec 2025 21:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766005860;
	bh=E99+zwn0yyxqlZnj/nPeVlzL5VXJh88JFFEl3Jf4W68=;
	h=Date:To:From:Subject:From;
	b=RhzxFfHyGGoMYzq0pETjAB9IMNNWM9l6So6uoxjMdJsH3Z7xBqJ2EWtaENTbWuws8
	 HVb4TITJy26ghriway3qkhDR5S+d1QEm1+3UVAHPDRSzP6FuSdFaVpnw30iW373HMa
	 /ozs8y8jJTOy+LbLRuB2WUUOquFMSbWkqYlBUYAI=
Date: Wed, 17 Dec 2025 13:10:59 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch added to mm-nonmm-unstable branch
Message-Id: <20251217211100.51A37C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: clean up modname and modbuildid initialization in kallsyms_lookup_buildid()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch

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
Subject: kallsyms: clean up modname and modbuildid initialization in kallsyms_lookup_buildid()
Date: Fri, 28 Nov 2025 14:59:15 +0100

The @modname and @modbuildid optional return parameters are set only when
the symbol is in a module.

Always initialize them so that they do not need to be cleared when the
module is not in a module.  It simplifies the logic and makes the code
even slightly more safe.

Note that bpf_address_lookup() function will get updated in a separate
patch.

Link: https://lkml.kernel.org/r/20251128135920.217303-3-pmladek@suse.com
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

 kernel/kallsyms.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/kallsyms.c~kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid
+++ a/kernel/kallsyms.c
@@ -362,6 +362,14 @@ static int kallsyms_lookup_buildid(unsig
 	 * or empty string.
 	 */
 	namebuf[0] = 0;
+	/*
+	 * Initialize the module-related return values. They are not set
+	 * when the symbol is in vmlinux or it is a bpf address.
+	 */
+	if (modname)
+		*modname = NULL;
+	if (modbuildid)
+		*modbuildid = NULL;
 
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
@@ -370,10 +378,6 @@ static int kallsyms_lookup_buildid(unsig
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos),
 				       namebuf, KSYM_NAME_LEN);
-		if (modname)
-			*modname = NULL;
-		if (modbuildid)
-			*modbuildid = NULL;
 
 		return strlen(namebuf);
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

