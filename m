Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CF8C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 19:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354155AbiDZTe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 15:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354279AbiDZTen (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 15:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F9DEE4D3
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 12:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E5C619A6
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 19:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7583C385A0;
        Tue, 26 Apr 2022 19:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651001430;
        bh=A9xkeHZMNFTISOBkwJprMdX947GMqV6bKTWkZAH2L8I=;
        h=Date:To:From:Subject:From;
        b=aO/zAfgab+k9VEJ222GAX5ScLHjgQKjLZNkE/6w0sq8soYMp9L67KHeqWfZnVT6m4
         vRdD8ADOw6cP2Va3H9VU/kxE+o8IlmPxuUVJO7jTP17qoRaMTMSDk0FR3sQWTW8waN
         /yl8BkNl9BWadHFHJAN7fl4J+CzGM2YYNSknfCuY=
Date:   Tue, 26 Apr 2022 12:30:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        jvgediya@linux.ibm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch added to -mm tree
Message-Id: <20220426193029.E7583C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix
has been added to the -mm tree.  Its filename is
     lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch

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
Subject: lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix

undo s/iff/if/, per Matthew

Cc: Jagdish Gediya <jvgediya@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kstrtox.c~lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix
+++ a/lib/kstrtox.c
@@ -340,7 +340,7 @@ EXPORT_SYMBOL(kstrtos8);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 if the first character is one of 'YyTt1NnFf0', or
+ * This routine returns 0 iff the first character is one of 'YyTt1NnFf0', or
  * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
  * pointed to by res is updated upon finding a match.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

