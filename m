Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA330EF7A
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005868; cv=none; b=YnEGV932kcysiT9HDVDVGkN/yjB0mHWtvoPtsYAkUUpsqJtuCROHh9oQQYwN/duu03Lo+5aqKT5IDCuYdiv9u7aI74kXOr3uuA1mwkm5f523CFjUcSteR1pP7xOZfFuDUhvn6m6lgbIS11eFemoOediE7Wr225UDAnctRJhO4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005868; c=relaxed/simple;
	bh=yO5SxNuW5kbTw9/5hCV4fvNtRtv12xbLQBP4PHPsBW4=;
	h=Date:To:From:Subject:Message-Id; b=XSPqkuKkoTX+tt8TfbKSHy1o+MBRKSkdtsyflzolaJLgu75q7OALuINWkWkQxFP0nnS84DONymcpDIdEi5HVZUAR1S7yuyqMrRYYT6A5GkWjCrAXYld9G9SslRdxvMX3cdgHEGaS8Di54NYdOfrDF4GdSnVTxjcWwdx5sgpP2oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRtOoy7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRtOoy7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB24C4CEF5;
	Wed, 17 Dec 2025 21:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766005868;
	bh=yO5SxNuW5kbTw9/5hCV4fvNtRtv12xbLQBP4PHPsBW4=;
	h=Date:To:From:Subject:From;
	b=gRtOoy7QyJg73mbgLy7NmRTllnGtg4RIFsyqX37YT6m15SCe6hq9zOLEu0VBOvvY3
	 VrH2tzKu+DYjZwxMrmPpEFFII7pgktUGJZ2dR6/6tXHD0bkiDBSXWv8e735tKCkKee
	 zXFxAwlmOER2SPGP7zyvvv9qdNbH8xLZA/3GYpoI=
Date: Wed, 17 Dec 2025 13:11:07 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch added to mm-nonmm-unstable branch
Message-Id: <20251217211107.DDB24C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: prevent module removal when printing module name and buildid
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

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
Subject: kallsyms: prevent module removal when printing module name and buildid
Date: Fri, 28 Nov 2025 14:59:20 +0100

kallsyms_lookup_buildid() copies the symbol name into the given buffer so
that it can be safely read anytime later.  But it just copies pointers to
mod->name and mod->build_id which might get reused after the related
struct module gets removed.

The lifetime of struct module is synchronized using RCU.  Take the rcu
read lock for the entire __sprint_symbol().

Link: https://lkml.kernel.org/r/20251128135920.217303-8-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
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

 kernel/kallsyms.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kallsyms.c~kallsyms-prevent-module-removal-when-printing-module-name-and-buildid
+++ a/kernel/kallsyms.c
@@ -474,6 +474,9 @@ static int __sprint_symbol(char *buffer,
 	unsigned long offset, size;
 	int len;
 
+	/* Prevent module removal until modname and modbuildid are printed */
+	guard(rcu)();
+
 	address += symbol_offset;
 	len = kallsyms_lookup_buildid(address, &size, &offset, &modname, &buildid,
 				       buffer);
_

Patches currently in -mm which might be from pmladek@suse.com are

kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch
kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch
module-add-helper-function-for-reading-module_buildid.patch
kallsyms-cleanup-code-for-appending-the-module-buildid.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch
kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch
kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

