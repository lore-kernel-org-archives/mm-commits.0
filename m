From: akpm@linux-foundation.org
Subject: + bug-in-mm-thrashc-function-grab_swap_token.patch added to -mm tree
Date: Thu, 10 May 2007 15:30:06 -0700
Message-ID: <200705102230.l4AMU638032557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756187AbXEJWad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikukkon@miku.homelinux.net, mikukkon@iki.fi, riel@redhat.com


The patch titled
     Bug in mm/thrash.c function grab_swap_token()
has been added to the -mm tree.  Its filename is
     bug-in-mm-thrashc-function-grab_swap_token.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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
 1 files changed, 2 insertions(+), 3 deletions(-)

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

bug-in-mm-thrashc-function-grab_swap_token.patch
