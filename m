Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51EA1C69D
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787891178; cv=none; b=MjKRmdJsmRT394prJi3NEzMTOYwRiPAcNUIvl1Cryi4jRaaxd3UobMM4LzuRU0VPGtaIlhTS2qPZlr6z0AK27It6OdBvir79RQSUMoZSVn2nzvC+gce9H3L7Oijw2bqKxza1Tqx8AtfDrQBlJhUZiMVBmRQacoTRNJXHfs8+N10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787891178; c=relaxed/simple;
	bh=sDDqInxNvPKLxhEUwN4ci8cp1GVhm4tM2a/6GUk97cE=;
	h=Date:To:From:Subject:Message-Id; b=iGK8kIgc6CzUCjCfJyNgye7gUrDr1XtWzGXw431n1O1/zUfgy54BkwokflMn1Y9oAlefXbuy+ABHohS408w4EMBlG1OARJauBPW2eluLCm3pRz5DH6sCprb9d+mqCPL0+FpPhIK4HcFJ5g2HrjX0lOxvf6vKPYbaLtF2btDt4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nW1S3D6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nW1S3D6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140821F000E9;
	Fri, 28 Aug 2026 04:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787891177;
	bh=7aC4/mtMu6RHUW+sqIIaJmVKi/jJUEYZMxhBD6DVUzM=;
	h=Date:To:From:Subject;
	b=nW1S3D6dtnkq+k0bvDZjPBh8NWK2u8sosDltGbDBFIUaUwJ27Z6+wPRC6419LYcGL
	 gNCNANWP8CGMxhz9hcnUSsfpn8bFvXNr72L3xXMgDv4+2A1lGVf8fpn0vIkSJVI0os
	 dEb5ZkqOUjxBRsIPICy85OeaKHGcWWwF7MtTy1kQ=
Date: Thu, 27 Aug 2026 21:26:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch added to mm-new branch
Message-Id: <20260828042617.140821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: emit TAP header in uffd-wp-mremap
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch

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
From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: emit TAP header in uffd-wp-mremap
Date: Tue, 25 Aug 2026 16:57:54 +0800

Patch series "selftests/mm: TAP output and global-state fixes", v4.

uffd-wp-mremap and mremap_test never print the TAP header (and mremap_test
skips with a bare exit(KSFT_SKIP) rather than a KTAP skip), so their
output is not valid KTAP; hugetlb-soft-offline toggles enable_soft_offline
during the run and leaves it disabled afterwards.


This patch (of 3):

uffd-wp-mremap calls ksft_set_plan() without ksft_print_header(), so its
output is not valid KTAP.  Add the header, like the sibling uffd tests
(uffd-stress, uffd-unit-tests).

Link: https://lore.kernel.org/20260825085756.63030-1-husong@kylinos.cn
Link: https://lore.kernel.org/20260825085756.63030-2-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-wp-mremap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-emit-tap-header-in-uffd-wp-mremap
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -347,6 +347,8 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	ksft_print_header();
+
 	hugepage_save_settings(true, true);
 
 	check_uffd_wp_feature_supported();
_

Patches currently in -mm which might be from husong@kylinos.cn are

selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch
selftests-mm-emit-tap-header-and-use-tap-skip-in-mremap_test.patch
selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch

