Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5973933344B
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967339; cv=none; b=H8F1NU2LTg+8PVdhH8+DVHQRgSwvi28z8+pmo1QS2znQkCcvtWlz9/wj/zwP5kNZd07P2uJLHTSapzsEgon1TE+Efx7qe9d0uZ1EyNjE6aAPGmEUv+WKGva50EsMwkU/yunYDJcFppwlS8ImSeYpDoDk9galVhvAQ4xcYyaWBDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967339; c=relaxed/simple;
	bh=KEcPh8G5hVGyOi+mkADcm7Ec0RKxphe5NiSls/Cvjj4=;
	h=Date:To:From:Subject:Message-Id; b=QDCL9z2Jazd1RCkDFa7zZtCMyJwOp1NWzpzQoHegsLnAhfevKN3UQU4Vzsci4tcOrRt20BVkQ8JuEqRxG2gUfWZHBS1NzOGE+fsj2DZuq2F93opyLRBMnWydWVfnNrNGxldcv9iAJvCeqG0GvYWUg9ljMo2lPhHCXfq3k/R8Mk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RBD/S36f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RBD/S36f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744B6C16AAE;
	Wed, 21 Jan 2026 03:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967338;
	bh=KEcPh8G5hVGyOi+mkADcm7Ec0RKxphe5NiSls/Cvjj4=;
	h=Date:To:From:Subject:From;
	b=RBD/S36fgmTRC1lbR17A9vNQuhvLO0WKYj5SU/FEb/y7/MZmBEZ7ZkDw+iNeKoUnU
	 WdIp7hXrREFgXe6ZQM/FzEvqEhlTnl+axKEOL+DmOUUrIJeajV7PYoByUK7m6ZoVwT
	 O5EjWPS4Wsao8j7mul9DOXRaLOx0fEl4srUy6jUU=
Date: Tue, 20 Jan 2026 19:48:57 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch removed from -mm tree
Message-Id: <20260121034858.744B6C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms: clean up @namebuf initialization in kallsyms_lookup_buildid()
has been removed from the -mm tree.  Its filename was
     kallsyms-clean-up-namebuf-initialization-in-kallsyms_lookup_buildid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


