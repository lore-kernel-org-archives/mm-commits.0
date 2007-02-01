From: akpm@osdl.org
Subject: + make-__sigqueue_free-and.patch added to -mm tree
Date: Thu, 01 Feb 2007 15:04:43 -0800
Message-ID: <200702012304.l11N4hex025711@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422696AbXBAXI1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 18:08:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: make __sigqueue_free() and  __sigqueue_alloc() non static
has been added to the -mm tree.  Its filename is
     make-__sigqueue_free-and.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: aio: make __sigqueue_free() and  __sigqueue_alloc() non static
=46rom: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

Allow subsystems to directly call into __sigqueue_alloc() and __sigqueu=
e_free.
This is used by the AIO signal notification patch.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Bharata B Rao <bharata@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Benjamin LaHaise <bcrl@linux.intel.com>
Cc: Jean Pierre Dion <jean-pierre.dion@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/signal.h |    3 +++
 kernel/signal.c        |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/signal.h~make-__sigqueue_free-and include/linux=
/signal.h
--- a/include/linux/signal.h~make-__sigqueue_free-and
+++ a/include/linux/signal.h
@@ -241,6 +241,9 @@ extern int sigprocmask(int, sigset_t *,=20
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *=
return_ka, struct pt_regs *regs, void *cookie);
 extern struct task_struct * sigevent_find_task(sigevent_t *);
+extern struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t =
flags,
+					 int override_rlimit);
+extern void __sigqueue_free(struct sigqueue *q);
=20
 extern struct kmem_cache *sighand_cachep;
=20
diff -puN kernel/signal.c~make-__sigqueue_free-and kernel/signal.c
--- a/kernel/signal.c~make-__sigqueue_free-and
+++ a/kernel/signal.c
@@ -267,8 +267,8 @@ next_signal(struct sigpending *pending,=20
 	return sig;
 }
=20
-static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t =
flags,
-					 int override_rlimit)
+struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
+				  int override_rlimit)
 {
 	struct sigqueue *q =3D NULL;
 	struct user_struct *user;
@@ -294,7 +294,7 @@ static struct sigqueue *__sigqueue_alloc
 	return(q);
 }
=20
-static void __sigqueue_free(struct sigqueue *q)
+void __sigqueue_free(struct sigqueue *q)
 {
 	if (q->flags & SIGQUEUE_PREALLOC)
 		return;
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
add-listio-syscall-support.patch
