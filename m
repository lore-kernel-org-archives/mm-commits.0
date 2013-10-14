From: akpm@linux-foundation.org
Subject: + percpu_refcount-export-symbols.patch added to -mm tree
Date: Mon, 14 Oct 2013 11:23:20 -0700
Message-ID: <525c3698.MFQZukCWn63ramcb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3JNSXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 14:23:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, m@bjorling.me

Subject: + percpu_refcount-export-symbols.patch added to -mm tree
To: m@bjorling.me,tj@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 11:23:20 -0700


The patch titled
     Subject: percpu_refcount: export symbols
has been added to the -mm tree.  Its filename is
     percpu_refcount-export-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu_refcount-export-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu_refcount-export-symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matias Bjorling <m@bjorling.me>
Subject: percpu_refcount: export symbols

Export the interface to be used within modules.

Signed-off-by: Matias Bjorling <m@bjorling.me>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/percpu-refcount.c~percpu_refcount-export-symbols lib/percpu-refcount.c
--- a/lib/percpu-refcount.c~percpu_refcount-export-symbols
+++ a/lib/percpu-refcount.c
@@ -53,6 +53,7 @@ int percpu_ref_init(struct percpu_ref *r
 	ref->release = release;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(percpu_ref_init);
 
 /**
  * percpu_ref_cancel_init - cancel percpu_ref_init()
@@ -84,6 +85,7 @@ void percpu_ref_cancel_init(struct percp
 		free_percpu(ref->pcpu_count);
 	}
 }
+EXPORT_SYMBOL_GPL(percpu_ref_cancel_init);
 
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
@@ -156,3 +158,4 @@ void percpu_ref_kill_and_confirm(struct
 
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
 }
+EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
_

Patches currently in -mm which might be from m@bjorling.me are

percpu_refcount-export-symbols.patch

