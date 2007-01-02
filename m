From: akpm@osdl.org
Subject: + simplify-some-code-to-use-the-container_of-macro.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:42:54 -0800
Message-ID: <200701022242.l02Mgtmx032358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907AbXABWoT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, davem@davemloft.net, heiko.carstens@de.ibm.com, jmorris@namei.org, kaber@trash.net, mchehab@infradead.org, paulus@samba.org, schwidefsky@de.ibm.com, sds@tycho.nsa.gov


The patch titled
     Simplify some code to use the container_of() macro
has been added to the -mm tree.  Its filename is
     simplify-some-code-to-use-the-container_of-macro.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Simplify some code to use the container_of() macro
From: "Robert P. J. Day" <rpjday@mindspring.com>

Simplify a number of code snippets in source and header files to use the
kernel.h "container_of()" macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/ppp_generic.c        |    2 +-
 drivers/s390/net/lcs.c           |    6 ++----
 drivers/video/sa1100fb.h         |    4 +---
 include/linux/security.h         |    2 +-
 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 security/selinux/hooks.c         |    2 +-
 6 files changed, 7 insertions(+), 11 deletions(-)

diff -puN drivers/net/ppp_generic.c~simplify-some-code-to-use-the-container_of-macro drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~simplify-some-code-to-use-the-container_of-macro
+++ a/drivers/net/ppp_generic.c
@@ -83,7 +83,7 @@ struct ppp_file {
 	int		dead;		/* unit/channel has been shut down */
 };
 
-#define PF_TO_X(pf, X)		((X *)((char *)(pf) - offsetof(X, file)))
+#define PF_TO_X(pf, X)		container_of(pf, X, file)
 
 #define PF_TO_PPP(pf)		PF_TO_X(pf, struct ppp)
 #define PF_TO_CHANNEL(pf)	PF_TO_X(pf, struct channel)
diff -puN drivers/s390/net/lcs.c~simplify-some-code-to-use-the-container_of-macro drivers/s390/net/lcs.c
--- a/drivers/s390/net/lcs.c~simplify-some-code-to-use-the-container_of-macro
+++ a/drivers/s390/net/lcs.c
@@ -1511,8 +1511,7 @@ lcs_txbuffer_cb(struct lcs_channel *chan
 	LCS_DBF_TEXT(5, trace, "txbuffcb");
 	/* Put buffer back to pool. */
 	lcs_release_buffer(channel, buffer);
-	card = (struct lcs_card *)
-		((char *) channel - offsetof(struct lcs_card, write));
+	card = container_of(channel, struct lcs_card, write);
 	if (netif_queue_stopped(card->dev) && netif_carrier_ok(card->dev))
 		netif_wake_queue(card->dev);
 	spin_lock(&card->lock);
@@ -1810,8 +1809,7 @@ lcs_get_frames_cb(struct lcs_channel *ch
 		LCS_DBF_TEXT(4, trace, "-eiogpkt");
 		return;
 	}
-	card = (struct lcs_card *)
-		((char *) channel - offsetof(struct lcs_card, read));
+	card = container_of(channel, struct lcs_card, write);
 	offset = 0;
 	while (lcs_hdr->offset != 0) {
 		if (lcs_hdr->offset <= 0 ||
diff -puN drivers/video/sa1100fb.h~simplify-some-code-to-use-the-container_of-macro drivers/video/sa1100fb.h
--- a/drivers/video/sa1100fb.h~simplify-some-code-to-use-the-container_of-macro
+++ a/drivers/video/sa1100fb.h
@@ -110,9 +110,7 @@ struct sa1100fb_info {
 #endif
 };
 
-#define __type_entry(ptr,type,member) ((type *)((char *)(ptr)-offsetof(type,member)))
-
-#define TO_INF(ptr,member)	__type_entry(ptr,struct sa1100fb_info,member)
+#define TO_INF(ptr,member)	container_of(ptr,struct sa1100fb_info,member)
 
 #define SA1100_PALETTE_MODE_VAL(bpp)    (((bpp) & 0x018) << 9)
 
diff -puN include/linux/security.h~simplify-some-code-to-use-the-container_of-macro include/linux/security.h
--- a/include/linux/security.h~simplify-some-code-to-use-the-container_of-macro
+++ a/include/linux/security.h
@@ -496,7 +496,7 @@ struct request_sock;
  *	Note that the fown_struct, @fown, is never outside the context of a
  *	struct file, so the file structure (and associated security information)
  *	can always be obtained:
- *		(struct file *)((long)fown - offsetof(struct file,f_owner));
+ *		container_of(fown, struct file, f_owner)
  * 	@tsk contains the structure of task receiving signal.
  *	@fown contains the file owner information.
  *	@sig is the signal that will be sent.  When 0, kernel sends SIGIO.
diff -puN net/ipv4/netfilter/nf_nat_core.c~simplify-some-code-to-use-the-container_of-macro net/ipv4/netfilter/nf_nat_core.c
--- a/net/ipv4/netfilter/nf_nat_core.c~simplify-some-code-to-use-the-container_of-macro
+++ a/net/ipv4/netfilter/nf_nat_core.c
@@ -168,7 +168,7 @@ find_appropriate_src(const struct nf_con
 
 	read_lock_bh(&nf_nat_lock);
 	list_for_each_entry(nat, &bysource[h], info.bysource) {
-		ct = (struct nf_conn *)((char *)nat - offsetof(struct nf_conn, data));
+		ct = container_of(nat, struct nf_conn, data);
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
 			nf_ct_invert_tuplepr(result,
diff -puN security/selinux/hooks.c~simplify-some-code-to-use-the-container_of-macro security/selinux/hooks.c
--- a/security/selinux/hooks.c~simplify-some-code-to-use-the-container_of-macro
+++ a/security/selinux/hooks.c
@@ -2654,7 +2654,7 @@ static int selinux_file_send_sigiotask(s
 	struct file_security_struct *fsec;
 
 	/* struct fown_struct is never outside the context of a struct file */
-        file = (struct file *)((long)fown - offsetof(struct file,f_owner));
+        file = container_of(fown, struct file, f_owner);
 
 	tsec = tsk->security;
 	fsec = file->f_security;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
simplify-some-code-to-use-the-container_of-macro.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
