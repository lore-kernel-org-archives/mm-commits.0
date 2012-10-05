From: akpm@linux-foundation.org
Subject: [merged] taskstats-cgroupstats_user_cmd-may-leak-on-error.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:17 -0700
Message-ID: <20121005202217.BB3F2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43081 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:19 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so94959qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, bsingharora@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats: cgroupstats_user_cmd() may leak on error
has been removed from the -mm tree.  Its filename was
     taskstats-cgroupstats_user_cmd-may-leak-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Juhl <jj@chaosbits.net>
Subject: taskstats: cgroupstats_user_cmd() may leak on error

If prepare_reply() succeeds we have allocated memory for 'rep_skb'.  If
nla_reserve() then subsequently fails and returns NULL we fail to release
the memory we allocated, thus causing a leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/taskstats.c~taskstats-cgroupstats_user_cmd-may-leak-on-error kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-cgroupstats_user_cmd-may-leak-on-error
+++ a/kernel/taskstats.c
@@ -445,6 +445,7 @@ static int cgroupstats_user_cmd(struct s
 	na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
 				sizeof(struct cgroupstats));
 	if (na == NULL) {
+		nlmsg_free(rep_skb);
 		rc = -EMSGSIZE;
 		goto err;
 	}
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch

