Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BE9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380893AbiD2UwR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347507AbiD2UwO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:52:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881BC852D4
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AE55B837C1
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC186C385A4;
        Fri, 29 Apr 2022 20:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651265333;
        bh=u6qOW8KLSrzymPBltuOkZep7LgzWEJBIMJQzbk8Bb+U=;
        h=Date:To:From:Subject:From;
        b=OJqp4mhKhOc61mUXCir1SvsVFw/BLCKXbEA/uwkvRLl1zkGVGm63jyn4s+MpiGKLy
         Cq/yIZ3lgsQN32V3nrN8W1ZOm8Ty7o4ZWhWbRy7+UHUgJTkQf87neO+Rz/vjDjSewd
         LR1I1j8xFyassbiWtfukIAZvnxB0/MlN0/HUulxo=
Date:   Fri, 29 Apr 2022 13:48:52 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        jakobkoschel@gmail.com, h.j.bos@vu.nl, david@redhat.com,
        c.giuffrida@vu.nl, bjohannesmeyer@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch removed from -mm tree
Message-Id: <20220429204852.EC186C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch

This patch was dropped because it was folded into fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch

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

mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

