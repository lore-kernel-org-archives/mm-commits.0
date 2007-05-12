From: akpm@linux-foundation.org
Subject: - bug-in-mm-thrashc-function-grab_swap_token.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:30 -0700
Message-ID: <200705120532.l4C5WUKN002046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665AbXELFc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikukkon@miku.homelinux.net, mikukkon@iki.fi, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Bug in mm/thrash.c function grab_swap_token()
has been removed from the -mm tree.  Its filename was
     bug-in-mm-thrashc-function-grab_swap_token.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: Bug in mm/thrash.c function grab_swap_token()
=46rom: Mika Kukkonen <mikukkon@miku.homelinux.net>

=46ollowing bug was uncovered by compiling with '-W' flag:

  CC      mm/thrash.o
mm/thrash.c: In function =E2=80=98grab_swap_token=E2=80=99:
mm/thrash.c:52: warning: comparison of unsigned expression < 0 is alway=
s false

Variable token_priority is unsigned, so decrementing first and then
checking the result does not work; fixed by reversing the test, patch
attached (compile tested only).

I am not sure if likely() makes much sense in this new situation, but
I'll let somebody else to make a decision on that.

Signed-off-by: Mika Kukkonen <mikukkon@iki.fi>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/thrash.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/thrash.c~bug-in-mm-thrashc-function-grab_swap_token mm/thr=
ash.c
--- a/mm/thrash.c~bug-in-mm-thrashc-function-grab_swap_token
+++ a/mm/thrash.c
@@ -48,9 +48,8 @@ void grab_swap_token(void)
 		if (current_interval < current->mm->last_interval)
 			current->mm->token_priority++;
 		else {
-			current->mm->token_priority--;
-			if (unlikely(current->mm->token_priority < 0))
-				current->mm->token_priority =3D 0;
+			if (likely(current->mm->token_priority > 0))
+				current->mm->token_priority--;
 		}
 		/* Check if we deserve the token */
 		if (current->mm->token_priority >
_

Patches currently in -mm which might be from mikukkon@miku.homelinux.ne=
t are

origin.patch
couple-fixes-to-fs-ecryptfs-inodec.patch
