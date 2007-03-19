From: akpm@linux-foundation.org
Subject: + getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch added to -mm tree
Date: Mon, 19 Mar 2007 14:26:26 -0700
Message-ID: <200703192126.l2JLQR4B017712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030528AbXCSV1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 17:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, oleg@tv-sign.ru


The patch titled
     getrusage(): fill ru_inblock and ru_oublock fields if possible
has been added to the -mm tree.  Its filename is
     getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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

 include/linux/task_io_accounting_ops.h |   28 +++++++++++++++++++++++
 kernel/sys.c                           |    7 +++++
 2 files changed, 35 insertions(+)

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
@@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw =3D p->signal->cnivcsw;
 			r->ru_minflt =3D p->signal->cmin_flt;
 			r->ru_majflt =3D p->signal->cmaj_flt;
+			r->ru_inblock =3D task_io_get_inblock(p);
+			r->ru_oublock =3D task_io_get_oublock(p);
=20
 			if (who =3D=3D RUSAGE_CHILDREN)
 				break;
@@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw +=3D p->signal->nivcsw;
 			r->ru_minflt +=3D p->signal->min_flt;
 			r->ru_majflt +=3D p->signal->maj_flt;
+			r->ru_inblock +=3D task_io_get_inblock(p);
+			r->ru_oublock +=3D task_io_get_oublock(p);
 			t =3D p;
 			do {
 				utime =3D cputime_add(utime, t->utime);
@@ -2040,6 +2045,8 @@ static void k_getrusage(struct task_stru
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

optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-const=
ify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
