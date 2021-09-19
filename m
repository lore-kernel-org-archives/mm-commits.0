Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C624C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A95361041
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhISXuS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXuQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:50:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB0961028;
        Sun, 19 Sep 2021 23:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632095331;
        bh=9zvasA5pSQ2wx4yf2l9FzmFbogpd83sMXACrONqTEaA=;
        h=Date:From:To:Subject:From;
        b=HVDLZDUPP0HgdGKdOfwG0zon5sSdahSHvmMw6Nl0ESMH4nbj9T2kDtEZdJGE5N3fA
         nBdYNGmdkz6cWDSLHIViiqqcqELXMK18wq1EZv6r42He/9b9yZ4lLAhrdIY8CLPTi2
         smMlwRzxDd2n1g+vhXuvOeywFqs5pawQknsRU2i8=
Date:   Sun, 19 Sep 2021 16:48:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mhocko@suse.com, linux@armlinux.org.uk,
        ebiederm@xmission.com, anthony.yznaga@oracle.com,
        keescook@chromium.org
Subject:  + binfmt_elf-reintroduce-using-map_fixed_noreplace.patch
 added to -mm tree
Message-ID: <20210919234849.si5I_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: reintroduce using MAP_FIXED_NOREPLACE
has been added to the -mm tree.  Its filename is
     binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/binfmt_elf-reintroduce-using-map_fixed_noreplace.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: binfmt_elf: reintroduce using MAP_FIXED_NOREPLACE

Commit b212921b13bd ("elf: don't use MAP_FIXED_NOREPLACE for elf
executable mappings") reverted back to using MAP_FIXED to map ELF LOAD
segments because it was found that the segments in some binaries overlap
and can cause MAP_FIXED_NOREPLACE to fail.

The original intent of MAP_FIXED_NOREPLACE in the ELF loader was to
prevent the silent clobbering of an existing mapping (e.g.  stack) by the
ELF image, which could lead to exploitable conditions.  Quoting commit
4ed28639519c ("fs, elf: drop MAP_FIXED usage from elf_map"), which
originally introduced the use of MAP_FIXED_NOREPLACE in the loader:

    Both load_elf_interp and load_elf_binary rely on elf_map to map
    segments [to a specific] address and they use MAP_FIXED to enforce
    that. This is however [a] dangerous thing prone to silent data
    corruption which can be even exploitable.
    ...
    Let's take CVE-2017-1000253 as an example ... we could end up mapping
    [the executable] over the existing stack ... The [stack layout] issue
    has been fixed since then ... So we should be safe and any [similar]
    attack should be impractical. On the other hand this is just too
    subtle [an] assumption ... it can break quite easily and [be] hard to
    spot.
    ...
    Address this [weakness] by changing MAP_FIXED to the newly added
    MAP_FIXED_NOREPLACE. This will mean that mmap will fail if there is
    an existing mapping clashing with the requested one [instead of
    silently] clobbering it.

Then processing ET_DYN binaries the loader already calculates a total size
for the image when the first segment is mapped, maps the entire image, and
then unmaps the remainder before the remaining segments are then
individually mapped.  To avoid the earlier problems (legitimate
overlapping LOAD segments specified in the ELF), apply the same logic to
ET_EXEC binaries as well.  For both ET_EXEC and ET_DYN+INTERP use
MAP_FIXED_NOREPLACE for the initial total size mapping and then use
MAP_FIXED to build the final (possibly legitimately overlapping) mappings.
For ET_DYN w/out INTERP, continue to map at a system-selected address in
the mmap region.

Link: https://lkml.kernel.org/r/20210916215947.3993776-1-keescook@chromium.org
Link: https://lore.kernel.org/lkml/1595869887-23307-2-git-send-email-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Co-developed-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/fs/binfmt_elf.c~binfmt_elf-reintroduce-using-map_fixed_noreplace
+++ a/fs/binfmt_elf.c
@@ -1074,20 +1074,26 @@ out_free_interp:
 
 		vaddr = elf_ppnt->p_vaddr;
 		/*
-		 * If we are loading ET_EXEC or we have already performed
-		 * the ET_DYN load_addr calculations, proceed normally.
+		 * The first time through the loop, load_addr_set is false:
+		 * layout will be calculated. Once set, use MAP_FIXED since
+		 * we know we've already safely mapped the entire region with
+		 * MAP_FIXED_NOREPLACE in the once-per-binary logic following.
 		 */
-		if (elf_ex->e_type == ET_EXEC || load_addr_set) {
+		if (load_addr_set) {
 			elf_flags |= MAP_FIXED;
+		} else if (elf_ex->e_type == ET_EXEC) {
+			/*
+			 * This logic is run once for the first LOAD Program
+			 * Header for ET_EXEC binaries. No special handling
+			 * is needed.
+			 */
+			elf_flags |= MAP_FIXED_NOREPLACE;
 		} else if (elf_ex->e_type == ET_DYN) {
 			/*
 			 * This logic is run once for the first LOAD Program
 			 * Header for ET_DYN binaries to calculate the
 			 * randomization (load_bias) for all the LOAD
-			 * Program Headers, and to calculate the entire
-			 * size of the ELF mapping (total_size). (Note that
-			 * load_addr_set is set to true later once the
-			 * initial mapping is performed.)
+			 * Program Headers.
 			 *
 			 * There are effectively two types of ET_DYN
 			 * binaries: programs (i.e. PIE: ET_DYN with INTERP)
@@ -1108,7 +1114,7 @@ out_free_interp:
 			 * Therefore, programs are loaded offset from
 			 * ELF_ET_DYN_BASE and loaders are loaded into the
 			 * independently randomized mmap region (0 load_bias
-			 * without MAP_FIXED).
+			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
 			 */
 			if (interpreter) {
 				load_bias = ELF_ET_DYN_BASE;
@@ -1117,7 +1123,7 @@ out_free_interp:
 				alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
 				if (alignment)
 					load_bias &= ~(alignment - 1);
-				elf_flags |= MAP_FIXED;
+				elf_flags |= MAP_FIXED_NOREPLACE;
 			} else
 				load_bias = 0;
 
@@ -1129,7 +1135,14 @@ out_free_interp:
 			 * is then page aligned.
 			 */
 			load_bias = ELF_PAGESTART(load_bias - vaddr);
+		}
 
+		/*
+		 * Calculate the entire size of the ELF mapping (total_size).
+		 * (Note that load_addr_set is set to true later once the
+		 * initial mapping is performed.)
+		 */
+		if (!load_addr_set) {
 			total_size = total_mapping_size(elf_phdata,
 							elf_ex->e_phnum);
 			if (!total_size) {
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
rapidio-avoid-bogus-__alloc_size-warning.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

