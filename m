Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28EEC43381
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B9164EFC
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCRAvg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230159AbhCRAvQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 20:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C24264F38;
        Thu, 18 Mar 2021 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616028675;
        bh=hFVZOIF0vs75o+LjsOjdeEJj7sl6hUmvGL5yodWSZwE=;
        h=Date:From:To:Subject:From;
        b=kU8J0IrGZw9/iq281awHNLu8uAXx8zQi95v5nnvOJblk5ioGE2OaqolTrD4RkdWFZ
         8rtqJMKaD8YW3UfZBoSn8NXh3Rs8FSeLTnJ4A6IkGSJA646bvTgV7sSX5x5xXCGwkw
         Rfi25hnn4ZMzGNCqPqPnAB9LNe7am585w4wmScbg=
Date:   Wed, 17 Mar 2021 17:51:14 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux@armlinux.org.uk, maninder1.s@samsung.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, v.narang@samsung.com, vbabka@suse.cz,
        viro@zeniv.linux.org.uk
Subject:  +
 mm-slub-add-support-for-free-path-information-of-an-object.patch added to
 -mm tree
Message-ID: <20210318005114.yAXAyGidM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: add support for free path information of an object
has been added to the -mm tree.  Its filename is
     mm-slub-add-support-for-free-path-information-of-an-object.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-add-support-for-free-path-information-of-an-object.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-add-support-for-free-path-information-of-an-object.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: mm/slub: add support for free path information of an object

Add support for information of free path along with allocation path of an
object:

slab kmalloc-64 start c8ab0140 data offset 64 pointer offset 0 size 64 allocated at meminfo_proc_show+0x40/0x4fc
[   20.192078]     meminfo_proc_show+0x40/0x4fc
[   20.192263]     seq_read_iter+0x18c/0x4c4
[   20.192430]     proc_reg_read_iter+0x84/0xac
[   20.192617]     generic_file_splice_read+0xe8/0x17c
[   20.192816]     splice_direct_to_actor+0xb8/0x290
[   20.193008]     do_splice_direct+0xa0/0xe0
[   20.193185]     do_sendfile+0x2d0/0x438
[   20.193345]     sys_sendfile64+0x12c/0x140
[   20.193523]     ret_fast_syscall+0x0/0x58
[   20.193695]     0xbeeacde4
[   20.193822]  Free path:
[   20.193935]     meminfo_proc_show+0x5c/0x4fc
[   20.194115]     seq_read_iter+0x18c/0x4c4
[   20.194285]     proc_reg_read_iter+0x84/0xac
[   20.194475]     generic_file_splice_read+0xe8/0x17c
[   20.194685]     splice_direct_to_actor+0xb8/0x290
[   20.194870]     do_splice_direct+0xa0/0xe0
[   20.195014]     do_sendfile+0x2d0/0x438
[   20.195174]     sys_sendfile64+0x12c/0x140
[   20.195336]     ret_fast_syscall+0x0/0x58
[   20.195491]     0xbeeacde4

Link: https://lkml.kernel.org/r/1615891032-29160-2-git-send-email-maninder1.s@samsung.com
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Co-developed-by: Vaneet Narang <v.narang@samsung.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |    1 +
 mm/slab_common.c |   12 +++++++++++-
 mm/slub.c        |    7 +++++++
 mm/util.c        |    2 +-
 4 files changed, 20 insertions(+), 2 deletions(-)

--- a/mm/slab_common.c~mm-slub-add-support-for-free-path-information-of-an-object
+++ a/mm/slab_common.c
@@ -554,7 +554,7 @@ bool kmem_valid_obj(void *object)
  * depends on the type of object and on how much debugging is enabled.
  * For a slab-cache object, the fact that it is a slab object is printed,
  * and, if available, the slab name, return address, and stack trace from
- * the allocation of that object.
+ * the allocation and last free path of that object.
  *
  * This function will splat if passed a pointer to a non-slab object.
  * If you are not sure what type of object you have, you should instead
@@ -599,6 +599,16 @@ void kmem_dump_obj(void *object)
 			break;
 		pr_info("    %pS\n", kp.kp_stack[i]);
 	}
+
+	if (kp.kp_free_stack[0])
+		pr_cont(" Free path:\n");
+
+	for (i = 0; i < ARRAY_SIZE(kp.kp_free_stack); i++) {
+		if (!kp.kp_free_stack[i])
+			break;
+		pr_info("    %pS\n", kp.kp_free_stack[i]);
+	}
+
 }
 
 #ifndef CONFIG_SLOB
--- a/mm/slab.h~mm-slub-add-support-for-free-path-information-of-an-object
+++ a/mm/slab.h
@@ -628,6 +628,7 @@ struct kmem_obj_info {
 	struct kmem_cache *kp_slab_cache;
 	void *kp_ret;
 	void *kp_stack[KS_ADDRS_COUNT];
+	void *kp_free_stack[KS_ADDRS_COUNT];
 };
 void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
 
--- a/mm/slub.c~mm-slub-add-support-for-free-path-information-of-an-object
+++ a/mm/slub.c
@@ -4000,6 +4000,13 @@ void kmem_obj_info(struct kmem_obj_info
 		if (!kpp->kp_stack[i])
 			break;
 	}
+
+	trackp = get_track(s, objp, TRACK_FREE);
+	for (i = 0; i < KS_ADDRS_COUNT && i < TRACK_ADDRS_COUNT; i++) {
+		kpp->kp_free_stack[i] = (void *)trackp->addrs[i];
+		if (!kpp->kp_free_stack[i])
+			break;
+	}
 #endif
 #endif
 }
--- a/mm/util.c~mm-slub-add-support-for-free-path-information-of-an-object
+++ a/mm/util.c
@@ -992,7 +992,7 @@ int __weak memcmp_pages(struct page *pag
  * depends on the type of object and on how much debugging is enabled.
  * For example, for a slab-cache object, the slab name is printed, and,
  * if available, the return address and stack trace from the allocation
- * of that object.
+ * and last free path of that object.
  */
 void mem_dump_obj(void *object)
 {
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

mm-slub-fixing-backtrace-of-objects-because-of-redzone-adjustment.patch
mm-slub-add-support-for-free-path-information-of-an-object.patch
arm-print-alloc-free-paths-for-address-in-registers.patch

