From: akpm@linux-foundation.org
Subject: + mark-late_time_init-as-__initdata.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:09:35 -0800
Message-ID: <200812172209.mBHM9ZMm029463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYLQWJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     init/main.c: mark late_time_init as __initdata
has been added to the -mm tree.  Its filename is
     mark-late_time_init-as-__initdata.patch

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
Subject: init/main.c: mark late_time_init as __initdata
From: "Jan Beulich" <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~mark-late_time_init-as-__initdata init/main.c
--- a/init/main.c~mark-late_time_init-as-__initdata
+++ a/init/main.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(system_state);
 
 extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
-void (*late_time_init)(void);
+void (*__initdata late_time_init)(void);
 extern void softirq_init(void);
 
 /* Untouched command line saved by arch-specific code. */
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
remove-remaining-unwinder-code.patch
mark-late_time_init-as-__initdata.patch

