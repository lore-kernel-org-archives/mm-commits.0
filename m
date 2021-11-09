Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902A4C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79CCF61284
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhKICgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235794AbhKICgW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77ECF61279;
        Tue,  9 Nov 2021 02:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425217;
        bh=7kRaZnN02H3Y0s4wUnS1uZLxoey/d8arYedjuTp+YfQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gG04iTfz3amvh6+epl3KyH5zFZVglQOLXghdrsmp9Stq6FyYgD36ZyK4ETrZepkak
         WFckKndlpGzQZPr9UCLZRkJ4P9TRhILw3qIkYQs54HqKw3F+SEhMmLdTNWtij++3sB
         xKl3J86Ra7mdGeyNJR7/2IPKMazKRcdB0psWOdLc=
Date:   Mon, 08 Nov 2021 18:33:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anthony.yznaga@oracle.com,
        avagin@openvz.org, chenjingwen6@huawei.com, ebiederm@xmission.com,
        keescook@chromium.org, khalid.aziz@oracle.com, linux-mm@kvack.org,
        linux@armlinux.org.uk, mhocko@suse.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 42/87] binfmt_elf: reintroduce using
 MAP_FIXED_NOREPLACE
Message-ID: <20211109023337.byL1_5rp_%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Co-developed-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Chen Jingwen <chenjingwen6@huawei.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrei Vagin <avagin@openvz.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
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
