From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-kmemleak-slightly-reduce-the-size-of-some-structures-o?=
 =?US-ASCII?Q?n-64-bit-architectures.patch?= removed from -mm tree
Date: Fri, 07 Jul 2017 12:11:06 -0700
Message-ID: <20170707191106.ETo6YiTyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdGGTLH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, luto@amacapital.net, mcgrof@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: slightly reduce the size of some structures on 64-bit architectures
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: slightly reduce the size of some structures on 64-bit architectures

Change the kmemleak_object.flags type to unsigned int and moves the
early_log.min_count (int) near early_log.op_type (int) to slightly reduce
the size of these structures on 64-bit architectures.

Link: http://lkml.kernel.org/r/1495726937-23557-2-git-send-email-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures
+++ a/mm/kmemleak.c
@@ -150,7 +150,7 @@ struct kmemleak_scan_area {
  */
 struct kmemleak_object {
 	spinlock_t lock;
-	unsigned long flags;		/* object status flags */
+	unsigned int flags;		/* object status flags */
 	struct list_head object_list;
 	struct list_head gray_list;
 	struct rb_node rb_node;
@@ -262,9 +262,9 @@ enum {
  */
 struct early_log {
 	int op_type;			/* kmemleak operation type */
+	int min_count;			/* minimum reference count */
 	const void *ptr;		/* allocated/freed memory block */
 	size_t size;			/* memory block size */
-	int min_count;			/* minimum reference count */
 	unsigned long trace[MAX_TRACE];	/* stack trace */
 	unsigned int trace_len;		/* stack trace length */
 };
@@ -393,7 +393,7 @@ static void dump_object_info(struct kmem
 		  object->comm, object->pid, object->jiffies);
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
-	pr_notice("  flags = 0x%lx\n", object->flags);
+	pr_notice("  flags = 0x%x\n", object->flags);
 	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
 	print_stack_trace(&trace, 4);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


