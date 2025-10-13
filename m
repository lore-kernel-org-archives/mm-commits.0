Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA551FCF7C
	for <mm-commits@vger.kernel.org>; Mon, 13 Oct 2025 22:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760395809; cv=none; b=hnhQTcJeU0uptDPrqji46dRTGnMIHwzjVZEwhQQtl+vdFbi14DilmOqb95810McTq1B4BIV4ecR4iQPxvvuk8WXfBPXm/sxK151xyoKBMo15YvQGFoCuZsAKYFuV97OcprwaV8smyWXlmNscmfpxgoCzJchzVPMu6eUnrC87oyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760395809; c=relaxed/simple;
	bh=OsJdm0ZwhunuAdH66Dq883dtxVRW9dfCB83iDC7AmZs=;
	h=Date:To:From:Subject:Message-Id; b=L/X/0BsCNofusISD1+toAIYTpVz9rSAHW2xM2V2IL0+FQ4HvNZLHZ2DUIo7XM6KeZxZ+EqsZ94DWBAVha23uW7x2Bb0+2VJietEANqlcuZUJWdT65Lc43HJbDO5QQds2p41sEglgGPOkmBhE6goQZJJ6BDTbxpE338u7ijB3ZZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xol4p6Di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xol4p6Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9373FC4CEFE;
	Mon, 13 Oct 2025 22:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760395808;
	bh=OsJdm0ZwhunuAdH66Dq883dtxVRW9dfCB83iDC7AmZs=;
	h=Date:To:From:Subject:From;
	b=Xol4p6Dia1WEkG3G4LSc3J2GeD2ccnOAyHy1ynPfs2RE4cR2JfaHDfhIkaLbhenVc
	 nKdBfLmZrZrThi5IYBzeUD7q30YamiOL5BhvclwYhhUkoATpfTFpjaCIoh0j3NW2W+
	 /4E6BcT91LQ4+7XNvjw5HCJNwDXF8H+aw9rF2Xtg=
Date: Mon, 13 Oct 2025 15:50:08 -0700
To: mm-commits@vger.kernel.org,mhocko@kernel.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-update-__vmalloc_node_noprof-documentation.patch added to mm-new branch
Message-Id: <20251013225008.9373FC4CEFE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: update __vmalloc_node_noprof() documentation
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-update-__vmalloc_node_noprof-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-update-__vmalloc_node_noprof-documentation.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: update __vmalloc_node_noprof() documentation
Date: Mon, 13 Oct 2025 19:42:22 +0200

The kernel-doc for __vmalloc_node_noprof() incorrectly states that
__GFP_NOFAIL reclaim modifier is not supported.  In fact it has been
supported since commit 9376130c390a ("mm/vmalloc: add support for
__GFP_NOFAIL").

To avoid duplication and future drift, point this helper's doc to
__vmalloc_node_range_noprof() for details and the full description.

Link: https://lkml.kernel.org/r/20251013174222.90123-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~vmalloc-update-__vmalloc_node_noprof-documentation
+++ a/mm/vmalloc.c
@@ -4034,11 +4034,8 @@ fail:
  * Allocate enough pages to cover @size from the page level allocator with
  * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
- * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
- * and __GFP_NOFAIL are not supported
- *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted
- * with mm people.
+ * Semantics of @gfp_mask(including reclaim/retry modifiers such as
+ * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
  *
  * Return: pointer to the allocated memory or %NULL on error
  */
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch
vmalloc-update-__vmalloc_node_noprof-documentation.patch

