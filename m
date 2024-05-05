Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5727604F
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942880; cv=none; b=G9/HvHnAdJjIO66qjEf5CWyUKgPFPoqbnyfacRoaiZKuZ7iGSBXkMJ0b59CMsH7L7NPf+hfuvJ8H9iwmZyDRZ7zA797rdoEptYVcWuPt+xkWZ96a/BGgE9fQ2+uXIF+FglnDSpYYvooD8rBYrrFTvddFykxelsCUIyGVurUzFoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942880; c=relaxed/simple;
	bh=4AtROHZ7Id/b3ivUN5+IVPOzAM4F+isU/LUEuLOXRD0=;
	h=Date:To:From:Subject:Message-Id; b=dKqtromd7j5Uug4OVNrdpAvxqCZ52z4x7yjmVogYYSqSTL52DWC7D9aRbDTfJ1OG7pPoLukdRUn1Enpy1IieO+OMKguhH+dH6x7b95wESR9cbe5CRsYbFbU3pcaY4/SR52YTfC/6OgvjowqZwd5QvTvxYOtkUsSmBHrku1ujX14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i4W2Sl3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i4W2Sl3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E71FC113CC;
	Sun,  5 May 2024 21:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942880;
	bh=4AtROHZ7Id/b3ivUN5+IVPOzAM4F+isU/LUEuLOXRD0=;
	h=Date:To:From:Subject:From;
	b=i4W2Sl3mj62ryKtgGg31MXRkCB+KciQvHmdPJPHeU1EaagCFt2wqqwapkpWvutVQx
	 +YmsbIccy3VXx2sOybbeU9K2s3DGBQQD5c/gICoUIedRN7J3Bf0PTHXdymlejXeMj/
	 cceex+oe9yNZty/heyslYjAxISxl2FkE9axoRoJs=
Date: Sun, 05 May 2024 14:01:19 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch added to mm-unstable branch
Message-Id: <20240505210120.1E71FC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: check errors from nr_schemes file reads
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: check errors from nr_schemes file reads
Date: Fri, 3 May 2024 11:03:10 -0700

DAMON context staging method in _damon_sysfs.py is not checking the
returned error from nr_schemes file read.  Check it.

Link: https://lkml.kernel.org/r/20240503180318.72798-3-sj@kernel.org
Fixes: f5f0e5a2bef9 ("selftests/damon/_damon_sysfs: implement kdamonds start function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -341,6 +341,8 @@ class DamonCtx:
         nr_schemes_file = os.path.join(
                 self.sysfs_dir(), 'schemes', 'nr_schemes')
         content, err = read_file(nr_schemes_file)
+        if err is not None:
+            return err
         if int(content) != len(self.schemes):
             err = write_file(nr_schemes_file, '%d' % len(self.schemes))
             if err != None:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch
selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

