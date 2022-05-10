Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D744C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiEJEXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbiEJEWC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD701B4358
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A56661766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCFCC385C2;
        Tue, 10 May 2022 04:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156253;
        bh=7+T4rsFaNM2xM5WYSvsOnV+sT/WuNlXaaJq++l0/L5Y=;
        h=Date:To:From:Subject:From;
        b=i0zTmbV7BF+0sOWLdA1Iy1pkVj96eGTm22X5u8TffSg0kmUXsAJZYoI3cQxYyoWrQ
         aMBuTesYv1PLKz9+SeK8Hr80AP1tInW+pfUizZIvnqoH7BtgYMdRN9guq/x9BuD2jP
         fu+W7kz3FLBTDMw08D+XpaGr2N51eFQKQeWlIyaE=
Date:   Mon, 09 May 2022 21:17:32 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        h.j.bos@vu.nl, david@redhat.com, c.giuffrida@vu.nl,
        bjohannesmeyer@gmail.com, adobriyan@gmail.com,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch removed from -mm tree
Message-Id: <20220510041733.5CCFCC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/kcore.c: remove check of list iterator against head past the loop body
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakob Koschel <jakobkoschel@gmail.com>
Subject: fs/proc/kcore.c: remove check of list iterator against head past the loop body

When list_for_each_entry() completes the iteration over the whole list
without breaking the loop, the iterator value will be a bogus pointer
computed based on the head element.

While it is safe to use the pointer to determine if it was computed based
on the head element, either with list_entry_is_head() or &pos->member ==
head, using the iterator variable after the loop should be avoided.

In preparation to limit the scope of a list iterator to the list traversal
loop, use a dedicated pointer to point to the found element [1].

[akpm@linux-foundation.org: reduce scope of `iter']
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20220331223700.902556-1-jakobkoschel@gmail.com
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body
+++ a/fs/proc/kcore.c
@@ -479,10 +479,15 @@ read_kcore(struct file *file, char __use
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			list_for_each_entry(m, &kclist_head, list) {
-				if (start >= m->addr &&
-				    start < m->addr + m->size)
+			struct kcore_list *iter;
+
+			m = NULL;
+			list_for_each_entry(iter, &kclist_head, list) {
+				if (start >= iter->addr &&
+				    start < iter->addr + iter->size) {
+					m = iter;
 					break;
+				}
 			}
 		}
 
@@ -492,12 +497,11 @@ read_kcore(struct file *file, char __use
 			page_offline_freeze();
 		}
 
-		if (&m->list == &kclist_head) {
+		if (!m) {
 			if (clear_user(buffer, tsz)) {
 				ret = -EFAULT;
 				goto out;
 			}
-			m = NULL;	/* skip the list anchor */
 			goto skip;
 		}
 
_

Patches currently in -mm which might be from jakobkoschel@gmail.com are


