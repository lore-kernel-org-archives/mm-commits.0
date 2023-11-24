Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B12C61D97
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345971AbjKXTb5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345941AbjKXTb4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:31:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ABE1FE6
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:32:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F687C433C8;
        Fri, 24 Nov 2023 19:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700854322;
        bh=jyfnAhnbc/ByNW/iVUeXgZx9APN5CMVzL28EGz4OV10=;
        h=Date:To:From:Subject:From;
        b=VOfJbEKEfQEWVTe9wAbcZI8xXEUS6hFLKnRbZzD4xzzZtdwiBMVHOBvTle5STbiqI
         hI1BmvfDOBdceR3M3ejbF666X4VcLD9MF4MbWsi/HNgXcHEAXVtW6xFjwVBtEcLhiJ
         pYeQGxN46P4iTmwSTp+ukM5Cq2vluGfjcHK99LfA=
Date:   Fri, 24 Nov 2023 11:32:01 -0800
To:     mm-commits@vger.kernel.org, takahiro.akashi@linaro.org,
        ebiederm@xmission.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-load-kernel-at-top-of-system-ram-if-required.patch added to mm-nonmm-unstable branch
Message-Id: <20231124193202.2F687C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: load kernel at top of system RAM if required
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-load-kernel-at-top-of-system-ram-if-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-load-kernel-at-top-of-system-ram-if-required.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: kexec_file: load kernel at top of system RAM if required
Date: Tue, 14 Nov 2023 17:16:58 +0800

Patch series "kexec_file: Load kernel at top of system RAM if required".

Justification:
==============

Kexec_load interface has been doing top down searching and loading
kernel/initrd/purgtory etc to prepare for kexec reboot.  In that way, the
benefits are that it avoids to consume and fragment limited low memory
which satisfy DMA buffer allocation and big chunk of continuous memory
during system init; and avoids to stir with BIOS/FW reserved or occupied
areas, or corner case handling/work around/quirk occupied areas when doing
system init.  By the way, the top-down searching and loading of kexec-ed
kernel is done in user space utility code.

For kexec_file loading, even if kexec_buf.top_down is 'true', it's simply
ignored.  It calls walk_system_ram_res() directly to go through all
resources of System RAM bottom up, to find an available memory region,
then call locate_mem_hole_callback() to allocate memory in that found
memory region from top to down.  This is not expected and inconsistent
with kexec_load.

Implementation
===============

In patch 1, introduce a new function walk_system_ram_res_rev() which is a
variant of walk_system_ram_res(), it walks through a list of all the
resources of System RAM in reversed order, i.e., from higher to lower.

In patch 2, check if kexec_buf.top_down is 'true' in
kexec_walk_resources(), if yes, call walk_system_ram_res_rev() to find
memory region of system RAM from top to down to load kernel/initrd etc.

Background information: ======================= And I ever tried this in
the past in a different way, please see below link.  In the post, I tried
to adjust struct sibling linking code, replace the the singly linked list
with list_head so that walk_system_ram_res_rev() can be implemented in a
much easier way.  Finally I failed. 
https://lore.kernel.org/all/20180718024944.577-4-bhe@redhat.com/

This time, I picked up the patch from AKASHI Takahiro's old post and made
some change to take as the current patch 1:
https://lists.infradead.org/pipermail/linux-arm-kernel/2017-September/531456.html


This patch (of 2):

Kexec_load interface has been doing top down searching and loading
kernel/initrd/purgtory etc to prepare for kexec reboot.  In that way, the
benefits are that it avoids to consume and fragment limited low memory
which satisfy DMA buffer allocation and big chunk of continuous memory
during system init; and avoids to stir with BIOS/FW reserved or occupied
areas, or corner case handling/work around/quirk occupied areas when doing
system init.  By the way, the top-down searching and loading of kexec-ed
kernel is done in user space utility code.

For kexec_file loading, even if kexec_buf.top_down is 'true', it's simply
ignored.  It calls walk_system_ram_res() directly to go through all
resources of System RAM bottom up, to find an available memory region,
then call locate_mem_hole_callback() to allocate memory in that found
memory region from top to down.  This is not expected and inconsistent
with kexec_load.

Here check if kexec_buf.top_down is 'true' in kexec_walk_resources(), if
yes, call the newly added walk_system_ram_res_rev() to find memory region
of system RAM from top to down to load kernel/initrd etc.

Link: https://lkml.kernel.org/r/20231114091658.228030-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20231114091658.228030-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kexec_file.c~kexec_file-load-kernel-at-top-of-system-ram-if-required
+++ a/kernel/kexec_file.c
@@ -592,6 +592,8 @@ static int kexec_walk_resources(struct k
 					   IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY,
 					   crashk_res.start, crashk_res.end,
 					   kbuf, func);
+	else if (kbuf->top_down)
+		return walk_system_ram_res_rev(0, ULONG_MAX, kbuf, func);
 	else
 		return walk_system_ram_res(0, ULONG_MAX, kbuf, func);
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch

