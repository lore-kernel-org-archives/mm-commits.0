From: akpm@linux-foundation.org
Subject: + sparc-make-sa_nomask-a-synonym-of-sa_nodefer.patch added to -mm tree
Date: Wed, 04 Jan 2012 16:00:57 -0800
Message-ID: <20120105000058.5BFB410004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33951 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab2AEAA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 19:00:59 -0500
Received: by ghrr15 with SMTP id r15so1830575ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 16:00:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, davem@davemloft.net, oleg@redhat.com


The patch titled
     Subject: sparc: make SA_NOMASK a synonym of SA_NODEFER
has been added to the -mm tree.  Its filename is
     sparc-make-sa_nomask-a-synonym-of-sa_nodefer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: sparc: make SA_NOMASK a synonym of SA_NODEFER

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
sparc-make-sa_nomask-a-synonym-of-sa_nodefer.patch
signal-add-block_sigmask-for-adding-sigmask-to-current-blocked.patch

