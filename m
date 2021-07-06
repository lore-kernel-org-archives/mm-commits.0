Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23023C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB6760FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhGFTOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231795AbhGFTOw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E64261057;
        Tue,  6 Jul 2021 19:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598732;
        bh=NxbUcrXJeZTUuuQtDY276yU0hxCUKln+BYJD4eOkhDA=;
        h=Date:From:To:Subject:From;
        b=yBpQidr6l9W7T/dcBvhT4FXcs5Mk2aAk64mfGQTvk7bRjeDoFJRfV1I4l7HpO624M
         qpqzXJCD4JGhBuHAVpkjVBYc9XRT0wM9qSqVRf3zi2oD29G0bFr3dh2FwXA35knbLO
         rcjhq/AvffQbaHeZQDZ0xUE8KzdAFYW96KXvw804=
Date:   Tue, 06 Jul 2021 12:12:11 -0700
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
 mm-ignore-map_executable-in-ksys_mmap_pgoff.patch removed from -mm tree
Message-ID: <20210706191211.w9HfzAEBF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ignore MAP_EXECUTABLE in ksys_mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-ignore-map_executable-in-ksys_mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: ignore MAP_EXECUTABLE in ksys_mmap_pgoff()

Let's also remove masking off MAP_EXECUTABLE from ksys_mmap_pgoff(): the
last in-tree occurrence of MAP_EXECUTABLE is now in LEGACY_MAP_MASK, which
accepts the flag e.g., for MAP_SHARED_VALIDATE; however, the flag is
ignored throughout the kernel now.

Add a comment to LEGACY_MAP_MASK stating that MAP_EXECUTABLE is ignored.

Link: https://lkml.kernel.org/r/20210421093453.6904-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kevin Brodsky <Kevin.Brodsky@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    2 ++
 mm/mmap.c            |    2 +-
 mm/nommu.c           |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/mman.h~mm-ignore-map_executable-in-ksys_mmap_pgoff
+++ a/include/linux/mman.h
@@ -31,6 +31,8 @@
 /*
  * The historical set of flags that all mmap implementations implicitly
  * support when a ->mmap_validate() op is not provided in file_operations.
+ *
+ * MAP_EXECUTABLE is completely ignored throughout the kernel.
  */
 #define LEGACY_MAP_MASK (MAP_SHARED \
 		| MAP_PRIVATE \
--- a/mm/mmap.c~mm-ignore-map_executable-in-ksys_mmap_pgoff
+++ a/mm/mmap.c
@@ -1633,7 +1633,7 @@ unsigned long ksys_mmap_pgoff(unsigned l
 			return PTR_ERR(file);
 	}
 
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	flags &= ~MAP_DENYWRITE;
 
 	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 out_fput:
--- a/mm/nommu.c~mm-ignore-map_executable-in-ksys_mmap_pgoff
+++ a/mm/nommu.c
@@ -1296,7 +1296,7 @@ unsigned long ksys_mmap_pgoff(unsigned l
 			goto out;
 	}
 
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	flags &= ~MAP_DENYWRITE;
 
 	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-complete-admin-guide-overhaul.patch

