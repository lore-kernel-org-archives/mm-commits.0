Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED94388E57
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 18:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782757617; cv=none; b=V//ni4/KYkYSgMeEvlKxrSbbWocLMSl7t1SoAPvNzMNSrU1CNJIHsNCtISSWRwPFkCGAnu7AJXNDFJO+BrMOeZZvjtFLjLsvzpwdNbYkzCjJK5E1lS2Jr8Vko8PnIoudxTF5ALNkslTdyOxOUJ11XkGufcMZ0FbqL+W5i3SyrZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782757617; c=relaxed/simple;
	bh=0AJ0BZXyh+7bbEkjSK/cu8fj/XFL1CYkjpZeY0OxxY8=;
	h=Date:To:From:Subject:Message-Id; b=HRFZxZ4tPF7GStU/TdawHCglB6QPr7VL4ukdKNu6jIEJjkEilOUD/r5nSpZn4nLrEaJsDyUl4QmFQMUj7K4vhJoJ8jhMlS3ZwhVdutHy/1mFebaWfm6f2+urV/E4e4OUVERvJ/jDamvhs4rRpsQgyXZ26wSLpAcqfg9qptor4ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XWCfbEVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XWCfbEVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67071F00A3D;
	Mon, 29 Jun 2026 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782757615;
	bh=0Rxc2WwlJ9SvY2RcpnqT9eGwdJxSLcZt20uf8p6KZPs=;
	h=Date:To:From:Subject;
	b=XWCfbEVedH8hyTIAVpnZC9G8ZQKEq5+wNmx02YGSR4gyN311+h0T73Edbtg/0VSeW
	 jsGzO2WUEEsy7kgFUkGP+hzfWBXjmLyZeajb+BWC9eEX0neOnXG8OckqkV20V74Xj7
	 3dHgaLtaJl8GWfEOGbey9rf7m8EFqUBvBdj/uVPY=
Date: Mon, 29 Jun 2026 11:26:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kkernel.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,doehyunbaek@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guidemm-damon-fix-damon-documentation-details.patch added to mm-new branch
Message-Id: <20260629182654.E67071F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/{admin-guide,mm}/damon: fix DAMON documentation details
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guidemm-damon-fix-damon-documentation-details.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guidemm-damon-fix-damon-documentation-details.patch

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
From: Doehyun Baek <doehyunbaek@gmail.com>
Subject: Docs/{admin-guide,mm}/damon: fix DAMON documentation details
Date: Mon, 29 Jun 2026 07:55:34 -0700

Fix minor DAMON documentation issues.  Correct the sysfs scheme file name
apply_interval_us, the DAMON_STAT module count, a malformed reference, a
misplaced label indentation, and a few typos.

Link: https://lore.kernel.org/20260629145538.134832-4-sj@kernel.org
Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Philippe Laferriere <plafer@proton.me>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SJ Park <sj@kkernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    8 ++++----
 Documentation/mm/damon/design.rst            |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guidemm-damon-fix-damon-documentation-details
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -246,7 +246,7 @@ writing to and reading from the files.
 Under ``nr_regions`` directory, two files for the lower-bound and upper-bound
 of DAMON's monitoring regions (``min`` and ``max``, respectively), which
 controls the monitoring overhead, exist.  You can set and get the values by
-writing to and rading from the files.
+writing to and reading from the files.
 
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
@@ -264,7 +264,7 @@ Please refer to  the :ref:`design docume
 <damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
 mechanism.  Reading and writing the four files under ``intervals_goal``
 directory shows and updates the tuning parameters that described in the
-:ref:design doc <damon_design_monitoring_intervals_autotuning>` with the same
+:ref:`design doc <damon_design_monitoring_intervals_autotuning>` with the same
 names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
 tuning-applied current values of the two intervals can be read from the
 ``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
@@ -377,7 +377,7 @@ schemes/<N>/
 In each scheme directory, nine directories (``access_pattern``, ``quotas``,
 ``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
 ``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
-and ``apply_interval``) exist.
+and ``apply_interval_us``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -743,7 +743,7 @@ counter).  Finally the tenth field (``X`
 (refer to :ref:`design <damon_design_age_tracking>` for more details of the
 counter).
 
-If the event was ``damon:damos_beofre_apply``, the ``perf script`` output would
+If the event was ``damon:damos_before_apply``, the ``perf script`` output would
 be somewhat like below::
 
     kdamond.0 47293 [000] 80801.060214: damon:damos_before_apply: ctx_idx=0 scheme_idx=0 target_idx=0 nr_regions=11 121932607488-135128711168: 0 136
--- a/Documentation/mm/damon/design.rst~docs-admin-guidemm-damon-fix-damon-documentation-details
+++ a/Documentation/mm/damon/design.rst
@@ -86,7 +86,7 @@ To know how user-space can do the config
 documentation.
 
 
- .. _damon_design_vaddr_target_regions_construction:
+.. _damon_design_vaddr_target_regions_construction:
 
 VMA-based Target Address Range Construction
 -------------------------------------------
@@ -930,11 +930,11 @@ control parameters for the usage would a
 purpose.
 
 To support such cases, yet more DAMON API user kernel modules that provide more
-simple and optimized user space interfaces are available.  Currently, two
-modules for proactive reclamation and LRU lists manipulation are provided.  For
-more detail, please read the usage documents for those
-(:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
-:doc:`/admin-guide/mm/damon/lru_sort`).
+simple and optimized user space interfaces are available.  Currently, three
+modules for access monitoring statistics, proactive reclamation, and LRU lists
+manipulation are provided.  For more detail, please read the usage documents for
+those (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim`
+and :doc:`/admin-guide/mm/damon/lru_sort`).
 
 .. _damon_design_special_purpose_modules_exclusivity:
 
_

Patches currently in -mm which might be from doehyunbaek@gmail.com are

docs-admin-guidemm-damon-fix-damon-documentation-details.patch

