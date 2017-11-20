From: akpm@linux-foundation.org
Subject: [merged] umh-optimize-proc_cap_handler.patch removed from
 -mm tree
Date: Mon, 20 Nov 2017 13:23:41 -0800
Message-ID: <20171120212341.V0JTENXec%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbdKTVXm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/umh.c: optimize 'proc_cap_handler()'
has been removed from the -mm tree.  Its filename was
     umh-optimize-proc_cap_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


