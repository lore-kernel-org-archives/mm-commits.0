From: akpm@linux-foundation.org
Subject: + char-ipmi-fix-cleanup_one_si-section-mismatch.patch added to -mm tree
Date: Mon, 28 Feb 2011 14:52:43 -0800
Message-ID: <201102282252.p1SMqhqX001831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab1B1Wwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 17:52:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, cminyard@mvista.com


The patch titled
     drivers/char/ipmi/ipmi_si_intf.c: fix cleanup_one_si section mismatch
has been added to the -mm tree.  Its filename is
     char-ipmi-fix-cleanup_one_si-section-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/ipmi/ipmi_si_intf.c: fix cleanup_one_si section mismatch
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

commit d2478521afc2022 ("char/ipmi: fix OOPS caused by
pnp_unregister_driver on unregistered driver") introduced a section
mismatch by calling __exit cleanup_ipmi_si from __devinit init_ipmi_si. 

Remove __exit annotation from cleanup_ipmi_si.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~char-ipmi-fix-cleanup_one_si-section-mismatch drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~char-ipmi-fix-cleanup_one_si-section-mismatch
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -3532,7 +3532,7 @@ static void cleanup_one_si(struct smi_in
 	kfree(to_clean);
 }
 
-static void __exit cleanup_ipmi_si(void)
+static void cleanup_ipmi_si(void)
 {
 	struct smi_info *e, *tmp_e;
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
char-ipmi-fix-cleanup_one_si-section-mismatch.patch

