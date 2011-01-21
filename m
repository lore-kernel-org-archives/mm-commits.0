From: akpm@linux-foundation.org
Subject: + mm-notifier_from_errno-cleanup.patch added to -mm tree
Date: Fri, 21 Jan 2011 00:02:48 -0800
Message-ID: <201101210802.p0L82mC2029994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab1AUIDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 03:03:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, lizf@cn.fujitsu.com, menage@google.com, penberg@cs.helsinki.fi


The patch titled
     mm: notifier_from_errno() cleanup
has been added to the -mm tree.  Its filename is
     mm-notifier_from_errno-cleanup.patch

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
Subject: mm: notifier_from_errno() cleanup
From: Prarit Bhargava <prarit@redhat.com>

While looking at some other notifier callbacks I noticed this code could
use a simple cleanup.

notifier_from_errno() no longer needs the if (ret)/else conditional.  That
same conditional is now done in notifier_from_errno().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    7 +------
 mm/slab.c        |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/page_cgroup.c~mm-notifier_from_errno-cleanup mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-notifier_from_errno-cleanup
+++ a/mm/page_cgroup.c
@@ -243,12 +243,7 @@ static int __meminit page_cgroup_callbac
 		break;
 	}
 
-	if (ret)
-		ret = notifier_from_errno(ret);
-	else
-		ret = NOTIFY_OK;
