From: akpm@linux-foundation.org
Subject: [patch 049/142] userfaultfd: convert BUG() to WARN_ON_ONCE()
Date: Wed, 22 Feb 2017 15:42:12 -0800
Message-ID: <58ae21d4.2d8GONt3MhIiAXIB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934568AbdBVXmQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: convert BUG() to WARN_ON_ONCE()

Avoid BUG_ON()s and only WARN instead. This is just a cleanup, it
can't make any runtime difference. This BUG_ON has never triggered and
cannot trigger.

Link: http://lkml.kernel.org/r/20161216144821.5183-4-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-convert-bug-to-warn_on_once fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-convert-bug-to-warn_on_once
+++ a/fs/userfaultfd.c
@@ -574,7 +574,8 @@ static unsigned int userfaultfd_poll(str
 			ret = POLLIN;
 		return ret;
 	default:
-		BUG();
+		WARN_ON_ONCE(1);
+		return POLLERR;
 	}
 }
 
_
