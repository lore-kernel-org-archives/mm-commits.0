From: akpm@linux-foundation.org
Subject: [merged] getdelays-fix-netlink-attribute-length.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:34:46 -0700
Message-ID: <20200403203446.7Y-81g_t1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUet (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsahern@kernel.org, johannes@sipsolutions.net, laoar.shao@gmail.com, mm-commits@vger.kernel.org, nagar@watson.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: tools/accounting/getdelays.c: fix netlink attribute length
has been removed from the -mm tree.  Its filename was
     getdelays-fix-netlink-attribute-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
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
