From: akpm@linux-foundation.org
Subject: + net-sunrpc-replace-strict_strto-calls.patch added to -mm tree
Date: Mon, 23 Jun 2014 16:29:51 -0700
Message-ID: <53a8b86f.fICF+ssM6+6eRpeG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaFWX3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, trond.myklebust@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/sunrpc: replace strict_strto calls
has been added to the -mm tree.  Its filename is
     net-sunrpc-replace-strict_strto-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-sunrpc-replace-strict_strto-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-sunrpc-replace-strict_strto-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: net/sunrpc: replace strict_strto calls

Replace obsolete strict_strto calls with appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/addr.c     |   16 ++++++----------
 net/sunrpc/auth.c     |    2 +-
 net/sunrpc/xprtsock.c |    4 ++--
 3 files changed, 9 insertions(+), 13 deletions(-)

diff -puN net/sunrpc/addr.c~net-sunrpc-replace-strict_strto-calls net/sunrpc/addr.c
--- a/net/sunrpc/addr.c~net-sunrpc-replace-strict_strto-calls
+++ a/net/sunrpc/addr.c
@@ -176,7 +176,7 @@ static int rpc_parse_scope_id(struct net
 	len = (buf + buflen) - delim - 1;
 	p = kstrndup(delim + 1, len, GFP_KERNEL);
 	if (p) {
-		unsigned long scope_id = 0;
+		u32 scope_id = 0;
 		struct net_device *dev;
 
 		dev = dev_get_by_name(net, p);
@@ -184,7 +184,7 @@ static int rpc_parse_scope_id(struct net
 			scope_id = dev->ifindex;
 			dev_put(dev);
 		} else {
-			if (strict_strtoul(p, 10, &scope_id) == 0) {
+			if (kstrtou32(p, 10, &scope_id) == 0) {
 				kfree(p);
 				return 0;
 			}
@@ -304,7 +304,7 @@ char *rpc_sockaddr2uaddr(const struct so
  * @sap: buffer into which to plant socket address
  * @salen: size of buffer
  *
- * @uaddr does not have to be '\0'-terminated, but strict_strtoul() and
+ * @uaddr does not have to be '\0'-terminated, but kstrtou8() and
  * rpc_pton() require proper string termination to be successful.
  *
  * Returns the size of the socket address if successful; otherwise
@@ -315,7 +315,7 @@ size_t rpc_uaddr2sockaddr(struct net *ne
 			  const size_t salen)
 {
 	char *c, buf[RPCBIND_MAXUADDRLEN + sizeof('\0')];
-	unsigned long portlo, porthi;
+	u8 portlo, porthi;
 	unsigned short port;
 
 	if (uaddr_len > RPCBIND_MAXUADDRLEN)
@@ -327,18 +327,14 @@ size_t rpc_uaddr2sockaddr(struct net *ne
 	c = strrchr(buf, '.');
 	if (unlikely(c == NULL))
 		return 0;
-	if (unlikely(strict_strtoul(c + 1, 10, &portlo) != 0))
-		return 0;
-	if (unlikely(portlo > 255))
+	if (unlikely(kstrtou8(c + 1, 10, &portlo) != 0))
 		return 0;
 
 	*c = '\0';
 	c = strrchr(buf, '.');
 	if (unlikely(c == NULL))
 		return 0;
-	if (unlikely(strict_strtoul(c + 1, 10, &porthi) != 0))
-		return 0;
-	if (unlikely(porthi > 255))
+	if (unlikely(kstrtou8(c + 1, 10, &porthi) != 0))
 		return 0;
 
 	port = (unsigned short)((porthi << 8) | portlo);
diff -puN net/sunrpc/auth.c~net-sunrpc-replace-strict_strto-calls net/sunrpc/auth.c
--- a/net/sunrpc/auth.c~net-sunrpc-replace-strict_strto-calls
+++ a/net/sunrpc/auth.c
@@ -48,7 +48,7 @@ static int param_set_hashtbl_sz(const ch
 
 	if (!val)
 		goto out_inval;
-	ret = strict_strtoul(val, 0, &num);
+	ret = kstrtoul(val, 0, &num);
 	if (ret == -EINVAL)
 		goto out_inval;
 	nbits = fls(num);
diff -puN net/sunrpc/xprtsock.c~net-sunrpc-replace-strict_strto-calls net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~net-sunrpc-replace-strict_strto-calls
+++ a/net/sunrpc/xprtsock.c
@@ -3054,12 +3054,12 @@ static int param_set_uint_minmax(const c
 		const struct kernel_param *kp,
 		unsigned int min, unsigned int max)
 {
-	unsigned long num;
+	unsigned int num;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
-	ret = strict_strtoul(val, 0, &num);
+	ret = kstrtouint(val, 0, &num);
 	if (ret == -EINVAL || num < min || num > max)
 		return -EINVAL;
 	*((unsigned int *)kp->arg) = num;
_

Patches currently in -mm which might be from dwalter@google.com are

arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
arch-powerpc-replace-obsolete-strict_strto-calls.patch
arch-x86-replace-strict_strto-calls.patch
drivers-scsi-replace-strict_strto-calls.patch
net-sunrpc-replace-strict_strto-calls.patch
include-linux-remove-strict_strto-definitions.patch

