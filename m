Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE30726E15F
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 22:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756420835; cv=none; b=qzRwY378o587IaBIU9muBoTpWiGtg/93B8iQuWWmu/mnDbNzUSLGUc2kUrqX/t3NAc3FdMJ0y4g3ThMcj57h2qjl7VIY9LvBeIYQJ7q27xOaKB6VodQgW/C8BJW8+2yAoJebMvb0/66xNk9SL7J/AXctG0AS8SVch613nF0bFcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756420835; c=relaxed/simple;
	bh=jNRb9VA6l4mDj1sQM+3/OqX/wWcR1mvQ0O26FF8FxY8=;
	h=Date:To:From:Subject:Message-Id; b=YyM+r7uinc7k+jt2ocZUo/wDuKUQPepLJECrIpB20fgRY9z8HlsQHycqM1jArIan1YFuHF6q94lI+H235VskDQeYmjCEp2ktwnXS+ymuvRNym0Dsz7aBfsGQ1Pi1Esxz/OvUEAuBTlpWw4N8jgkKIXw37du7jOAiMwHS1Gq0h7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzJtTQrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzJtTQrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B165C4CEEB;
	Thu, 28 Aug 2025 22:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756420835;
	bh=jNRb9VA6l4mDj1sQM+3/OqX/wWcR1mvQ0O26FF8FxY8=;
	h=Date:To:From:Subject:From;
	b=fzJtTQrKcOCrs5wZPyKnlg8lZouTNn1AXE4Yvo7m1YHocrE8+eKjy+/rtGIfCFoM9
	 h48mE5TQ0ne79bNCuJ7IUUeFseppGwbIa90PUjvwaT0XzTmBIF7OVVYcmDyZQ369uy
	 lXCDFUFpo1TKff7YWyfV6uJtbsdd2Xs0sAM3zAAk=
Date: Thu, 28 Aug 2025 15:40:34 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch added to mm-new branch
Message-Id: <20250828224035.5B165C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document addr_unit file
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Thu, 28 Aug 2025 10:12:40 -0700

Document addr_unit DAMON sysfs file on DAMON usage document.

Link: https://lkml.kernel.org/r/20250828171242.59810-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   11 +++++++----
 Documentation/mm/damon/design.rst            |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-addr_unit-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -61,7 +61,7 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -188,9 +188,9 @@ details).  At the moment, only one conte
 contexts/<N>/
 -------------
 
-In each context directory, two files (``avail_operations`` and ``operations``)
-and three directories (``monitoring_attrs``, ``targets``, and ``schemes``)
-exist.
+In each context directory, three files (``avail_operations``, ``operations``
+and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
+and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -205,6 +205,9 @@ You can set and get what type of monitor
 context by writing one of the keywords listed in ``avail_operations`` file and
 reading from the ``operations`` file.
 
+``addr_unit`` file is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the operations set.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-document-addr_unit-file
+++ a/Documentation/mm/damon/design.rst
@@ -135,6 +135,8 @@ the interference is the responsibility o
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+.. _damon_design_addr_unit:
+
 Address Unit
 ------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

