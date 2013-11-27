From: akpm@linux-foundation.org
Subject: [merged]
 kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch removed
 from -mm tree
Date: Wed, 27 Nov 2013 12:26:31 -0800
Message-ID: <52965577.r6pN2kmIpsgRNh7p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3K0U0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 15:26:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 12:26:31 -0800


The patch titled
     Subject: kernel/timer.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
has been removed from the -mm tree.  Its filename was
     kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: kernel/timer.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/timer.c~kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node kernel/timer.c
--- a/kernel/timer.c~kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node
+++ a/kernel/timer.c
@@ -1518,9 +1518,8 @@ static int init_timers_cpu(int cpu)
 			/*
 			 * The APs use this path later in boot
 			 */
-			base = kmalloc_node(sizeof(*base),
-						GFP_KERNEL | __GFP_ZERO,
-						cpu_to_node(cpu));
+			base = kzalloc_node(sizeof(*base), GFP_KERNEL,
+					    cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

