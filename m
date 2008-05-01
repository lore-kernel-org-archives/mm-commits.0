From: akpm@linux-foundation.org
Subject: - net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch removed from -mm tree
Date: Thu, 01 May 2008 01:16:10 -0700
Message-ID: <200805010816.m418GAsx027832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbYEAIQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 04:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     net/ipv4/ip_output.c:ip_send_check() mustn't be inline
has been removed from the -mm tree.  Its filename was
     net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/ipv4/ip_output.c:ip_send_check() mustn't be inline
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error with UML and gcc 4.3:

/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c: In function `__ip_local_out':
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c:89: sorry, unimplemented: inlining failed in call to `ip_send_check': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c:99: sorry, unimplemented: called from here

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ip_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/ip_output.c~net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c~net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline
+++ a/net/ipv4/ip_output.c
@@ -85,7 +85,7 @@
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 
 /* Generate a checksum for an outgoing IP datagram. */
-__inline__ void ip_send_check(struct iphdr *iph)
+void ip_send_check(struct iphdr *iph)
 {
 	iph->check = 0;
 	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-marker_debug-static.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch

