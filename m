From: akpm@linux-foundation.org
Subject: + aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
 added to -mm tree
Date: Fri, 26 Jul 2013 13:36:07 -0700
Message-ID: <51f2ddb7.PH/78hDOxZyGB1i4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759613Ab3GZUgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:36:07 -0700


The patch titled
     Subject: aoe: fill in per-AoE-target information for debugfs file
has been added to the -mm tree.  Its filename is
     aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch

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
Subject: aoe: fill in per-AoE-target information for debugfs file

This information is presented in a compact format that has evolved for
easy routine scanning by expert humans, mostly developers and support
technicians helping to troubleshoot or test AoE-based systems.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-fill-in-per-aoe-target-information-for-debugfs-file drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-fill-in-per-aoe-target-information-for-debugfs-file
+++ a/drivers/block/aoe/aoeblk.c
@@ -113,11 +113,42 @@ static ssize_t aoedisk_show_payload(stru
 static int aoedisk_debugfs_show(struct seq_file *s, void *ignored)
 {
 	struct aoedev *d;
+	struct aoetgt **t, **te;
+	struct aoeif *ifp, *ife;
 	unsigned long flags;
+	char c;
 
 	d = s->private;
+	seq_printf(s, "rttavg: %d rttdev: %d\n",
+		d->rttavg >> RTTSCALE,
+		d->rttdev >> RTTDSCALE);
+	seq_printf(s, "nskbpool: %d\n", skb_queue_len(&d->skbpool));
+	seq_printf(s, "kicked: %ld\n", d->kicked);
+	seq_printf(s, "maxbcnt: %ld\n", d->maxbcnt);
+	seq_printf(s, "ref: %ld\n", d->ref);
+
 	spin_lock_irqsave(&d->lock, flags);
-	seq_printf(s, "%s\n", d->gd->disk_name); /* place holder */
+	t = d->targets;
+	te = t + d->ntargets;
+	for (; t < te && *t; t++) {
+		c = '\t';
+		seq_printf(s, "falloc: %ld\n", (*t)->falloc);
+		seq_printf(s, "ffree: %p\n",
+			list_empty(&(*t)->ffree) ? NULL : (*t)->ffree.next);
+		seq_printf(s, "%pm:%d:%d:%d\n", (*t)->addr, (*t)->nout,
+			(*t)->maxout, (*t)->nframes);
+		seq_printf(s, "\tssthresh:%d\n", (*t)->ssthresh);
+		seq_printf(s, "\ttaint:%d\n", (*t)->taint);
+		seq_printf(s, "\tr:%d\n", (*t)->rpkts);
+		seq_printf(s, "\tw:%d\n", (*t)->wpkts);
+		ifp = (*t)->ifs;
+		ife = ifp + ARRAY_SIZE((*t)->ifs);
+		for (; ifp->nd && ifp < ife; ifp++) {
+			seq_printf(s, "%c%s", c, ifp->nd->name);
+			c = ',';
+		}
+		seq_puts(s, "\n");
+	}
 	spin_unlock_irqrestore(&d->lock, flags);
 
 	return 0;
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-create-and-destroy-debugfs-directory-for-aoe.patch
aoe-add-aoe-target-files-to-debugfs.patch
aoe-provide-file-operations-for-debugfs-files.patch
aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-85.patch

