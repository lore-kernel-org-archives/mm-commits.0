Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB831C2324
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750287952; cv=none; b=s06BIUStU5q5iFFFAnt7DncJmmjT/tdzOfTMPmpV6L43pumZtyJ5x4/YIb+UgVD8UpKKGcPCmLY8pSjFcJghN/ir0HG2gX3uyJrt3KmkkIfqxm609WwPOsg1smi1Y8+vqqIAVQXqer4jV8MeLkWMa3J6Wu2au9JhB2yO6ytsjGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750287952; c=relaxed/simple;
	bh=z779GLWd1PIRqbRLxumx7gS4ZgmoleyY42ZX283FoI8=;
	h=Date:To:From:Subject:Message-Id; b=SPJbHxtF5/vweaN4ZVzHVbbrkuzPhUMIjljJuP7KZ4rdEd6tIZg7EzFoR7xT5L0AzX7hqIJP0i+iYKR+XDCY4TBDNUmoFHyu814cHEJfSkIYmGY7/OUcDDuTyr7M2LHW2G80K2OzJj2fpLYRIrnrJRpS8SN7ucqkF+TApj8aCsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tC6K0dam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tC6K0dam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DD6C4CEE7;
	Wed, 18 Jun 2025 23:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750287952;
	bh=z779GLWd1PIRqbRLxumx7gS4ZgmoleyY42ZX283FoI8=;
	h=Date:To:From:Subject:From;
	b=tC6K0damWcoK6KPEA3EIvcZS1mohTtiJCLyMGbKYhUYFpfgAi8AQyjDyWYbCsVN+x
	 UhdQG8fjf8KkollX7Zsdp6AdYL++wY8T/urFl3+q5SSQ7F6g6Nq2K3WQYhNpj5Pei+
	 MzPiOZbVAQO1ztcNvKFm8UXYMo/grRwd7Gr7DROs=
Date: Wed, 18 Jun 2025 16:05:51 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,cachen@purestorage.com,arnd@arndb.de,petr.pavlu@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + codetag-avoid-unused-alloc_tags-sections-symbols.patch added to mm-new branch
Message-Id: <20250618230552.19DD6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: codetag: avoid unused alloc_tags sections/symbols
has been added to the -mm mm-new branch.  Its filename is
     codetag-avoid-unused-alloc_tags-sections-symbols.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/codetag-avoid-unused-alloc_tags-sections-symbols.patch

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
From: Petr Pavlu <petr.pavlu@suse.com>
Subject: codetag: avoid unused alloc_tags sections/symbols
Date: Wed, 18 Jun 2025 14:50:35 +0200

With CONFIG_MEM_ALLOC_PROFILING=n, vmlinux and all modules unnecessarily
contain the symbols __start_alloc_tags and __stop_alloc_tags, which define
an empty range.  In the case of modules, the presence of these symbols
also forces the linker to create an empty .codetag.alloc_tags section.

Update codetag.lds.h to make the data conditional on
CONFIG_MEM_ALLOC_PROFILING.

Link: https://lkml.kernel.org/r/20250618125037.53182-1-petr.pavlu@suse.com
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Casey Chen <cachen@purestorage.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/codetag.lds.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/asm-generic/codetag.lds.h~codetag-avoid-unused-alloc_tags-sections-symbols
+++ a/include/asm-generic/codetag.lds.h
@@ -2,6 +2,12 @@
 #ifndef __ASM_GENERIC_CODETAG_LDS_H
 #define __ASM_GENERIC_CODETAG_LDS_H
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+#define IF_MEM_ALLOC_PROFILING(...) __VA_ARGS__
+#else
+#define IF_MEM_ALLOC_PROFILING(...)
+#endif
+
 #define SECTION_WITH_BOUNDARIES(_name)	\
 	. = ALIGN(8);			\
 	__start_##_name = .;		\
@@ -9,7 +15,7 @@
 	__stop_##_name = .;
 
 #define CODETAG_SECTIONS()		\
-	SECTION_WITH_BOUNDARIES(alloc_tags)
+	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(alloc_tags))
 
 #define MOD_SEPARATE_CODETAG_SECTION(_name)	\
 	.codetag.##_name : {			\
@@ -22,6 +28,6 @@
  * unload them individually once unused.
  */
 #define MOD_SEPARATE_CODETAG_SECTIONS()		\
-	MOD_SEPARATE_CODETAG_SECTION(alloc_tags)
+	IF_MEM_ALLOC_PROFILING(MOD_SEPARATE_CODETAG_SECTION(alloc_tags))
 
 #endif /* __ASM_GENERIC_CODETAG_LDS_H */
_

Patches currently in -mm which might be from petr.pavlu@suse.com are

codetag-avoid-unused-alloc_tags-sections-symbols.patch

