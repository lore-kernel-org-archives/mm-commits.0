From: akpm@linux-foundation.org
Subject: +
 kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource.patch added to -mm tree
Date: Fri, 24 May 2013 13:50:17 -0700
Message-ID: <519fd289.bUc6aLyW9x3xd8Ud%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3EXUuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbarnes@virtuousgeek.org, bjorn.helgaas@hp.com, haokexin@gmail.com

Subject: + kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource.patch added to -mm tree
To: haokexin@gmail.com,bjorn.helgaas@hp.com,jbarnes@virtuousgeek.org
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:50:17 -0700


The patch titled
     Subject: kernel/resource.c: remove the unneeded assignment in function __find_resource
has been added to the -mm tree.  Its filename is
     kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: kernel/resource.c: remove the unneeded assignment in function __find_resource

This line was introduced by fcb11918 ("resources: add arch hook for
preventing allocation in reserved areas").  But the struct tmp was already
assigned to *new in the above line, so this seems superfluous.  Just
remove it.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/resource.c~kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource
+++ a/kernel/resource.c
@@ -448,7 +448,6 @@ static int __find_resource(struct resour
 	struct resource *this = root->child;
 	struct resource tmp = *new, avail, alloc;
 
-	tmp.flags = new->flags;
 	tmp.start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the assignment
_

Patches currently in -mm which might be from haokexin@gmail.com are

kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource.patch

