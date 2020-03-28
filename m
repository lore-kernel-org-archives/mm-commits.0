From: akpm@linux-foundation.org
Subject: + getdelays-fix-netlink-attribute-length.patch added to
 -mm tree
Date: Sat, 28 Mar 2020 13:04:43 -0700
Message-ID: <20200328200443.ZdmdYg8Ph%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgC1UEo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 16:04:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsahern@kernel.org, johannes@sipsolutions.net, laoar.shao@gmail.com, mm-commits@vger.kernel.org, nagar@watson.ibm.com


The patch titled
     Subject: tools/accounting/getdelays.c: fix netlink attribute length
has been added to the -mm tree.  Its filename is
     getdelays-fix-netlink-attribute-length.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/getdelays-fix-netlink-attribute-length.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/getdelays-fix-netlink-attribute-length.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Ahern <dsahern@kernel.org>
Subject: tools/accounting/getdelays.c: fix netlink attribute length

A recent change to the netlink code: 6e237d099fac ("netlink: Relax attr
validation for fixed length types") logs a warning when programs send
messages with invalid attributes (e.g., wrong length for a u32).  Yafang
reported this error message for tools/accounting/getdelays.c.

send_cmd() is wrongly adding 1 to the attribute length.  As noted in
include/uapi/linux/netlink.h nla_len should be NLA_HDRLEN + payload
length, so drop the +1.

Link: http://lkml.kernel.org/r/20200327173111.63922-1-dsahern@kernel.org
Fixes: 9e06d3f9f6b1 ("per task delay accounting taskstats interface: documentation fix")
Signed-off-by: David Ahern <dsahern@kernel.org>
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/accounting/getdelays.c~getdelays-fix-netlink-attribute-length
+++ a/tools/accounting/getdelays.c
@@ -136,7 +136,7 @@ static int send_cmd(int sd, __u16 nlmsg_
 	msg.g.version = 0x1;
 	na = (struct nlattr *) GENLMSG_DATA(&msg);
 	na->nla_type = nla_type;
-	na->nla_len = nla_len + 1 + NLA_HDRLEN;
+	na->nla_len = nla_len + NLA_HDRLEN;
 	memcpy(NLA_DATA(na), nla_data, nla_len);
 	msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
 
_

Patches currently in -mm which might be from dsahern@kernel.org are

getdelays-fix-netlink-attribute-length.patch
