From: akpm@linux-foundation.org
Subject: - remove-broken-netfilter-binary-sysctls-from-bridging-code.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:46 -0700
Message-ID: <200710010714.l917Ek7R004558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbXJAHVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jfannin@gmail.com, davem@davemloft.net, ebiederm@xmission.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     Remove broken netfilter binary sysctls from bridging code
has been removed from the -mm tree.  Its filename was
     remove-broken-netfilter-binary-sysctls-from-bridging-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove broken netfilter binary sysctls from bridging code
From: jfannin@gmail.com (Joseph Fannin)

The netfilter sysctls in the bridging code don't set strategy routines:

 sysctl table check failed: /net/bridge/bridge-nf-call-arptables .3.10.1 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-call-iptables .3.10.2 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-call-ip6tables .3.10.3 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-filter-vlan-tagged .3.10.4 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-filter-pppoe-tagged .3.10.5 Missing strategy

These binary sysctls can't work.  The binary sysctl numbers of other
netfilter sysctls with this problem are being removed.  These need to go as
well.

Signed-off-by: Joseph Fannin <jfannin@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bridge/br_netfilter.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN net/bridge/br_netfilter.c~remove-broken-netfilter-binary-sysctls-from-bridging-code net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c~remove-broken-netfilter-binary-sysctls-from-bridging-code
+++ a/net/bridge/br_netfilter.c
@@ -904,7 +904,6 @@ int brnf_sysctl_call_tables(ctl_table * 
 
 static ctl_table brnf_table[] = {
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_ARPTABLES,
 		.procname	= "bridge-nf-call-arptables",
 		.data		= &brnf_call_arptables,
 		.maxlen		= sizeof(int),
@@ -912,7 +911,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_IPTABLES,
 		.procname	= "bridge-nf-call-iptables",
 		.data		= &brnf_call_iptables,
 		.maxlen		= sizeof(int),
@@ -920,7 +918,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_IP6TABLES,
 		.procname	= "bridge-nf-call-ip6tables",
 		.data		= &brnf_call_ip6tables,
 		.maxlen		= sizeof(int),
@@ -928,7 +925,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_FILTER_VLAN_TAGGED,
 		.procname	= "bridge-nf-filter-vlan-tagged",
 		.data		= &brnf_filter_vlan_tagged,
 		.maxlen		= sizeof(int),
@@ -936,7 +932,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_FILTER_PPPOE_TAGGED,
 		.procname	= "bridge-nf-filter-pppoe-tagged",
 		.data		= &brnf_filter_pppoe_tagged,
 		.maxlen		= sizeof(int),
_

Patches currently in -mm which might be from jfannin@gmail.com are

git-net.patch
