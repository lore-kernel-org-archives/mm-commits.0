From: akpm@linux-foundation.org
Subject: [merged] documentation-sparsetxt-document-context-annotations-for-lock-checking.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:31 -0800
Message-ID: <20121218200932.1AAFF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:61315 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2LRUJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:34 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so70208lbc.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, josh@joshtriplett.org, sparse@chrisli.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sparse.txt: document context annotations for lock checking
has been removed from the -mm tree.  Its filename was
     documentation-sparsetxt-document-context-annotations-for-lock-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: Documentation/sparse.txt: document context annotations for lock checking

The context feature of sparse is used with the Linux kernel sources to
check for imbalanced uses of locks.  Document the annotations defined in
include/linux/compiler.h that tell sparse what to expect when a lock is
held on function entry, exit, or both.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Christopher Li <sparse@chrisli.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sparse.txt |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN Documentation/sparse.txt~documentation-sparsetxt-document-context-annotations-for-lock-checking Documentation/sparse.txt
--- a/Documentation/sparse.txt~documentation-sparsetxt-document-context-annotations-for-lock-checking
+++ a/Documentation/sparse.txt
@@ -49,6 +49,24 @@ be generated without __CHECK_ENDIAN__.
 __bitwise - noisy stuff; in particular, __le*/__be* are that.  We really
 don't want to drown in noise unless we'd explicitly asked for it.
 
+Using sparse for lock checking
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The following macros are undefined for gcc and defined during a sparse
+run to use the "context" tracking feature of sparse, applied to
+locking.  These annotations tell sparse when a lock is held, with
+regard to the annotated function's entry and exit.
+
+__must_hold - The specified lock is held on function entry and exit.
+
+__acquires - The specified lock is held on function exit, but not entry.
+
+__releases - The specified lock is held on function entry, but not exit.
+
+If the function enters and exits without the lock held, acquiring and
+releasing the lock inside the function in a balanced way, no
+annotation is needed.  The tree annotations above are for cases where
+sparse would otherwise report a context imbalance.
 
 Getting sparse
 ~~~~~~~~~~~~~~
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

