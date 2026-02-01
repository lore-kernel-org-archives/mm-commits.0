Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610553EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905013; cv=none; b=NRTSZ6YrJhTHDNiOoI3HQp6TehRDRWF9HFTQPg8i+I8r2lyHANWWM3v+nZYO02ySPA+Uts1f9oMMFMKhhlrPg1ka+Tms6HafNh3EIqH9vKKjnm4x/LwIWw/b2eRFc2qTOQEwJ4xCVUwnlzY3szTJ/3RxFC0pkBmpSZJZ2pwaQg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905013; c=relaxed/simple;
	bh=00jU3YPJxb9fQxo0U/zA7zRJfRetL4dSBzNxjlnbU8w=;
	h=Date:To:From:Subject:Message-Id; b=jcr/ZSfV61nTTRGLqNfKrsW06kgRPj+yhXUwDpGq9VUu+1SA+pvXgFsQrfkry4iNqBZvW5Kd5P9VlHMKe5NLpWJhl3lP7TKO22/ccC35FSvwjRPLxlSEBGpPtMvITKuLAK/toLuMSSfxPQGsBOSrjACkat2hde6zFZHTJfk0d3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BK6stPs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BK6stPs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3C6C4CEF1;
	Sun,  1 Feb 2026 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905013;
	bh=00jU3YPJxb9fQxo0U/zA7zRJfRetL4dSBzNxjlnbU8w=;
	h=Date:To:From:Subject:From;
	b=BK6stPs+dMF3TKvdrAVDMp3kP+eWIk5FnOWtUfQTGsg/z3HJSlSmRuEyW6Vx0IcaM
	 stDZX2vAOI6NYf51Mtyyyn49v3q1FAPoGHVxKw10ld/PK9F5f2y6o5H+y3H/eWVDi+
	 fxoc7dS0yrQ1DKqMb9HGhfQvDxHF+kYgbah/bpG4=
Date: Sat, 31 Jan 2026 16:16:52 -0800
To: mm-commits@vger.kernel.org,ynorov@nvidia.com,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tracing-remove-size-parameter-in-__trace_puts.patch removed from -mm tree
Message-Id: <20260201001653.2C3C6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tracing: remove size parameter in __trace_puts()
has been removed from the -mm tree.  Its filename was
     tracing-remove-size-parameter-in-__trace_puts.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: tracing: remove size parameter in __trace_puts()
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


