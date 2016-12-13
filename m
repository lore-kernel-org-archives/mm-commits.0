From: akpm@linux-foundation.org
Subject: [patch 097/123] fs/proc/array.c: slightly improve render_sigset_t
Date: Mon, 12 Dec 2016 16:45:25 -0800
Message-ID: <584f44a5.Wupgq5XW2WuJAB3L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMAp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, linux@rasmusvillemoes.dk, adobriyan@gmail.com, avagin@openvz.org, keescook@chromium.org

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
Acked-by: Andrei Vagin <avagin@openvz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
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
