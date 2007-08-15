From: akpm@linux-foundation.org
Subject: + sysctl-remove-broken-netfilter-binary-sysctls.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:59:51 -0700
Message-ID: <200708151959.l7FJxpMC012480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936357AbXHOUAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, davem@davemloft.net, kaber@trash.net


The patch titled
     sysctl: remove broken netfilter binary sysctls
has been added to the -mm tree.  Its filename is
     sysctl-remove-broken-netfilter-binary-sysctls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remove broken netfilter binary sysctls
From: Eric W. Biederman <ebiederm@xmission.com>

No one has bothered to set strategy routine for the the netfilter sysctls that
return jiffies to be sysctl_jiffies.

So it appears the sys_sysctl path is unused and untested, so this patch
removes the binary sysctl numbers.

Which fixes the netfilter oops in 2.6.23-rc2-mm2 for me.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    1 
 net/netfilter/nf_conntrack_proto_generic.c     |    2 -
 net/netfilter/nf_conntrack_proto_sctp.c        |   14 -----------
 net/netfilter/nf_conntrack_proto_tcp.c         |   18 ---------------
 net/netfilter/nf_conntrack_proto_udp.c         |    4 ---
 7 files changed, 42 deletions(-)

diff -puN net/ipv4/netfilter/nf_conntrack_proto_icmp.c~sysctl-remove-broken-netfilter-binary-sysctls net/ipv4/netfilter/nf_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c~sysctl-remove-broken-netfilter-binary-sysctls
+++ a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -284,7 +284,6 @@ static int icmp_nfattr_to_tuple(struct n
 static struct ctl_table_header *icmp_sysctl_header;
 static struct ctl_table icmp_sysctl_table[] = {
 	{
-		.ctl_name	= NET_NF_CONNTRACK_ICMP_TIMEOUT,
 		.procname	= "nf_conntrack_icmp_timeout",
 		.data		= &nf_ct_icmp_timeout,
 		.maxlen		= sizeof(unsigned int),
@@ -298,7 +297,6 @@ static struct ctl_table icmp_sysctl_tabl
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 static struct ctl_table icmp_compat_sysctl_table[] = {
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT,
 		.procname	= "ip_conntrack_icmp_timeout",
 		.data		= &nf_ct_icmp_timeout,
 		.maxlen		= sizeof(unsigned int),
diff -puN net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c~sysctl-remove-broken-netfilter-binary-sysctls net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c~sysctl-remove-broken-netfilter-binary-sysctls
+++ a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -305,7 +305,6 @@ static struct nf_hook_ops ipv6_conntrack
 #ifdef CONFIG_SYSCTL
 static ctl_table nf_ct_ipv6_sysctl_table[] = {
 	{
-		.ctl_name	= NET_NF_CONNTRACK_FRAG6_TIMEOUT,
 		.procname	= "nf_conntrack_frag6_timeout",
 		.data		= &nf_ct_frag6_timeout,
 		.maxlen		= sizeof(unsigned int),
diff -puN net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c~sysctl-remove-broken-netfilter-binary-sysctls net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c~sysctl-remove-broken-netfilter-binary-sysctls
+++ a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -263,7 +263,6 @@ static int icmpv6_nfattr_to_tuple(struct
 static struct ctl_table_header *icmpv6_sysctl_header;
 static struct ctl_table icmpv6_sysctl_table[] = {
 	{
-		.ctl_name	= NET_NF_CONNTRACK_ICMPV6_TIMEOUT,
 		.procname	= "nf_conntrack_icmpv6_timeout",
 		.data		= &nf_ct_icmpv6_timeout,
 		.maxlen		= sizeof(unsigned int),
diff -puN net/netfilter/nf_conntrack_proto_generic.c~sysctl-remove-broken-netfilter-binary-sysctls net/netfilter/nf_conntrack_proto_generic.c
--- a/net/netfilter/nf_conntrack_proto_generic.c~sysctl-remove-broken-netfilter-binary-sysctls
+++ a/net/netfilter/nf_conntrack_proto_generic.c
@@ -70,7 +70,6 @@ static int new(struct nf_conn *conntrack
 static struct ctl_table_header *generic_sysctl_header;
 static struct ctl_table generic_sysctl_table[] = {
 	{
-		.ctl_name	= NET_NF_CONNTRACK_GENERIC_TIMEOUT,
 		.procname	= "nf_conntrack_generic_timeout",
 		.data		= &nf_ct_generic_timeout,
 		.maxlen		= sizeof(unsigned int),
@@ -84,7 +83,6 @@ static struct ctl_table generic_sysctl_t
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 static struct ctl_table generic_compat_sysctl_table[] = {
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT,
 		.procname	= "ip_conntrack_generic_timeout",
 		.data		= &nf_ct_generic_timeout,
 		.maxlen		= sizeof(unsigned int),
diff -puN net/netfilter/nf_conntrack_proto_sctp.c~sysctl-remove-broken-netfilter-binary-sysctls net/netfilter/nf_conntrack_proto_sctp.c
--- a/net/netfilter/nf_conntrack_proto_sctp.c~sysctl-remove-broken-netfilter-binary-sysctls
+++ a/net/netfilter/nf_conntrack_proto_sctp.c
@@ -476,7 +476,6 @@ static unsigned int sctp_sysctl_table_us
 static struct ctl_table_header *sctp_sysctl_header;
 static struct ctl_table sctp_sysctl_table[] = {
 	{
-		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED,
 		.procname	= "nf_conntrack_sctp_timeout_closed",
 		.data		= &nf_ct_sctp_timeout_closed,
 		.maxlen		= sizeof(unsigned int),
@@ -484,7 +483,6 @@ static struct ctl_table sctp_sysctl_tabl
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_WAIT,
 		.procname	= "nf_conntrack_sctp_timeout_cookie_wait",
 		.data		= &nf_ct_sctp_timeout_cookie_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -492,7 +490,6 @@ static struct ctl_table sctp_sysctl_tabl
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_ECHOED,
 		.procname	= "nf_conntrack_sctp_timeout_cookie_echoed",
 		.data		= &nf_ct_sctp_timeout_cookie_echoed,
 		.maxlen		= sizeof(unsigned int),
@@ -500,7 +497,6 @@ static struct ctl_table sctp_sysctl_tabl
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_ESTABLISHED,
 		.procname	= "nf_conntrack_sctp_timeout_established",
 		.data		= &nf_ct_sctp_timeout_established,
 		.maxlen		= sizeof(unsigned int),
@@ -508,7 +504,6 @@ static struct ctl_table sctp_sysctl_tabl
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT,
 		.procname	= "nf_conntrack_sctp_timeout_shutdown_sent",
 		.data		= &nf_ct_sctp_timeout_shutdown_sent,
 		.maxlen		= sizeof(unsigned int),
@@ -516,7 +511,6 @@ static struct ctl_table sctp_sysctl_tabl
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD,
 		.procname	= "nf_conntrack_sctp_timeout_shutdown_recd",
 		.data		= &nf_ct_sctp_timeout_shutdown_recd,
 		.maxlen		= sizeof(unsigned int),
@@ -524,7 +518,6 @@ static struct ctl_table sctp_sysctl_tabl
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT,
 		.procname	= "nf_conntrack_sctp_timeout_shutdown_ack_sent",
 		.data		= &nf_ct_sctp_timeout_shutdown_ack_sent,
 		.maxlen		= sizeof(unsigned int),
@@ -539,7 +532,6 @@ static struct ctl_table sctp_sysctl_tabl
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 static struct ctl_table sctp_compat_sysctl_table[] = {
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED,
 		.procname	= "ip_conntrack_sctp_timeout_closed",
 		.data		= &nf_ct_sctp_timeout_closed,
 		.maxlen		= sizeof(unsigned int),
@@ -547,7 +539,6 @@ static struct ctl_table sctp_compat_sysc
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_WAIT,
 		.procname	= "ip_conntrack_sctp_timeout_cookie_wait",
 		.data		= &nf_ct_sctp_timeout_cookie_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -555,7 +546,6 @@ static struct ctl_table sctp_compat_sysc
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_COOKIE_ECHOED,
 		.procname	= "ip_conntrack_sctp_timeout_cookie_echoed",
 		.data		= &nf_ct_sctp_timeout_cookie_echoed,
 		.maxlen		= sizeof(unsigned int),
@@ -563,7 +553,6 @@ static struct ctl_table sctp_compat_sysc
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_ESTABLISHED,
 		.procname	= "ip_conntrack_sctp_timeout_established",
 		.data		= &nf_ct_sctp_timeout_established,
 		.maxlen		= sizeof(unsigned int),
@@ -571,7 +560,6 @@ static struct ctl_table sctp_compat_sysc
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT,
 		.procname	= "ip_conntrack_sctp_timeout_shutdown_sent",
 		.data		= &nf_ct_sctp_timeout_shutdown_sent,
 		.maxlen		= sizeof(unsigned int),
@@ -579,7 +567,6 @@ static struct ctl_table sctp_compat_sysc
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD,
 		.procname	= "ip_conntrack_sctp_timeout_shutdown_recd",
 		.data		= &nf_ct_sctp_timeout_shutdown_recd,
 		.maxlen		= sizeof(unsigned int),
@@ -587,7 +574,6 @@ static struct ctl_table sctp_compat_sysc
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT,
 		.procname	= "ip_conntrack_sctp_timeout_shutdown_ack_sent",
 		.data		= &nf_ct_sctp_timeout_shutdown_ack_sent,
 		.maxlen		= sizeof(unsigned int),
diff -puN net/netfilter/nf_conntrack_proto_tcp.c~sysctl-remove-broken-netfilter-binary-sysctls net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c~sysctl-remove-broken-netfilter-binary-sysctls
+++ a/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1166,7 +1166,6 @@ static unsigned int tcp_sysctl_table_use
 static struct ctl_table_header *tcp_sysctl_header;
 static struct ctl_table tcp_sysctl_table[] = {
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
 		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
 		.data		= &nf_ct_tcp_timeout_syn_sent,
 		.maxlen		= sizeof(unsigned int),
@@ -1174,7 +1173,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
 		.procname	= "nf_conntrack_tcp_timeout_syn_recv",
 		.data		= &nf_ct_tcp_timeout_syn_recv,
 		.maxlen		= sizeof(unsigned int),
@@ -1182,7 +1180,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
 		.procname	= "nf_conntrack_tcp_timeout_established",
 		.data		= &nf_ct_tcp_timeout_established,
 		.maxlen		= sizeof(unsigned int),
@@ -1190,7 +1187,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
 		.procname	= "nf_conntrack_tcp_timeout_fin_wait",
 		.data		= &nf_ct_tcp_timeout_fin_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -1198,7 +1194,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
 		.procname	= "nf_conntrack_tcp_timeout_close_wait",
 		.data		= &nf_ct_tcp_timeout_close_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -1206,7 +1201,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
 		.procname	= "nf_conntrack_tcp_timeout_last_ack",
 		.data		= &nf_ct_tcp_timeout_last_ack,
 		.maxlen		= sizeof(unsigned int),
@@ -1214,7 +1208,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
 		.procname	= "nf_conntrack_tcp_timeout_time_wait",
 		.data		= &nf_ct_tcp_timeout_time_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -1222,7 +1215,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
 		.procname	= "nf_conntrack_tcp_timeout_close",
 		.data		= &nf_ct_tcp_timeout_close,
 		.maxlen		= sizeof(unsigned int),
@@ -1230,7 +1222,6 @@ static struct ctl_table tcp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS,
 		.procname	= "nf_conntrack_tcp_timeout_max_retrans",
 		.data		= &nf_ct_tcp_timeout_max_retrans,
 		.maxlen		= sizeof(unsigned int),
@@ -1269,7 +1260,6 @@ static struct ctl_table tcp_sysctl_table
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 static struct ctl_table tcp_compat_sysctl_table[] = {
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
 		.procname	= "ip_conntrack_tcp_timeout_syn_sent",
 		.data		= &nf_ct_tcp_timeout_syn_sent,
 		.maxlen		= sizeof(unsigned int),
@@ -1277,7 +1267,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
 		.procname	= "ip_conntrack_tcp_timeout_syn_recv",
 		.data		= &nf_ct_tcp_timeout_syn_recv,
 		.maxlen		= sizeof(unsigned int),
@@ -1285,7 +1274,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
 		.procname	= "ip_conntrack_tcp_timeout_established",
 		.data		= &nf_ct_tcp_timeout_established,
 		.maxlen		= sizeof(unsigned int),
@@ -1293,7 +1281,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
 		.procname	= "ip_conntrack_tcp_timeout_fin_wait",
 		.data		= &nf_ct_tcp_timeout_fin_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -1301,7 +1288,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
 		.procname	= "ip_conntrack_tcp_timeout_close_wait",
 		.data		= &nf_ct_tcp_timeout_close_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -1309,7 +1295,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
 		.procname	= "ip_conntrack_tcp_timeout_last_ack",
 		.data		= &nf_ct_tcp_timeout_last_ack,
 		.maxlen		= sizeof(unsigned int),
@@ -1317,7 +1302,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
 		.procname	= "ip_conntrack_tcp_timeout_time_wait",
 		.data		= &nf_ct_tcp_timeout_time_wait,
 		.maxlen		= sizeof(unsigned int),
@@ -1325,7 +1309,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
 		.procname	= "ip_conntrack_tcp_timeout_close",
 		.data		= &nf_ct_tcp_timeout_close,
 		.maxlen		= sizeof(unsigned int),
@@ -1333,7 +1316,6 @@ static struct ctl_table tcp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS,
 		.procname	= "ip_conntrack_tcp_timeout_max_retrans",
 		.data		= &nf_ct_tcp_timeout_max_retrans,
 		.maxlen		= sizeof(unsigned int),
diff -puN net/netfilter/nf_conntrack_proto_udp.c~sysctl-remove-broken-netfilter-binary-sysctls net/netfilter/nf_conntrack_proto_udp.c
--- a/net/netfilter/nf_conntrack_proto_udp.c~sysctl-remove-broken-netfilter-binary-sysctls
+++ a/net/netfilter/nf_conntrack_proto_udp.c
@@ -146,7 +146,6 @@ static unsigned int udp_sysctl_table_use
 static struct ctl_table_header *udp_sysctl_header;
 static struct ctl_table udp_sysctl_table[] = {
 	{
-		.ctl_name	= NET_NF_CONNTRACK_UDP_TIMEOUT,
 		.procname	= "nf_conntrack_udp_timeout",
 		.data		= &nf_ct_udp_timeout,
 		.maxlen		= sizeof(unsigned int),
@@ -154,7 +153,6 @@ static struct ctl_table udp_sysctl_table
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
 		.procname	= "nf_conntrack_udp_timeout_stream",
 		.data		= &nf_ct_udp_timeout_stream,
 		.maxlen		= sizeof(unsigned int),
@@ -168,7 +166,6 @@ static struct ctl_table udp_sysctl_table
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 static struct ctl_table udp_compat_sysctl_table[] = {
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT,
 		.procname	= "ip_conntrack_udp_timeout",
 		.data		= &nf_ct_udp_timeout,
 		.maxlen		= sizeof(unsigned int),
@@ -176,7 +173,6 @@ static struct ctl_table udp_compat_sysct
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
-		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
 		.procname	= "ip_conntrack_udp_timeout_stream",
 		.data		= &nf_ct_udp_timeout_stream,
 		.maxlen		= sizeof(unsigned int),
_

Patches currently in -mm which might be from ebiederm@xmission.com are

dvb_en_50221-convert-to-kthread-api.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-remove-broken-cdrom-binary-sysctls-update.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-parport-remove-binary-paths.patch
sysctl-simplify-the-pty-sysctl-logic.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-clean-up-the-sched-debug-sysctl-usage.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
