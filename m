From: akpm@linux-foundation.org
Subject: + aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:10:37 -0700
Message-ID: <20121017221038.2BF4D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40239 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2JQWKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:10:39 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so998975ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:10:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: update cap on outstanding commands based on config query response
has been added to the -mm tree.  Its filename is
     aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update cap on outstanding commands based on config query response

The ATA over Ethernet config query response contains a "buffer count"
field reflecting the AoE target's capacity to buffer incoming AoE
commands.

By taking the current value of this field into accound, we increase
performance throughput or avoid network congestion, when the value
has increased or decreased, respectively.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    6 +++---
 drivers/block/aoe/aoecmd.c |    6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-cap-on-outstanding-commands-based-on-config-query-response drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-cap-on-outstanding-commands-based-on-config-query-response
+++ a/drivers/block/aoe/aoe.h
@@ -122,14 +122,14 @@ struct aoeif {
 
 struct aoetgt {
 	unsigned char addr[6];
-	ushort nframes;
+	ushort nframes;		/* cap on frames to use */
 	struct aoedev *d;			/* parent device I belong to */
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
 	ushort nout;
-	ushort maxout;
-	ulong falloc;
+	ushort maxout;		/* current value for max outstanding */
+	ulong falloc;		/* number of allocated frames */
 	ulong lastwadj;		/* last window adjustment */
 	int minbcnt;
 	int wpkts, rpkts;
diff -puN drivers/block/aoe/aoecmd.c~aoe-update-cap-on-outstanding-commands-based-on-config-query-response drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-update-cap-on-outstanding-commands-based-on-config-query-response
+++ a/drivers/block/aoe/aoecmd.c
@@ -1373,7 +1373,11 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	spin_lock_irqsave(&d->lock, flags);
 
 	t = gettgt(d, h->src);
-	if (!t) {
+	if (t) {
+		t->nframes = n;
+		if (n < t->maxout)
+			t->maxout = n;
+	} else {
 		t = addtgt(d, h->src, n);
 		if (!t)
 			goto bail;
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

