From: akpm@linux-foundation.org
Subject: [alternative-merged]
 fs-proc-arrayc-slightly-improve-render_sigset_t.patch removed from -mm tree
Date: Tue, 08 Nov 2016 14:21:52 -0800
Message-ID: <58225000.bIbHI5uFHPYXZ0NR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932197AbcKHWVx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 17:21:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: slightly improve render_sigset_t
has been removed from the -mm tree.  Its filename was
     fs-proc-arrayc-slightly-improve-render_sigset_t.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: fs/proc/array.c: slightly improve render_sigset_t

format_decode and vsnprintf occasionally show up in perf top, so I went
looking for places that might not need the full printf power.  With the
help of kprobes, I gathered some statistics on which format strings we
mostly pass to vsnprintf.  On a trivial desktop workload, I hit "%x" 25%
of the time, so something apparently reads /proc/pid/status (which does
5*16 printf("%x") calls) a lot.

With this patch, reading /proc/pid/status is 30% faster according to
this microbenchmark:

	char buf[4096];
	int i, fd;
	for (i = 0; i < 10000; ++i) {
		fd = open("/proc/self/status", O_RDONLY);
		read(fd, buf, sizeof(buf));
		close(fd);
	}

Link: http://lkml.kernel.org/r/1474410485-1305-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~fs-proc-arrayc-slightly-improve-render_sigset_t fs/proc/array.c
--- a/fs/proc/array.c~fs-proc-arrayc-slightly-improve-render_sigset_t
+++ a/fs/proc/array.c
@@ -245,7 +245,7 @@ void render_sigset_t(struct seq_file *m,
 		if (sigismember(set, i+2)) x |= 2;
 		if (sigismember(set, i+3)) x |= 4;
 		if (sigismember(set, i+4)) x |= 8;
-		seq_printf(m, "%x", x);
+		seq_putc(m, hex_asc[x]);
 	} while (i >= 4);
 
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


