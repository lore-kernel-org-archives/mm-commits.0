From: akpm@linux-foundation.org
Subject: + drivers-char-agp-genericc-fix-oom-and-buffer-overflow.patch added to -mm tree
Date: Thu, 14 Apr 2011 13:25:50 -0700
Message-ID: <201104142025.p3EKPoJD004375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab1DNU0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 16:26:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, airlied@linux.ie


The patch titled
     drivers/char/agp/generic.c: fix OOM and buffer overflow
has been added to the -mm tree.  Its filename is
     drivers-char-agp-genericc-fix-oom-and-buffer-overflow.patch

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
Subject: drivers/char/agp/generic.c: fix OOM and buffer overflow
From: Vasiliy Kulikov <segoon@openwall.com>

page_count is copied from userspace.  agp_allocate_memory() tries to check
whether this number is too big, but doesn't take into account the wrap
case.  Also agp_create_user_memory() doesn't check whether alloc_size is
calculated from num_agp_pages variable without overflow.  This may lead to
allocation of too small buffer with following buffer overflow.

Another problem in agp code is not addressed in the patch - kernel memory
exhaustion (AGPIOC_RESERVE and AGPIOC_ALLOCATE ioctls).  It is not checked
whether requested pid is a pid of the caller (no check in
agpioc_reserve_wrap()).  Each allocation is limited to 16KB, though, there
is no per-process limit.  This might lead to OOM situation, which is not
even solved in case of the caller death by OOM killer - the memory is
allocated for another (faked) process.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/generic.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/generic.c~drivers-char-agp-genericc-fix-oom-and-buffer-overflow drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~drivers-char-agp-genericc-fix-oom-and-buffer-overflow
+++ a/drivers/char/agp/generic.c
@@ -115,6 +115,9 @@ static struct agp_memory *agp_create_use
 	struct agp_memory *new;
 	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
 
+	if (INT_MAX/sizeof(struct page *) < num_agp_pages)
+		return NULL;
+
 	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
 	if (new == NULL)
 		return NULL;
@@ -234,11 +237,14 @@ struct agp_memory *agp_allocate_memory(s
 	int scratch_pages;
 	struct agp_memory *new;
 	size_t i;
+	int cur_memory;
 
 	if (!bridge)
 		return NULL;
 
-	if ((atomic_read(&bridge->current_memory_agp) + page_count) > bridge->max_memory_agp)
+	cur_memory = atomic_read(&bridge->current_memory_agp);
+	if ((cur_memory + page_count > bridge->max_memory_agp) ||
+	    (cur_memory + page_count < page_count))
 		return NULL;
 
 	if (type >= AGP_USER_TYPES) {
_

Patches currently in -mm which might be from segoon@openwall.com are

drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes.patch
drivers-char-agp-genericc-fix-oom-and-buffer-overflow.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch

