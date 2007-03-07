From: akpm@linux-foundation.org
Subject: - knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:51 -0800
Message-ID: <200703070421.l274LpSa018940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47074 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXCGEVz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: remove CONFIG_IPV6 ifdefs from sunrpc server code
has been removed from the -mm tree.  Its filename was
     knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: remove CONFIG_IPV6 ifdefs from sunrpc server code
From: NeilBrown <neilb@suse.de>

They don't really save that much, and aren't worth the hassle.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svc.h |    2 --
 net/sunrpc/svcsock.c       |   13 +++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff -puN include/linux/sunrpc/svc.h~knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code
+++ a/include/linux/sunrpc/svc.h
@@ -194,9 +194,7 @@ static inline void svc_putu32(struct kve
 
 union svc_addr_u {
     struct in_addr	addr;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
     struct in6_addr	addr6;
-#endif
 };
 
 /*
diff -puN net/sunrpc/svcsock.c~knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code
+++ a/net/sunrpc/svcsock.c
@@ -131,13 +131,13 @@ static char *__svc_print_addr(struct soc
 			NIPQUAD(((struct sockaddr_in *) addr)->sin_addr),
 			htons(((struct sockaddr_in *) addr)->sin_port));
 		break;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+
 	case AF_INET6:
 		snprintf(buf, len, "%x:%x:%x:%x:%x:%x:%x:%x, port=%u",
 			NIP6(((struct sockaddr_in6 *) addr)->sin6_addr),
 			htons(((struct sockaddr_in6 *) addr)->sin6_port));
 		break;
-#endif
+
 	default:
 		snprintf(buf, len, "unknown address type: %d", addr->sa_family);
 		break;
@@ -449,9 +449,7 @@ svc_wake_up(struct svc_serv *serv)
 
 union svc_pktinfo_u {
 	struct in_pktinfo pkti;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	struct in6_pktinfo pkti6;
-#endif
 };
 
 static void svc_set_cmsg_data(struct svc_rqst *rqstp, struct cmsghdr *cmh)
@@ -467,7 +465,7 @@ static void svc_set_cmsg_data(struct svc
 			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
 		}
 		break;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+
 	case AF_INET6: {
 			struct in6_pktinfo *pki = CMSG_DATA(cmh);
 
@@ -479,7 +477,6 @@ static void svc_set_cmsg_data(struct svc
 			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
 		}
 		break;
-#endif
 	}
 	return;
 }
@@ -730,13 +727,11 @@ static inline void svc_udp_get_dest_addr
 		rqstp->rq_daddr.addr.s_addr = pki->ipi_spec_dst.s_addr;
 		break;
 		}
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6: {
 		struct in6_pktinfo *pki = CMSG_DATA(cmh);
 		ipv6_addr_copy(&rqstp->rq_daddr.addr6, &pki->ipi6_addr);
 		break;
 		}
-#endif
 	}
 }
 
@@ -985,11 +980,9 @@ static inline int svc_port_is_privileged
 	case AF_INET:
 		return ntohs(((struct sockaddr_in *)sin)->sin_port)
 			< PROT_SOCK;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6:
 		return ntohs(((struct sockaddr_in6 *)sin)->sin6_port)
 			< PROT_SOCK;
-#endif
 	default:
 		return 0;
 	}
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
