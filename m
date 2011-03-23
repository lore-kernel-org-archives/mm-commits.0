From: akpm@linux-foundation.org
Subject: [merged] mm-notifier_from_errno-cleanup.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:34:01 -0700
Message-ID: <201103232037.p2NKbbOB028252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933517Ab1CWUz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, lizf@cn.fujitsu.com, menage@google.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     mm: notifier_from_errno() cleanup
has been removed from the -mm tree.  Its filename was
     mm-notifier_from_errno-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
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
