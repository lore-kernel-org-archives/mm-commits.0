From: akpm@linux-foundation.org
Subject: + mm-mremap-validate-input-before-taking-lock.patch added to -mm
 tree
Date: Mon, 10 Jun 2013 14:05:48 -0700
Message-ID: <51b63fac.eSxvcoE/X4blHU0u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3FJVFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 17:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, linux@rasmusvillemoes.dk

Subject: + mm-mremap-validate-input-before-taking-lock.patch added to -mm tree
To: linux@rasmusvillemoes.dk,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 14:05:48 -0700


The patch titled
     Subject: mm: mremap: validate input before taking lock
has been added to the -mm tree.  Its filename is
     mm-mremap-validate-input-before-taking-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm: mremap: validate input before taking lock

This patch is very similar to 84d96d897671 ("mm: madvise: complete input
validation before taking lock"): perform some basic validation of the
input to mremap() before taking the &current->mm->mmap_sem lock.  This
also makes the MREMAP_FIXED => MREMAP_MAYMOVE dependency slightly more
explicit.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN mm/mremap.c~mm-mremap-validate-input-before-taking-lock mm/mremap.c
--- a/mm/mremap.c~mm-mremap-validate-input-before-taking-lock
+++ a/mm/mremap.c
@@ -456,13 +456,14 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	unsigned long charged = 0;
 	bool locked = false;
 
-	down_write(&current->mm->mmap_sem);
-
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
-		goto out;
+		return ret;
+
+	if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
+		return ret;
 
 	if (addr & ~PAGE_MASK)
-		goto out;
+		return ret;
 
 	old_len = PAGE_ALIGN(old_len);
 	new_len = PAGE_ALIGN(new_len);
@@ -473,12 +474,13 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	 * a zero new-len is nonsensical.
 	 */
 	if (!new_len)
-		goto out;
+		return ret;
+
+	down_write(&current->mm->mmap_sem);
 
 	if (flags & MREMAP_FIXED) {
-		if (flags & MREMAP_MAYMOVE)
-			ret = mremap_to(addr, old_len, new_addr, new_len,
-					&locked);
+		ret = mremap_to(addr, old_len, new_addr, new_len,
+				&locked);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
mm-mremap-validate-input-before-taking-lock.patch

