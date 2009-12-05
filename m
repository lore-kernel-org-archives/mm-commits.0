From: akpm@linux-foundation.org
Subject: + pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch added to -mm tree
Date: Fri, 04 Dec 2009 16:59:59 -0800
Message-ID: <200912050059.nB50xxIr018582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbZLEBAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 20:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, oleg@redhat.com, penberg@cs.helsinki.fi


The patch titled
     pid: tighten pidmap spinlock critical section by removing kfree()
has been added to the -mm tree.  Its filename is
     pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.pat=
ch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
vsprintf-factorize-null-string.patch
vsprintf-pre-calculate-final-string-length-for-later-use.patch
vsprintf-give-it-some-care-to-please-checkpatchpl.patch
vsprintf-use-tolower-whenever-possible.patch
vsprintf-reduce-code-size-by-avoiding-extra-check.patch
vsprintf-move-local-vars-to-block-local-vars-and-remove-unneeded-ones.p=
atch
vsprintf-factor-out-skip_space-code-in-a-separate-function.patch
vsprintf-reuse-almost-identical-simple_strtoulx-functions.patch
ctype-constify-read-only-_ctype-string.patch
string-factorize-skip_spaces-and-export-it-to-be-generally-available.pa=
tch
string-on-strstrip-first-remove-leading-spaces-before-running-over-str.=
patch
tree-wide-convert-open-calls-to-remove-spaces-to-skip_spaces-lib-functi=
on.patch
parser-remove-unnecessary-strlen.patch
pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch
pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
