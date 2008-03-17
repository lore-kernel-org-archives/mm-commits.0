From: akpm@linux-foundation.org
Subject: + netfilter-ipt_recent-sanity-check-hit-count.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:20:25 -0700
Message-ID: <200803172320.m2HNKPJ1003494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbYCQXUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:20:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@hozac.com, kaber@trash.net, skennedy@vcn.com


The patch titled
     netfilter: ipt_recent: sanity check hit count
has been added to the -mm tree.  Its filename is
     netfilter-ipt_recent-sanity-check-hit-count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netfilter: ipt_recent: sanity check hit count
From: "Daniel Hokka Zakrisson" <daniel@hozac.com>

If a rule using ipt_recent is created with a hit count greater than
ip_pkt_list_tot, the rule will never match as it cannot keep track of enough
timestamps.  This patch makes ipt_recent refuse to create such rules.

With ip_pkt_list_tot's default value of 20, the following can be used
to reproduce the problem.

nc -u -l 0.0.0.0 1234 &
for i in `seq 1 100`; do echo $i | nc -w 1 -u 127.0.0.1 1234; done

This limits it to 20 packets:
iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
         --rsource
iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
         60 --hitcount 20 --name test --rsource -j DROP

While this is unlimited:
iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
         --rsource
iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
         60 --hitcount 21 --name test --rsource -j DROP

With the patch the second rule-set will throw an EINVAL.

Signed-off-by: Daniel Hokka Zakrisson <daniel@hozac.com>
Reported-by: Sean Kennedy <skennedy@vcn.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/ipt_recent.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN net/ipv4/netfilter/ipt_recent.c~netfilter-ipt_recent-sanity-check-hit-count net/ipv4/netfilter/ipt_recent.c
--- a/net/ipv4/netfilter/ipt_recent.c~netfilter-ipt_recent-sanity-check-hit-count
+++ a/net/ipv4/netfilter/ipt_recent.c
@@ -252,6 +252,8 @@ recent_mt_check(const char *tablename, c
 	if ((info->check_set & (IPT_RECENT_SET | IPT_RECENT_REMOVE)) &&
 	    (info->seconds || info->hit_count))
 		return false;
+	if (info->hit_count > ip_pkt_list_tot)
+		return false;
 	if (info->name[0] == '\0' ||
 	    strnlen(info->name, IPT_RECENT_NAME_LEN) == IPT_RECENT_NAME_LEN)
 		return false;
_

Patches currently in -mm which might be from daniel@hozac.com are

netfilter-ipt_recent-sanity-check-hit-count.patch

