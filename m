Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B730AABE
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 18:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774031580; cv=none; b=miF87XLcNiCU2n8DTcYsFyJPbsFZu3Zl1ikJcpZ/WDzXWbB99goPrAREOMoyOgOMXID0GV9yegXc0WqEg8Ti4QlcSPAqsAqQ7w96+zISSc3F3MOIGad5uH99KEP+ghn/+E2JBfPFED1QPsNcqRascsSlI42P5kCxPgCTJ6TGgGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774031580; c=relaxed/simple;
	bh=D0rZ4nZ/vLSi/jqJHyYi7XCYR8IrkkRGGuNtLwWQ7BE=;
	h=Date:To:From:Subject:Message-Id; b=P+lmY2N1vBzaBg7k3AvIwPInSrM0DEh1Pfr+PwFlyxDl6MqEuCSLHev8lp5pfrnoD6DP6Wyl5bnm1PbKQxoVVJ35DldsIkDFZO41BIPgnVXKGF2Is5I1GP/OjUuzZOV2AlcQA6QAU7xAqyW0ennAtlYXEp6/NXQYhN+giyPqbeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wR98cKsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wR98cKsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B154C4CEF7;
	Fri, 20 Mar 2026 18:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774031579;
	bh=D0rZ4nZ/vLSi/jqJHyYi7XCYR8IrkkRGGuNtLwWQ7BE=;
	h=Date:To:From:Subject:From;
	b=wR98cKsm4tOdBblipFbwExVX4VgaN3I6C25dFrvOMnJwJIwa2POdfB2t69qtZnuzb
	 S8yYc10kPWpDPZN7nzOR797KXbbA4GqKc6hDUeQ73F0ht30j2p6ZtArYOE6WRNiKid
	 7OBbMRYL2uOK2BruXxGXX8do6wkIA2k3IOFYJWCg=
Date: Fri, 20 Mar 2026 11:32:59 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch added to mm-new branch
Message-Id: <20260320183259.9B154C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix
Date: Fri, 20 Mar 2026 13:56:04 -0400

update .gitignore, per Lorenzo

Link: https://lkml.kernel.org/r/D60C0C65-11E3-4060-9295-B67F90E9D774@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -61,3 +61,4 @@ guard-regions
 merge
 prctl_thp_disable
 rmap
+folio_split_race_test
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-add-folio_split-and-filemap_get_entry-race-test.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch

