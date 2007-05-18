From: akpm@linux-foundation.org
Subject: + make-atm-driver-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:38 -0700
Message-ID: <200705181737.l4IHbceQ019851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:50086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbXERRkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:40:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, xemul@openvz.org


The patch titled
     Make ATM driver use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-atm-driver-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make ATM driver use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

The .show callback receives the list_head pointer now, not the struct
br2684_dev one.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/atm/br2684.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff -puN net/atm/br2684.c~make-atm-driver-use-seq_list_xxx-helpers net/atm/br2684.c
--- a/net/atm/br2684.c~make-atm-driver-use-seq_list_xxx-helpers
+++ a/net/atm/br2684.c
@@ -699,28 +699,13 @@ static struct atm_ioctl br2684_ioctl_ops
 #ifdef CONFIG_PROC_FS
 static void *br2684_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	loff_t offs = 0;
-	struct br2684_dev *brd;
-
 	read_lock(&devs_lock);
-
-	list_for_each_entry(brd, &br2684_devs, br2684_devs) {
-		if (offs == *pos)
-			return brd;
-		++offs;
-	}
-	return NULL;
+	return seq_list_start(&br2684_devs, *pos);
 }
 
 static void *br2684_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct br2684_dev *brd = v;
-
-	++*pos;
-
-	brd = list_entry(brd->br2684_devs.next,
-			 struct br2684_dev, br2684_devs);
-	return (&brd->br2684_devs != &br2684_devs) ? brd : NULL;
+	return seq_list_next(v, &br2684_devs, pos);
 }
 
 static void br2684_seq_stop(struct seq_file *seq, void *v)
@@ -730,7 +715,8 @@ static void br2684_seq_stop(struct seq_f
 
 static int br2684_seq_show(struct seq_file *seq, void *v)
 {
-	const struct br2684_dev *brdev = v;
+	const struct br2684_dev *brdev = list_entry(v, struct br2684_dev,
+			br2684_devs);
 	const struct net_device *net_dev = brdev->net_dev;
 	const struct br2684_vcc *brvcc;
 
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
