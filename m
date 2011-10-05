From: akpm@google.com
Subject: + memory-hotplug-release-lock-on-an-error-path.patch added to -mm tree
Date: Wed, 05 Oct 2011 14:50:24 -0700
Message-ID: <201110052150.p95LoOUT010315@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:40617 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JEVvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 17:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, greg@kroah.com, nfont@austin.ibm.com


The patch titled
     Subject: memory hotplug: release lock on an error path
has been added to the -mm tree.  Its filename is
     memory-hotplug-release-lock-on-an-error-path.patch

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
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: memory hotplug: release lock on an error path

We need to release the mutex here before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-release-lock-on-an-error-path drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-release-lock-on-an-error-path
+++ a/drivers/base/memory.c
@@ -299,7 +299,7 @@ static int memory_block_change_state(str
 		for (i = 0; i < sections_per_block; i++) {
 			ret = check_page_reservations(mem->start_section_nr + i);
 			if (ret)
-				return ret;
+				goto out;
 		}
 	}
 
_
Subject: Subject: memory hotplug: release lock on an error path

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
memory-hotplug-release-lock-on-an-error-path.patch

