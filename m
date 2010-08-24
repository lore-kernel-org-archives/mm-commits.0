From: akpm@linux-foundation.org
Subject: + kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch added to -mm tree
Date: Tue, 24 Aug 2010 16:46:42 -0700
Message-ID: <201008242346.o7ONkgAf023360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934375Ab0HXXrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 19:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org


The patch titled
     kernel/resource.c: handle reinsertion of an already-inserted resource
has been added to the -mm tree.  Its filename is
     kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch

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
Subject: kernel/resource.c: handle reinsertion of an already-inserted resource
From: Huang Shijie <shijie8@gmail.com>

If the same resource is inserted to the resource tree (maybe not on
purpose), a dead loop will be created.  In this situation, The kernel does
not report any warning or error :(

  The command below will show a endless print.
  #cat /proc/iomem

[akpm@linux-foundation.org: add WARN_ON()]
Signed-off-by: Huang Shijie <shijie8@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/resource.c~kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource
+++ a/kernel/resource.c
@@ -453,6 +453,8 @@ static struct resource * __insert_resour
 
 		if (first == parent)
 			return first;
+		if (WARN_ON(first == new))	/* duplicated insertion */
+			return first;
 
 		if ((first->start > new->start) || (first->end < new->end))
 			break;
_

Patches currently in -mm which might be from shijie8@gmail.com are

kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch

