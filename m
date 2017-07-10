From: akpm@linux-foundation.org
Subject: [folded-merged]
 signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch removed
 from -mm tree
Date: Mon, 10 Jul 2017 15:36:44 -0700
Message-ID: <5964017c.ZOc0jnqAdmCnv/EO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754041AbdGJWgp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, oleg@redhat.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signal-avoid-undefined-behaviour-in-kill_something_info-fix
has been removed from the -mm tree.  Its filename was
     signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

This patch was dropped because it was folded into signal-avoid-undefined-behaviour-in-kill_something_info.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: signal-avoid-undefined-behaviour-in-kill_something_info-fix

tweak comment

Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/signal.c~signal-avoid-undefined-behaviour-in-kill_something_info-fix kernel/signal.c
--- a/kernel/signal.c~signal-avoid-undefined-behaviour-in-kill_something_info-fix
+++ a/kernel/signal.c
@@ -1402,10 +1402,7 @@ static int kill_something_info(int sig,
 		return ret;
 	}
 
-	/*
-	 * -INT_MIN is undefined, it need to exclude following case to
-	 * avoid the UBSAN detection.
-	 */
+	/* -INT_MIN is undefined.  Exclude this case to avoid a UBSAN warning */
 	if (pid == INT_MIN)
 		return -ESRCH;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

signal-avoid-undefined-behaviour-in-kill_something_info.patch

