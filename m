From: akpm@osdl.org
Subject: - knfsd-dont-ignore-kstrdup-failure-in-rpc-caches.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:17:52 -0800
Message-ID: <200612140617.kBE6HpHL002318@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52732 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbWLNGSJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: Don't ignore kstrdup failure in rpc caches
has been removed from the -mm tree.  Its filename was
     knfsd-dont-ignore-kstrdup-failure-in-rpc-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: Don't ignore kstrdup failure in rpc caches
From: NeilBrown <neilb@suse.de>

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/sunrpc/svcauth_unix.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN net/sunrpc/svcauth_unix.c~knfsd-dont-ignore-kstrdup-failure-in-rpc-caches net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~knfsd-dont-ignore-kstrdup-failure-in-rpc-caches
+++ a/net/sunrpc/svcauth_unix.c
@@ -53,6 +53,10 @@ struct auth_domain *unix_domain_find(cha
 			return NULL;
 		kref_init(&new->h.ref);
 		new->h.name = kstrdup(name, GFP_KERNEL);
+		if (new->h.name == NULL) {
+			kfree(new);
+			return NULL;
+		}
 		new->h.flavour = &svcauth_unix;
 		new->addr_changes = 0;
 		rv = auth_domain_lookup(name, &new->h);
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

