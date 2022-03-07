Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09EBC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 23:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbiCGXxd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239676AbiCGXxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 18:53:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276F8B7C0
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 15:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4CD761269
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 23:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134E1C340E9;
        Mon,  7 Mar 2022 23:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646697155;
        bh=QICKmP8dfgUZEUD6mCi/JFvkIhG/mxSXajVx+SuuwpY=;
        h=Date:To:From:Subject:From;
        b=eAWYH7cIVkLWFDsDt7LWkmK1YgqPn3XfYtg2OWFJSzgbE7lYmANVZrtM9gOl28lVH
         iXhcWEi4Ye5lMeYHuvgvxy3r2M2jN42MBvn62dggR5wz6nGG7EGIEhh4V8f09S67Nv
         qfJk3NYDMqqrJBRJsxBaf71kc8dEDAruCg6NXTvg=
Date:   Mon, 07 Mar 2022 15:52:34 -0800
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, natechancellor@gmail.com,
        lukas.bulwahn@gmail.com, bsingharora@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-remove-unneeded-dead-assignment-fix.patch added to -mm tree
Message-Id: <20220307235235.134E1C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats-remove-unneeded-dead-assignment-fix
has been added to the -mm tree.  Its filename is
     taskstats-remove-unneeded-dead-assignment-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/taskstats-remove-unneeded-dead-assignment-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/taskstats-remove-unneeded-dead-assignment-fix.patch

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
Subject: taskstats-remove-unneeded-dead-assignment-fix

reduce scope of `rc'

Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/taskstats.c~taskstats-remove-unneeded-dead-assignment-fix
+++ a/kernel/taskstats.c
@@ -113,12 +113,14 @@ static void send_cpu_listeners(struct sk
 	struct listener *s, *tmp;
 	struct sk_buff *skb_next, *skb_cur = skb;
 	void *reply = genlmsg_data(genlhdr);
-	int rc, delcount = 0;
+	int delcount = 0;
 
 	genlmsg_end(skb, reply);
 
 	down_read(&listeners->sem);
 	list_for_each_entry(s, &listeners->list, list) {
+		int rc;
+
 		skb_next = NULL;
 		if (!list_is_last(&s->list, &listeners->list)) {
 			skb_next = skb_clone(skb_cur, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

