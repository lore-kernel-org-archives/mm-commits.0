From: akpm@linux-foundation.org
Subject: [to-be-updated] net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch removed from -mm tree
Date: Thu, 07 Feb 2013 14:53:05 -0800
Message-ID: <20130207225305.E26E71E419F@corp2gmr1-2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:59595 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422669Ab3BGWxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 17:53:08 -0500
Received: by mail-we0-f202.google.com with SMTP id t11so211482wey.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 14:53:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, davem@davemloft.net, horms@verge.net.au, ja@ssi.bg, mm-commits@vger.kernel.org


The patch titled
     Subject: net: change type of netns_ipvs->sysctl_sync_qlen_max
has been removed from the -mm tree.  Its filename was
     net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: net: change type of netns_ipvs->sysctl_sync_qlen_max

This member of struct netns_ipvs is calculated from nr_free_buffer_pages
so change its type to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/ip_vs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/net/ip_vs.h~net-change-type-of-netns_ipvs-sysctl_sync_qlen_max include/net/ip_vs.h
--- a/include/net/ip_vs.h~net-change-type-of-netns_ipvs-sysctl_sync_qlen_max
+++ a/include/net/ip_vs.h
@@ -966,7 +966,7 @@ struct netns_ipvs {
 	int			sysctl_snat_reroute;
 	int			sysctl_sync_ver;
 	int			sysctl_sync_ports;
-	int			sysctl_sync_qlen_max;
+	unsigned long		sysctl_sync_qlen_max;
 	int			sysctl_sync_sock_size;
 	int			sysctl_cache_bypass;
 	int			sysctl_expire_nodest_conn;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

