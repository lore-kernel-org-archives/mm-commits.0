From: akpm@linux-foundation.org
Subject: + make-some-netfilter-related-proc-files-use-seq_list_xxx.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:56 -0700
Message-ID: <200705181737.l4IHbu4h019876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:47263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbXERRrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, davem@davemloft.net, kaber@trash.net, xemul@openvz.org


The patch titled
     Make some netfilter-related proc files use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-some-netfilter-related-proc-files-use-seq_list_xxx.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make some netfilter-related proc files use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

This includes /proc/net/ip_conntrack_expect file.

Although struct nf_conntrack_expect has list_head as the very first element I
use list_entry in .show callback to emphasize the fact that *v is the
list_head pointer.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |   27 +---------
 net/netfilter/nf_conntrack_expect.c                   |   27 +---------
 2 files changed, 8 insertions(+), 46 deletions(-)

diff -puN net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c~make-some-netfilter-related-proc-files-use-seq_list_xxx net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c~make-some-netfilter-related-proc-files-use-seq_list_xxx
+++ a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -208,35 +208,15 @@ static const struct file_operations ct_f
 /* expects */
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct list_head *e = &nf_conntrack_expect_list;
-	loff_t i;
-
 	/* strange seq_file api calls stop even if we fail,
 	 * thus we need to grab lock since stop unlocks */
 	read_lock_bh(&nf_conntrack_lock);
-
-	if (list_empty(e))
-		return NULL;
-
-	for (i = 0; i <= *pos; i++) {
-		e = e->next;
-		if (e == &nf_conntrack_expect_list)
-			return NULL;
-	}
-	return e;
+	return seq_list_start(&nf_conntrack_expect_list, *pos);
 }
 
 static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct list_head *e = v;
-
-	++*pos;
-	e = e->next;
-
-	if (e == &nf_conntrack_expect_list)
-		return NULL;
-
-	return e;
+	return seq_list_next(v, &nf_conntrack_expect_list, pos);
 }
 
 static void exp_seq_stop(struct seq_file *s, void *v)
@@ -246,7 +226,8 @@ static void exp_seq_stop(struct seq_file
 
 static int exp_seq_show(struct seq_file *s, void *v)
 {
-	struct nf_conntrack_expect *exp = v;
+	struct nf_conntrack_expect *exp = list_entry(v,
+			struct nf_conntrack_expect, list);
 
 	if (exp->tuple.src.l3num != AF_INET)
 		return 0;
diff -puN net/netfilter/nf_conntrack_expect.c~make-some-netfilter-related-proc-files-use-seq_list_xxx net/netfilter/nf_conntrack_expect.c
--- a/net/netfilter/nf_conntrack_expect.c~make-some-netfilter-related-proc-files-use-seq_list_xxx
+++ a/net/netfilter/nf_conntrack_expect.c
@@ -366,35 +366,15 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_re
 #ifdef CONFIG_PROC_FS
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct list_head *e = &nf_conntrack_expect_list;
-	loff_t i;
-
 	/* strange seq_file api calls stop even if we fail,
 	 * thus we need to grab lock since stop unlocks */
 	read_lock_bh(&nf_conntrack_lock);
-
-	if (list_empty(e))
-		return NULL;
-
-	for (i = 0; i <= *pos; i++) {
-		e = e->next;
-		if (e == &nf_conntrack_expect_list)
-			return NULL;
-	}
-	return e;
+	return seq_list_start(&nf_conntrack_expect_list, *pos);
 }
 
 static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct list_head *e = v;
-
-	++*pos;
-	e = e->next;
-
-	if (e == &nf_conntrack_expect_list)
-		return NULL;
-
-	return e;
+	return seq_list_next(v, &nf_conntrack_expect_list, pos);
 }
 
 static void exp_seq_stop(struct seq_file *s, void *v)
@@ -404,7 +384,8 @@ static void exp_seq_stop(struct seq_file
 
 static int exp_seq_show(struct seq_file *s, void *v)
 {
-	struct nf_conntrack_expect *expect = v;
+	struct nf_conntrack_expect *expect = list_entry(v,
+			struct nf_conntrack_expect, list);
 
 	if (expect->timeout.function)
 		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
_

Patches currently in -mm which might be from xemul@sw.ru are

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-afs-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
