Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83C0C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 15:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5B764E02
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 15:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZPzT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 10:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhBZPzS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 10:55:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7593564ED5;
        Fri, 26 Feb 2021 15:54:33 +0000 (UTC)
Date:   Fri, 26 Feb 2021 10:54:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jacob Wen <jian.w.wen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
Message-ID: <20210226105431.03786c7b@gandalf.local.home>
In-Reply-To: <20210225164829.30fe227d@gandalf.local.home>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <20210224210740.73273c7a@oasis.local.home>
        <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
        <20210225093128.4cd86439@gandalf.local.home>
        <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
        <20210225125741.4fc7e43e@gandalf.local.home>
        <20210225164829.30fe227d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 25 Feb 2021 16:48:29 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Because strings may be allowed if the trace point always passes in
> something that is not freed, I would need to add a post processing check
> (before the string is printed out) to make sure that no string is
> dereferenced that doesn't point to kernel read only memory, and refuse to
> print it if it does (and trigger a warning as well). That would have caught
> the bug in this patch.

The below patch catches cases that unsafe strings are dereferenced. For
example:

  kmem_cache_free: call_site=__i915_gem_free_object_rcu+0x30/0x40 [i915] ptr=00000000f445da7e name=(0xffff8b01456930a0:drm_i915_gem_object)[UNSAFE-MEMORY]

Note, I plan on changing this to make it an opt in option to display the
string that is unsafe (as it is unsafe to display it) but may be necessary
to see what those strings are to see why its unsafe and debug it.

Note, because it allows strings that are constant in the core kernel, it
doesn't always complain:

  kmem_cache_free: call_site=unlink_anon_vmas+0x79/0x1e0 ptr=0000000056c4302b name=anon_vma_chain
  kmem_cache_free: call_site=__put_anon_vma+0x4e/0xe0 ptr=00000000e658eb73 name=anon_vma

It gives a big warning when it does trigger, so it shouldn't be missed.

I'll add more comments and make this ready for the next merge window. At
least now it should catch cases when people add unsafe strings, and be less
reliant on me needing to police all trace event submissions.

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e295c413580e..0bd76873a7f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3551,6 +3551,89 @@ static char *trace_iter_expand_format(struct trace_iterator *iter)
 	return tmp;
 }
 
+static bool trace_safe_str(struct trace_iterator *iter, const char *str)
+{
+	unsigned long addr = (unsigned long)str;
+
+	/* OK if part of the event data */
+	if ((addr >= (unsigned long)iter->ent) &&
+	    (addr < (unsigned long)iter->ent + iter->ent_size))
+		return true;
+	/* OK if part of the temp seq buffer */
+	if ((addr >= (unsigned long)iter->tmp_seq.buffer) &&
+	    (addr < (unsigned long)iter->tmp_seq.buffer + PAGE_SIZE))
+		return true;
+	/* Core rodata can not be freed */
+	if (is_kernel_rodata(addr))
+		return true;
+	return false;
+}
+
+void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
+			 va_list ap)
+{
+	const char *p = fmt;
+	const char *str;
+	int i, j;
+
+	if (WARN_ON_ONCE(!fmt))
+		return;
+
+	/* Don't bother checking when doing a ftrace_dump() */
+	if (iter->fmt == static_fmt_buf)
+		goto print;
+
+	while (*p) {
+		j = 0;
+
+		for (i = 0; p[i]; i++) {
+			if (i + 1 >= iter->fmt_size) {
+				if (!trace_iter_expand_format(iter))
+					goto print;
+			}
+
+			if (p[i] == '\\' && p[i+1]) {
+				i++;
+				continue;
+			}
+			if (p[i] == '%') {
+				for (j = 1; p[i+j]; j++) {
+					if (isdigit(p[i+j]) ||
+					    p[i+j] == '*' ||
+					    p[i+j] == '.')
+						continue;
+					break;
+				}
+				if (p[i+j] == 's')
+					break;
+			}
+			j = 0;
+		}
+		if (!p[i])
+			break;
+
+		strncpy(iter->fmt, p, i);
+		iter->fmt[i] = '\0';
+		trace_seq_vprintf(&iter->seq, iter->fmt, ap);
+
+		str = va_arg(ap, const char *);
+		if (WARN_ON_ONCE(!trace_safe_str(iter, str))) {
+			trace_seq_printf(&iter->seq, "(0x%px:%s)", str, str);
+			str = "[UNSAFE-MEMORY]";
+			strcpy(iter->fmt, "%s");
+		} else {
+			strncpy(iter->fmt, p + i, j + 1);
+			iter->fmt[j+1] = '\0';
+		}
+		trace_seq_printf(&iter->seq, iter->fmt, str);
+
+		p += i + j + 1;
+	}
+ print:
+	if (*p)
+		trace_seq_vprintf(&iter->seq, p, ap);
+}
+
 const char *trace_event_format(struct trace_iterator *iter, const char *fmt)
 {
 	const char *p, *new_fmt;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index dec13ff66077..5e41b5fd5318 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -582,6 +582,8 @@ void trace_buffer_unlock_commit_nostack(struct trace_buffer *buffer,
 					struct ring_buffer_event *event);
 
 const char *trace_event_format(struct trace_iterator *iter, const char *fmt);
+void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
+			 va_list ap);
 
 int trace_empty(struct trace_iterator *iter);
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 61255bad7e01..a0146e1fffdf 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -317,7 +317,7 @@ void trace_event_printf(struct trace_iterator *iter, const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	trace_seq_vprintf(&iter->seq, trace_event_format(iter, fmt), ap);
+	trace_check_vprintf(iter, trace_event_format(iter, fmt), ap);
 	va_end(ap);
 }
 EXPORT_SYMBOL(trace_event_printf);
