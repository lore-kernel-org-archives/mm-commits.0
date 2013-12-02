From: akpm@linux-foundation.org
Subject: + kernel-forkc-remove-redundant-null-check-in-dup_mm.patch added
 to -mm tree
Date: Mon, 02 Dec 2013 14:08:20 -0800
Message-ID: <529d04d4.7R/oQxTeJngKObkK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3LBWIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 17:08:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, daeseok.youn@gmail.com

Subject: + kernel-forkc-remove-redundant-null-check-in-dup_mm.patch added to -mm tree
To: daeseok.youn@gmail.com,oleg@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 14:08:20 -0800


The patch titled
     Subject: kernel/fork.c: remove redundant NULL check in dup_mm()
has been added to the -mm tree.  Its filename is
     kernel-forkc-remove-redundant-null-check-in-dup_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-forkc-remove-redundant-null-check-in-dup_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-forkc-remove-redundant-null-check-in-dup_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: kernel/fork.c: remove redundant NULL check in dup_mm()

current->mm doesn't need a NULL check in dup_mm().  Becasue dup_mm() is
used only in copy_mm() and current->mm is checked whether it is NULL or
not in copy_mm() before calling dup_mm().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/fork.c~kernel-forkc-remove-redundant-null-check-in-dup_mm kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-remove-redundant-null-check-in-dup_mm
+++ a/kernel/fork.c
@@ -804,9 +804,6 @@ static struct mm_struct *dup_mm(struct t
 	struct mm_struct *mm, *oldmm = current->mm;
 	int err;
 
-	if (!oldmm)
-		return NULL;
