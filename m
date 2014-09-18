From: akpm@linux-foundation.org
Subject: + netfilter-replace-strnicmp-with-strncasecmp.patch added to -mm
 tree
Date: Thu, 18 Sep 2014 14:36:08 -0700
Message-ID: <541b5048.UiXKDGjZJsIAVUcy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaIRVgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: netfilter: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     netfilter-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/netfilter-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/netfilter-replace-strnicmp-with-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: netfilter: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipvs/ip_vs_ftp.c   |    6 +++---
 net/netfilter/nf_conntrack_ftp.c |    4 ++--
 net/netfilter/nf_conntrack_sip.c |   22 +++++++++++-----------
 net/netfilter/nf_log.c           |    2 +-
 net/netfilter/nf_nat_sip.c       |    2 +-
 5 files changed, 18 insertions(+), 18 deletions(-)

diff -puN net/netfilter/ipvs/ip_vs_ftp.c~netfilter-replace-strnicmp-with-strncasecmp net/netfilter/ipvs/ip_vs_ftp.c
--- a/net/netfilter/ipvs/ip_vs_ftp.c~netfilter-replace-strnicmp-with-strncasecmp
+++ a/net/netfilter/ipvs/ip_vs_ftp.c
@@ -96,13 +96,13 @@ static int ip_vs_ftp_get_addrport(char *
 
 	if (data_limit - data < plen) {
 		/* check if there is partial match */
-		if (strnicmp(data, pattern, data_limit - data) == 0)
+		if (strncasecmp(data, pattern, data_limit - data) == 0)
 			return -1;
 		else
 			return 0;
 	}
 
-	if (strnicmp(data, pattern, plen) != 0) {
+	if (strncasecmp(data, pattern, plen) != 0) {
 		return 0;
 	}
 	s = data + plen;
@@ -353,7 +353,7 @@ static int ip_vs_ftp_in(struct ip_vs_app
 	data_limit = skb_tail_pointer(skb);
 
 	while (data <= data_limit - 6) {
-		if (strnicmp(data, "PASV\r\n", 6) == 0) {
+		if (strncasecmp(data, "PASV\r\n", 6) == 0) {
 			/* Passive mode on */
 			IP_VS_DBG(7, "got PASV at %td of %td\n",
 				  data - data_start,
diff -puN net/netfilter/nf_conntrack_ftp.c~netfilter-replace-strnicmp-with-strncasecmp net/netfilter/nf_conntrack_ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c~netfilter-replace-strnicmp-with-strncasecmp
+++ a/net/netfilter/nf_conntrack_ftp.c
@@ -304,12 +304,12 @@ static int find_pattern(const char *data
 
 	if (dlen <= plen) {
 		/* Short packet: try for partial? */
-		if (strnicmp(data, pattern, dlen) == 0)
+		if (strncasecmp(data, pattern, dlen) == 0)
 			return -1;
 		else return 0;
 	}
 
-	if (strnicmp(data, pattern, plen) != 0) {
+	if (strncasecmp(data, pattern, plen) != 0) {
 #if 0
 		size_t i;
 
diff -puN net/netfilter/nf_conntrack_sip.c~netfilter-replace-strnicmp-with-strncasecmp net/netfilter/nf_conntrack_sip.c
--- a/net/netfilter/nf_conntrack_sip.c~netfilter-replace-strnicmp-with-strncasecmp
+++ a/net/netfilter/nf_conntrack_sip.c
@@ -247,7 +247,7 @@ int ct_sip_parse_request(const struct nf
 	for (; dptr < limit - strlen("sip:"); dptr++) {
 		if (*dptr == '\r' || *dptr == '\n')
 			return -1;
-		if (strnicmp(dptr, "sip:", strlen("sip:")) == 0) {
+		if (strncasecmp(dptr, "sip:", strlen("sip:")) == 0) {
 			dptr += strlen("sip:");
 			break;
 		}
@@ -350,7 +350,7 @@ static const char *ct_sip_header_search(
 			continue;
 		}
 
-		if (strnicmp(dptr, needle, len) == 0)
+		if (strncasecmp(dptr, needle, len) == 0)
 			return dptr;
 	}
 	return NULL;
@@ -383,10 +383,10 @@ int ct_sip_get_header(const struct nf_co
 		/* Find header. Compact headers must be followed by a
 		 * non-alphabetic character to avoid mismatches. */
 		if (limit - dptr >= hdr->len &&
-		    strnicmp(dptr, hdr->name, hdr->len) == 0)
+		    strncasecmp(dptr, hdr->name, hdr->len) == 0)
 			dptr += hdr->len;
 		else if (hdr->cname && limit - dptr >= hdr->clen + 1 &&
-			 strnicmp(dptr, hdr->cname, hdr->clen) == 0 &&
+			 strncasecmp(dptr, hdr->cname, hdr->clen) == 0 &&
 			 !isalpha(*(dptr + hdr->clen)))
 			dptr += hdr->clen;
 		else
@@ -620,9 +620,9 @@ static int ct_sip_parse_transport(struct
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strnicmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
 			*proto = IPPROTO_TCP;
-		else if (!strnicmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
@@ -743,10 +743,10 @@ int ct_sip_get_sdp_header(const struct n
 
 		if (term != SDP_HDR_UNSPEC &&
 		    limit - dptr >= thdr->len &&
-		    strnicmp(dptr, thdr->name, thdr->len) == 0)
+		    strncasecmp(dptr, thdr->name, thdr->len) == 0)
 			break;
 		else if (limit - dptr >= hdr->len &&
-			 strnicmp(dptr, hdr->name, hdr->len) == 0)
+			 strncasecmp(dptr, hdr->name, hdr->len) == 0)
 			dptr += hdr->len;
 		else
 			continue;
@@ -1394,7 +1394,7 @@ static int process_sip_response(struct s
 		if (handler->response == NULL)
 			continue;
 		if (*datalen < matchend + handler->len ||
-		    strnicmp(*dptr + matchend, handler->method, handler->len))
+		    strncasecmp(*dptr + matchend, handler->method, handler->len))
 			continue;
 		return handler->response(skb, protoff, dataoff, dptr, datalen,
 					 cseq, code);
@@ -1435,7 +1435,7 @@ static int process_sip_request(struct sk
 		if (handler->request == NULL)
 			continue;
 		if (*datalen < handler->len ||
-		    strnicmp(*dptr, handler->method, handler->len))
+		    strncasecmp(*dptr, handler->method, handler->len))
 			continue;
 
 		if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_CSEQ,
@@ -1462,7 +1462,7 @@ static int process_sip_msg(struct sk_buf
 	const struct nf_nat_sip_hooks *hooks;
 	int ret;
 
-	if (strnicmp(*dptr, "SIP/2.0 ", strlen("SIP/2.0 ")) != 0)
+	if (strncasecmp(*dptr, "SIP/2.0 ", strlen("SIP/2.0 ")) != 0)
 		ret = process_sip_request(skb, protoff, dataoff, dptr, datalen);
 	else
 		ret = process_sip_response(skb, protoff, dataoff, dptr, datalen);
diff -puN net/netfilter/nf_log.c~netfilter-replace-strnicmp-with-strncasecmp net/netfilter/nf_log.c
--- a/net/netfilter/nf_log.c~netfilter-replace-strnicmp-with-strncasecmp
+++ a/net/netfilter/nf_log.c
@@ -30,7 +30,7 @@ static struct nf_logger *__find_logger(i
 
 		log = rcu_dereference_protected(loggers[pf][i],
 						lockdep_is_held(&nf_log_mutex));
-		if (!strnicmp(str_logger, log->name, strlen(log->name)))
+		if (!strncasecmp(str_logger, log->name, strlen(log->name)))
 			return log;
 	}
 
diff -puN net/netfilter/nf_nat_sip.c~netfilter-replace-strnicmp-with-strncasecmp net/netfilter/nf_nat_sip.c
--- a/net/netfilter/nf_nat_sip.c~netfilter-replace-strnicmp-with-strncasecmp
+++ a/net/netfilter/nf_nat_sip.c
@@ -155,7 +155,7 @@ static unsigned int nf_nat_sip(struct sk
 	int request, in_header;
 
 	/* Basic rules: requests and responses. */
-	if (strnicmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
+	if (strncasecmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
 		if (ct_sip_parse_request(ct, *dptr, *datalen,
 					 &matchoff, &matchlen,
 					 &addr, &port) > 0 &&
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
arm-replace-strnicmp-with-strncasecmp.patch
block-replace-strnicmp-with-strncasecmp.patch
netfilter-replace-strnicmp-with-strncasecmp.patch
video-fbdev-replace-strnicmp-with-strncasecmp.patch
cifs-replace-strnicmp-with-strncasecmp.patch
ocfs2-replace-strnicmp-with-strncasecmp.patch
isofs-replace-strnicmp-with-strncasecmp.patch
batman-adv-replace-strnicmp-with-strncasecmp.patch
acpi-battery-replace-strnicmp-with-strncasecmp.patch
cpufreq-replace-strnicmp-with-strncasecmp.patch
cpuidle-replace-strnicmp-with-strncasecmp.patch
scsi-replace-strnicmp-with-strncasecmp.patch
ib_srpt-replace-strnicmp-with-strncasecmp.patch
input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch
altera-stapl-replace-strnicmp-with-strncasecmp.patch
thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
pnp-replace-strnicmp-with-strncasecmp.patch
s390-cio-replace-strnicmp-with-strncasecmp.patch
staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
thermal-replace-strnicmp-with-strncasecmp.patch
kdb-replace-strnicmp-with-strncasecmp.patch

