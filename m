Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A25C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2B2208E4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600053732;
	bh=vDuRWU/j59SuS4GwiMlvFFL7MbqVcw/K9PPBq0uFaak=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ns/NXRWxC1rFXe4Jpio8M5V+df7dj8l5IYmDzNZoxB+At3PqchrOoA57DPV2c6gfT
	 M/EECZ4cHFvoA6B4G+OB57rAYyBJDpf3xD15Fx94BMpcfOveLOq5lKU8LpWJZCrRKc
	 guSMVdiISsBWE5tVGOQUMWbm700xnmwDZgxylQB8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgINDWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgINDWK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 23:22:10 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B99208DB;
        Mon, 14 Sep 2020 03:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600053729;
        bh=vDuRWU/j59SuS4GwiMlvFFL7MbqVcw/K9PPBq0uFaak=;
        h=Date:From:To:Subject:From;
        b=r9PjuYpG+RW1R+G0/Td9vgSKbgHSOq3S4IJmJwOXSJotulRb2DKNeS6ThKCHI1vpZ
         gndamfa8z6MPKG1mHHEAlW9DeyoU5TCbRp4ZLZnQRmNEDwHVQIs0wpVuCevTueygM+
         X5hlClvDW87HQ7vlLXbV6jfkXQ+wTArDeizSYv2s=
Date:   Sun, 13 Sep 2020 20:22:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        hch@lst.de, tklauser@distanz.ch
Subject:  +
 fs-adjust-dirtytime_interval_handler-definition-to-match-prototype.patch
 added to -mm tree
Message-ID: <20200914032209.cF9p9%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fs-writeback.c: adjust dirtytime_interval_handler definition to match prototype
has been added to the -mm tree.  Its filename is
     fs-adjust-dirtytime_interval_handler-definition-to-match-prototype.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-adjust-dirtytime_interval_handler-definition-to-match-prototype.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-adjust-dirtytime_interval_handler-definition-to-match-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: fs/fs-writeback.c: adjust dirtytime_interval_handler definition to match prototype

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer.  Adjust the
definition of dirtytime_interval_handler to match its prototype in
linux/writeback.h which fixes the following sparse error/warning:

fs/fs-writeback.c:2189:50: warning: incorrect type in argument 3 (different address spaces)
fs/fs-writeback.c:2189:50:    expected void *
fs/fs-writeback.c:2189:50:    got void [noderef] __user *buffer
fs/fs-writeback.c:2184:5: error: symbol 'dirtytime_interval_handler' redeclared with different type (incompatible argument 3 (different address spaces)):
fs/fs-writeback.c:2184:5:    int extern [addressable] [signed] [toplevel] dirtytime_interval_handler( ... )
fs/fs-writeback.c: note: in included file:
./include/linux/writeback.h:374:5: note: previously declared as:
./include/linux/writeback.h:374:5:    int extern [addressable] [signed] [toplevel] dirtytime_interval_handler( ... )

Link: https://lkml.kernel.org/r/20200907093140.13434-1-tklauser@distanz.ch
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fs-writeback.c~fs-adjust-dirtytime_interval_handler-definition-to-match-prototype
+++ a/fs/fs-writeback.c
@@ -2184,7 +2184,7 @@ static int __init start_dirtytime_writeb
 __initcall(start_dirtytime_writeback);
 
 int dirtytime_interval_handler(struct ctl_table *table, int write,
-			       void __user *buffer, size_t *lenp, loff_t *ppos)
+			       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
 
_

Patches currently in -mm which might be from tklauser@distanz.ch are

ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch
stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch
fs-adjust-dirtytime_interval_handler-definition-to-match-prototype.patch

