Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878D4C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1846023F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhGFTOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231819AbhGFTOp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8509860FE3;
        Tue,  6 Jul 2021 19:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598726;
        bh=ZOMyU8RWttfFEVGkvnKwPb1/s9WwdaaxEPjW+LOM5mg=;
        h=Date:From:To:Subject:From;
        b=E0L+EAxJbSTuG//VHGjpGxnk/gXXhy5IEGIInJwX29Uss98R9u6Mfcu2gK8rYna4X
         kIkF/Sy7Pbhnqqcsuk06WynDbWXVyqC9PtDAckJh/Lx7qRwlhAivHnwXzXPXXwKu5b
         XpbbScgI/NBJdlJnN9QSx0UkAs9sRdyQWvF9lsUc=
Date:   Tue, 06 Jul 2021 12:12:05 -0700
From:   akpm@linux-foundation.org
To:     acme@kernel.org, alexander.shishkin@linux.intel.com, bp@alien8.de,
        catalin.marinas@arm.com, david@redhat.com, dzickus@redhat.com,
        ebiederm@xmission.com, feng.tang@intel.com, gerg@linux-m68k.org,
        hpa@zytor.com, jolsa@redhat.com, keescook@chromium.org,
        Kevin.Brodsky@arm.com, mark.rutland@arm.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, namhyung@kernel.org,
        peterz@infradead.org, rppt@kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 perf-map_executable-does-not-indicate-vm_mayexec.patch removed from -mm
 tree
Message-ID: <20210706191205.K2tuUqSk8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: perf: MAP_EXECUTABLE does not indicate VM_MAYEXEC
has been removed from the -mm tree.  Its filename was
     perf-map_executable-does-not-indicate-vm_mayexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: perf: MAP_EXECUTABLE does not indicate VM_MAYEXEC

Patch series "perf/binfmt/mm: remove in-tree usage of MAP_EXECUTABLE".

Stumbling over the history of MAP_EXECUTABLE, I noticed that we still have
some in-tree users that we can get rid of.


This patch (of 3):

Before commit e9714acf8c43 ("mm: kill vma flag VM_EXECUTABLE and
mm->num_exe_file_vmas"), VM_EXECUTABLE indicated MAP_EXECUTABLE. 
MAP_EXECUTABLE is nowadays essentially ignored by the kernel and does not
relate to VM_MAYEXEC.

Link: https://lkml.kernel.org/r/20210421093453.6904-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210421093453.6904-2-david@redhat.com
Fixes: f972eb63b100 ("perf: Pass protection and flags bits through mmap2 interface")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kevin Brodsky <Kevin.Brodsky@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/events/core.c~perf-map_executable-does-not-indicate-vm_mayexec
+++ a/kernel/events/core.c
@@ -8301,8 +8301,6 @@ static void perf_event_mmap_event(struct
 
 	if (vma->vm_flags & VM_DENYWRITE)
 		flags |= MAP_DENYWRITE;
-	if (vma->vm_flags & VM_MAYEXEC)
-		flags |= MAP_EXECUTABLE;
 	if (vma->vm_flags & VM_LOCKED)
 		flags |= MAP_LOCKED;
 	if (is_vm_hugetlb_page(vma))
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-complete-admin-guide-overhaul.patch

