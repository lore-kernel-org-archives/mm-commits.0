From: akpm@linux-foundation.org
Subject: [patch 23/94] kernel/umh.c: optimize 'proc_cap_handler()'
Date: Fri, 17 Nov 2017 15:27:32 -0800
Message-ID: <20171117232732.Mq3rzEx-_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423264AbdKQX1d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christophe.jaillet@wanadoo.fr, mcgrof@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
