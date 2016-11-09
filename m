From: akpm@linux-foundation.org
Subject: [withdrawn] proc-optimize-render_sigset_t.patch removed from -mm
 tree
Date: Wed, 09 Nov 2016 13:44:47 -0800
Message-ID: <582398cf.wEXAovMgYMNCJU+p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752802AbcKIVos (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2016 16:44:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/array.c: optimize render_sigset_t()
has been removed from the -mm tree.  Its filename was
     proc-optimize-render_sigset_t.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: fs/proc/array.c: optimize render_sigset_t()

render_sigset_t() requires about 30% of time to generate /proc/pid/status.

- 74.44% sys_read
 - 74.40% vfs_read
    - 74.01% __vfs_read
       - 73.36% seq_read
          - 72.97% proc_single_show
             - 72.26% proc_pid_status
                + 29.79% render_sigset_t
                + 11.47% task_mem
                + 5.60% render_cap_t
                + 4.95% seq_printf
                + 4.28% cpuset_task_status_allowed

seq_printf is called for each symbol of a signal mask.  This patch collect
a whole mask in a buffer and prints it for one call of seq_puts().

  - 65.02% proc_single_show
     - 63.75% proc_pid_status
        + 15.73% task_mem
        + 7.42% render_sigset_t
        + 7.39% render_cap_t
        + 6.46% cpuset_task_status_allowed

/proc/pid/status is generated 25% faster with this optimization.

Link: http://lkml.kernel.org/r/1478641048-11406-1-git-send-email-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/proc/array.c~proc-optimize-render_sigset_t fs/proc/array.c
--- a/fs/proc/array.c~proc-optimize-render_sigset_t
+++ a/fs/proc/array.c
@@ -232,11 +232,13 @@ static inline void task_state(struct seq
 void render_sigset_t(struct seq_file *m, const char *header,
 				sigset_t *set)
 {
-	int i;
+	char buf[_NSIG / 4 + 2];
+	int i, j;
 
 	seq_puts(m, header);
 
 	i = _NSIG;
+	j = 0;
 	do {
 		int x = 0;
 
@@ -245,10 +247,13 @@ void render_sigset_t(struct seq_file *m,
 		if (sigismember(set, i+2)) x |= 2;
 		if (sigismember(set, i+3)) x |= 4;
 		if (sigismember(set, i+4)) x |= 8;
-		seq_printf(m, "%x", x);
+		buf[j++] = hex_asc[x];
 	} while (i >= 4);
 
-	seq_putc(m, '\n');
+	buf[j++] = '\n';
+	buf[j++] = 0;
+
+	seq_puts(m, buf);
 }
 
 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
_

Patches currently in -mm which might be from avagin@openvz.org are


