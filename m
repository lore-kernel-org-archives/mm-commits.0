From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures.patch added to -mm tree
Date: Thu, 25 May 2017 15:40:35 -0700
Message-ID: <59275d63.0HdrrS047NObEVR+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760026AbdEYWkg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, luto@amacapital.net, mcgrof@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: slightly reduce the size of some structures on 64-bit architectures
has been added to the -mm tree.  Its filename is
     mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-kmemleak-slightly-reduce-the-size-of-some-structures-on-64-bit-architectures.patch
mm-kmemleak-factor-object-reference-updating-out-of-scan_block.patch
mm-kmemleak-treat-vm_struct-as-alternative-reference-to-vmalloced-objects.patch

