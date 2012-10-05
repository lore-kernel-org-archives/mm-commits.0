From: akpm@linux-foundation.org
Subject: [merged] proc-use-null-instead-of-0-for-pointer.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:05 -0700
Message-ID: <20121005202006.0F6785C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:60462 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:07 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98926lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/root.c: use NULL instead of 0 for pointer
has been removed from the -mm tree.  Its filename was
     proc-use-null-instead-of-0-for-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: fs/proc/root.c: use NULL instead of 0 for pointer

This cleanup also fixes the following sparse warning:
fs/proc/root.c:64:45: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/root.c~proc-use-null-instead-of-0-for-pointer fs/proc/root.c
--- a/fs/proc/root.c~proc-use-null-instead-of-0-for-pointer
+++ a/fs/proc/root.c
@@ -61,7 +61,7 @@ static int proc_parse_options(char *opti
 		if (!*p)
 			continue;
 
-		args[0].to = args[0].from = 0;
+		args[0].to = args[0].from = NULL;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_gid:
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch

