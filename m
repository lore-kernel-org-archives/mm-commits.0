Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0111B13AC1
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745799500; cv=none; b=DHvjo4z2mkRLDVeA6SGdKBTmtmyEpuveH6hP660q0N2SMrYELI6e77erzpeH3kIBSI7jbMdA6aMGA9cjwJEIO8spnSewLEUUlJEePsZ4RCwCGR9BlBokIvT33McRG6tL0TUj58f+HHHN+IoYv9fKYKICdA6jfwedK7s0c/wZeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745799500; c=relaxed/simple;
	bh=RZfOf8zt3LOKazAnZiamTllZ0OLlM9rejk3+7PquHt8=;
	h=Date:To:From:Subject:Message-Id; b=WD4RUtYkQX35KlOzbn4Jrj5RDdpEwRyORiwnJ/m+Z/2d7TyHDBwlweWdSAB7h4hkh2XO41f+lVJl0X2fmk3C1olgaod9H+qXXB0w3ODsKRwPMKvqWc5oiMdDwUxPJHgEsjoU0Cu7bh0CI/S+YtdCnCpl9JSNZhiEQy/WyCo9L8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0pV1k+kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0pV1k+kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626D4C4CEE3;
	Mon, 28 Apr 2025 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745799497;
	bh=RZfOf8zt3LOKazAnZiamTllZ0OLlM9rejk3+7PquHt8=;
	h=Date:To:From:Subject:From;
	b=0pV1k+kEPcr0XBiDMSpk9Dh+jnenVzQavriOsPwbvTTYBDJwlTsqkWJLM6YIi3W3V
	 qKtfGvNk47v/XAtSVEuNuAPMyHYK0870ujSOaTCVXTIHyP2fXC4q3s8e7k4AZPta3Z
	 ywx2mHsRg0vP1k5mmnJOPLg8LA8m9Q8EbRV04nII=
Date: Sun, 27 Apr 2025 17:18:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rppt@kernel.org,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch added to mm-unstable branch
Message-Id: <20250428001817.626D4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug_page_alloc: improve error message for invalid guardpage minorder
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/debug_page_alloc: improve error message for invalid guardpage minorder
Date: Sun, 27 Apr 2025 18:04:41 +0800

When an invalid debug_guardpage_minorder value is provided, include the
user input in the error message.  This helps users and developers diagnose
configuration issues more easily.

No functional change.

Link: https://lkml.kernel.org/r/20250427100442.958352-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug_page_alloc.c~mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder
+++ a/mm/debug_page_alloc.c
@@ -23,7 +23,7 @@ static int __init debug_guardpage_minord
 	unsigned long res;
 
 	if (kstrtoul(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
-		pr_err("Bad debug_guardpage_minorder value\n");
+		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch
fs-proc-page-refactoring-to-reduce-code-duplication.patch
mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch
mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch
mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch
mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

