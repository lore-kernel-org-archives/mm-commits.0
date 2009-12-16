From: akpm@linux-foundation.org
Subject: [merged] pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:06 -0800
Message-ID: <200912162039.nBGKd6w8013502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964985AbZLPUjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, oleg@redhat.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     pid: tighten pidmap spinlock critical section by removing kfree()
has been removed from the -mm tree.  Its filename was
     pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.pat=
ch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: pid: tighten pidmap spinlock critical section by removing kfre=
e()
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Avoid calling kfree() under pidmap spinlock, calling it afterwards.

Normally kfree() is fast, but sometimes it can be slow, so avoid
calling it under the spinlock if we can do it.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/pid.c~pid-tighten-pidmap-spinlock-critical-section-by-=
removing-kfree kernel/pid.c
--- a/kernel/pid.c~pid-tighten-pidmap-spinlock-critical-section-by-remo=
ving-kfree
+++ a/kernel/pid.c
@@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_names
 			 * installing it:
 			 */
 			spin_lock_irq(&pidmap_lock);
-			if (map->page)
-				kfree(page);
-			else
+			if (!map->page) {
 				map->page =3D page;
+				page =3D NULL;
+			}
 			spin_unlock_irq(&pidmap_lock);
+			kfree(page);
 			if (unlikely(!map->page))
 				break;
 		}
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
