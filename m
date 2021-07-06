Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5792C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB9B60FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhGFTPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231886AbhGFTPD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A36560FE3;
        Tue,  6 Jul 2021 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598744;
        bh=s5ciTpbTXVYdzXf27V0XoNT3hOWhVZ/B+3I7E/PEHJ0=;
        h=Date:From:To:Subject:From;
        b=tMp+Gw91rZLdVBOMO+kq/FTs+IV9QcMGGeM+jaGnm46tNl7tQRzY037+W3FSkuc3z
         s1xCewQ7drj9NKWRAjYXrIsD8sHpk9kTY926Y0GDkO4V9+cnVk3b8Dp5hYVveGxw4O
         +LQPXuwELKOHMBr6BdVDRG+q0/zBlru4BAolw4ls=
Date:   Tue, 06 Jul 2021 12:12:24 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 drm-i915-selftests-use-vma_lookup-in-__igt_mmap.patch removed from -mm tree
Message-ID: <20210706191224.VVeJD8dvh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915/selftests: use vma_lookup() in __igt_mmap()
has been removed from the -mm tree.  Its filename was
     drm-i915-selftests-use-vma_lookup-in-__igt_mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: drm/i915/selftests: use vma_lookup() in __igt_mmap()

vma_lookup() will look up the vma at a specific address.  find_vma() will
start the search for a specific address and continue upwards.  This fixes
an issue with the selftest as the returned vma may not be the newly
created vma, but simply the vma at a higher address.

Link: https://lkml.kernel.org/r/20210521174745.2219620-3-Liam.Howlett@Oracle.com
Fixes: 6fedafacae1b (drm/i915/selftests: Wrap vm_mmap() around GEM
objects
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c~drm-i915-selftests-use-vma_lookup-in-__igt_mmap
+++ a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -871,7 +871,7 @@ static int __igt_mmap(struct drm_i915_pr
 
 	pr_debug("igt_mmap(%s, %d) @ %lx\n", obj->mm.region->name, type, addr);
 
-	area = find_vma(current->mm, addr);
+	area = vma_lookup(current->mm, addr);
 	if (!area) {
 		pr_err("%s: Did not create a vm_area_struct for the mmap\n",
 		       obj->mm.region->name);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


