Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4722C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 23:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbiCaXuq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243192AbiCaXuq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 19:50:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE2A1B3097
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 16:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D23BCB82298
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 23:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFB9C340EE;
        Thu, 31 Mar 2022 23:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648770533;
        bh=3gBQo25yF/7hJ0TV3ceVHkpSaXFLtH/0Ws6wf5Imo14=;
        h=Date:To:From:Subject:From;
        b=ci7PMgOFXsSfo0o9nfRWUGm/gnmIMHb8760iQNr8ssdwxpHAPaApjGsrtIF+ry36V
         rraNiSLPRu49PLdL/ceDxqZbojFSIQT70Z10wXVceZwD6D2BHTHtGIVpQecJaC9eBz
         zZ9+LQnhP8FB6K4UT6R8PHKbC3oQiSilTnsXmKao=
Date:   Thu, 31 Mar 2022 16:48:52 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        jakobkoschel@gmail.com, h.j.bos@vu.nl, david@redhat.com,
        c.giuffrida@vu.nl, bjohannesmeyer@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch added to -mm tree
Message-Id: <20220331234853.6DFB9C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix
has been added to the -mm tree.  Its filename is
     fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix

reduce scope of `iter'

Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix
+++ a/fs/proc/kcore.c
@@ -316,7 +316,6 @@ read_kcore(struct file *file, char __use
 	size_t page_offline_frozen = 1;
 	size_t phdrs_len, notes_len;
 	struct kcore_list *m;
-	struct kcore_list *iter;
 	size_t tsz;
 	int nphdr;
 	unsigned long start;
@@ -480,6 +479,8 @@ read_kcore(struct file *file, char __use
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
+			struct kcore_list *iter;
+
 			m = NULL;
 			list_for_each_entry(iter, &kclist_head, list) {
 				if (start >= iter->addr &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
arm64-implement-stack_trace_save_shadow-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
b.patch

