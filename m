From: akpm@linux-foundation.org
Subject: +
 proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status.patch
 added to -mm tree
Date: Fri, 16 Feb 2018 15:51:15 -0800
Message-ID: <5a876e73.CQhqRz1NxNCk07nA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbeBPXvQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:51:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: replace seq_printf by seq_put_smth to speed up /proc/pid/status
has been added to the -mm tree.  Its filename is
     proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: proc: replace seq_printf by seq_put_smth to speed up /proc/pid/status

seq_printf() works slower than seq_puts, seq_puts, etc.

== test_proc.c
int main(int argc, char **argv)
{
	int n, i, fd;
	char buf[16384];

	n = atoi(argv[1]);
	for (i = 0; i < n; i++) {
		fd = open(argv[2], O_RDONLY);
		if (fd < 0)
			return 1;
		if (read(fd, buf, sizeof(buf)) <= 0)
			return 1;
		close(fd);
	}

	return 0;
}
==

$ time ./test_proc  1000000 /proc/1/status

== Before path ==
real	0m5.171s
user	0m0.328s
sys	0m4.783s

== After patch ==
real	0m4.761s
user	0m0.334s
sys	0m4.366s

Link: http://lkml.kernel.org/r/20180212074931.7227-4-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/proc/array.c~proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status fs/proc/array.c
--- a/fs/proc/array.c~proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status
+++ a/fs/proc/array.c
@@ -174,7 +174,8 @@ static inline void task_state(struct seq
 
 	if (umask >= 0)
 		seq_printf(m, "Umask:\t%#04o\n", umask);
-	seq_printf(m, "State:\t%s", get_task_state(p));
+	seq_puts(m, "State:\t");
+	seq_puts(m, get_task_state(p));
 
 	seq_put_decimal_ull(m, "\nTgid:\t", tgid);
 	seq_put_decimal_ull(m, "\nNgid:\t", ngid);
@@ -300,8 +301,8 @@ static void render_cap_t(struct seq_file
 
 	seq_puts(m, header);
 	CAP_FOR_EACH_U32(__capi) {
-		seq_printf(m, "%08x",
-			   a->cap[CAP_LAST_U32 - __capi]);
+		seq_put_hex_ll(m, NULL,
+			   a->cap[CAP_LAST_U32 - __capi], 8);
 	}
 	seq_putc(m, '\n');
 }
@@ -355,7 +356,8 @@ static void task_cpus_allowed(struct seq
 
 static inline void task_core_dumping(struct seq_file *m, struct mm_struct *mm)
 {
-	seq_printf(m, "CoreDumping:\t%d\n", !!mm->core_state);
+	seq_put_decimal_ull(m, "CoreDumping:\t", !!mm->core_state);
+	seq_putc(m, '\n');
 }
 
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
@@ -491,7 +493,11 @@ static int do_task_stat(struct seq_file
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(task->real_start_time);
 
-	seq_printf(m, "%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
+	seq_put_decimal_ull(m, "", pid_nr_ns(pid, ns));
+	seq_puts(m, " (");
+	seq_puts(m, tcomm);
+	seq_puts(m, ") ");
+	seq_putc(m, state);
 	seq_put_decimal_ll(m, " ", ppid);
 	seq_put_decimal_ll(m, " ", pgid);
 	seq_put_decimal_ll(m, " ", sid);
_

Patches currently in -mm which might be from avagin@openvz.org are

procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch
proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps.patch
proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps.patch
proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull.patch
proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status.patch

