Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794698489;
	b=UeS4firHWLBNMzJdc0ZFNhKnLnjhAPy1iOWWtvXKLmsdkcHVhO8aQKKIDANPMwBWDbJ4
	 hqNRrfRTd5vunPeW2urrNM58saN83KAPPyswn+CV0hTH4XlIy3/MKMXGoRLYqs4T/Fk5r
	 8bjZY7CB0Sho8n8fyHPgEYpgO/cFql1fQKUfYlkKLlnPsqdBTrOxgYZ1fw7RwZWDYWqyy
	 I8hZOVBKb0ttSLWlJRygV9+Q+7NupgqJRztvnR563WathnsZGLXi98HoFik+ErnySAJsQ
	 8DHWg8yM29z2mnJcrb8q22vzUvLVZkCqlCj0uKVLcK5E6aac0QGBBNCZR5H7+EkYt6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698489;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=B+f3+gDyfyVvD0h0pPBUZxnjUu1WDovrMoJhhdxQFnw=;
	b=kY8ztzC9w9DqokPI4hMt6tJI4JpUMv2J7v/azRCA1fYPip5dJ1y8bWDhbN3z8B6AniAP
	 C9sPFZdh4vE7h3AcGYJ6xyMxpUdrUWY4OovF+M2dBG/771VZ4YKoPeXItqdcSxIu7IZV4
	 cIkhywUbA0PVf4TfmBGfrObkhLafl/sFdxu+m0sn6/9rSkFKE5clfl1LMC9QZAhlKlHsJ
	 //xKgu5HslPC5hBfWEQIeOP8ZYfkXa1Y8cJgS5Cmf01uYDitk6K49UrLUWFwq+hSCJVYQ
	 G/7SK27xxlgGgLVoor8QQQucwjaBYg9KG+bW9HQ7OZNE6U/2bQSwgH+Za6gI3qiYcug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oERk2MRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB95606A329
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 23:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oERk2MRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F1C1F000C4;
	Sat, 14 Nov 2026 23:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794698489;
	bh=B+f3+gDyfyVvD0h0pPBUZxnjUu1WDovrMoJhhdxQFnw=;
	h=Date:To:From:Subject;
	b=oERk2MRo2BZhiKIC82bov/WUzjGdTRuKD6bZ7rM7BYNZCY0dHK1rmbnRakUFpYtBc
	 Pn0zHlfVdnF3oOuz26Ww34EZvRtBJM6hLHxv8d2+tyr7BYGpT3e1j5e/ZO/UhVlRrJ
	 iAa1fr70SHG7m94VkjUH6e380wKqEafIjWhBkQsI=
Date: Sat, 14 Nov 2026 15:21:28 -0800
To: mm-commits@vger.kernel.org,wfelipe@google.com,ryan.roberts@arm.com,
	rppt@kernel.org,mhiramat@kernel.org,leitao@debian.org,ekffu200098@gmail.com,
	brauner@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-remove-strlcat-and-sprintf-from-do_one_initcall.patch added to mm-nonmm-unstable branch
Message-Id: <20261114232129.35F1C1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: init: remove strlcat() and sprintf() from do_one_initcall()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-remove-strlcat-and-sprintf-from-do_one_initcall.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-remove-strlcat-and-sprintf-from-do_one_initcall.patch

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
From: Thorsten Blum <blum@kernel.org>
Subject: init: remove strlcat() and sprintf() from do_one_initcall()
Date: Sat, 14 Nov 2026 12:05:31 +0100

In preparation for removing strlcat() from the kernel [1], format the
warning directly in WARN().  This also removes the temporary 64-byte
buffer and the sprintf() call while preserving the warning text.

Link: https://lore.kernel.org/20261114110531.26138-2-blum@kernel.org
Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wilson Felipe Pereira <wfelipe@google.com>

 init/main.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/init/main.c~init-remove-strlcat-and-sprintf-from-do_one_initcall
+++ a/init/main.c
@@ -1409,7 +1409,8 @@ static inline void do_trace_initcall_lev
 int __init_or_module do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
-	char msgbuf[64];
+	bool preempt_imbalanced;
+	bool irqs_left_disabled;
 	int ret;
 
 	if (initcall_blacklisted(fn))
@@ -1419,17 +1420,17 @@ int __init_or_module do_one_initcall(ini
 	ret = fn();
 	do_trace_initcall_finish(fn, ret);
 
-	msgbuf[0] = 0;
-
-	if (preempt_count() != count) {
-		sprintf(msgbuf, "preemption imbalance ");
+	preempt_imbalanced = preempt_count() != count;
+	if (preempt_imbalanced)
 		preempt_count_set(count);
-	}
-	if (irqs_disabled()) {
-		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
+
+	irqs_left_disabled = irqs_disabled();
+	if (irqs_left_disabled)
 		local_irq_enable();
-	}
-	WARN(msgbuf[0], "initcall %pS returned with %s\n", fn, msgbuf);
+
+	WARN(preempt_imbalanced || irqs_left_disabled, "initcall %pS returned with %s%s\n", fn,
+	     preempt_imbalanced ? "preemption imbalance " : "",
+	     irqs_left_disabled ? "disabled interrupts " : "");
 
 	add_latent_entropy();
 	return ret;
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch
init-use-strscpy-in-do_initcalls.patch
init-use-kmalloc-in-do_initcalls.patch
init-remove-strlcat-and-sprintf-from-do_one_initcall.patch

