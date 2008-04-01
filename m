From: akpm@linux-foundation.org
Subject: + slub-change-slub_debug-to-config_slub_debug-in-slubc.patch added to -mm tree
Date: Tue, 01 Apr 2008 13:04:08 -0700
Message-ID: <200804012004.m31K48AX010722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756986AbYDAUE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tremyfr@yahoo.fr, clameter@sgi.com


The patch titled
     slub: change SLUB_DEBUG to CONFIG_SLUB_DEBUG in slub.c
has been added to the -mm tree.  Its filename is
     slub-change-slub_debug-to-config_slub_debug-in-slubc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: slub: change SLUB_DEBUG to CONFIG_SLUB_DEBUG in slub.c
=46rom: Reynes Philippe <tremyfr@yahoo.fr>

SLUB_DEBUG is used, instead of CONFIG_SLUB_DEBUG. So the compilation
failed with the error :

  CC      mm/slub.o
mm/slub.c: In function =91show_slab_objects=92:
mm/slub.c:3674: erreur: implicit declaration of function =91count_parti=
al=92
mm/slub.c:3674: erreur: =91count_free=92 undeclared (first use in this =
function)
mm/slub.c:3674: erreur: (Each undeclared identifier is reported only on=
ce
mm/slub.c:3674: erreur: for each function it appears in.)
mm/slub.c:3687: erreur: =91count_total=92 undeclared (first use in this=
 function)
mm/slub.c:3689: erreur: =91count_inuse=92 undeclared (first use in this=
 function)
make[1]: *** [mm/slub.o] Erreur 1
make: *** [mm] Erreur 2

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-change-slub_debug-to-config_slub_debug-in-slub=
c mm/slub.c
--- a/mm/slub.c~slub-change-slub_debug-to-config_slub_debug-in-slubc
+++ a/mm/slub.c
@@ -2688,7 +2688,8 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
=20
-#if defined(SLUB_DEBUG) || defined(CONFIG_SLABINFO)
+#if (defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)) || \
+	defined(CONFIG_SLABINFO)
 static unsigned long count_partial(struct kmem_cache_node *n)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from tremyfr@yahoo.fr are

slub-change-slub_debug-to-config_slub_debug-in-slubc.patch
git-sched-schedc-needs-tickh.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
