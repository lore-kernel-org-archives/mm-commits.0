From: akpm@linux-foundation.org
Subject: [merged] char-ipmi-fix-cleanup_one_si-section-mismatch.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:48 -0700
Message-ID: <201103250725.p2P7Pgbg026070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933852Ab1CYHZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ipmi/ipmi_si_intf.c: fix cleanup_one_si section mismatch
has been removed from the -mm tree.  Its filename was
     char-ipmi-fix-cleanup_one_si-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3521,7 +3521,7 @@ static void cleanup_one_si(struct smi_in
 	kfree(to_clean);
 }
 
-static void __exit cleanup_ipmi_si(void)
+static void cleanup_ipmi_si(void)
 {
 	struct smi_info *e, *tmp_e;
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
linux-next.patch

