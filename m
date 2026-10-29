Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300941;
	b=D3hAcPtaGmP69VU9I1xzIh2BODdc04VPxVLFZYbimN/J9lZ6LsFghCykUiYoL8vDfBRl
	 Fu5e8BkbLcg6to+gHilJbzjIcPHkSO+nQWu81IGoMX/BUu0bgkAV202D2XUIUAQQ6MWpH
	 8vuVVKU6IXC+L8UC0/hDrClEa76pC/9Tl/DgZ5W2fb/TBqUM+ia1bqg0HGSUyElez9Tfx
	 Ivs6g2lHW1D0VTgOUl2KLRZd/XLbr9cvDj28OfFesY6kyprNLSXkaui52QZaNcmZltrYF
	 bxAgqt1nuYE9vbFfZh8BBZKpPSMEC+dYfpLFqUKGy0XwN7IXqPkjSbYTjyql4Eu4nBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300941;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yb2trCfuX/TGOotvnGvabuZ75AmDMsZHqtVO48FHxgY=;
	b=TcsFGJMnKy8U3YW+OOg8n0HghaVf7GzId3UkqZ0V5hAb8il/P+UgXulyG9mRAVDNxN7G
	 Udib/qyeI6U7dWG7kSbXHr8Xm0mz3rwYl106BVNlpKfBD8bsB4VAQrCv6PocbZHlVvsJh
	 V3vyhp7Qupl1cia04JlwTdeGUFT5nAlDO0G+N5mZ+9+hmTOv7q7HuBugz9NRkkk96SXR2
	 7LWDkVTGIBMePx2NXWWqzkEHEmc8F2SiBzV88Kw086dyh1K0OeqTv35tGKnfGbUY6bMuF
	 s2Rk5uGHYwt/rBdvlCy+cPDMNB7DyA2zpfLtLXqvFBZSfBWKbjZxtuMOMkhS1etXQDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=muT0hZXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFBF606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 19:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=muT0hZXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA271F01824;
	Thu, 29 Oct 2026 19:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793300940;
	bh=yb2trCfuX/TGOotvnGvabuZ75AmDMsZHqtVO48FHxgY=;
	h=Date:To:From:Subject;
	b=muT0hZXMXyWR5W06qyF5sTc7gsiRxTYLZaAwEmVSLzflyTAghX3G346jvFDL5Q3M2
	 GeBk74Nah7iIGrcWoW54b47k00TV+ST7n6/aebwVC8SHhdAyDoipPwe2QDc15O1Hgx
	 lyvQMl1cn+GDrXFu51hDQWwH2Hd+IpRtzIFqBohg=
Date: Thu, 29 Oct 2026 12:09:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch added to mm-new branch
Message-Id: <20261029190900.6EA271F01824@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: load xfs before checking for it in run_vmtests.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch

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
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: selftests/mm: load xfs before checking for it in run_vmtests.sh
Date: Thu, 29 Oct 2026 02:24:36 -0400

run_vmtests.sh creates a loop-mounted XFS for "khugepaged all:file" and
for the pagecache folio split cases of split_huge_page_test, since
tmpfs does not give them large pagecache folios.

It only does so when xfs already shows up in /proc/filesystems. When
xfs is built as a module that is not loaded yet, the check fails, no
XFS is created, "khugepaged all:file" is reported as skipped and every
pagecache folio split case of split_huge_page_test is skipped with "No
large pagecache folio generated".

Load xfs with load_module() when it is not registered yet, so that it
is unloaded again once the script is done. Match xfs as a whole word,
as "selinuxfs" contains it too, as does "vxfs" on kernels before 7.3,
and would otherwise skip the load and leave xfs to be loaded by
mount(). "run_vmtests.sh -t thp" with xfs built as a module and not
loaded:

                                        before    after
  khugepaged all:file                  skipped      run
  skipped split_huge_page_test cases        43        0
  xfs loaded after the run                  no       no
  xfs loaded after the run, with
  selinuxfs or vxfs registered             yes       no

Link: https://lore.kernel.org/20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-2-16ad772850ee@gmail.com
Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,7 +412,7 @@ CATEGORY="thp" run_test ./khugepaged -s
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-	if grep xfs /proc/filesystems &>/dev/null; then
+	if grep -qw xfs /proc/filesystems || load_module xfs; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
 	    XFS_DIR=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}
_

Patches currently in -mm which might be from odys.yuan@gmail.com are

selftests-mm-track-the-modules-run_vmtestssh-loads.patch
selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch

