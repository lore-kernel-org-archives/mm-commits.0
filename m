From: akpm@linux-foundation.org
Subject: +
 kernel-padatac-register-hotcpu-notifier-after-initialization.patch added to -mm tree
Date: Mon, 26 Aug 2013 14:55:05 -0700
Message-ID: <521bceb9.+J0YojcV7UZcsVGJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3HZVzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 17:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, steffen.klassert@secunet.com, herbert@gondor.apana.org.au, richard@nod.at

Subject: + kernel-padatac-register-hotcpu-notifier-after-initialization.patch added to -mm tree
To: richard@nod.at,herbert@gondor.apana.org.au,steffen.klassert@secunet.com
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 14:55:05 -0700


The patch titled
     Subject: kernel/padata.c: register hotcpu notifier after initialization
has been added to the -mm tree.  Its filename is
     kernel-padatac-register-hotcpu-notifier-after-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-padatac-register-hotcpu-notifier-after-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-padatac-register-hotcpu-notifier-after-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
