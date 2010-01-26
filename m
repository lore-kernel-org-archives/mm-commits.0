From: akpm@linux-foundation.org
Subject: [to-be-updated] idr-fix-idr-corruption-when-id-crosses-a-layer-boundary.patch removed from -mm tree
Date: Mon, 25 Jan 2010 16:04:12 -0800
Message-ID: <201001260004.o0Q04C7L019007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab0AZAEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:04:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: fix idr corruption when id crosses a layer boundary
has been removed from the -mm tree.  Its filename was
     idr-fix-idr-corruption-when-id-crosses-a-layer-boundary.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: fix idr corruption when id crosses a layer boundary
From: Eric Paris <eparis@redhat.com>

inotify has for months been been having problems keeping the fsnotify view
of its objects in sync with the idr view of its objects.  I discovered
this was only ever the case with the 4096th object created.  What actually
happened is that inotify would try to do the following operation:

idr_get_new_above(idr, NULL, 4095, &id);
and would get id=4095.
idr_get_new_above(idr, NULL, 4095, &id);
and would get id=4096.

Notice I used 4095 both times.  Everything seems fine.  We would then do:

idr_find(idr, 4095);
and would get the entry for 4095.
idr_find(idr, 4096);
and would get NULL!!  WHOOPS!

idr_remove(idr, 4096) strangely enough didn't blow up.

What I discovered was that when adding an id >= 4096 the idr needed to
grow another layer.  This was normally dealt with in idr_get_empty_slot()
if we found that the id was larger than the idr could hold.  The problem
was that I was passing 4095 which appeared to be small enough to fit, but
in sub_alloc() we found that 4095 was taken and bumped it up to 4096.  I
added a test in sub_alloc() which kicks back out if the id is changed to
be larger than fits in the idr.  I readily admit that I don't understand
the other part of that test or how we 'get back to the top layer.' I
wonder if that is not what was supposed to deal with this.  This certainly
needs some review, but it fixes my problem and should finally silence the
months and months old inotify complaints people's machines have been
spewing...


 #include <linux/idr.h>
 #include <linux/kernel.h>
 #include <linux/module.h>

static DEFINE_IDR(test_idr);

int init_module(void)
{
	int ret, forty95, forty96;
	void *addr;

	/* add 2 entries both with 4095 as the start address */
again1:
	if (!idr_pre_get(&test_idr, GFP_KERNEL))
		return -ENOMEM;
	ret = idr_get_new_above(&test_idr, (void *)4095, 4095, &forty95);
	if (ret) {
		if (ret == -EAGAIN)
			goto again1;
		return ret;
	}
	if (forty95 != 4095)
		printk(KERN_ERR "hmmm, forty95=%d\n", forty95);

again2:
	if (!idr_pre_get(&test_idr, GFP_KERNEL))
		return -ENOMEM;
	ret = idr_get_new_above(&test_idr, (void *)4096, 4095, &forty96);
	if (ret) {
		if (ret == -EAGAIN)
			goto again2;
		return ret;
	}
	if (forty96 != 4096)
		printk(KERN_ERR "hmmm, forty96=%d\n", forty96);

	/* try to find the 2 entries, noticing that 4096 broke */
	addr = idr_find(&test_idr, forty95);
	if ((int)addr != forty95)
		printk(KERN_ERR "hmmm, after find forty95=%d addr=%d\n", forty95, (int)addr);
	addr = idr_find(&test_idr, forty96);
	if ((int)addr != forty96)
		printk(KERN_ERR "hmmm, after find forty96=%d addr=%d\n", forty96, (int)addr);
	/* really weird, the entry which should be at 4096 is actually at 0!! */
	addr = idr_find(&test_idr, 0);
	if ((int)addr)
		printk(KERN_ERR "found an entry at id=0 for addr=%d\n", (int)addr);

	idr_remove(&test_idr, forty95);
	idr_remove(&test_idr, forty96);

	return 0;
}

void cleanup_module(void)
{
}

MODULE_AUTHOR("Eric Paris <eparis@redhat.com>");
MODULE_DESCRIPTION("Simple idr test");
MODULE_LICENSE("GPL");

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN lib/idr.c~idr-fix-idr-corruption-when-id-crosses-a-layer-boundary lib/idr.c
--- a/lib/idr.c~idr-fix-idr-corruption-when-id-crosses-a-layer-boundary
+++ a/lib/idr.c
@@ -155,8 +155,12 @@ static int sub_alloc(struct idr *idp, in
 			oid = id;
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
-			/* if already at the top layer, we need to grow */
-			if (!(p = pa[l])) {
+			/*
+			 * if already at the top layer or if we just rounded id
+			 * to be so large the idp doesn't have enough layers,
+			 * we need to grow.
+			 */
+			if (!(p = pa[l]) || (id >= (1 << (idp->layers * IDR_BITS)))) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
@@ -260,7 +264,7 @@ build_up:
 
 static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
 {
-	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_LEVEL] = { NULL, };
 	int id;
 
 	id = idr_get_empty_slot(idp, starting_id, pa);
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
idr-fix-a-critical-misallocation-bug.patch
idr-fix-idr-corruption-when-id-crosses-a-layer-boundary.patch

