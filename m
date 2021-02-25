Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD93C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 21:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08B4A64F2C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 21:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhBYVtO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 16:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234055AbhBYVtM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 16:49:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83EAE64F2C;
        Thu, 25 Feb 2021 21:48:30 +0000 (UTC)
Date:   Thu, 25 Feb 2021 16:48:29 -0500
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
Message-ID: <20210225164829.30fe227d@gandalf.local.home>
In-Reply-To: <20210225125741.4fc7e43e@gandalf.local.home>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <20210224210740.73273c7a@oasis.local.home>
        <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
        <20210225093128.4cd86439@gandalf.local.home>
        <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
        <20210225125741.4fc7e43e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 25 Feb 2021 12:57:41 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > So "%pD" takes a "struct file *" pointer, and follows it to the
> > dentry, and then from the dentry to the name. So it will in fact
> > follow pointers even more than "%s" does.  
> 
> Correct, as I've told people about that as well.
> 
> > 
> > It might indeed be worth having a warning for TP_printk() about any of
> > the formats that follow a pointer, exactly because of the whole "by
> > the time it actually prints, the pointer may be long gone".
> >  
> 
> Just a comment? Or should we add some check that gives a warning for when
> one of these are used? That can be done at boot up or module load. (note, %s
> can be OK for some cases, as mentioned in a previous email).

My fix for the patch in this thread is currently going through my test
suite.

But I just made this patch (not applied to any tree yet) that checks the
print format of every event when they are registered, and if it contains a
dereference pointer that does not point to the code in the ring buffer
(either via an address '&' or the field being an array), then it will give
a big warning.

So far it hasn't triggered on any of the events that I have compiled in,
although it did trigger when I didn't parse correctly.

Is this something that I should add? (with better comments and such)

Because strings may be allowed if the trace point always passes in
something that is not freed, I would need to add a post processing check
(before the string is printed out) to make sure that no string is
dereferenced that doesn't point to kernel read only memory, and refuse to
print it if it does (and trigger a warning as well). That would have caught
the bug in this patch.

-- Steve

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a3563afd412d..fc691f054fb6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -217,6 +217,172 @@ int trace_event_get_offsets(struct trace_event_call *call)
 	return tail->offset + tail->size;
 }
 
+static bool test_field(const char *fmt, struct trace_event_call *call)
+{
+	struct trace_event_fields *field = call->class->fields_array;
+	const char *array_descriptor;
+	const char *p = fmt;
+	int len;
+
+	if (!(len = str_has_prefix(fmt, "REC->")))
+		return false;
+	fmt += len;
+	for (p = fmt; *p; p++) {
+		if (!isalnum(*p) && *p != '_')
+			break;
+	}
+	len = p - fmt;
+
+	for (; field->type; field++) {
+		if (strncmp(field->name, fmt, len) ||
+		    field->name[len])
+			continue;
+		array_descriptor = strchr(field->type, '[');
+		if (str_has_prefix(field->type, "__data_loc"))
+			array_descriptor = NULL;
+		/* This is an array and is OK to dereference. */
+		return array_descriptor != NULL;
+	}
+	return false;
+}
+
+/* For type cast only, does not handle quotes */
+static int skip_parens(const char *fmt)
+{
+	int parens = 0;
+	int i;
+
+	for (i = 0; fmt[i]; i++) {
+		switch (fmt[i]) {
+		case '(':
+			parens++;
+			break;
+		case ')':
+			if (!--parens)
+				return i + 1;
+		}
+	}
+	return i;
+}
+
+static void test_event_printk(struct trace_event_call *call)
+{
+	u64 dereference_flags = 0;
+	bool first = true;
+	const char *fmt;
+	int parens = 0;
+	char in_quote = 0;
+	int start_arg = 0;
+	int arg = 0;
+	int i;
+
+	fmt = call->print_fmt;
+
+	if (!fmt)
+		return;
+
+	for (i = 0; fmt[i]; i++) {
+		switch (fmt[i]) {
+		case '\\':
+			i++;
+			if (!fmt[i])
+				return;
+			continue;
+		case '"':
+		case '\'':
+			if (first) {
+				if (fmt[i] == '\'')
+					continue;
+				if (in_quote) {
+					arg = 0;
+					first = false;
+				}
+			}
+			if (in_quote) {
+				if (in_quote == fmt[i])
+					in_quote = 0;
+			} else {
+				in_quote = fmt[i];
+			}
+			continue;
+		case '%':
+			if (!first || !in_quote)
+				continue;
+			i++;
+			if (!fmt[i])
+				return;
+			switch (fmt[i]) {
+			case '%':
+				continue;
+			case 'p':
+				/* Find dereferencing fields */
+				switch (fmt[i + 1]) {
+				case 'B': case 'R': case 'r':
+				case 'b': case 'M': case 'm':
+				case 'I': case 'i': case 'E':
+				case 'U': case 'V': case 'N':
+				case 'a': case 'd': case 'D':
+				case 'g': case 't': case 'C':
+				case 'O': case 'f':
+					if (WARN_ONCE(arg == 63,
+						      "Event: %s",
+						      trace_event_name(call)))
+						return;
+					dereference_flags |= 1ULL << arg;
+				}
+				break;
+			}
+			arg++;
+			continue;
+		case '(':
+			if (in_quote)
+				continue;
+			parens++;
+			continue;
+		case ')':
+			if (in_quote)
+				continue;
+			parens--;
+			if (WARN_ONCE(parens < 0, "Event: %s\narg='%s'\n%*s",
+				      trace_event_name(call),
+				      fmt + start_arg,
+				      (i - start_arg) + 5, "^"))
+				return;
+			continue;
+		case ',':
+			if (in_quote || parens)
+				continue;
+			i++;
+			while (isspace(fmt[i]))
+				i++;
+			if (fmt[i] == '(')
+				i += skip_parens(fmt + i);
+			start_arg = i;
+			/* dereferenced pointers are fine here */
+			if (fmt[i] == '&')
+				dereference_flags &= ~(1ULL << arg);
+
+			if (dereference_flags & (1ULL << arg)) {
+				if (test_field(fmt + i, call))
+					dereference_flags &= ~(1ULL << arg);
+			}
+			i--;
+			arg++;
+		}
+	}
+
+	if (WARN_ON_ONCE(dereference_flags)) {
+		arg = 0;
+		while (!(dereference_flags & 1)) {
+			dereference_flags >>= 1;
+			arg++;
+		}
+		pr_warn("event %s has unsafe dereference of argument %d\n",
+			trace_event_name(call), arg);
+		pr_warn("print_fmt: %s\n", fmt);
+	}
+}
+
 int trace_event_raw_init(struct trace_event_call *call)
 {
 	int id;
@@ -225,6 +391,8 @@ int trace_event_raw_init(struct trace_event_call *call)
 	if (!id)
 		return -ENODEV;
 
+	test_event_printk(call);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);
