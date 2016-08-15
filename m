From: akpm@linux-foundation.org
Subject: + radix-tree-slot-can-be-null-in-radix_tree_next_slot.patch added to -mm tree
Date: Mon, 15 Aug 2016 14:51:27 -0700
Message-ID: <57b2395f.jyTwAc0x5S7lIZJd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbcHOVv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 17:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, aryabinin@virtuozzo.com, dvyukov@google.com, koct9i@gmail.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: 'slot' can be NULL in radix_tree_next_slot()
has been added to the -mm tree.  Its filename is
     radix-tree-slot-can-be-null-in-radix_tree_next_slot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-slot-can-be-null-in-radix_tree_next_slot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-slot-can-be-null-in-radix_tree_next_slot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: 'slot' can be NULL in radix_tree_next_slot()

There are four cases I can see where we could end up with a NULL 'slot' in
radix_tree_next_slot().  Yet radix_tree_next_slot() never actually checks
whether 'slot' is NULL.  It just happens that for the cases where 'slot'
is NULL, some other combination of factors prevents us from dereferencing
it.

It would be very easy for someone to unwittingly change one of these
factors without realizing that we are implicitly depending on it to save
us from a NULL pointer dereference.

Add a comment documenting the things that allow 'slot' to be safely passed
as NULL to radix_tree_next_slot().

Here are details on the four cases:

1) radix_tree_iter_retry() via a non-tagged iteration like
radix_tree_for_each_slot().  In this case we currently aren't seeing a bug
because radix_tree_iter_retry() sets

	iter->next_index = iter->index;

which means that in in the else case in radix_tree_next_slot(), 'count' is
zero, so we skip over the while() loop and effectively just return NULL
without ever dereferencing 'slot'.

2) radix_tree_iter_retry() via tagged iteration like
radix_tree_for_each_tagged().  This case was giving us NULL pointer
dereferences in testing, and was fixed with this commit:

commit 3cb9185c6730 ("radix-tree: fix radix_tree_iter_retry() for tagged
iterators.")

This fix doesn't explicitly check for 'slot' being NULL, though, it works
around the NULL pointer dereference by instead zeroing iter->tags in
radix_tree_iter_retry(), which makes us bail out of the if() case in
radix_tree_next_slot() before we dereference 'slot'.

3) radix_tree_iter_next() via via a non-tagged iteration like
radix_tree_for_each_slot().  This currently happens in shmem_tag_pins()
and shmem_partial_swap_usage().

As with non-tagged iteration, 'count' in the else case of
radix_tree_next_slot() is zero, so we skip over the while() loop and
effectively just return NULL without ever dereferencing 'slot'.

4) radix_tree_iter_next() via tagged iteration like
radix_tree_for_each_tagged().  This happens in shmem_wait_for_pins().

radix_tree_iter_next() zeros out iter->tags, so we end up exiting
radix_tree_next_slot() here:

	if (flags & RADIX_TREE_ITER_TAGGED) {
		void *canon = slot;

		iter->tags >>= 1;
		if (unlikely(!iter->tags))
			return NULL;

Link: http://lkml.kernel.org/r/20160815194237.25967-2-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/radix-tree.h~radix-tree-slot-can-be-null-in-radix_tree_next_slot include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-slot-can-be-null-in-radix_tree_next_slot
+++ a/include/linux/radix-tree.h
@@ -461,6 +461,14 @@ static inline struct radix_tree_node *en
  *
  * This function updates @iter->index in the case of a successful lookup.
  * For tagged lookup it also eats @iter->tags.
+ *
+ * There are several cases where 'slot' can be passed in as NULL to this
+ * function.  These cases result from the use of radix_tree_iter_next() or
+ * radix_tree_iter_retry().  In these cases we don't end up dereferencing
+ * 'slot' because either:
+ * a) we are doing tagged iteration and iter->tags has been set to 0, or
+ * b) we are doing non-tagged iteration, and iter->index and iter->next_index
+ *    have been set up so that radix_tree_chunk_size() returns 1 or 0.
  */
 static __always_inline void **
 radix_tree_next_slot(void **slot, struct radix_tree_iter *iter, unsigned flags)
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-slot-can-be-null-in-radix_tree_next_slot.patch
radix-tree-tests-add-iteration-test.patch
radix-tree-tests-properly-initialize-mutex.patch

