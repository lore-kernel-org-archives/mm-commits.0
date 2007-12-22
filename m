From: akpm@linux-foundation.org
Subject: + constify-tables-in-kernel-sysctl_checkc.patch added to -mm tree
Date: Fri, 21 Dec 2007 21:04:44 -0800
Message-ID: <200712220504.lBM54i72018257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbXLVFFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 00:05:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, davej@codemonkey.org.uk, ebiederm@xmission.com


The patch titled
     constify tables in kernel/sysctl_check.c
has been added to the -mm tree.  Its filename is
     constify-tables-in-kernel-sysctl_checkc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: constify tables in kernel/sysctl_check.c
From: "Jan Beulich" <jbeulich@novell.com>

Remains the question whether it is intended that many, perhaps even large,
tables are compiled in without ever having a chance to get used, i.e. 
whether there shouldn't #ifdef CONFIG_xxx get added.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |  151 +++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 76 deletions(-)

diff -puN kernel/sysctl_check.c~constify-tables-in-kernel-sysctl_checkc kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~constify-tables-in-kernel-sysctl_checkc
+++ a/kernel/sysctl_check.c
@@ -8,10 +8,10 @@
 struct trans_ctl_table {
 	int			ctl_name;
 	const char		*procname;
-	struct trans_ctl_table	*child;
+	const struct trans_ctl_table *child;
 };
 
-static struct trans_ctl_table trans_random_table[] = {
+static const struct trans_ctl_table trans_random_table[] = {
 	{ RANDOM_POOLSIZE,	"poolsize" },
 	{ RANDOM_ENTROPY_COUNT,	"entropy_avail" },
 	{ RANDOM_READ_THRESH,	"read_wakeup_threshold" },
@@ -21,13 +21,13 @@ static struct trans_ctl_table trans_rand
 	{}
 };
 
-static struct trans_ctl_table trans_pty_table[] = {
+static const struct trans_ctl_table trans_pty_table[] = {
 	{ PTY_MAX,		"max" },
 	{ PTY_NR,		"nr" },
 	{}
 };
 
-static struct trans_ctl_table trans_kern_table[] = {
+static const struct trans_ctl_table trans_kern_table[] = {
 	{ KERN_OSTYPE,			"ostype" },
 	{ KERN_OSRELEASE,		"osrelease" },
 	/* KERN_OSREV not used */
@@ -107,7 +107,7 @@ static struct trans_ctl_table trans_kern
 	{}
 };
 
-static struct trans_ctl_table trans_vm_table[] = {
+static const struct trans_ctl_table trans_vm_table[] = {
 	{ VM_OVERCOMMIT_MEMORY,		"overcommit_memory" },
 	{ VM_PAGE_CLUSTER,		"page-cluster" },
 	{ VM_DIRTY_BACKGROUND,		"dirty_background_ratio" },
@@ -139,7 +139,7 @@ static struct trans_ctl_table trans_vm_t
 	{}
 };
 
-static struct trans_ctl_table trans_net_core_table[] = {
+static const struct trans_ctl_table trans_net_core_table[] = {
 	{ NET_CORE_WMEM_MAX,		"wmem_max" },
 	{ NET_CORE_RMEM_MAX,		"rmem_max" },
 	{ NET_CORE_WMEM_DEFAULT,	"wmem_default" },
@@ -165,14 +165,14 @@ static struct trans_ctl_table trans_net_
 	{},
 };
 
-static struct trans_ctl_table trans_net_unix_table[] = {
+static const struct trans_ctl_table trans_net_unix_table[] = {
 	/* NET_UNIX_DESTROY_DELAY unused */
 	/* NET_UNIX_DELETE_DELAY unused */
 	{ NET_UNIX_MAX_DGRAM_QLEN,	"max_dgram_qlen" },
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv4_route_table[] = {
+static const struct trans_ctl_table trans_net_ipv4_route_table[] = {
 	{ NET_IPV4_ROUTE_FLUSH,			"flush" },
 	{ NET_IPV4_ROUTE_MIN_DELAY,		"min_delay" },
 	{ NET_IPV4_ROUTE_MAX_DELAY,		"max_delay" },
@@ -195,7 +195,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv4_conf_vars_table[] = {
+static const struct trans_ctl_table trans_net_ipv4_conf_vars_table[] = {
 	{ NET_IPV4_CONF_FORWARDING,		"forwarding" },
 	{ NET_IPV4_CONF_MC_FORWARDING,		"mc_forwarding" },
 
@@ -222,14 +222,14 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv4_conf_table[] = {
+static const struct trans_ctl_table trans_net_ipv4_conf_table[] = {
 	{ NET_PROTO_CONF_ALL,		"all",		trans_net_ipv4_conf_vars_table },
 	{ NET_PROTO_CONF_DEFAULT,	"default",	trans_net_ipv4_conf_vars_table },
 	{ 0, NULL, trans_net_ipv4_conf_vars_table },
 	{}
 };
 
-static struct trans_ctl_table trans_net_neigh_vars_table[] = {
+static const struct trans_ctl_table trans_net_neigh_vars_table[] = {
 	{ NET_NEIGH_MCAST_SOLICIT,	"mcast_solicit" },
 	{ NET_NEIGH_UCAST_SOLICIT,	"ucast_solicit" },
 	{ NET_NEIGH_APP_SOLICIT,	"app_solicit" },
@@ -251,13 +251,13 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_neigh_table[] = {
+static const struct trans_ctl_table trans_net_neigh_table[] = {
 	{ NET_PROTO_CONF_DEFAULT, "default", trans_net_neigh_vars_table },
 	{ 0, NULL, trans_net_neigh_vars_table },
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv4_netfilter_table[] = {
+static const struct trans_ctl_table trans_net_ipv4_netfilter_table[] = {
 	{ NET_IPV4_NF_CONNTRACK_MAX,				"ip_conntrack_max" },
 
 	{ NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,		"ip_conntrack_tcp_timeout_syn_sent" },
@@ -294,7 +294,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv4_table[] = {
+static const struct trans_ctl_table trans_net_ipv4_table[] = {
 	{ NET_IPV4_FORWARD,			"ip_forward" },
 	{ NET_IPV4_DYNADDR,			"ip_dynaddr" },
 
@@ -393,13 +393,13 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipx_table[] = {
+static const struct trans_ctl_table trans_net_ipx_table[] = {
 	{ NET_IPX_PPROP_BROADCASTING,	"ipx_pprop_broadcasting" },
 	/* NET_IPX_FORWARDING unused */
 	{}
 };
 
-static struct trans_ctl_table trans_net_atalk_table[] = {
+static const struct trans_ctl_table trans_net_atalk_table[] = {
 	{ NET_ATALK_AARP_EXPIRY_TIME,		"aarp-expiry-time" },
 	{ NET_ATALK_AARP_TICK_TIME,		"aarp-tick-time" },
 	{ NET_ATALK_AARP_RETRANSMIT_LIMIT,	"aarp-retransmit-limit" },
@@ -407,7 +407,7 @@ static struct trans_ctl_table trans_net_
 	{},
 };
 
-static struct trans_ctl_table trans_net_netrom_table[] = {
+static const struct trans_ctl_table trans_net_netrom_table[] = {
 	{ NET_NETROM_DEFAULT_PATH_QUALITY,		"default_path_quality" },
 	{ NET_NETROM_OBSOLESCENCE_COUNT_INITIALISER,	"obsolescence_count_initialiser" },
 	{ NET_NETROM_NETWORK_TTL_INITIALISER,		"network_ttl_initialiser" },
@@ -423,7 +423,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ax25_param_table[] = {
+static const struct trans_ctl_table trans_net_ax25_table[] = {
 	{ NET_AX25_IP_DEFAULT_MODE,	"ip_default_mode" },
 	{ NET_AX25_DEFAULT_MODE,	"ax25_default_mode" },
 	{ NET_AX25_BACKOFF_TYPE,	"backoff_type" },
@@ -441,12 +441,12 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ax25_table[] = {
+static const struct trans_ctl_table trans_net_ax25_table[] = {
 	{ 0, NULL, trans_net_ax25_param_table },
 	{}
 };
 
-static struct trans_ctl_table trans_net_bridge_table[] = {
+static const struct trans_ctl_table trans_net_bridge_table[] = {
 	{ NET_BRIDGE_NF_CALL_ARPTABLES,		"bridge-nf-call-arptables" },
 	{ NET_BRIDGE_NF_CALL_IPTABLES,		"bridge-nf-call-iptables" },
 	{ NET_BRIDGE_NF_CALL_IP6TABLES,		"bridge-nf-call-ip6tables" },
@@ -455,7 +455,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_rose_table[] = {
+static const struct trans_ctl_table trans_net_rose_table[] = {
 	{ NET_ROSE_RESTART_REQUEST_TIMEOUT,	"restart_request_timeout" },
 	{ NET_ROSE_CALL_REQUEST_TIMEOUT,	"call_request_timeout" },
 	{ NET_ROSE_RESET_REQUEST_TIMEOUT,	"reset_request_timeout" },
@@ -469,7 +469,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv6_conf_var_table[] = {
+static const struct trans_ctl_table trans_net_ipv6_conf_var_table[] = {
 	{ NET_IPV6_FORWARDING,			"forwarding" },
 	{ NET_IPV6_HOP_LIMIT,			"hop_limit" },
 	{ NET_IPV6_MTU,				"mtu" },
@@ -497,14 +497,14 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv6_conf_table[] = {
+static const struct trans_ctl_table trans_net_ipv6_conf_table[] = {
 	{ NET_PROTO_CONF_ALL,		"all",	trans_net_ipv6_conf_var_table },
 	{ NET_PROTO_CONF_DEFAULT, 	"default", trans_net_ipv6_conf_var_table },
 	{ 0, NULL, trans_net_ipv6_conf_var_table },
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv6_route_table[] = {
+static const struct trans_ctl_table trans_net_ipv6_route_table[] = {
 	{ NET_IPV6_ROUTE_FLUSH,			"flush" },
 	{ NET_IPV6_ROUTE_GC_THRESH,		"gc_thresh" },
 	{ NET_IPV6_ROUTE_MAX_SIZE,		"max_size" },
@@ -518,12 +518,12 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv6_icmp_table[] = {
+static const struct trans_ctl_table trans_net_ipv6_icmp_table[] = {
 	{ NET_IPV6_ICMP_RATELIMIT,	"ratelimit" },
 	{}
 };
 
-static struct trans_ctl_table trans_net_ipv6_table[] = {
+static const struct trans_ctl_table trans_net_ipv6_table[] = {
 	{ NET_IPV6_CONF,		"conf",		trans_net_ipv6_conf_table },
 	{ NET_IPV6_NEIGH,		"neigh",	trans_net_neigh_table },
 	{ NET_IPV6_ROUTE,		"route",	trans_net_ipv6_route_table },
@@ -538,7 +538,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_x25_table[] = {
+static const struct trans_ctl_table trans_net_x25_table[] = {
 	{ NET_X25_RESTART_REQUEST_TIMEOUT,	"restart_request_timeout" },
 	{ NET_X25_CALL_REQUEST_TIMEOUT,		"call_request_timeout" },
 	{ NET_X25_RESET_REQUEST_TIMEOUT,	"reset_request_timeout" },
@@ -548,13 +548,13 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_tr_table[] = {
+static const struct trans_ctl_table trans_net_tr_table[] = {
 	{ NET_TR_RIF_TIMEOUT,	"rif_timeout" },
 	{}
 };
 
 
-static struct trans_ctl_table trans_net_decnet_conf_vars[] = {
+static const struct trans_ctl_table trans_net_decnet_conf_vars[] = {
 	{ NET_DECNET_CONF_DEV_FORWARDING,	"forwarding" },
 	{ NET_DECNET_CONF_DEV_PRIORITY,		"priority" },
 	{ NET_DECNET_CONF_DEV_T2,		"t2" },
@@ -562,12 +562,12 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_decnet_conf[] = {
+static const struct trans_ctl_table trans_net_decnet_conf[] = {
 	{ 0, NULL, trans_net_decnet_conf_vars },
 	{}
 };
 
-static struct trans_ctl_table trans_net_decnet_table[] = {
+static const struct trans_ctl_table trans_net_decnet_table[] = {
 	{ NET_DECNET_CONF,		"conf",	trans_net_decnet_conf },
 	{ NET_DECNET_NODE_ADDRESS,	"node_address" },
 	{ NET_DECNET_NODE_NAME,		"node_name" },
@@ -585,7 +585,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_sctp_table[] = {
+static const struct trans_ctl_table trans_net_sctp_table[] = {
 	{ NET_SCTP_RTO_INITIAL,		"rto_initial" },
 	{ NET_SCTP_RTO_MIN,		"rto_min" },
 	{ NET_SCTP_RTO_MAX,		"rto_max" },
@@ -606,7 +606,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_llc_llc2_timeout_table[] = {
+static const struct trans_ctl_table trans_net_llc_llc2_timeout_table[] = {
 	{ NET_LLC2_ACK_TIMEOUT,		"ack" },
 	{ NET_LLC2_P_TIMEOUT,		"p" },
 	{ NET_LLC2_REJ_TIMEOUT,		"rej" },
@@ -614,23 +614,23 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_llc_station_table[] = {
+static const struct trans_ctl_table trans_net_llc_station_table[] = {
 	{ NET_LLC_STATION_ACK_TIMEOUT,	"ack_timeout" },
 	{}
 };
 
-static struct trans_ctl_table trans_net_llc_llc2_table[] = {
+static const struct trans_ctl_table trans_net_llc_llc2_table[] = {
 	{ NET_LLC2,		"timeout",	trans_net_llc_llc2_timeout_table },
 	{}
 };
 
-static struct trans_ctl_table trans_net_llc_table[] = {
+static const struct trans_ctl_table trans_net_llc_table[] = {
 	{ NET_LLC2,		"llc2",		trans_net_llc_llc2_table },
 	{ NET_LLC_STATION,	"station",	trans_net_llc_station_table },
 	{}
 };
 
-static struct trans_ctl_table trans_net_netfilter_table[] = {
+static const struct trans_ctl_table trans_net_netfilter_table[] = {
 	{ NET_NF_CONNTRACK_MAX,				"nf_conntrack_max" },
 	{ NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,	"nf_conntrack_tcp_timeout_syn_sent" },
 	{ NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,	"nf_conntrack_tcp_timeout_syn_recv" },
@@ -667,12 +667,12 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_dccp_table[] = {
+static const struct trans_ctl_table trans_net_dccp_table[] = {
 	{ NET_DCCP_DEFAULT,	"default" },
 	{}
 };
 
-static struct trans_ctl_table trans_net_irda_table[] = {
+static const struct trans_ctl_table trans_net_irda_table[] = {
 	{ NET_IRDA_DISCOVERY,		"discovery" },
 	{ NET_IRDA_DEVNAME,		"devname" },
 	{ NET_IRDA_DEBUG,		"debug" },
@@ -690,7 +690,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_net_table[] = {
+static const struct trans_ctl_table trans_net_table[] = {
 	{ NET_CORE,		"core",		trans_net_core_table },
 	/* NET_ETHER not used */
 	/* NET_802 not used */
@@ -716,7 +716,7 @@ static struct trans_ctl_table trans_net_
 	{}
 };
 
-static struct trans_ctl_table trans_fs_quota_table[] = {
+static const struct trans_ctl_table trans_fs_quota_table[] = {
 	{ FS_DQ_LOOKUPS,	"lookups" },
 	{ FS_DQ_DROPS,		"drops" },
 	{ FS_DQ_READS,		"reads" },
@@ -729,7 +729,7 @@ static struct trans_ctl_table trans_fs_q
 	{}
 };
 
-static struct trans_ctl_table trans_fs_xfs_table[] = {
+static const struct trans_ctl_table trans_fs_xfs_table[] = {
 	{ XFS_RESTRICT_CHOWN,	"restrict_chown" },
 	{ XFS_SGID_INHERIT,	"irix_sgid_inherit" },
 	{ XFS_SYMLINK_MODE,	"irix_symlink_mode" },
@@ -750,24 +750,24 @@ static struct trans_ctl_table trans_fs_x
 	{}
 };
 
-static struct trans_ctl_table trans_fs_ocfs2_nm_table[] = {
+static const struct trans_ctl_table trans_fs_ocfs2_nm_table[] = {
 	{ 1, "hb_ctl_path" },
 	{}
 };
 
-static struct trans_ctl_table trans_fs_ocfs2_table[] = {
+static const struct trans_ctl_table trans_fs_ocfs2_table[] = {
 	{ 1,	"nm",	trans_fs_ocfs2_nm_table },
 	{}
 };
 
-static struct trans_ctl_table trans_inotify_table[] = {
+static const struct trans_ctl_table trans_inotify_table[] = {
 	{ INOTIFY_MAX_USER_INSTANCES,	"max_user_instances" },
 	{ INOTIFY_MAX_USER_WATCHES,	"max_user_watches" },
 	{ INOTIFY_MAX_QUEUED_EVENTS,	"max_queued_events" },
 	{}
 };
 
-static struct trans_ctl_table trans_fs_table[] = {
+static const struct trans_ctl_table trans_fs_table[] = {
 	{ FS_NRINODE,		"inode-nr" },
 	{ FS_STATINODE,		"inode-state" },
 	/* FS_MAXINODE unused */
@@ -793,11 +793,11 @@ static struct trans_ctl_table trans_fs_t
 	{}
 };
 
-static struct trans_ctl_table trans_debug_table[] = {
+static const struct trans_ctl_table trans_debug_table[] = {
 	{}
 };
 
-static struct trans_ctl_table trans_cdrom_table[] = {
+static const struct trans_ctl_table trans_cdrom_table[] = {
 	{ DEV_CDROM_INFO,		"info" },
 	{ DEV_CDROM_AUTOCLOSE,		"autoclose" },
 	{ DEV_CDROM_AUTOEJECT,		"autoeject" },
@@ -807,12 +807,12 @@ static struct trans_ctl_table trans_cdro
 	{}
 };
 
-static struct trans_ctl_table trans_ipmi_table[] = {
+static const struct trans_ctl_table trans_ipmi_table[] = {
 	{ DEV_IPMI_POWEROFF_POWERCYCLE,	"poweroff_powercycle" },
 	{}
 };
 
-static struct trans_ctl_table trans_mac_hid_files[] = {
+static const struct trans_ctl_table trans_mac_hid_files[] = {
 	/* DEV_MAC_HID_KEYBOARD_SENDS_LINUX_KEYCODES unused */
 	/* DEV_MAC_HID_KEYBOARD_LOCK_KEYCODES unused */
 	{ DEV_MAC_HID_MOUSE_BUTTON_EMULATION,	"mouse_button_emulation" },
@@ -822,35 +822,35 @@ static struct trans_ctl_table trans_mac_
 	{}
 };
 
-static struct trans_ctl_table trans_raid_table[] = {
+static const struct trans_ctl_table trans_raid_table[] = {
 	{ DEV_RAID_SPEED_LIMIT_MIN,	"speed_limit_min" },
 	{ DEV_RAID_SPEED_LIMIT_MAX,	"speed_limit_max" },
 	{}
 };
 
-static struct trans_ctl_table trans_scsi_table[] = {
+static const struct trans_ctl_table trans_scsi_table[] = {
 	{ DEV_SCSI_LOGGING_LEVEL, "logging_level" },
 	{}
 };
 
-static struct trans_ctl_table trans_parport_default_table[] = {
+static const struct trans_ctl_table trans_parport_default_table[] = {
 	{ DEV_PARPORT_DEFAULT_TIMESLICE,	"timeslice" },
 	{ DEV_PARPORT_DEFAULT_SPINTIME,		"spintime" },
 	{}
 };
 
-static struct trans_ctl_table trans_parport_device_table[] = {
+static const struct trans_ctl_table trans_parport_device_table[] = {
 	{ DEV_PARPORT_DEVICE_TIMESLICE,		"timeslice" },
 	{}
 };
 
-static struct trans_ctl_table trans_parport_devices_table[] = {
+static const struct trans_ctl_table trans_parport_devices_table[] = {
 	{ DEV_PARPORT_DEVICES_ACTIVE,		"active" },
 	{ 0, NULL, trans_parport_device_table },
 	{}
 };
 
-static struct trans_ctl_table trans_parport_parport_table[] = {
+static const struct trans_ctl_table trans_parport_parport_table[] = {
 	{ DEV_PARPORT_SPINTIME,		"spintime" },
 	{ DEV_PARPORT_BASE_ADDR,	"base-addr" },
 	{ DEV_PARPORT_IRQ,		"irq" },
@@ -864,13 +864,13 @@ static struct trans_ctl_table trans_parp
 	{ DEV_PARPORT_AUTOPROBE + 4,	"autoprobe3" },
 	{}
 };
-static struct trans_ctl_table trans_parport_table[] = {
+static const struct trans_ctl_table trans_parport_table[] = {
 	{ DEV_PARPORT_DEFAULT,	"default",	trans_parport_default_table },
 	{ 0, NULL, trans_parport_parport_table },
 	{}
 };
 
-static struct trans_ctl_table trans_dev_table[] = {
+static const struct trans_ctl_table trans_dev_table[] = {
 	{ DEV_CDROM,	"cdrom",	trans_cdrom_table },
 	/* DEV_HWMON unused */
 	{ DEV_PARPORT,	"parport",	trans_parport_table },
@@ -881,19 +881,19 @@ static struct trans_ctl_table trans_dev_
 	{}
 };
 
-static struct trans_ctl_table trans_bus_isa_table[] = {
+static const struct trans_ctl_table trans_bus_isa_table[] = {
 	{ BUS_ISA_MEM_BASE,	"membase" },
 	{ BUS_ISA_PORT_BASE,	"portbase" },
 	{ BUS_ISA_PORT_SHIFT,	"portshift" },
 	{}
 };
 
-static struct trans_ctl_table trans_bus_table[] = {
+static const struct trans_ctl_table trans_bus_table[] = {
 	{ CTL_BUS_ISA,	"isa",	trans_bus_isa_table },
 	{}
 };
 
-static struct trans_ctl_table trans_arlan_conf_table0[] = {
+static const struct trans_ctl_table trans_arlan_conf_table0[] = {
 	{ 1,	"spreadingCode" },
 	{ 2,	"channelNumber" },
 	{ 3,	"scramblingDisable" },
@@ -964,7 +964,7 @@ static struct trans_ctl_table trans_arla
 	{}
 };
 
-static struct trans_ctl_table trans_arlan_conf_table1[] = {
+static const struct trans_ctl_table trans_arlan_conf_table1[] = {
 	{ 1,	"spreadingCode" },
 	{ 2,	"channelNumber" },
 	{ 3,	"scramblingDisable" },
@@ -1035,7 +1035,7 @@ static struct trans_ctl_table trans_arla
 	{}
 };
 
-static struct trans_ctl_table trans_arlan_conf_table2[] = {
+static const struct trans_ctl_table trans_arlan_conf_table2[] = {
 	{ 1,	"spreadingCode" },
 	{ 2,	"channelNumber" },
 	{ 3,	"scramblingDisable" },
@@ -1106,7 +1106,7 @@ static struct trans_ctl_table trans_arla
 	{}
 };
 
-static struct trans_ctl_table trans_arlan_conf_table3[] = {
+static const struct trans_ctl_table trans_arlan_conf_table3[] = {
 	{ 1,	"spreadingCode" },
 	{ 2,	"channelNumber" },
 	{ 3,	"scramblingDisable" },
@@ -1177,7 +1177,7 @@ static struct trans_ctl_table trans_arla
 	{}
 };
 
-static struct trans_ctl_table trans_arlan_table[] = {
+static const struct trans_ctl_table trans_arlan_table[] = {
 	{ 1,		"arlan0",	trans_arlan_conf_table0 },
 	{ 2,		"arlan1",	trans_arlan_conf_table1 },
 	{ 3,		"arlan2",	trans_arlan_conf_table2 },
@@ -1185,13 +1185,13 @@ static struct trans_ctl_table trans_arla
 	{}
 };
 
-static struct trans_ctl_table trans_s390dbf_table[] = {
+static const struct trans_ctl_table trans_s390dbf_table[] = {
 	{ 5678 /* CTL_S390DBF_STOPPABLE */,	"debug_stoppable" },
 	{ 5679 /* CTL_S390DBF_ACTIVE */,	"debug_active" },
 	{}
 };
 
-static struct trans_ctl_table trans_sunrpc_table[] = {
+static const struct trans_ctl_table trans_sunrpc_table[] = {
 	{ CTL_RPCDEBUG,		"rpc_debug" },
 	{ CTL_NFSDEBUG,		"nfs_debug" },
 	{ CTL_NFSDDEBUG,	"nfsd_debug" },
@@ -1203,7 +1203,7 @@ static struct trans_ctl_table trans_sunr
 	{}
 };
 
-static struct trans_ctl_table trans_pm_table[] = {
+static const struct trans_ctl_table trans_pm_table[] = {
 	{ 1 /* CTL_PM_SUSPEND */,	"suspend" },
 	{ 2 /* CTL_PM_CMODE */,		"cmode" },
 	{ 3 /* CTL_PM_P0 */,		"p0" },
@@ -1211,13 +1211,13 @@ static struct trans_ctl_table trans_pm_t
 	{}
 };
 
-static struct trans_ctl_table trans_frv_table[] = {
+static const struct trans_ctl_table trans_frv_table[] = {
 	{ 1,	"cache-mode" },
 	{ 2,	"pin-cxnr" },
 	{}
 };
 
-static struct trans_ctl_table trans_root_table[] = {
+static const struct trans_ctl_table trans_root_table[] = {
 	{ CTL_KERN,	"kernel",	trans_kern_table },
 	{ CTL_VM,	"vm",		trans_vm_table },
 	{ CTL_NET,	"net",		trans_net_table },
@@ -1261,15 +1261,14 @@ static struct ctl_table *sysctl_parent(s
 	return table;
 }
 
-static struct trans_ctl_table *sysctl_binary_lookup(struct ctl_table *table)
+static const struct trans_ctl_table *sysctl_binary_lookup(struct ctl_table *table)
 {
 	struct ctl_table *test;
-	struct trans_ctl_table *ref;
-	int depth, cur_depth;
+	const struct trans_ctl_table *ref;
+	int cur_depth;
 
-	depth = sysctl_depth(table);
+	cur_depth = sysctl_depth(table);
 
-	cur_depth = depth;
 	ref = trans_root_table;
 repeat:
 	test = sysctl_parent(table, cur_depth);
@@ -1437,7 +1436,7 @@ static void sysctl_check_leaf(struct nsp
 
 static void sysctl_check_bin_path(struct ctl_table *table, const char **fail)
 {
-	struct trans_ctl_table *ref;
+	const struct trans_ctl_table *ref;
 
 	ref = sysctl_binary_lookup(table);
 	if (table->ctl_name && !ref)
_

Patches currently in -mm which might be from jbeulich@novell.com are

git-acpi.patch
ia64-remove-dead-code.patch
ia64-honor-notify_die-returning-notify_stop.patch
git-x86.patch
xen-fiddle_vdso-must-be-__init.patch
constify-tables-in-kernel-sysctl_checkc.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
