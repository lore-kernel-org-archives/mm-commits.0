From: akpm@linux-foundation.org
Subject: [patch 42/51] kernel/kcmp.c: drop branch leftover typo
Date: Tue, 03 Oct 2017 16:16:26 -0700
Message-ID: <59d41a4a.7EmlAP2kTNJB9Fsl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58842 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gorcunov@gmail.com, avagin@virtuozzo.com, esyr@redhat.com, gorcunov@openvz.org, xemul@virtuozzo.com

From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: kernel/kcmp.c: drop branch leftover typo

The else branch been left over and escaped the source code refresh.  Not a
problem but better clean it up.

Fixes: 0791e3644e5e ("kcmp: add KCMP_EPOLL_TFD mode to compare epoll target files")
Link: http://lkml.kernel.org/r/20170917165838.GA1887@uranus.lan
Reported-by: Eugene Syromiatnikov <esyr@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Andrei Vagin <avagin@virtuozzo.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kcmp.c~kcmp-drop-branch-leftover-typo kernel/kcmp.c
--- a/kernel/kcmp.c~kcmp-drop-branch-leftover-typo
+++ a/kernel/kcmp.c
@@ -131,7 +131,7 @@ static int kcmp_epoll_target(struct task
 	if (filp_epoll) {
 		filp_tgt = get_epoll_tfile_raw_ptr(filp_epoll, slot.tfd, slot.toff);
 		fput(filp_epoll);
-	} else
+	}
 
 	if (IS_ERR(filp_tgt))
 		return PTR_ERR(filp_tgt);
_
