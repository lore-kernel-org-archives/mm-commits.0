From: akpm@linux-foundation.org
Subject: + jbd-do-not-try-lock_acquire-after-handle-made-invalid.patch added to -mm tree
Date: Tue, 15 Jan 2008 15:58:02 -0800
Message-ID: <200801152358.m0FNw2VM010092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759795AbYAOX6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 18:58:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jonas.bonn@gmail.com


The patch titled
     jbd: do not try lock_acquire after handle made invalid
has been added to the -mm tree.  Its filename is
     jbd-do-not-try-lock_acquire-after-handle-made-invalid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: do not try lock_acquire after handle made invalid
From: Jonas Bonn <jonas.bonn@gmail.com>

This likely fixes the oops in __lock_acquire reported as:

http://www.kerneloops.org/raw.php?rawid=2753&msgid=
http://www.kerneloops.org/raw.php?rawid=2749&msgid=

In these reported oopses, start_this_handle is returning -EROFS.

Signed-off-by: Jonas Bonn <jonas.bonn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/jbd/transaction.c~jbd-do-not-try-lock_acquire-after-handle-made-invalid fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-do-not-try-lock_acquire-after-handle-made-invalid
+++ a/fs/jbd/transaction.c
@@ -288,10 +288,12 @@ handle_t *journal_start(journal_t *journ
 		jbd_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
+		goto out;
 	}
 
 	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 
+out:
 	return handle;
 }
 
_

Patches currently in -mm which might be from jonas.bonn@gmail.com are

jbd-do-not-try-lock_acquire-after-handle-made-invalid.patch
