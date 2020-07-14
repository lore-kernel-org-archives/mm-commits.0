Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940F8C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 709872193E
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594690893;
	bh=UkzOTHidGqkWK6/oGZge8O6HcSB6CYuWyAKFo22aEsI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kGSNmyBqBjFUDVsyFrdfr+DeiNVAw5dFcOpdMumqOAN0pPT0tYF9k74VNXSNvH9Tw
	 HxAZzIHczDjyjC2hYilfZC9eZWZ/t+yJ2NQqtBkvsgYfalp4feHfncWj3Xit167dHr
	 nRw/wjGj5q6z5GDCQ9Ui/LEMdN6/mbsGqUbHQIcE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGNBld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNBld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:41:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7FFD20578;
        Tue, 14 Jul 2020 01:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594690891;
        bh=UkzOTHidGqkWK6/oGZge8O6HcSB6CYuWyAKFo22aEsI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oLBREJ2Qawjd6IL+6h3z9jkLpq92Wqf39ginHnVEHXrk2YLDEFpC3IqQkzEZORWrh
         HT6vDFMNIf/JgOB/EqQK0QjjaNv/tv2mLHxYW+1BvPFBWw2o6ZKovfVDpcxeBU/8H4
         aArCKIO+cq/o1ZPjGn0hW05q9ZOao5SOu5zflBHE=
Date:   Mon, 13 Jul 2020 18:41:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  + mm-vmallocc-remove-bug-from-the-find_va_links.patch
 added to -mm tree
Message-ID: <20200714014131.sUgivIStL%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: remove BUG() from the find_va_links()
has been added to the -mm tree.  Its filename is
     mm-vmallocc-remove-bug-from-the-find_va_links.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-remove-bug-from-the-find_va_links.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-remove-bug-from-the-find_va_links.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc.c: remove BUG() from the find_va_links()

Get rid of BUG() macro, that should be used only when a critical situation
happens and a system is not able to function anymore.

Replace it with WARN() macro instead, dump some extra information about
start/end addresses of both VAs which overlap.  Such overlap data can help
to figure out what happened making further analysis easier.  For example
if both areas are identical it could mean a double free.

A recovery process consists of declining all further steps regarding
inserting of conflicting overlap range.  In that sense find_va_links() now
can return NULL, so its return value has to be checked by callers.

Side effect of such process is it can leak memory, but it is better than
just killing a machine for no good reason.  Apart of that a debugging
process can be done on alive system.

Link: http://lkml.kernel.org/r/20200711104531.12242-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-remove-bug-from-the-find_va_links
+++ a/mm/vmalloc.c
@@ -512,6 +512,10 @@ static struct vmap_area *__find_vmap_are
 /*
  * This function returns back addresses of parent node
  * and its left or right link for further processing.
+ *
+ * Otherwise NULL is returned. In that case all further
+ * steps regarding inserting of conflicting overlap range
+ * have to be declined and actually considered as a bug.
  */
 static __always_inline struct rb_node **
 find_va_links(struct vmap_area *va,
@@ -550,8 +554,12 @@ find_va_links(struct vmap_area *va,
 		else if (va->va_end > tmp_va->va_start &&
 				va->va_start >= tmp_va->va_end)
 			link = &(*link)->rb_right;
-		else
-			BUG();
+		else {
+			WARN(1, "vmalloc bug: 0x%lx-0x%lx overlaps with 0x%lx-0x%lx\n",
+				va->va_start, va->va_end, tmp_va->va_start, tmp_va->va_end);
+
+			return NULL;
+		}
 	} while (*link);
 
 	*parent = &tmp_va->rb_node;
@@ -697,7 +705,8 @@ insert_vmap_area(struct vmap_area *va,
 	struct rb_node *parent;
 
 	link = find_va_links(va, root, NULL, &parent);
-	link_va(va, root, parent, link, head);
+	if (link)
+		link_va(va, root, parent, link, head);
 }
 
 static void
@@ -713,8 +722,10 @@ insert_vmap_area_augment(struct vmap_are
 	else
 		link = find_va_links(va, root, NULL, &parent);
 
-	link_va(va, root, parent, link, head);
-	augment_tree_propagate_from(va);
+	if (link) {
+		link_va(va, root, parent, link, head);
+		augment_tree_propagate_from(va);
+	}
 }
 
 /*
@@ -722,6 +733,11 @@ insert_vmap_area_augment(struct vmap_are
  * and next free blocks. If coalesce is not done a new
  * free area is inserted. If VA has been merged, it is
  * freed.
+ *
+ * Please note, it can return NULL in case of overlap
+ * ranges, followed by WARN() report. Despite it is a
+ * buggy behaviour, a system can be alive and keep
+ * ongoing.
  */
 static __always_inline struct vmap_area *
 merge_or_add_vmap_area(struct vmap_area *va,
@@ -738,6 +754,8 @@ merge_or_add_vmap_area(struct vmap_area
 	 * inserted, unless it is merged with its sibling/siblings.
 	 */
 	link = find_va_links(va, root, NULL, &parent);
+	if (!link)
+		return NULL;
 
 	/*
 	 * Get next node of VA to check if merging can be done.
@@ -1346,6 +1364,9 @@ static bool __purge_vmap_area_lazy(unsig
 		va = merge_or_add_vmap_area(va, &free_vmap_area_root,
 					    &free_vmap_area_list);
 
+		if (!va)
+			continue;
+
 		if (is_vmalloc_or_module_addr((void *)orig_start))
 			kasan_release_vmalloc(orig_start, orig_end,
 					      va->va_start, va->va_end);
@@ -3330,8 +3351,9 @@ recovery:
 		orig_end = vas[area]->va_end;
 		va = merge_or_add_vmap_area(vas[area], &free_vmap_area_root,
 					    &free_vmap_area_list);
-		kasan_release_vmalloc(orig_start, orig_end,
-				      va->va_start, va->va_end);
+		if (va)
+			kasan_release_vmalloc(orig_start, orig_end,
+				va->va_start, va->va_end);
 		vas[area] = NULL;
 	}
 
@@ -3379,8 +3401,9 @@ err_free_shadow:
 		orig_end = vas[area]->va_end;
 		va = merge_or_add_vmap_area(vas[area], &free_vmap_area_root,
 					    &free_vmap_area_list);
-		kasan_release_vmalloc(orig_start, orig_end,
-				      va->va_start, va->va_end);
+		if (va)
+			kasan_release_vmalloc(orig_start, orig_end,
+				va->va_start, va->va_end);
 		vas[area] = NULL;
 		kfree(vms[area]);
 	}
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch
mm-vmalloc-simplify-augment_tree_propagate_check-func.patch
mm-vmalloc-switch-to-propagate-callback.patch
mm-vmalloc-update-the-header-about-kva-rework.patch
mm-vmallocc-remove-bug-from-the-find_va_links.patch

