Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D3D30F529
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766005858; cv=none; b=NvDuaRGzGZsMitjD62AnI4820dZIK6YhNzFPkYs0BsXN2q4aNV12gY7uugUcQUXx8I6FiwOhUJ2a0G+HyuFKcUUYjJqFT8mTQBphf1kyVmtWSMuqfW/zuv29qI+JogmuFHbK/6rQHMqrUDXDMZ1OzSzSGky2Px/Y4DIfWd08RHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766005858; c=relaxed/simple;
	bh=Cb58HAe52InIC4KiR2P+i1UVha/D3baFhfn/Ne6xZtI=;
	h=Date:To:From:Subject:Message-Id; b=U4SH1I8y2nIX8ll/npGgpzlM5W5pqT19H6EmrpNxpp1eN0hfSxSw3a+mzlw+qVg9/H0Hgvt2mSgqA3bPb6Cprjysrlt6j139WQaL6oKSoGXSaKh3EkoOHOEbnoFO8OyFZKGTi++GcjeJiCQBrP/q8RjTRbo0MiqWsjoMS+ezH/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qowvnBbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qowvnBbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9D4C4CEF5;
	Wed, 17 Dec 2025 21:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766005857;
	bh=Cb58HAe52InIC4KiR2P+i1UVha/D3baFhfn/Ne6xZtI=;
	h=Date:To:From:Subject:From;
	b=qowvnBbCz3qYRKqvXUsigl0J4SYug1W0wS8M4/KRax59pEjet9VomeqKz5QdFvBCa
	 jHCZLnSkBbB+wLHOhjD1FGsQQQeAGEEB9sj0XKbZg0zG0WBU3hm2FnmGmMrFwGPp3N
	 BSsSNdbBHYk/rtx93mYz7x2tTMz3qXR9zpXeFTBA=
Date: Wed, 17 Dec 2025 13:10:57 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch added to mm-nonmm-unstable branch
Message-Id: <20251217211057.BB9D4C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: clean up @namebuf initialization in kallsyms_lookup_buildid()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch

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
Subject: kallsyms: clean up @namebuf initialization in kallsyms_lookup_buildid()
Date: Fri, 28 Nov 2025 14:59:14 +0100

Patch series "kallsyms: Prevent invalid access when showing module
buildid", v3.

We have seen nested crashes in __sprint_symbol(), see below.  They seem to
be caused by an invalid pointer to "buildid".  This patchset cleans up
kallsyms code related to module buildid and fixes this invalid access when
printing backtraces.

I made an audit of __sprint_symbol() and found several situations
when the buildid might be wrong:

  + bpf_address_lookup() does not set @modbuildid

  + ftrace_mod_address_lookup() does not set @modbuildid

  + __sprint_symbol() does not take rcu_read_lock and
    the related struct module might get removed before
    mod->build_id is printed.

This patchset solves these problems:

  + 1st, 2nd patches are preparatory
  + 3rd, 4th, 6th patches fix the above problems
  + 5th patch cleans up a suspicious initialization code.

This is the backtrace, we have seen. But it is not really important.
The problems fixed by the patchset are obvious:

  crash64> bt [62/2029]
  PID: 136151 TASK: ffff9f6c981d4000 CPU: 367 COMMAND: "btrfs"
  #0 [ffffbdb687635c28] machine_kexec at ffffffffb4c845b3
  #1 [ffffbdb687635c80] __crash_kexec at ffffffffb4d86a6a
  #2 [ffffbdb687635d08] hex_string at ffffffffb51b3b61
  #3 [ffffbdb687635d40] crash_kexec at ffffffffb4d87964
  #4 [ffffbdb687635d50] oops_end at ffffffffb4c41fc8
  #5 [ffffbdb687635d70] do_trap at ffffffffb4c3e49a
  #6 [ffffbdb687635db8] do_error_trap at ffffffffb4c3e6a4
  #7 [ffffbdb687635df8] exc_stack_segment at ffffffffb5666b33
  #8 [ffffbdb687635e20] asm_exc_stack_segment at ffffffffb5800cf9
  ...


This patch (of 7)

The function kallsyms_lookup_buildid() initializes the given @namebuf by
clearing the first and the last byte.  It is not clear why.

The 1st byte makes sense because some callers ignore the return code and
expect that the buffer contains a valid string, for example:

  - function_stat_show()
    - kallsyms_lookup()
      - kallsyms_lookup_buildid()

The initialization of the last byte does not make much sense because it
can later be overwritten.  Fortunately, it seems that all called functions
behave correctly:

  -  kallsyms_expand_symbol() explicitly adds the trailing '\0'
     at the end of the function.

  - All *__address_lookup() functions either use the safe strscpy()
    or they do not touch the buffer at all.

Document the reason for clearing the first byte.  And remove the useless
initialization of the last byte.

Link: https://lkml.kernel.org/r/20251128135920.217303-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/kallsyms.c~kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid
+++ a/kernel/kallsyms.c
@@ -355,7 +355,12 @@ static int kallsyms_lookup_buildid(unsig
 {
 	int ret;
 
-	namebuf[KSYM_NAME_LEN - 1] = 0;
+	/*
+	 * kallsyms_lookus() returns pointer to namebuf on success and
+	 * NULL on error. But some callers ignore the return value.
+	 * Instead they expect @namebuf filled either with valid
+	 * or empty string.
+	 */
 	namebuf[0] = 0;
 
 	if (is_ksym_addr(addr)) {
_

Patches currently in -mm which might be from pmladek@suse.com are

kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch
kallsyms-clean-up-modname-and-modbuildid-initialization-in-kallsyms_lookup_buildid.patch
module-add-helper-function-for-reading-module_buildid.patch
kallsyms-cleanup-code-for-appending-the-module-buildid.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch
kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch
kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

