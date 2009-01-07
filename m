From: akpm@linux-foundation.org
Subject: - mark-late_time_init-as-__initdata.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:10 -0800
Message-ID: <200901072216.n07MGAns015867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757096AbZAGWQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     init/main.c: mark late_time_init as __initdata
has been removed from the -mm tree.  Its filename was
     mark-late_time_init-as-__initdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -107,7 +107,7 @@ EXPORT_SYMBOL(system_state);
 
 extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
-void (*late_time_init)(void);
+void (*__initdata late_time_init)(void);
 extern void softirq_init(void);
 
 /* Untouched command line saved by arch-specific code. */
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch

