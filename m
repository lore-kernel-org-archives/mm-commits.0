From: akpm@linux-foundation.org
Subject: - sysctl-update-sysctl_checks-list-of-binary-paths.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:49:16 -0700
Message-ID: <200710180849.l9I8nGCZ002884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932342AbXJRItX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, davem@davemloft.net, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     sysctl: update sysctl_checks list of binary paths
has been removed from the -mm tree.  Its filename was
     sysctl-update-sysctl_checks-list-of-binary-paths.patch

This patch was dropped because it was folded into sysctl-update-sysctl_check_table.patch

------------------------------------------------------
Subject: sysctl: update sysctl_checks list of binary paths
From: Eric W. Biederman <ebiederm@xmission.com>

In the netfilter code and the ipv6 ipqueue code I have found two more binary
paths that don't conflict with anything.  So this patch adds them to the list
of valid sysctl binary paths.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/sysctl_check.c~sysctl-update-sysctl_checks-list-of-binary-paths kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-update-sysctl_checks-list-of-binary-paths
+++ a/kernel/sysctl_check.c
@@ -565,6 +565,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_IPV6_IP6FRAG_TIME,	"ip6frag_time" },
 	{ NET_IPV6_IP6FRAG_SECRET_INTERVAL,	"ip6frag_secret_interval" },
 	{ NET_IPV6_MLD_MAX_MSF,		"mld_max_msf" },
+	{ 2088 /* IPQ_QMAX */,		"ip6_queue_maxlen" },
 	{}
 };
 
@@ -723,6 +724,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_LLC,		"llc",		trans_net_llc_table },
 	{ NET_NETFILTER,	"netfilter",	trans_net_netfilter_table },
 	{ NET_DCCP,		"dccp",		trans_net_dccp_table },
+	{ 2089,			"nf_conntrack_max" },
 	{}
 };
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-parport-remove-binary-paths.patch
sysctl-simplify-the-pty-sysctl-logic.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
sysctl-properly-register-the-irda-binary-sysctl-numbers.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch
sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch
