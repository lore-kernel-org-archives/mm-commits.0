From: akpm@linux-foundation.org
Subject: + taskstats-cgroupstats_user_cmd-may-leak-on-error.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:48:10 -0700
Message-ID: <20120816184810.A961B1E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42625 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2HPSsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:48:11 -0400
Received: by obbwc20 with SMTP id wc20so2147529obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:48:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, bsingharora@gmail.com


The patch titled
     Subject: taskstats: cgroupstats_user_cmd() may leak on error
has been added to the -mm tree.  Its filename is
     taskstats-cgroupstats_user_cmd-may-leak-on-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -437,6 +437,7 @@ static int cgroupstats_user_cmd(struct s
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
linux-next.patch
taskstats-cgroupstats_user_cmd-may-leak-on-error.patch

