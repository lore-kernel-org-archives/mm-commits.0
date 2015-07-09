From: akpm@linux-foundation.org
Subject: + mremap-simplify-the-overlap-check-in-mremap_to.patch added to
 -mm tree
Date: Thu, 09 Jul 2015 15:26:34 -0700
Message-ID: <559ef51a.snvsnj/AhuLJ7+mc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbbGIW0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, hughd@google.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: simplify the "overlap" check in mremap_to()
has been added to the -mm tree.  Its filename is
     mremap-simplify-the-overlap-check-in-mremap_to.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mremap-simplify-the-overlap-check-in-mremap_to.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mremap-simplify-the-overlap-check-in-mremap_to.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mremap: simplify the "overlap" check in mremap_to()

Minor, but this check is overcomplicated.  Two half-intervals do NOT
overlap if END1 <= START2 || END2 <= START1, mremap_to() just needs to
negate this check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/mremap.c~mremap-simplify-the-overlap-check-in-mremap_to mm/mremap.c
--- a/mm/mremap.c~mremap-simplify-the-overlap-check-in-mremap_to
+++ a/mm/mremap.c
@@ -407,13 +407,8 @@ static unsigned long mremap_to(unsigned
 	if (new_len > TASK_SIZE || new_addr > TASK_SIZE - new_len)
 		goto out;
 
-	/* Check if the location we're moving into overlaps the
-	 * old location at all, and fail if it does.
-	 */
-	if ((new_addr <= addr) && (new_addr+new_len) > addr)
-		goto out;
