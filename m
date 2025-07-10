Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E281F2857F2
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126327; cv=none; b=eIcIkRFyqVYO8eCWOiJCB+ZkTlP+MHdB6iEadsMpLIx1rk0gVrJYkQOSPwzVJqsAwMLYCkqKf/pADrT2/37VYgtcsFSZDLTCmwfRG1abVMdGsgHu2xpsl1C1KZQeY/cRI9A9qIh8FU1D0yePEyi42YKUL78SdQzTb7Z+2AHWxmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126327; c=relaxed/simple;
	bh=L7ipCEevsEFgzgNpw9ygee37jimbYXRBUIprWjqYsKY=;
	h=Date:To:From:Subject:Message-Id; b=GWazWfSTDnuCHxT0lgdhwQLaoqGtCIUqESU9ygj0L3rD/EygEQEYYSG3H5x2grQiLPJfsBeMHSWScFU4TZKnOHpMT/27CAjF/sgVIk/h3JASTCdEB1LUSohJcD79nJTVnxg54YfZAcLERfYjEJr4ImV96WSSzVlonk4mfIdD+Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQB6hvWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQB6hvWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87F6C4CEE3;
	Thu, 10 Jul 2025 05:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126326;
	bh=L7ipCEevsEFgzgNpw9ygee37jimbYXRBUIprWjqYsKY=;
	h=Date:To:From:Subject:From;
	b=CQB6hvWdJPBq5ND2i2ZcMkWD4JqvpDeOl8WKb4SUVCjNzwoSpOm0t/rTKZcCYTfdp
	 +ouSogBg2s6un/ZGFpQ+VGuuBphd7b4HXEnXjScPOA39rYmVdbW6xmNDgDwRmWUHrY
	 trrgrP/dHcAeCs90m8x4wLHrve3yDHF2PmWr9des=
Date: Wed, 09 Jul 2025 22:45:26 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,cachen@purestorage.com,arnd@arndb.de,petr.pavlu@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] codetag-avoid-unused-alloc_tags-sections-symbols.patch removed from -mm tree
Message-Id: <20250710054526.B87F6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: codetag: avoid unused alloc_tags sections/symbols
has been removed from the -mm tree.  Its filename was
     codetag-avoid-unused-alloc_tags-sections-symbols.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


