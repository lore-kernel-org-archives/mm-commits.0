From: akpm@linux-foundation.org
Subject: [merged] pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:09 -0800
Message-ID: <200912162039.nBGKd9Jo013507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964989AbZLPUja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, oleg@redhat.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     pid: reduce code size by using a pointer to iterate over array
has been removed from the -mm tree.  Its filename was
     pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patc=
h

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: pid: reduce code size by using a pointer to iterate over array
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

It decreases code size by 16 bytes on my gcc 4.4.1 on Core 2:
  text    data     bss     dec     hex filename
  4314    2216       8    6538    198a kernel/pid.o-BEFORE
  4298    2216       8    6522    197a kernel/pid.o-AFTER

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/pid.c~pid-reduce-code-size-by-using-a-pointer-to-itera=
te-over-array kernel/pid.c
--- a/kernel/pid.c~pid-reduce-code-size-by-using-a-pointer-to-iterate-o=
ver-array
+++ a/kernel/pid.c
@@ -269,12 +269,11 @@ struct pid *alloc_pid(struct pid_namespa
 	for (type =3D 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
=20
+	upid =3D pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
-	for (i =3D ns->level; i >=3D 0; i--) {
-		upid =3D &pid->numbers[i];
+	for ( ; upid >=3D pid->numbers; --upid)
 		hlist_add_head_rcu(&upid->pid_chain,
 				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
-	}
 	spin_unlock_irq(&pidmap_lock);
=20
 out:
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
