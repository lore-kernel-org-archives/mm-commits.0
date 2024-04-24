Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A26745CB
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713993018; cv=none; b=o+ymcKoBXeH0Bzf2Q6YFScJo79Z3pNeoD9kw2HpF3SgwV39iiUbCjOapUAU/FK+sw6pkibiiDwPV3+ZTPe+aTJQLJ2wfh6wroNAzRIuuvcHFhDikQ5qtcke32Or1NEhP/UAs+tmIVQo6Ne1nxg/yNnzDANiPd9Hmk5A0ptZyMmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713993018; c=relaxed/simple;
	bh=i9+JEMdvc0KOXCn/4YuyDRUqBIrIkaT701RgioJYtEk=;
	h=Date:To:From:Subject:Message-Id; b=TiSmwBpN4D/RwnDiSsYZHpgnQsdfneAkGCONjKmLzJSSWgz4sDHUuVPq47UCkqV1vNOq/1rhPngStLq3P3q0uj6OsYU7aV3vHterwzP2ig74xgLNyxcpNurT4RO4X1X3h/YzhUgcDSE419ICuOZ0tIkh3qOm4W8sJLoRg+ieHpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XlMO/XVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XlMO/XVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F43DC113CD;
	Wed, 24 Apr 2024 21:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713993017;
	bh=i9+JEMdvc0KOXCn/4YuyDRUqBIrIkaT701RgioJYtEk=;
	h=Date:To:From:Subject:From;
	b=XlMO/XVKsMfd1/X5ZhfDFZzXe5FJTpq9PRYSUbS2DFWFykTrDBXjB5Hzu16JlN4Ak
	 bYQQz+QvIRbqEGEiw7O7MqBEEqaRmR6Ct/8VWqwcwgCpTgEXAgb4YYcMGPa0OrecH+
	 ZcGnXYY44/B/b2/mzvVxHOHaWmz1DPry99W6Cz2I=
Date: Wed, 24 Apr 2024 14:10:16 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch added to mm-unstable branch
Message-Id: <20240424211017.7F43DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: soft-dirty should fail if a testcase fails
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: soft-dirty should fail if a testcase fails
Date: Wed, 24 Apr 2024 11:53:01 +0100

Previously soft-dirty was unconditionally exiting with success, even if
one of its testcases failed.  Let's fix that so that failure can be
reported to automated systems properly.

Link: https://lkml.kernel.org/r/20240424105301.3157695-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/soft-dirty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-soft-dirty-should-fail-if-a-testcase-fails
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -209,5 +209,5 @@ int main(int argc, char **argv)
 
 	close(pagemap_fd);
 
-	return ksft_exit_pass();
+	ksft_finished();
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache-fix.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-update-get_swap_pages-to-take-folio-order.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch
selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch

