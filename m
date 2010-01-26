From: akpm@linux-foundation.org
Subject: + idr-fix-a-critical-misallocation-bug.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:04:02 -0800
Message-ID: <201001260004.o0Q042fM018996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287Ab0AZAEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, eparis@redhat.com, stable@kernel.org


The patch titled
     idr: fix a critical misallocation bug
has been added to the -mm tree.  Its filename is
     idr-fix-a-critical-misallocation-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: fix a critical misallocation bug
From: Tejun Heo <tj@kernel.org>

Eric Paris located a bug in idr.  With IDR_BITS of 6, it grows to three
layers when id 4096 is first allocated.  When that happens, idr wraps
incorrectly and searches the idr array ignoring the high bits.  The
following test code from Eric demonstrates the bug nicely.

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

This happens because when sub_alloc() back tracks it doesn't always do it
step-by-step while the over-the-limit detection assumes step-by-step
backtracking.  The logic in sub_alloc() looks like the following.

  restart:
    clear pa[top level + 1] for end cond detection
    l = top level
    while (true) {
	search for empty slot at this level
	if (not found) {
	    push id to the next possible value
	    l++
A:	    if (pa[l] is clear)
	        failed, return asking caller to grow the tree
	    if (going up 1 level gives more slots to search)
	        continue the while loop above with the incremented l
	    else
C:	        goto restart
	}
	adjust id accordingly to the found slot
	if (l == 0)
	    return found id;
	create lower level if not there yet
	record pa[l] and l--
    }

Test A is the fail exit condition but this assumes that failure is
propagated upwared one level at a time but the B optimization path breaks
the assumption and restarts the whole thing with a start value which is
above the possible limit with the current layers.  sub_alloc() assumes the
start id value is inside the limit when called and test A is the only exit
condition check, so it ends up searching for empty slot while ignoring
high set bit.

So, for 4095->4096 test, level0 search fails but pa[1] contains a valid
pointer.  However, going up 1 level wouldn't give any more empty slot so
it takes C and when the whole thing restarts nobody notices the high bit
set beyond the top level.

This patch fixes the bug by changing the fail exit condition check to full
id limit check.

Based-on-patch-from: Eric Paris <eparis@redhat.com>
Reported-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/idr.c~idr-fix-a-critical-misallocation-bug lib/idr.c
--- a/lib/idr.c~idr-fix-a-critical-misallocation-bug
+++ a/lib/idr.c
@@ -140,8 +140,7 @@ static int sub_alloc(struct idr *idp, in
 	id = *starting_id;
  restart:
 	p = idp->top;
-	l = idp->layers;
-	pa[l--] = NULL;
+	l = p->layer;
 	while (1) {
 		/*
 		 * We run around this while until we reach the leaf node...
@@ -155,8 +154,8 @@ static int sub_alloc(struct idr *idp, in
 			oid = id;
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
-			/* if already at the top layer, we need to grow */
-			if (!(p = pa[l])) {
+			/* did id go over the limit? */
+			if (id >= (1 << (idp->layers * IDR_BITS))) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
idr-fix-a-critical-misallocation-bug.patch

