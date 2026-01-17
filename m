Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8731ACED5
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768619074; cv=none; b=ZITg4sIaIs6ZbpqD3t/2JaSS6A5KWQ4gOvHUK2Bo5kQPPCDZt7Yk+uYd+bhn9xRRTv93c245uJmRoI8aAGHAHD4Z9a/LNiln50PJLVQP2JanKJGx5T2pqwVIKsr/R2EFgmQDJOKg5yO2rTwDu71iw0By4oBV+OzXAWUMoDM4TMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768619074; c=relaxed/simple;
	bh=6EHZetJyquLtgcKc3D9tRtQ2arxJghlSJ0lKHxCezgE=;
	h=Date:To:From:Subject:Message-Id; b=M9TVFFlS7/QsldR2g/Ts4jS9fcABLHSWHFWN1kqLeFQGCyJ8LF0u0D/iE3ak74Kr3sUfPJxeTeQAzC0FVlDyw47fRL3+D5NnQlQVhTeUYpQoh0EPUjkiW2SiCgK5iJ5D6VnL5GZ47hE7RsQVWbmovukU61/q2y82gk4YHeCDot4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M1GJ6Hfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M1GJ6Hfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FADFC116C6;
	Sat, 17 Jan 2026 03:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768619073;
	bh=6EHZetJyquLtgcKc3D9tRtQ2arxJghlSJ0lKHxCezgE=;
	h=Date:To:From:Subject:From;
	b=M1GJ6Hfz21TZwCFPJOI3+xtGajHvBJmdYSHsppOdxn7Alw4xVewB69ZEKWDxxsmiF
	 QKXaiWQ+/w9ZbIvzDhgosO81786x0A/QRDOWl7zHiBvqnoGtSxD9v7z2YxSFT31UxN
	 JyyBWAagXKarkFWp9knTVsANm/tLY4xPnLlwBPt8=
Date: Fri, 16 Jan 2026 19:04:33 -0800
To: mm-commits@vger.kernel.org,ynorov@nvidia.com,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tracing-remove-size-parameter-in-__trace_puts.patch added to mm-nonmm-unstable branch
Message-Id: <20260117030433.9FADFC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tracing: Remove size parameter in __trace_puts()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tracing-remove-size-parameter-in-__trace_puts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tracing-remove-size-parameter-in-__trace_puts.patch

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
From: Steven Rostedt <rostedt@goodmis.org>
Subject: tracing: Remove size parameter in __trace_puts()
Date: Thu, 15 Jan 2026 23:25:08 -0500

The __trace_puts() function takes a string pointer and the size of the
string itself.  All users currently simply pass in the strlen() of the
string it is also passing in.  There's no reason to pass in the size. 
Instead have the __trace_puts() function do the strlen() within the
function itself.

This fixes a header recursion issue where using strlen() in the macro
calling __trace_puts() requires adding #include <linux/string.h> in order
to use strlen().  Removing the use of strlen() from the header fixes the
recursion issue.

Link: https://lore.kernel.org/all/aUN8Hm377C5A0ILX@yury/
Link: https://lkml.kernel.org/r/20260116042510.241009-6-ynorov@nvidia.com
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++--
 kernel/trace/trace.c   |    7 +++----
 kernel/trace/trace.h   |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/kernel.h~tracing-remove-size-parameter-in-__trace_puts
+++ a/include/linux/kernel.h
@@ -328,10 +328,10 @@ int __trace_printk(unsigned long ip, con
 	if (__builtin_constant_p(str))					\
 		__trace_bputs(_THIS_IP_, trace_printk_fmt);		\
 	else								\
-		__trace_puts(_THIS_IP_, str, strlen(str));		\
+		__trace_puts(_THIS_IP_, str);				\
 })
 extern int __trace_bputs(unsigned long ip, const char *str);
-extern int __trace_puts(unsigned long ip, const char *str, int size);
+extern int __trace_puts(unsigned long ip, const char *str);
 
 extern void trace_dump_stack(int skip);
 
--- a/kernel/trace/trace.c~tracing-remove-size-parameter-in-__trace_puts
+++ a/kernel/trace/trace.c
@@ -1178,11 +1178,10 @@ EXPORT_SYMBOL_GPL(__trace_array_puts);
  * __trace_puts - write a constant string into the trace buffer.
  * @ip:	   The address of the caller
  * @str:   The constant string to write
- * @size:  The size of the string.
  */
-int __trace_puts(unsigned long ip, const char *str, int size)
+int __trace_puts(unsigned long ip, const char *str)
 {
-	return __trace_array_puts(printk_trace, ip, str, size);
+	return __trace_array_puts(printk_trace, ip, str, strlen(str));
 }
 EXPORT_SYMBOL_GPL(__trace_puts);
 
@@ -1201,7 +1200,7 @@ int __trace_bputs(unsigned long ip, cons
 	int size = sizeof(struct bputs_entry);
 
 	if (!printk_binsafe(tr))
-		return __trace_puts(ip, str, strlen(str));
+		return __trace_puts(ip, str);
 
 	if (!(tr->trace_flags & TRACE_ITER(PRINTK)))
 		return 0;
--- a/kernel/trace/trace.h~tracing-remove-size-parameter-in-__trace_puts
+++ a/kernel/trace/trace.h
@@ -2116,7 +2116,7 @@ extern void tracing_log_err(struct trace
  * about performance). The internal_trace_puts() is for such
  * a purpose.
  */
-#define internal_trace_puts(str) __trace_puts(_THIS_IP_, str, strlen(str))
+#define internal_trace_puts(str) __trace_puts(_THIS_IP_, str)
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)	\
_

Patches currently in -mm which might be from rostedt@goodmis.org are

tracing-remove-size-parameter-in-__trace_puts.patch

