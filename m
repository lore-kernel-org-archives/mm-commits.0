From: akpm@linux-foundation.org
Subject: - uml-fix-2620-hang.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:09 -0800
Message-ID: <200702170713.l1H7D9I0021436@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946442AbXBQHO1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:14:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix 2.6.20 hang
has been removed from the -mm tree.  Its filename was
     uml-fix-2620-hang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix 2.6.20 hang
From: Jeff Dike <jdike@addtoit.com>

A previous cleanup misused need_poll, which had a fairly broken interface. 
It implemented a growable array, changing the used elements count itself,
but leaving it up to the caller to fill in the actual elements, including
the entire array if the array had to be reallocated.  This worked because
the previous users were switching between two such structures, and the
elements were copied from the inactive array to the active array after
making sure the active array had enough room.

maybe_sigio_broken was made to use need_poll, but it was operating on a
single array, so when the buffer was reallocated, the previous contents
were lost.

This patch makes need_poll implement more sane semantics.  It merely
assures that the array is of the proper size and that the contents are
preserved.  It is up to the caller to adjust the used elements count and to
ensure that the proper elements are resent.

This manifested itself as a hang in 2.6.20 as the uninitialized buffer
convinced UML that one of its own file descriptors didn't support SIGIO and
needed to be watched by poll in a separate thread.  The result was an
interrupt flood as control traffic over this descriptor sparked interrupts,
which resulted in more control traffic, ad nauseum.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sigio.c |   38 +++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff -puN arch/um/os-Linux/sigio.c~uml-fix-2620-hang arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-fix-2620-hang
+++ a/arch/um/os-Linux/sigio.c
@@ -97,20 +97,22 @@ static int write_sigio_thread(void *unus
 
 static int need_poll(struct pollfds *polls, int n)
 {
-	if(n <= polls->size){
-		polls->used = n;
+	struct pollfd *new;
+
+	if(n <= polls->size)
 		return 0;
-	}
-	kfree(polls->poll);
-	polls->poll = um_kmalloc_atomic(n * sizeof(struct pollfd));
-	if(polls->poll == NULL){
+
+	new = um_kmalloc_atomic(n * sizeof(struct pollfd));
+	if(new == NULL){
 		printk("need_poll : failed to allocate new pollfds\n");
-		polls->size = 0;
-		polls->used = 0;
 		return -ENOMEM;
 	}
+
+	memcpy(new, polls->poll, polls->used * sizeof(struct pollfd));
+	kfree(polls->poll);
+
+	polls->poll = new;
 	polls->size = n;
-	polls->used = n;
 	return 0;
 }
 
@@ -171,15 +173,15 @@ int add_sigio_fd(int fd)
 			goto out;
 	}
 
-	n = current_poll.used + 1;
-	err = need_poll(&next_poll, n);
+	n = current_poll.used;
+	err = need_poll(&next_poll, n + 1);
 	if(err)
 		goto out;
 
-	for(i = 0; i < current_poll.used; i++)
-		next_poll.poll[i] = current_poll.poll[i];
-
-	next_poll.poll[n - 1] = *p;
+	memcpy(next_poll.poll, current_poll.poll,
+	       current_poll.used * sizeof(struct pollfd));
+	next_poll.poll[n] = *p;
+	next_poll.used = n + 1;
 	update_thread();
  out:
 	sigio_unlock();
@@ -214,6 +216,7 @@ int ignore_sigio_fd(int fd)
 		if(p->fd != fd)
 			next_poll.poll[n++] = *p;
 	}
+	next_poll.used = current_poll.used - 1;
 
 	update_thread();
  out:
@@ -331,10 +334,9 @@ void maybe_sigio_broken(int fd, int read
 
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
-	if(err){
-		printk("maybe_sigio_broken - failed to add pollfd\n");
+	if(err)
 		goto out;
-	}
+
 	all_sigio_fds.poll[all_sigio_fds.used++] =
 		((struct pollfd) { .fd  	= fd,
 				   .events 	= read ? POLLIN : POLLOUT,
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
fix-i386-and-x86_64-fault-information-pollution.patch
uml-fix-prototypes.patch
