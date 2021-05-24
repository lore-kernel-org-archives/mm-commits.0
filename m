Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14003C47085
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE4966141F
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhEXXxJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 19:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229798AbhEXXxI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 19:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 931B861360;
        Mon, 24 May 2021 23:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621900298;
        bh=q4Q+eJQHVvuLDPxjGMjdqEB1SF+vIKqra6bM8R130Ak=;
        h=Date:From:To:Subject:From;
        b=P9h4Kj8bxAdXic8/xhYIhQQhp7UBMa3/9j16G2B4EdTlOuSOnPJHUI0YjtmZ9encg
         pJbfkD6MCUbfWVp+cUruX+aXz5KfffjNag6CYla7fGgVgYrczV7vzcywXSx1PKTDT4
         rO4L5nEf6dDR40JT70uvjIL1q1R3m5PZy4zhgIFg=
Date:   Mon, 24 May 2021 16:51:38 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  [nacked]
 slub-print-raw-pointer-addresses-when-debugging.patch removed from -mm tree
Message-ID: <20210524235138.VLvsgz96p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: print raw pointer addresses when debugging
has been removed from the -mm tree.  Its filename was
     slub-print-raw-pointer-addresses-when-debugging.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: slub: print raw pointer addresses when debugging

Obscuring the pointers that slub shows when debugging makes for some
confusing slub debug messages:

 Padding overwritten. 0x0000000079f0674a-0x000000000d4dce17

Those addresses are hashed for kernel security reasons.  If we're trying
to be secure with slub_debug on the commandline we have some big problems
given that we dump whole chunks of kernel memory to the kernel logs. 
Let's use %px here and dump buffers with the actual address for the buffer
instead of the hashed version so that the logs are meaningful.  This also
helps if a kernel address is in some slub debug report so we can figure
out that the object is referencing itself.

Link: https://lkml.kernel.org/r/20210520013539.3733631-3-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/slub.c~slub-print-raw-pointer-addresses-when-debugging
+++ a/mm/slub.c
@@ -568,7 +568,7 @@ static void print_section(char *level, c
 			  unsigned int length)
 {
 	metadata_access_enable();
-	print_hex_dump(level, kasan_reset_tag(text), DUMP_PREFIX_ADDRESS,
+	print_hex_dump(level, kasan_reset_tag(text), DUMP_PREFIX_RAW_ADDRESS,
 			16, 1, addr, length, 1);
 	metadata_access_disable();
 }
@@ -669,7 +669,7 @@ void print_tracking(struct kmem_cache *s
 
 static void print_page_info(struct page *page)
 {
-	pr_err("Slab 0x%p objects=%u used=%u fp=0x%p flags=%#lx(%pGp)\n",
+	pr_err("Slab 0x%px objects=%u used=%u fp=0x%px flags=%#lx(%pGp)\n",
 	       page, page->objects, page->inuse, page->freelist,
 	       page->flags, &page->flags);
 
@@ -729,7 +729,7 @@ static void print_trailer(struct kmem_ca
 
 	print_page_info(page);
 
-	pr_err("Object 0x%p @offset=%tu fp=0x%p\n\n",
+	pr_err("Object 0x%px @offset=%tu fp=0x%px\n\n",
 	       p, p - addr, get_freepointer(s, p));
 
 	if (s->flags & SLAB_RED_ZONE)
@@ -805,7 +805,7 @@ static void init_object(struct kmem_cach
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	slab_fix(s, "Restoring 0x%p-0x%p=0x%x\n", from, to - 1, data);
+	slab_fix(s, "Restoring 0x%px-0x%px=0x%x\n", from, to - 1, data);
 	memset(from, data, to - from);
 }
 
@@ -831,7 +831,7 @@ static int check_bytes_and_report(struct
 		goto skip_bug_print;
 
 	slab_bug(s, "%s overwritten", what);
-	pr_err("0x%p-0x%p @offset=%tu. First byte 0x%x instead of 0x%x\n",
+	pr_err("0x%px-0x%px @offset=%tu. First byte 0x%x instead of 0x%x\n",
 					fault, end - 1, fault - addr,
 					fault[0], value);
 	print_trailer(s, page, object);
@@ -925,7 +925,7 @@ static int slab_pad_check(struct kmem_ca
 	while (end > fault && end[-1] == POISON_INUSE)
 		end--;
 
-	slab_err(s, page, "Padding overwritten. 0x%p-0x%p @offset=%tu",
+	slab_err(s, page, "Padding overwritten. 0x%px-0x%px @offset=%tu",
 			fault, end - 1, fault - start);
 	print_section(KERN_ERR, "Padding ", pad, remainder);
 
@@ -1073,7 +1073,7 @@ static void trace(struct kmem_cache *s,
 								int alloc)
 {
 	if (s->flags & SLAB_TRACE) {
-		pr_info("TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
+		pr_info("TRACE %s %s 0x%px inuse=%d fp=0x%px\n",
 			s->name,
 			alloc ? "alloc" : "free",
 			object, page->inuse,
@@ -1218,7 +1218,7 @@ static inline int free_consistency_check
 		struct page *page, void *object, unsigned long addr)
 {
 	if (!check_valid_pointer(s, page, object)) {
-		slab_err(s, page, "Invalid object pointer 0x%p", object);
+		slab_err(s, page, "Invalid object pointer 0x%px", object);
 		return 0;
 	}
 
@@ -1232,10 +1232,10 @@ static inline int free_consistency_check
 
 	if (unlikely(s != page->slab_cache)) {
 		if (!PageSlab(page)) {
-			slab_err(s, page, "Attempt to free object(0x%p) outside of slab",
+			slab_err(s, page, "Attempt to free object(0x%px) outside of slab",
 				 object);
 		} else if (!page->slab_cache) {
-			pr_err("SLUB <none>: no slab for object 0x%p.\n",
+			pr_err("SLUB <none>: no slab for object 0x%px.\n",
 			       object);
 			dump_stack();
 		} else
@@ -1295,7 +1295,7 @@ out:
 	slab_unlock(page);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	if (!ret)
-		slab_fix(s, "Object at 0x%p not freed", object);
+		slab_fix(s, "Object at 0x%px not freed", object);
 	return ret;
 }
 
@@ -3931,7 +3931,7 @@ static void list_slab_objects(struct kme
 	for_each_object(p, s, addr, page->objects) {
 
 		if (!test_bit(__obj_to_index(s, addr, p), map)) {
-			pr_err("Object 0x%p @offset=%tu\n", p, p - addr);
+			pr_err("Object 0x%px @offset=%tu\n", p, p - addr);
 			print_tracking(s, p);
 		}
 	}
_

Patches currently in -mm which might be from swboyd@chromium.org are

buildid-only-consider-gnu-notes-for-build-id-parsing.patch
buildid-add-api-to-parse-build-id-out-of-buffer.patch
buildid-stash-away-kernels-build-id-on-init.patch
buildid-stash-away-kernels-build-id-on-init-fix.patch
dump_stack-add-vmlinux-build-id-to-stack-traces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
arm64-stacktrace-use-%psb-for-backtrace-printing.patch
x86-dumpstack-use-%psb-%pbb-for-backtrace-printing.patch
scripts-decode_stacktracesh-support-debuginfod.patch
scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
scripts-decode_stacktracesh-indicate-auto-can-be-used-for-base-path.patch
buildid-mark-some-arguments-const.patch
buildid-fix-kernel-doc-notation.patch
kdump-use-vmlinux_build_id-to-simplify.patch

