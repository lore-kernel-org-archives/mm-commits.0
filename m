From: akpm@linux-foundation.org
Subject: + umh-optimize-proc_cap_handler.patch added to -mm tree
Date: Fri, 10 Nov 2017 15:58:32 -0800
Message-ID: <5a063d28.aR2/MaTdLCnDqKKk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754053AbdKJX6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2017 18:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/umh.c: optimize 'proc_cap_handler()'
has been added to the -mm tree.  Its filename is
     umh-optimize-proc_cap_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/umh-optimize-proc_cap_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/umh-optimize-proc_cap_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: kernel/umh.c: optimize 'proc_cap_handler()'

If 'write' is 0, we can avoid a call to spin_lock/spin_unlock.

Link: http://lkml.kernel.org/r/20171020193331.7233-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/umh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/umh.c~umh-optimize-proc_cap_handler kernel/umh.c
--- a/kernel/umh.c~umh-optimize-proc_cap_handler
+++ a/kernel/umh.c
@@ -537,14 +537,14 @@ static int proc_cap_handler(struct ctl_t
 	/*
 	 * Drop everything not in the new_cap (but don't add things)
 	 */
-	spin_lock(&umh_sysctl_lock);
 	if (write) {
+		spin_lock(&umh_sysctl_lock);
 		if (table->data == CAP_BSET)
 			usermodehelper_bset = cap_intersect(usermodehelper_bset, new_cap);
 		if (table->data == CAP_PI)
 			usermodehelper_inheritable = cap_intersect(usermodehelper_inheritable, new_cap);
+		spin_unlock(&umh_sysctl_lock);
 	}
-	spin_unlock(&umh_sysctl_lock);
 
 	return 0;
 }
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

umh-optimize-proc_cap_handler.patch
rapidio-fix-resources-leak-in-error-handling-path-in-rio_dma_transfer.patch
rapidio-fix-an-error-handling-in-rio_dma_transfer.patch

