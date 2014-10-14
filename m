From: akpm@linux-foundation.org
Subject: [merged] altera-stapl-replace-strnicmp-with-strncasecmp.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:26 -0700
Message-ID: <543d69e2.VobA/Ly6apihAtK1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbaJNSWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, liplianin@netup.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: altera-stapl: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     altera-stapl-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: altera-stapl: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Igor M. Liplianin" <liplianin@netup.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/altera-stapl/altera.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/altera-stapl/altera.c~altera-stapl-replace-strnicmp-with-strncasecmp drivers/misc/altera-stapl/altera.c
--- a/drivers/misc/altera-stapl/altera.c~altera-stapl-replace-strnicmp-with-strncasecmp
+++ a/drivers/misc/altera-stapl/altera.c
@@ -454,7 +454,7 @@ exit_done:
 
 				name = &p[str_table + name_id];
 
-				if (strnicmp(aconf->action, name, strlen(name)) == 0) {
+				if (strncasecmp(aconf->action, name, strlen(name)) == 0) {
 					action_found = 1;
 					current_proc =
 						get_unaligned_be32(&p[action_table +
@@ -2176,7 +2176,7 @@ static int altera_get_note(u8 *p, s32 pr
 			key_ptr = &p[note_strings +
 					get_unaligned_be32(
 					&p[note_table + (8 * i)])];
-			if ((strnicmp(key, key_ptr, strlen(key_ptr)) == 0) &&
+			if ((strncasecmp(key, key_ptr, strlen(key_ptr)) == 0) &&
 						(key != NULL)) {
 				status = 0;
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

