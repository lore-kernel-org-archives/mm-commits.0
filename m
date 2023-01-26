Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E4DC27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbjAZAbc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbjAZAbY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:31:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6480F10AB9
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:31:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FEC616EF
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55365C433EF;
        Thu, 26 Jan 2023 00:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693065;
        bh=lRKC1YEpZu4Yw5jRJwBfdZIuM6h9SdMI/og/QSWJEMk=;
        h=Date:To:From:Subject:From;
        b=1iFoL+gp37FpnV1+zrSAU7Ai1Hx5LgBzYJY3GM+3IT4h8jchwq4z7uGZwF4Z1PAvH
         8GWLvle8aIONfjBelZyBQ/n5QYkcIz/weSP4D3XI1EjawOYwqqWTUXbZ5bJwqEI9jb
         f/vW5TYsxvFI4QWcWzBtRpY0Gc9i35kCqpP/K8LQ=
Date:   Wed, 25 Jan 2023 16:31:04 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-export-dump_mm.patch added to mm-unstable branch
Message-Id: <20230126003105.55365C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export dump_mm()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-export-dump_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-export-dump_mm.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: export dump_mm()
Date: Wed, 25 Jan 2023 15:35:54 -0800

mmap_assert_write_locked() is used in vm_flags modifiers.  Because
mmap_assert_write_locked() uses dump_mm() and vm_flags are sometimes
modified from inside a module, it's necessary to export dump_mm()
function.

Link: https://lkml.kernel.org/r/20230125233554.153109-8-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/debug.c~mm-export-dump_mm
+++ a/mm/debug.c
@@ -215,6 +215,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm->def_flags, &mm->def_flags
 	);
 }
+EXPORT_SYMBOL(dump_mm);
 
 static bool page_init_poisoning __read_mostly = true;
 
_

Patches currently in -mm which might be from surenb@google.com are

kernel-fork-convert-vma-assignment-to-a-memcpy.patch
mm-introduce-vma-vm_flags-wrapper-functions.patch
mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch
mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch
mm-introduce-mod_vm_flags_nolock-and-use-it-in-untrack_pfn.patch
mm-export-dump_mm.patch

