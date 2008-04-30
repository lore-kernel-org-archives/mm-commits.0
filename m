From: akpm@linux-foundation.org
Subject: - lib-inflatec-handle-failed-malloc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:00 -0700
Message-ID: <200804300540.m3U5e0da028899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbYD3Fkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, meyering@redhat.com, mm-commits@vger.kernel.org


The patch titled
     lib/inflate.c: handle failed malloc()
has been removed from the -mm tree.  Its filename was
     lib-inflatec-handle-failed-malloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/inflate.c: handle failed malloc()
From: Jim Meyering <jim@meyering.net>

lib/inflate.c (inflate_dynamic): Don't deref NULL upon failed malloc.

Signed-off-by: Jim Meyering <meyering@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/inflate.c~lib-inflatec-handle-failed-malloc lib/inflate.c
--- a/lib/inflate.c~lib-inflatec-handle-failed-malloc
+++ a/lib/inflate.c
@@ -811,6 +811,9 @@ DEBG("<dyn");
   ll = malloc(sizeof(*ll) * (286+30));  /* literal/length and distance code lengths */
 #endif
 
+  if (ll == NULL)
+    return 1;
+
   /* make local bit buffer */
   b = bb;
   k = bk;
_

Patches currently in -mm which might be from jim@meyering.net are

origin.patch
git-v9fs.patch

