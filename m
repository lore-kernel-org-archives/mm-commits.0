From: akpm@linux-foundation.org
Subject: [merged] olpc-fix-model-detection-without-ofw.patch removed from -mm tree
Date: Tue, 17 Feb 2009 16:08:42 -0800
Message-ID: <200902180008.n1I08gKA020828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbZBRAJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 19:09:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cjb@laptop.org, mm-commits@vger.kernel.org


The patch titled
     From: Chris Ball <cjb@laptop.org>
has been removed from the -mm tree.  Its filename was
     olpc-fix-model-detection-without-ofw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Chris Ball <cjb@laptop.org>
From: Chris Ball <cjb@laptop.org>
Return-Path: <cjb@laptop.org>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=none autolearn=ham
	version=3.2.4
Received: from y.localdomain (y.localdomain [127.0.0.1])
	by y.localdomain (8.14.2/8.14.2) with ESMTP id n1E21cSM028703
	for <akpm@localhost>; Fri, 13 Feb 2009 18:01:39 -0800
Received: from imap1.linux-foundation.org [140.211.169.55]
	by y.localdomain with IMAP (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Fri, 13 Feb 2009 18:01:39 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1E1w9DG026335
	for <akpm@imap1.linux-foundation.org>; Fri, 13 Feb 2009 17:58:09 -0800
Received: from void.printf.net (void.printf.net [89.145.121.20])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1E1vYgT011992
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <akpm@linux-foundation.org>; Fri, 13 Feb 2009 17:57:36 -0800
Received: from pullcord.laptop.org ([18.85.46.20])
	by void.printf.net with esmtp (Exim 4.50)
	id 1LY9lV-0008Hj-4x; Sat, 14 Feb 2009 01:56:21 +0000
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andres Salomon <dilinger@queued.net>
Subject: [PATCH] olpc: fix model detection without OFW
References: <1222208409.16003.25.camel@brick>
Date: Fri, 13 Feb 2009 20:56:18 -0500
In-Reply-To: <1222208409.16003.25.camel@brick> (Harvey Harrison's message of
	"Tue, 23 Sep 2008 15:20:09 -0700")
Message-ID: <m3mycpye65.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received-SPF: none (domain of cjb@laptop.org does not designate permitted sender hosts)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13

Harvey's endianness patch (e51a1ac2dfca9ad869471e88f828281db7e810c0)
breaks model comparison on OLPC; the value 0xc2 needs to be scaled
up by olpc_board().  The pre-patch version was wrong, but accidentally
worked anyway (big-endian 0xc2 is big enough to satisfy all other
board revisions, but little endian 0xc2 is not).

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 arch/x86/kernel/olpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 7a13fac..4006c52 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -203,7 +203,7 @@ static void __init platform_detect(void)
 static void __init platform_detect(void)
 {
 	/* stopgap until OFW support is added to the kernel */
-	olpc_platform_info.boardrev = 0xc2;
+	olpc_platform_info.boardrev = olpc_board(0xc2);
 }
 #endif
 
-- 
1.6.1.3

Patches currently in -mm which might be from cjb@laptop.org are

linux-next.patch
olpc-fix-model-detection-without-ofw.patch

