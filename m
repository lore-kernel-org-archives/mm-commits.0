From: akpm@linux-foundation.org
Subject: + generic-swap-ext3-remove-local-swap-macro.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:13 -0800
Message-ID: <200812030819.mB38JDRU010290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYLCITi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, tytso@mit.edu


The patch titled
     generic swap(): ext3: remove local swap() macro
has been added to the -mm tree.  Its filename is
     generic-swap-ext3-remove-local-swap-macro.patch

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
Subject: generic swap(): ext3: remove local swap() macro
From: Wu Fengguang <fengguang.wu@intel.com>

Use the new generic implementation.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ext3/namei.c~generic-swap-ext3-remove-local-swap-macro fs/ext3/namei.c
--- a/fs/ext3/namei.c~generic-swap-ext3-remove-local-swap-macro
+++ a/fs/ext3/namei.c
@@ -74,10 +74,6 @@ static struct buffer_head *ext3_append(h
 #define assert(test) J_ASSERT(test)
 #endif
 
-#ifndef swap
-#define swap(x, y) do { typeof(x) z = x; x = y; y = z; } while (0)
-#endif
