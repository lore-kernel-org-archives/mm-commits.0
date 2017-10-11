From: akpm@linux-foundation.org
Subject: +
 stackdepot-ignore-junk-last-entry-in-case-of-switch-from-user-mode.patch
 added to -mm tree
Date: Wed, 11 Oct 2017 16:13:01 -0700
Message-ID: <59dea57d.ihUXa+KqlvbeEc+H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbdJKXNC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 19:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maninder1.s@samsung.com, a.sahrawat@samsung.com, chris@chris-wilson.co.uk, dvyukov@google.com, mark.rutland@arm.com, v.narang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: ignore junk last entry in case of switch from user mode.
has been added to the -mm tree.  Its filename is
     stackdepot-ignore-junk-last-entry-in-case-of-switch-from-user-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stackdepot-ignore-junk-last-entry-in-case-of-switch-from-user-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stackdepot-ignore-junk-last-entry-in-case-of-switch-from-user-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: lib/stackdepot.c: ignore junk last entry in case of switch from user mode.

Issue observed on ARM.

Whenever there is switch from user mode, we end up with invalid last entry
with some user space address as below:-

 save_stack+0x40/0xec
 __set_page_owner+0x2c/0x64
....
....
 __handle_domain_irq+0x9c/0x130
 gic_handle_irq+0x40/0x80
 __irq_usr+0x4c/0x60
 0xb6507818

So in this case last entry is not valid, which leads to allocated one more
new frame for stackdepot although having all above frames exactly same.

(It increases depot_index drastically)

So its better to ignore that last frame in case of switch.
 save_stack+0x40/0xec
 __set_page_owner+0x2c/0x64
....
....
 __handle_domain_irq+0x9c/0x130
 gic_handle_irq+0x40/0x80
 __irq_usr+0x4c/0x60

Link: http://lkml.kernel.org/r/1507725802-44574-1-git-send-email-maninder1.s@samsung.com
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN lib/stackdepot.c~stackdepot-ignore-junk-last-entry-in-case-of-switch-from-user-mode lib/stackdepot.c
--- a/lib/stackdepot.c~stackdepot-ignore-junk-last-entry-in-case-of-switch-from-user-mode
+++ a/lib/stackdepot.c
@@ -214,6 +214,13 @@ depot_stack_handle_t depot_save_stack(st
 	if (unlikely(trace->nr_entries == 0))
 		goto fast_exit;
 
+	/* 
+	 * Ignore last entry if it belongs to user space
+	 * in case of switch from user mode.
+	 */
+	if (!kernel_text_address(trace->entries[trace->nr_entries - 1]))
+		trace->nr_entries--;
+
 	hash = hash_stack(trace->entries, trace->nr_entries);
 	bucket = &stack_table[hash & STACK_HASH_MASK];
 
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

bloat-o-meter-provide-3-different-arguments-for-data-function-and-all.patch
bloat-o-meter-provide-3-different-arguments-for-data-function-and-all-v2.patch
stackdepot-ignore-junk-last-entry-in-case-of-switch-from-user-mode.patch

