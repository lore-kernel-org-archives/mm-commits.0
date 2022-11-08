Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08043C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKHXtB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiKHXtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD025B85E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F7E616FB
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06283C433C1;
        Tue,  8 Nov 2022 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951339;
        bh=8oLGN6XLRd5XeleIupkki0V/hJ1GCdt0y5yXXem3Pqc=;
        h=Date:To:From:Subject:From;
        b=NddMgPtt9vz587U4hhktFY8ABCPLhxMwPz6iNe8dI7Lh4AuGtauBAAfwuZQiMPZGi
         GnC+17em1vvTrljwMSPL9DPvfijWXqO8kiCKxyK4Mq7KTzz0LYeK03MR9lbxL8oHzG
         fed9QksGK2PvK0uv5un+W3o03PrP56hx5KjkUg40=
Date:   Tue, 08 Nov 2022 15:48:58 -0800
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com,
        keescook@chromium.org, dyoung@redhat.com, bhe@redhat.com,
        stephen.s.brennan@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size.patch added to mm-nonmm-unstable branch
Message-Id: <20221108234859.06283C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmcoreinfo: warn if we exceed vmcoreinfo data size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: vmcoreinfo: warn if we exceed vmcoreinfo data size
Date: Thu, 27 Oct 2022 13:50:08 -0700

Though vmcoreinfo is intended to be small, at just one page, useful
information is still added to it, so we risk running out of space. 
Currently there is no runtime check to see whether the vmcoreinfo buffer
has been exhausted.  Add a warning for this case.

Currently, my static checking tool[1] indicates that a good upper bound
for vmcoreinfo size is currently 3415 bytes, but the best time to add
warnings is before the risk becomes too high.

[1] https://github.com/brenns10/kernel_stuff/blob/master/vmcoreinfosize/vmcoreinfosize.py

Link: https://lkml.kernel.org/r/20221027205008.312534-1-stephen.s.brennan@oracle.com
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/crash_core.c~vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size
+++ a/kernel/crash_core.c
@@ -383,6 +383,9 @@ void vmcoreinfo_append_str(const char *f
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
 	vmcoreinfo_size += r;
+
+	WARN_ONCE(vmcoreinfo_size == VMCOREINFO_BYTES,
+		  "vmcoreinfo data exceeds allocated size, truncating");
 }
 
 /*
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are

vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size.patch

