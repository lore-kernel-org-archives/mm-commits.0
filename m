Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA3EEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjFSUUI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjFSUUH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403DFD3;
        Mon, 19 Jun 2023 13:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C85DD60C96;
        Mon, 19 Jun 2023 20:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E90C433C0;
        Mon, 19 Jun 2023 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206005;
        bh=YBLoTsYMsC/YNK40nBq3C7BK1qs8F/ljx4PwpVFv9M8=;
        h=Date:To:From:Subject:From;
        b=2RKNGYFBbWL/yKXseitZxK+sb6/5aurGKDel0yOxXfqYtPyzBBzADhwn5vH7/zaUB
         hBa/WcBXIT/ARjc6iMIhlz/zeH7R5fhyNU18X4hgQfEn5e/Vd2LqddJsNIrouq2WVX
         DVUltF/5jMEyWGFYvVs7uMKcpoPZrP2qgdDhBtw0=
Date:   Mon, 19 Jun 2023 13:20:04 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        laoar.shao@gmail.com, aris@redhat.com, aquini@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] writeback-fix-dereferencing-null-mapping-host-on-writeback_page_template.patch removed from -mm tree
Message-Id: <20230619202005.29E90C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: writeback: fix dereferencing NULL mapping->host on writeback_page_template
has been removed from the -mm tree.  Its filename was
     writeback-fix-dereferencing-null-mapping-host-on-writeback_page_template.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: writeback: fix dereferencing NULL mapping->host on writeback_page_template
Date: Tue, 6 Jun 2023 19:36:13 -0400

When commit 19343b5bdd16 ("mm/page-writeback: introduce tracepoint for
wait_on_page_writeback()") repurposed the writeback_dirty_page trace event
as a template to create its new wait_on_page_writeback trace event, it
ended up opening a window to NULL pointer dereference crashes due to the
(infrequent) occurrence of a race where an access to a page in the
swap-cache happens concurrently with the moment this page is being written
to disk and the tracepoint is enabled:

    BUG: kernel NULL pointer dereference, address: 0000000000000040
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 800000010ec0a067 P4D 800000010ec0a067 PUD 102353067 PMD 0
    Oops: 0000 [#1] PREEMPT SMP PTI
    CPU: 1 PID: 1320 Comm: shmem-worker Kdump: loaded Not tainted 6.4.0-rc5+ #13
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20230301gitf80f052277c8-1.fc37 03/01/2023
    RIP: 0010:trace_event_raw_event_writeback_folio_template+0x76/0xf0
    Code: 4d 85 e4 74 5c 49 8b 3c 24 e8 06 98 ee ff 48 89 c7 e8 9e 8b ee ff ba 20 00 00 00 48 89 ef 48 89 c6 e8 fe d4 1a 00 49 8b 04 24 <48> 8b 40 40 48 89 43 28 49 8b 45 20 48 89 e7 48 89 43 30 e8 a2 4d
    RSP: 0000:ffffaad580b6fb60 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: ffff90e38035c01c RCX: 0000000000000000
    RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff90e38035c044
    RBP: ffff90e38035c024 R08: 0000000000000002 R09: 0000000000000006
    R10: ffff90e38035c02e R11: 0000000000000020 R12: ffff90e380bac000
    R13: ffffe3a7456d9200 R14: 0000000000001b81 R15: ffffe3a7456d9200
    FS:  00007f2e4e8a15c0(0000) GS:ffff90e3fbc80000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000040 CR3: 00000001150c6003 CR4: 0000000000170ee0
    Call Trace:
     <TASK>
     ? __die+0x20/0x70
     ? page_fault_oops+0x76/0x170
     ? kernelmode_fixup_or_oops+0x84/0x110
     ? exc_page_fault+0x65/0x150
     ? asm_exc_page_fault+0x22/0x30
     ? trace_event_raw_event_writeback_folio_template+0x76/0xf0
     folio_wait_writeback+0x6b/0x80
     shmem_swapin_folio+0x24a/0x500
     ? filemap_get_entry+0xe3/0x140
     shmem_get_folio_gfp+0x36e/0x7c0
     ? find_busiest_group+0x43/0x1a0
     shmem_fault+0x76/0x2a0
     ? __update_load_avg_cfs_rq+0x281/0x2f0
     __do_fault+0x33/0x130
     do_read_fault+0x118/0x160
     do_pte_missing+0x1ed/0x2a0
     __handle_mm_fault+0x566/0x630
     handle_mm_fault+0x91/0x210
     do_user_addr_fault+0x22c/0x740
     exc_page_fault+0x65/0x150
     asm_exc_page_fault+0x22/0x30

This problem arises from the fact that the repurposed writeback_dirty_page
trace event code was written assuming that every pointer to mapping
(struct address_space) would come from a file-mapped page-cache object,
thus mapping->host would always be populated, and that was a valid case
before commit 19343b5bdd16.  The swap-cache address space
(swapper_spaces), however, doesn't populate its ->host (struct inode)
pointer, thus leading to the crashes in the corner-case aforementioned.

commit 19343b5bdd16 ended up breaking the assignment of __entry->name and
__entry->ino for the wait_on_page_writeback tracepoint -- both dependent
on mapping->host carrying a pointer to a valid inode.  The assignment of
__entry->name was fixed by commit 68f23b89067f ("memcg: fix a crash in
wb_workfn when a device disappears"), and this commit fixes the remaining
case, for __entry->ino.

Link: https://lkml.kernel.org/r/20230606233613.1290819-1-aquini@redhat.com
Fixes: 19343b5bdd16 ("mm/page-writeback: introduce tracepoint for wait_on_page_writeback()")
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/writeback.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/writeback.h~writeback-fix-dereferencing-null-mapping-host-on-writeback_page_template
+++ a/include/trace/events/writeback.h
@@ -68,7 +68,7 @@ DECLARE_EVENT_CLASS(writeback_folio_temp
 		strscpy_pad(__entry->name,
 			    bdi_dev_name(mapping ? inode_to_bdi(mapping->host) :
 					 NULL), 32);
-		__entry->ino = mapping ? mapping->host->i_ino : 0;
+		__entry->ino = (mapping && mapping->host) ? mapping->host->i_ino : 0;
 		__entry->index = folio->index;
 	),
 
_

Patches currently in -mm which might be from aquini@redhat.com are


