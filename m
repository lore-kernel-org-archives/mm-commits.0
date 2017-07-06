From: akpm@linux-foundation.org
Subject: [patch 022/108] mm/slub.c: pack red_left_pad with another
 int to save a word
Date: Thu, 06 Jul 2017 15:36:28 -0700
Message-ID: <20170706223628.NTPLG3_Ss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34714 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbdGFWge (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/slub.c: pack red_left_pad with another int to save a word

Patch series "try to save some memory for kmem_cache in some cases", v2.

kmem_cache is a frequently used data in kernel.  During the code reading,
I found maybe we could save some space in some cases.

1. On 64bit arch, type int will occupy a word if it doesn't sit well.

2. cpu_slab->partial is just used when CONFIG_SLUB_CPU_PARTIAL is set

3. cpu_partial is just used when CONFIG_SLUB_CPU_PARTIAL is set, while
   just save some space on 32bit arch.


This patch (of 3):

On 64bit arch, struct is 8-bytes aligned, so int will occupy a word if it
doesn't sit well.

This patch pack red_left_pad with reserved to save 8 bytes for struct
kmem_cache on a 64bit arch.

Link: http://lkml.kernel.org/r/20170502144533.10729-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~mm-slub-pack-red_left_pad-with-another-int-to-save-a-word include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-pack-red_left_pad-with-another-int-to-save-a-word
+++ a/include/linux/slub_def.h
@@ -79,9 +79,9 @@ struct kmem_cache {
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
 	int reserved;		/* Reserved bytes at the end of slabs */
+	int red_left_pad;	/* Left redzone padding size */
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
-	int red_left_pad;	/* Left redzone padding size */
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;	/* For sysfs */
 	struct work_struct kobj_remove_work;
_
