From: akpm@linux-foundation.org
Subject: - inith-remove-obsolete-content-from.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:08 -0700
Message-ID: <200807252255.m6PMt8AY002951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbYGYWzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     init.h: remove obsolete content
has been removed from the -mm tree.  Its filename was
     inith-remove-obsolete-content-from.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init.h: remove obsolete content
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Remove apparently obsolete content from init.h referring to gcc 2.9x
and to "no_module_init".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN include/linux/init.h~inith-remove-obsolete-content-from include/linux/init.h
--- a/include/linux/init.h~inith-remove-obsolete-content-from
+++ a/include/linux/init.h
@@ -275,13 +275,7 @@ void __init parse_early_param(void);
 
 #define security_initcall(fn)		module_init(fn)
 
-/* These macros create a dummy inline: gcc 2.9x does not count alias
- as usage, hence the `unused function' warning when __init functions
- are declared static. We use the dummy __*_module_inline functions
- both to kill the warning and check the type of the init/cleanup
- function. */
