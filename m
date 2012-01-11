From: akpm@linux-foundation.org
Subject: [merged] sparc-make-sa_nomask-a-synonym-of-sa_nodefer.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:33:05 -0800
Message-ID: <20120111213305.A2EDC1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:52712 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995Ab2AKVdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:33:06 -0500
Received: by ghrr15 with SMTP id r15so137556ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:33:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, davem@davemloft.net, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: make SA_NOMASK a synonym of SA_NODEFER
has been removed from the -mm tree.  Its filename was
     sparc-make-sa_nomask-a-synonym-of-sa_nodefer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: sparc: make SA_NOMASK a synonym of SA_NODEFER

Unlike other architectures, sparc currently has no SA_NODEFER definition
but only the older SA_NOMASK.  Since SA_NOMASK is the historical name for
SA_NODEFER, add SA_NODEFER and copy what other architectures do by making
SA_NOMASK a synonym for SA_NODEFER.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/signal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/signal.h~sparc-make-sa_nomask-a-synonym-of-sa_nodefer arch/sparc/include/asm/signal.h
--- a/arch/sparc/include/asm/signal.h~sparc-make-sa_nomask-a-synonym-of-sa_nodefer
+++ a/arch/sparc/include/asm/signal.h
@@ -143,10 +143,11 @@ struct sigstack {
 #define SA_ONSTACK	_SV_SSTACK
 #define SA_RESTART	_SV_INTR
 #define SA_ONESHOT	_SV_RESET
-#define SA_NOMASK	0x20u
+#define SA_NODEFER	0x20u
 #define SA_NOCLDWAIT    0x100u
 #define SA_SIGINFO      0x200u
 
+#define SA_NOMASK	SA_NODEFER
 
 #define SIG_BLOCK          0x01	/* for blocking signals */
 #define SIG_UNBLOCK        0x02	/* for unblocking signals */
_

Patches currently in -mm which might be from matt.fleming@intel.com are

origin.patch
linux-next.patch

