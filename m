From: akpm@linux-foundation.org
Subject: - fix-count-compat_count-bounds-checking.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:04 -0700
Message-ID: <200810182312.m9INC4AR027924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbYJRXMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, a.p.zijlstra@chello.nl, aaw@google.com, mm-commits@vger.kernel.org


The patch titled
     exec.c, compat.c: fix count(), compat_count() bounds checking
has been removed from the -mm tree.  Its filename was
     fix-count-compat_count-bounds-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec.c, compat.c: fix count(), compat_count() bounds checking
From: Jason Baron <jbaron@redhat.com>

With MAX_ARG_STRINGS set to 0x7FFFFFFF, and being passed to 'count()' and
compat_count(), it would appear that the current max bounds check of
fs/exec.c:394:

	if(++i > max)
		return -E2BIG;

would never trigger. Since 'i' is of type int, so values would wrap and the
function would continue looping.

Simple fix seems to be chaning ++i to i++ and checking for '>='.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Ollie Wild" <aaw@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    2 +-
 fs/exec.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/compat.c~fix-count-compat_count-bounds-checking fs/compat.c
--- a/fs/compat.c~fix-count-compat_count-bounds-checking
+++ a/fs/compat.c
@@ -1239,7 +1239,7 @@ static int compat_count(compat_uptr_t __
 			if (!p)
 				break;
 			argv++;
-			if(++i > max)
+			if (i++ >= max)
 				return -E2BIG;
 		}
 	}
diff -puN fs/exec.c~fix-count-compat_count-bounds-checking fs/exec.c
--- a/fs/exec.c~fix-count-compat_count-bounds-checking
+++ a/fs/exec.c
@@ -391,7 +391,7 @@ static int count(char __user * __user * 
 			if (!p)
 				break;
 			argv++;
-			if(++i > max)
+			if (i++ >= max)
 				return -E2BIG;
 			cond_resched();
 		}
_

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch

