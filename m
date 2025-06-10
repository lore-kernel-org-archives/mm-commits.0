Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BB72135D1
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584233; cv=none; b=Hhfp46g0He645PTzwMufS1+q4O9yVXibXYnWW5clB6psZmlsPcRHKNlMMcQvGy9ExrEZyUuzscTEdaRegTYOnvmoRKkaoaeHNPa7zCdyfqqpX3shyi+D9PyjaAH3I1NQII5SQ92/95OifDKVKeXMc6fraqK00ZuVhowEWBAa5xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584233; c=relaxed/simple;
	bh=IbIXLCzHk7BH9RW15qp3ecWhZabphlKq52nnCtxlzQo=;
	h=Date:To:From:Subject:Message-Id; b=SWxdOKW5JCv/1KOzU3CkpPzww01szMuYtMgW6kn6GURlAEQg6Oj4bVBOchz4IAr6pUo/t88PFRFu5C2aZXBePAMQZkgVqMgDsQW7t0Cxc4yU1UAaYWi9xQcGfzLivza9nYKZZ0ebPw36UfqCQ46l2OgR/DnLnYbyxCzM8TmAaxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E7bq2M6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E7bq2M6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B81CC4CEED;
	Tue, 10 Jun 2025 19:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749584232;
	bh=IbIXLCzHk7BH9RW15qp3ecWhZabphlKq52nnCtxlzQo=;
	h=Date:To:From:Subject:From;
	b=E7bq2M6C7qXdrAAQIXpvgfyZnKqW7z6pYEPbk2TEpBFNZHPIAXmHtjX+ImEG7YA8s
	 bYwgJlDluAp8WElrq+eo3mJhFNg9dvHS64i6ouAFwBocr+dB6U93NvvkPqHUl0xUJE
	 hifVfZ/PE5gYbDNVREDIjwzt1X9Cl6R2j4PyAE8Q=
Date: Tue, 10 Jun 2025 12:37:11 -0700
To: mm-commits@vger.kernel.org,yzhong@purestorage.com,surenb@google.com,pasha.tatashin@soleen.com,mcgrof@kernel.org,kent.overstreet@linux.dev,arnd@arndb.de,cachen@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-remove-empty-module-tag-section.patch added to mm-new branch
Message-Id: <20250610193712.9B81CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: remove empty module tag section
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-remove-empty-module-tag-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-remove-empty-module-tag-section.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Casey Chen <cachen@purestorage.com>
Subject: alloc_tag: remove empty module tag section
Date: Tue, 10 Jun 2025 10:22:58 -0600

The empty MOD_CODETAG_SECTIONS() macro added an incomplete .data section
in module linker script, which caused symbol lookup tools like gdb to
misinterpret symbol addresses e.g., __ib_process_cq incorrectly mapping to
unrelated functions like below.

  (gdb) disas __ib_process_cq
  Dump of assembler code for function trace_event_fields_cq_schedule:

Removing the empty section restores proper symbol resolution and layout,
ensuring .data placement behaves as expected.

Link: https://lkml.kernel.org/r/20250610162258.324645-1-cachen@purestorage.com
Fixes: 0db6f8d7820a ("alloc_tag: load module tags into separate contiguous memory")
       22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Yuanyuan Zhong <yzhong@purestorage.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/codetag.lds.h |    6 ------
 scripts/module.lds.S              |    5 -----
 2 files changed, 11 deletions(-)

--- a/include/asm-generic/codetag.lds.h~alloc_tag-remove-empty-module-tag-section
+++ a/include/asm-generic/codetag.lds.h
@@ -11,12 +11,6 @@
 #define CODETAG_SECTIONS()		\
 	SECTION_WITH_BOUNDARIES(alloc_tags)
 
-/*
- * Module codetags which aren't used after module unload, therefore have the
- * same lifespan as the module and can be safely unloaded with the module.
- */
-#define MOD_CODETAG_SECTIONS()
-
 #define MOD_SEPARATE_CODETAG_SECTION(_name)	\
 	.codetag.##_name : {			\
 		SECTION_WITH_BOUNDARIES(_name)	\
--- a/scripts/module.lds.S~alloc_tag-remove-empty-module-tag-section
+++ a/scripts/module.lds.S
@@ -52,17 +52,12 @@ SECTIONS {
 	.data : {
 		*(.data .data.[0-9a-zA-Z_]*)
 		*(.data..L*)
-		MOD_CODETAG_SECTIONS()
 	}
 
 	.rodata : {
 		*(.rodata .rodata.[0-9a-zA-Z_]*)
 		*(.rodata..L*)
 	}
-#else
-	.data : {
-		MOD_CODETAG_SECTIONS()
-	}
 #endif
 	MOD_SEPARATE_CODETAG_SECTIONS()
 }
_

Patches currently in -mm which might be from cachen@purestorage.com are

alloc_tag-remove-empty-module-tag-section.patch

