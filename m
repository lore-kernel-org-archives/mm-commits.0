From: akpm@linux-foundation.org
Subject: + mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch added to -mm tree
Date: Wed, 10 May 2017 15:16:39 -0700
Message-ID: <59139147.OyZHrMHlAXMI2H1r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdEJWQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 18:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: pack red_left_pad with another int to save a word
has been added to the -mm tree.  Its filename is
     mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/slub.c: pack red_left_pad with another int to save a word

Patch series " try to save some memory for kmem_cache in some cases", v2.

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
 #endif
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch
mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

