From: akpm@linux-foundation.org
Subject: - getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:36 -0700
Message-ID: <200705120533.l4C5XaiC002127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755108AbXELFeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     getrusage(): fill ru_inblock and ru_oublock fields if possible
has been removed from the -mm tree.  Its filename was
     getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: getrusage(): fill ru_inblock and ru_oublock fields if possible
=46rom: Eric Dumazet <dada1@cosmosbay.com>

If CONFIG_TASK_IO_ACCOUNTING is defined, we update io accounting counte=
rs for
each task.

This patch permits reporting of values using the well known getrusage()=
=20
syscall, filling ru_inblock and ru_oublock instead of null values.

As TASK_IO_ACCOUNTING currently counts bytes counts, we approximate blo=
cks
count doing : nr_blocks =3D nr_bytes / 512

Example of use :
----------------------
After patch is applied, /usr/bin/time command can now give a good=20
approximation of IO that the process had to do.

$ /usr/bin/time grep tototo /usr/include/*
Command exited with non-zero status 1
0.00user 0.02system 0:02.11elapsed 1%CPU (0avgtext+0avgdata 0maxresiden=
t)k
24288inputs+0outputs (0major+259minor)pagefaults 0swaps

$ /usr/bin/time dd if=3D/dev/zero of=3D/tmp/testfile count=3D1000
1000+0 enregistrements lus
1000+0 enregistrements =E9crits
512000 octets (512 kB) copi=E9s, 0,00326601 seconde, 157 MB/s
0.00user 0.00system 0:00.00elapsed 80%CPU (0avgtext+0avgdata 0maxreside=
nt)k
0inputs+3000outputs (0major+299minor)pagefaults 0swaps

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h                  |    1=20
 include/linux/task_io_accounting_ops.h |   28 +++++++++++++++++++++++
 kernel/exit.c                          |    9 +++++++
 kernel/fork.c                          |    1=20
 kernel/sys.c                           |    7 +++++
 5 files changed, 46 insertions(+)

diff -puN include/linux/sched.h~getrusage-fill-ru_inblock-and-ru_oubloc=
k-fields-if-possible include/linux/sched.h
--- a/include/linux/sched.h~getrusage-fill-ru_inblock-and-ru_oublock-fi=
elds-if-possible
+++ a/include/linux/sched.h
@@ -469,6 +469,7 @@ struct signal_struct {
 	cputime_t utime, stime, cutime, cstime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
+	unsigned long inblock, oublock, cinblock, coublock;
=20
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
diff -puN include/linux/task_io_accounting_ops.h~getrusage-fill-ru_inbl=
ock-and-ru_oublock-fields-if-possible include/linux/task_io_accounting_=
ops.h
--- a/include/linux/task_io_accounting_ops.h~getrusage-fill-ru_inblock-=
and-ru_oublock-fields-if-possible
+++ a/include/linux/task_io_accounting_ops.h
@@ -10,11 +10,29 @@ static inline void task_io_account_read(
 	current->ioac.read_bytes +=3D bytes;
 }
=20
+/*
+ * We approximate number of blocks, because we account bytes only.
+ * A 'block' is 512 bytes
+ */
+static inline unsigned long task_io_get_inblock(const struct task_stru=
ct *p)
+{
+	return p->ioac.read_bytes >> 9;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 	current->ioac.write_bytes +=3D bytes;
 }
=20
+/*
+ * We approximate number of blocks, because we account bytes only.
+ * A 'block' is 512 bytes
+ */
+static inline unsigned long task_io_get_oublock(const struct task_stru=
ct *p)
+{
+	return p->ioac.write_bytes >> 9;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 	current->ioac.cancelled_write_bytes +=3D bytes;
@@ -31,10 +49,20 @@ static inline void task_io_account_read(
 {
 }
=20
+static inline unsigned long task_io_get_inblock(const struct task_stru=
ct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 }
=20
+static inline unsigned long task_io_get_oublock(const struct task_stru=
ct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 }
diff -puN kernel/exit.c~getrusage-fill-ru_inblock-and-ru_oublock-fields=
-if-possible kernel/exit.c
--- a/kernel/exit.c~getrusage-fill-ru_inblock-and-ru_oublock-fields-if-=
possible
+++ a/kernel/exit.c
@@ -42,6 +42,7 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/blkdev.h>
+#include <linux/task_io_accounting_ops.h>
=20
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -113,6 +114,8 @@ static void __exit_signal(struct task_st
 		sig->nvcsw +=3D tsk->nvcsw;
 		sig->nivcsw +=3D tsk->nivcsw;
 		sig->sched_time +=3D tsk->sched_time;
+		sig->inblock +=3D task_io_get_inblock(tsk);
+		sig->oublock +=3D task_io_get_oublock(tsk);
 		sig =3D NULL; /* Marker for below. */
 	}
=20
@@ -1193,6 +1196,12 @@ static int wait_task_zombie(struct task_
 			p->nvcsw + sig->nvcsw + sig->cnvcsw;
 		psig->cnivcsw +=3D
 			p->nivcsw + sig->nivcsw + sig->cnivcsw;
+		psig->cinblock +=3D
+			task_io_get_inblock(p) +
+			sig->inblock + sig->cinblock;
+		psig->coublock +=3D
+			task_io_get_oublock(p) +
+			sig->oublock + sig->coublock;
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
=20
diff -puN kernel/fork.c~getrusage-fill-ru_inblock-and-ru_oublock-fields=
-if-possible kernel/fork.c
--- a/kernel/fork.c~getrusage-fill-ru_inblock-and-ru_oublock-fields-if-=
possible
+++ a/kernel/fork.c
@@ -875,6 +875,7 @@ static inline int copy_signal(unsigned l
 	sig->utime =3D sig->stime =3D sig->cutime =3D sig->cstime =3D cputime=
_zero;
 	sig->nvcsw =3D sig->nivcsw =3D sig->cnvcsw =3D sig->cnivcsw =3D 0;
 	sig->min_flt =3D sig->maj_flt =3D sig->cmin_flt =3D sig->cmaj_flt =3D=
 0;
+	sig->inblock =3D sig->oublock =3D sig->cinblock =3D sig->coublock =3D=
 0;
 	sig->sched_time =3D 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
diff -puN kernel/sys.c~getrusage-fill-ru_inblock-and-ru_oublock-fields-=
if-possible kernel/sys.c
--- a/kernel/sys.c~getrusage-fill-ru_inblock-and-ru_oublock-fields-if-p=
ossible
+++ a/kernel/sys.c
@@ -29,6 +29,7 @@
 #include <linux/signal.h>
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
+#include <linux/task_io_accounting_ops.h>
=20
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -2082,6 +2083,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw =3D p->signal->cnivcsw;
 			r->ru_minflt =3D p->signal->cmin_flt;
 			r->ru_majflt =3D p->signal->cmaj_flt;
+			r->ru_inblock =3D p->signal->cinblock;
+			r->ru_oublock =3D p->signal->coublock;
=20
 			if (who =3D=3D RUSAGE_CHILDREN)
 				break;
@@ -2093,6 +2096,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw +=3D p->signal->nivcsw;
 			r->ru_minflt +=3D p->signal->min_flt;
 			r->ru_majflt +=3D p->signal->maj_flt;
+			r->ru_inblock +=3D p->signal->inblock;
+			r->ru_oublock +=3D p->signal->oublock;
 			t =3D p;
 			do {
 				utime =3D cputime_add(utime, t->utime);
@@ -2101,6 +2106,8 @@ static void k_getrusage(struct task_stru
 				r->ru_nivcsw +=3D t->nivcsw;
 				r->ru_minflt +=3D t->min_flt;
 				r->ru_majflt +=3D t->maj_flt;
+				r->ru_inblock +=3D task_io_get_inblock(t);
+				r->ru_oublock +=3D task_io_get_oublock(t);
 				t =3D next_thread(t);
 			} while (t !=3D p);
 			break;
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
lguest-the-host-code.patch
