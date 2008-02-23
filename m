From: akpm@linux-foundation.org
Subject: + lib-inflatec-handle-failed-malloc.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:35 -0800
Message-ID: <200802230734.m1N7YOuG018286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754668AbYBWHyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim@meyering.net, meyering@redhat.com


The patch titled
     lib/inflate.c: handle failed malloc()
has been added to the -mm tree.  Its filename is
     lib-inflatec-handle-failed-malloc.patch

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

usbaudio-handle-kcalloc-failure.patch
9p-handle-kstrdup-and-match_strdup-failure.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch
