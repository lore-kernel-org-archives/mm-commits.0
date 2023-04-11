Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F47C7619A
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 04:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDKET6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjDKET5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 00:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9C510E6
        for <mm-commits@vger.kernel.org>; Mon, 10 Apr 2023 21:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC4B961DAA
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 04:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503CDC433D2;
        Tue, 11 Apr 2023 04:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681186795;
        bh=QqaWV0OUfAP4tSPvIP0yrA4ZSktr7f99xKt2UGkH62E=;
        h=Date:To:From:Subject:From;
        b=WOXrniaSbH1l0WI3YCRL1usF41DwCYMOas84ZxxI5drAMw62JHHAv7AqOBwyoQTBy
         ahNdUO5gJL9qFdZoBI7vF+r/UVzPxDKFN6zkeeRzIjLPYcFkto0RZlvybdFlYY3M2c
         R2C7V0yiejNpahRmNbnCFfUPa3EaCZsQb7Zjjckw=
Date:   Mon, 10 Apr 2023 21:19:54 -0700
To:     mm-commits@vger.kernel.org, yuming.han@unisoc.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, ke.wang@unisoc.com,
        huangzhaoyang@gmail.com, Xiaosong.Ma@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-perform-the-check-when-page-without-mapping-but-page-mapping-contains-junk-or-random-bitscribble.patch added to mm-unstable branch
Message-Id: <20230411041955.503CDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: perform the check when page without mapping but page->mapping contains junk or random bitscribble
has been added to the -mm mm-unstable branch.  Its filename is
     fs-perform-the-check-when-page-without-mapping-but-page-mapping-contains-junk-or-random-bitscribble.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-perform-the-check-when-page-without-mapping-but-page-mapping-contains-junk-or-random-bitscribble.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "xiaosong.ma" <Xiaosong.Ma@unisoc.com>
Subject: fs: perform the check when page without mapping but page->mapping contains junk or random bitscribble
Date: Mon, 10 Apr 2023 09:45:02 +0800

Perform the check in dump_mapping() to print warning info and avoid crash
with invalid non-NULL page->mapping.

For example, a panic with following backtraces show dump_page will show
wrong info and panic when the bad page is non-NULL mapping and
page->mapping is 0x80000000000.

    crash_arm64> bt
    PID: 232    TASK: ffffff80e8c2c340  CPU: 0   COMMAND: "Binder:232_2"
     #0 [ffffffc013e5b080] sysdump_panic_event$b2bce43a479f4f7762201bfee02d7889 at ffffffc0108d7c2c
     #1 [ffffffc013e5b0c0] atomic_notifier_call_chain at ffffffc010300228
     #2 [ffffffc013e5b2c0] panic at ffffffc0102c926c
     #3 [ffffffc013e5b370] die at ffffffc010267670
     #4 [ffffffc013e5b3a0] die_kernel_fault at ffffffc0102808a4
     #5 [ffffffc013e5b3d0] __do_kernel_fault at ffffffc010280820
     #6 [ffffffc013e5b410] do_bad_area at ffffffc01028059c
     #7 [ffffffc013e5b440] do_translation_fault$4df5decbea5d08a63349aa36f07426b2 at ffffffc0111149c8
     #8 [ffffffc013e5b470] do_mem_abort at ffffffc0100a4488
     #9 [ffffffc013e5b5e0] el1_ia at ffffffc0100a6c00
     #10 [ffffffc013e5b5f0] __dump_page at ffffffc0104beecc
     #11 [ffffffc013e5b630] bad_page at ffffffc0104e6ffc
     #12 [ffffffc013e5b820] rmqueue_bulk at ffffffc0104e9128
     #13 [ffffffc013e5b950] rmqueue at ffffffc0104e7c3c
     #14 [ffffffc013e5b9c0] get_page_from_freelist at ffffffc0104e3e3c
     #15 [ffffffc013e5ba50] __alloc_pages_nodemask at ffffffc0104e3a7c
     #16 [ffffffc013e5bac0] pagecache_get_page at ffffffc01047d0e4
     #17 [ffffffc013e5bb20] grab_cache_page_write_begin at ffffffc010480e3c
     #18 [ffffffc013e5bb50] block_write_begin at ffffffc010586204
     #19 [ffffffc013e5bb90] blkdev_write_begin$75b353f60767e771433fc3b19ba260ab at ffffffc01058cc48
     #20 [ffffffc013e5bc00] generic_perform_write at ffffffc010480f1c
     #21 [ffffffc013e5bc60] __generic_file_write_iter at ffffffc01048115c
     #22 [ffffffc013e5bcf0] blkdev_write_iter at ffffffc01058c0a8
     #23 [ffffffc013e5bda0] __vfs_write at ffffffc01052d808
     #24 [ffffffc013e5bdd0] vfs_write at ffffffc01052da5c
     #25 [ffffffc013e5be30] __arm64_sys_pwrite64 at ffffffc01052e09c
     #26 [ffffffc013e5be60] el0_svc_common at ffffffc010272224
     #27 [ffffffc013e5bea0] el0_svc_handler at ffffffc010272148
     #28 [ffffffc013e5bff0] el0_svc at ffffffc0100a7ec4

Link: https://lkml.kernel.org/r/1681091102-31907-1-git-send-email-Xiaosong.Ma@unisoc.com
Signed-off-by: xiaosong.ma <Xiaosong.Ma@unisoc.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Yuming Han <yuming.han@unisoc.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/inode.c~fs-perform-the-check-when-page-without-mapping-but-page-mapping-contains-junk-or-random-bitscribble
+++ a/fs/inode.c
@@ -565,7 +565,8 @@ void dump_mapping(const struct address_s
 	 * If mapping is an invalid pointer, we don't want to crash
 	 * accessing it, so probe everything depending on it carefully.
 	 */
-	if (get_kernel_nofault(host, &mapping->host) ||
+	if (get_kernel_nofault(mapping, &mapping) ||
+	    get_kernel_nofault(host, &mapping->host) ||
 	    get_kernel_nofault(a_ops, &mapping->a_ops)) {
 		pr_warn("invalid mapping:%px\n", mapping);
 		return;
_

Patches currently in -mm which might be from Xiaosong.Ma@unisoc.com are

fs-perform-the-check-when-page-without-mapping-but-page-mapping-contains-junk-or-random-bitscribble.patch

