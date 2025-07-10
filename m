Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D3E284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126260; cv=none; b=FsWQVyMdHA6nvUp4wN3TQOyeeZ1iOzHCZWw2i3CHFwJrddfZG3JT8c/OqEa483ycei8PTkUyRPKS2P3Hxk7Mmt7vV0KmwXR23poiv4bEmQ4pN/KL1vX9HneRqcs07Me87piJYNf5vIRuR7s71CiYe61iHRytJFKpdtdtUY6i0RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126260; c=relaxed/simple;
	bh=CxGrNr1Y1fGirGvvdYtJh/+nVLSCWXqTq7ENHG7GO4s=;
	h=Date:To:From:Subject:Message-Id; b=ft9Q3xhJnXRKNdTQGICtEjG2sBMHCtTif44FUd6Df6ulf2E+NjazGTQ3Z+sZkcTesUbo55Y9FlM8C0F9pnZ85dUd46GiwB0kMFqUNNQ0cgo6ON+hZZam7+GY1FjQt3Tl1kZF4Q4ndBS7ii93RUukNiCA4e7DvFyQ/wpPNbzUdGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YvI9T4Ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YvI9T4Ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F414C4CEE3;
	Thu, 10 Jul 2025 05:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126260;
	bh=CxGrNr1Y1fGirGvvdYtJh/+nVLSCWXqTq7ENHG7GO4s=;
	h=Date:To:From:Subject:From;
	b=YvI9T4UaTMW/EzUxNR+4NdMsg7Yji9SktS1WK/caVqvLlN/ayB/tIuTnf1+EiO2/b
	 USHNg+4Mor/nOXNoi0lyjkbCR6KdNB0C5zUh6Y6QaSlhjcSn+qDM9KelZVK3gtrNLp
	 rbz+dGsaxV3JP2V+JBLf6tu5SRHrtS7DcbLMGmbs=
Date: Wed, 09 Jul 2025 22:44:19 -0700
To: mm-commits@vger.kernel.org,yzhong@purestorage.com,surenb@google.com,pasha.tatashin@soleen.com,mcgrof@kernel.org,kent.overstreet@linux.dev,arnd@arndb.de,cachen@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-remove-empty-module-tag-section.patch removed from -mm tree
Message-Id: <20250710054420.4F414C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: remove empty module tag section
has been removed from the -mm tree.  Its filename was
     alloc_tag-remove-empty-module-tag-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


