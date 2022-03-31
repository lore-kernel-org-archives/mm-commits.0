Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF89C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 23:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243199AbiCaXun (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiCaXul (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 19:50:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4BC1B6975
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 16:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48C8D61767
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 23:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF18C340EE;
        Thu, 31 Mar 2022 23:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648770531;
        bh=D1ZSZtwFDNLNh+hSfO6m7SM6XiWkMGYm9nVIO7vrgkI=;
        h=Date:To:From:Subject:From;
        b=NmmHHx+cA2Rfm2+AbhDKzoUsSB8sb3PgmQUqPGh5tSXEDjO+AUGOt1K0n5+yeeI8c
         Js+6xKr16YsF3VgPxB0CantpmPGXLxr+BRBdKecgX2IAO/hwRRWEDi3jw7k2NJB9ZE
         0e7z0hldwJIZXR7Vlxlupoplk+a3lYr5ox3BODl4=
Date:   Thu, 31 Mar 2022 16:48:51 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        h.j.bos@vu.nl, david@redhat.com, c.giuffrida@vu.nl,
        bjohannesmeyer@gmail.com, adobriyan@gmail.com,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch added to -mm tree
Message-Id: <20220331234851.9EF18C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: remove check of list iterator against head past the loop body
has been added to the -mm tree.  Its filename is
     fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/proc/kcore.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body
+++ a/fs/proc/kcore.c
@@ -316,6 +316,7 @@ read_kcore(struct file *file, char __use
 	size_t page_offline_frozen = 1;
 	size_t phdrs_len, notes_len;
 	struct kcore_list *m;
+	struct kcore_list *iter;
 	size_t tsz;
 	int nphdr;
 	unsigned long start;
@@ -479,10 +480,13 @@ read_kcore(struct file *file, char __use
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			list_for_each_entry(m, &kclist_head, list) {
-				if (start >= m->addr &&
-				    start < m->addr + m->size)
+			m = NULL;
+			list_for_each_entry(iter, &kclist_head, list) {
+				if (start >= iter->addr &&
+				    start < iter->addr + iter->size) {
+					m = iter;
 					break;
+				}
 			}
 		}
 
@@ -492,12 +496,11 @@ read_kcore(struct file *file, char __use
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

hugetlb-remove-use-of-list-iterator-variable-after-loop.patch
ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch
ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch
rapidio-remove-unnecessary-use-of-list-iterator.patch

