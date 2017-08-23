From: akpm@linux-foundation.org
Subject: + fs-select-fix-memory-corruption-in-compat_get_fd_set.patch
 added to -mm tree
Date: Wed, 23 Aug 2017 14:55:16 -0700
Message-ID: <599df9c4.FUolWUrxWZJ/vG1P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44014 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdHWVzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 17:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/select.c: fix memory corruption in compat_get_fd_set()
has been added to the -mm tree.  Its filename is
     fs-select-fix-memory-corruption-in-compat_get_fd_set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-select-fix-memory-corruption-in-compat_get_fd_set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-select-fix-memory-corruption-in-compat_get_fd_set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: fs/select.c: fix memory corruption in compat_get_fd_set()

464d62421cb8 ("select: switch compat_{get,put}_fd_set() to
compat_{get,put}_bitmap()") changed the calculation on how many bytes need
to be zeroed when userspace handed over a NULL pointer for a fdset array
in the select syscall.

The calculation was changed in compat_get_fd_set() wrongly from
	memset(fdset, 0, ((nr + 1) & ~1)*sizeof(compat_ulong_t));
to
	memset(fdset, 0, ALIGN(nr, BITS_PER_LONG));

The ALIGN(nr, BITS_PER_LONG) calculates the number of bits which need to
be zeroed in the target fdset array (rounded up to the next full bits for
an unsigned long).  But the memset() call expects the number of bytes to
be zeroed.

This leads to clearing more memory than wanted (on the stack area or even
at kmalloc()ed memory areas) and to random kernel crashes as we have seen
them on the parisc platform.

The correct change should have been
	memset(fdset, 0, (ALIGN(nr, BITS_PER_LONG) / BITS_PER_LONG) * BYTES_PER_LONG);
which is the same as can be archieved with a call to
	zero_fd_set(nr, fdset).

Link: http://lkml.kernel.org/r/20170823203700.GA29614@ls3530.fritz.box
Fixes: 464d62421cb8 ("select: switch compat_{get,put}_fd_set() to compat_{get,put}_bitmap()"
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/select.c~fs-select-fix-memory-corruption-in-compat_get_fd_set fs/select.c
--- a/fs/select.c~fs-select-fix-memory-corruption-in-compat_get_fd_set
+++ a/fs/select.c
@@ -1164,11 +1164,7 @@ int compat_get_fd_set(unsigned long nr,
 	if (ufdset) {
 		return compat_get_bitmap(fdset, ufdset, nr);
 	} else {
-		/* Tricky, must clear full unsigned long in the
-		 * kernel fdset at the end, ALIGN makes sure that
-		 * actually happens.
-		 */
-		memset(fdset, 0, ALIGN(nr, BITS_PER_LONG));
+		zero_fd_set(nr, fdset);
 		return 0;
 	}
 }
_

Patches currently in -mm which might be from deller@gmx.de are

fs-select-fix-memory-corruption-in-compat_get_fd_set.patch

