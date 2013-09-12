From: akpm@linux-foundation.org
Subject: [merged]
 kernel-padatac-register-hotcpu-notifier-after-initialization.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:41:05 -0700
Message-ID: <523218d1.CffyQe8pfoB2SEEB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3ILTlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, steffen.klassert@secunet.com, herbert@gondor.apana.org.au, richard@nod.at

Subject: [merged] kernel-padatac-register-hotcpu-notifier-after-initialization.patch removed from -mm tree
To: richard@nod.at,herbert@gondor.apana.org.au,steffen.klassert@secunet.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:05 -0700


The patch titled
     Subject: kernel/padata.c: register hotcpu notifier after initialization
has been removed from the -mm tree.  Its filename was
     kernel-padatac-register-hotcpu-notifier-after-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: kernel/padata.c: register hotcpu notifier after initialization

padata_cpu_callback() takes pinst->lock, to avoid taking an uninitialized
lock, register the notifier after it's initialization.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/padata.c~kernel-padatac-register-hotcpu-notifier-after-initialization kernel/padata.c
--- a/kernel/padata.c~kernel-padatac-register-hotcpu-notifier-after-initialization
+++ a/kernel/padata.c
@@ -1086,18 +1086,18 @@ struct padata_instance *padata_alloc(str
 
 	pinst->flags = 0;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	pinst->cpu_notifier.notifier_call = padata_cpu_callback;
-	pinst->cpu_notifier.priority = 0;
-	register_hotcpu_notifier(&pinst->cpu_notifier);
-#endif
