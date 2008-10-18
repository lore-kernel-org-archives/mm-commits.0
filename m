From: akpm@linux-foundation.org
Subject: - inith-remove-long-dead-__setup_null_param-macro.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:12 -0700
Message-ID: <200810182311.m9INBC7k027687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbYJRXLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     init.h: remove long-dead __setup_null_param() macro
has been removed from the -mm tree.  Its filename was
     inith-remove-long-dead-__setup_null_param-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init.h: remove long-dead __setup_null_param() macro
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

This macro appears to have been unused for ages, and there are no
invocations of it anywhere in the source tree.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/init.h~inith-remove-long-dead-__setup_null_param-macro include/linux/init.h
--- a/include/linux/init.h~inith-remove-long-dead-__setup_null_param-macro
+++ a/include/linux/init.h
@@ -233,9 +233,6 @@ struct obs_kernel_param {
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }
 
-#define __setup_null_param(str, unique_id)			\
-	__setup_param(str, unique_id, NULL, 0)
