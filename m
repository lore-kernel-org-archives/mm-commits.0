Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00DDC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D9161132
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhEJBeg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 21:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhEJBef (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 21:34:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4858D6103E;
        Mon, 10 May 2021 01:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620610412;
        bh=wxiS5cESVtJ4HU8skLa2TJ42ebP2fLiOhzP3NHD3lfE=;
        h=Date:From:To:Subject:From;
        b=viB2uLuzfjENchdyIPXsfrEdfdoT79ka2Q2USK4KzvCkvNpk3+iwDq6Bzvdp0UAFn
         njZYJXkHtqXXa4pQ98tVB177fWXYJRL+sopGZ8yFUFqt8wh1qHjy33UtfsZs9lAeDH
         fZvyCTpDITeQ3Ts+84lbkib9YIfFmqZIuNnmOT5w=
Date:   Sun, 09 May 2021 18:33:30 -0700
From:   akpm@linux-foundation.org
To:     acme@kernel.org, alexander.shishkin@linux.intel.com, bp@alien8.de,
        catalin.marinas@arm.com, david@redhat.com, dzickus@redhat.com,
        ebiederm@xmission.com, feng.tang@intel.com, gerg@linux-m68k.org,
        hpa@zytor.com, jolsa@redhat.com, keescook@chromium.org,
        Kevin.Brodsky@arm.com, mark.rutland@arm.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, namhyung@kernel.org,
        peterz@infradead.org, rppt@kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
Subject:  + perf-map_executable-does-not-indicate-vm_mayexec.patch
 added to -mm tree
Message-ID: <20210510013330.JwWZbbxkg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: perf: MAP_EXECUTABLE does not indicate VM_MAYEXEC
has been added to the -mm tree.  Its filename is
     perf-map_executable-does-not-indicate-vm_mayexec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/perf-map_executable-does-not-indicate-vm_mayexec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/perf-map_executable-does-not-indicate-vm_mayexec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -8306,8 +8306,6 @@ static void perf_event_mmap_event(struct
 
 	if (vma->vm_flags & VM_DENYWRITE)
 		flags |= MAP_DENYWRITE;
-	if (vma->vm_flags & VM_MAYEXEC)
-		flags |= MAP_EXECUTABLE;
 	if (vma->vm_flags & VM_LOCKED)
 		flags |= MAP_LOCKED;
 	if (is_vm_hugetlb_page(vma))
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch

