Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FDC255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744915; cv=none; b=YpfKVBbL+58dSsP3Authn7TNQrAFNINRTnnsR1dWVmyy15//jSATAGv5O5de0Wu2MdUwRGNysokLBCAHJP0t89CwAexy4BSyDZX3Knx0uO2TgG5iNVxM2Fs/icbWdwYke4cfh7KzU/OmlEz2HMUm7nae1aiXoRvyD7VHzLDJYnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744915; c=relaxed/simple;
	bh=hLEXj43wYh77gsCp7fFrbPRJ6meedkMYRFzt32B+unU=;
	h=Date:To:From:Subject:Message-Id; b=Y3RxdPTjMIhqM7HfTzDEcWP9XRaReZ2kH/6I8Fs+ESYR9GDspl+1GvklwPP8vs/5A1cDG5yqpn5r/30VQg/2hgFD/691YM9KI8fOFp2Hh8orKBtDgR6X4T/QOE5goST8FGnMxMrY/9tG7WGEx/sd1mCaxWr7XfrJyFjN98svM9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPnCUtjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPnCUtjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A992C4CEF7;
	Sun, 29 Mar 2026 00:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744915;
	bh=hLEXj43wYh77gsCp7fFrbPRJ6meedkMYRFzt32B+unU=;
	h=Date:To:From:Subject:From;
	b=YPnCUtjKx5HWgDUJwRtevaSloz/L4joxxQl5bPtwNQMoekQx2vzLz76p/XPvwZRDo
	 cDvRjS/+QvV0rNRdWxasIV2po0EMoTQhe78PVK5R2afDto5lBLvBM98qPI6APtS1tp
	 V2+ZN/b0qf41d5n1dIPVU8KA5hgp1yMK/fna8YB4=
Date: Sat, 28 Mar 2026 17:41:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-document-exclusivity-of-special-purpose-modules.patch removed from -mm tree
Message-Id: <20260329004155.7A992C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon: document exclusivity of special-purpose modules
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-document-exclusivity-of-special-purpose-modules.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: Docs/mm/damon: document exclusivity of special-purpose modules
Date: Sun, 15 Mar 2026 09:29:44 -0700

Add a section in design.rst to explain that DAMON special-purpose kernel
modules (LRU_SORT, RECLAIM, STAT) run in an exclusive manner and return
-EBUSY if another is already running.

Update lru_sort.rst, reclaim.rst and stat.rst by adding cross-references
to this exclusivity rule at the end of their respective Example sections.

This change is motivated from another discussion [1].

Link: https://lkml.kernel.org/r/20260315162945.80994-1-sj@kernel.org
Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t [1]
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    5 +++++
 Documentation/admin-guide/mm/damon/reclaim.rst  |    5 +++++
 Documentation/admin-guide/mm/damon/stat.rst     |    5 +++++
 Documentation/mm/damon/design.rst               |    4 ++++
 4 files changed, 19 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -351,3 +351,8 @@ the LRU-list based page granularity recl
     # echo 400 > wmarks_mid
     # echo 200 > wmarks_low
     # echo Y > enabled
+
+Note that this module (damon_lru_sort) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -318,6 +318,11 @@ granularity reclamation. ::
     # echo 200 > wmarks_low
     # echo Y > enabled
 
+Note that this module (damon_reclaim) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. [1] https://research.google/pubs/pub48551/
 .. [2] https://lwn.net/Articles/787611/
 .. [3] https://www.kernel.org/doc/html/latest/mm/free_page_reporting.html
--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -45,6 +45,11 @@ You can enable DAMON_STAT by setting the
 Setting it as ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
+Note that this module (damon_stat) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. _damon_stat_aggr_interval_us:
 
 aggr_interval_us
--- a/Documentation/mm/damon/design.rst~docs-mm-damon-document-exclusivity-of-special-purpose-modules
+++ a/Documentation/mm/damon/design.rst
@@ -853,6 +853,10 @@ more detail, please read the usage docum
 (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
 
+.. _damon_design_special_purpose_modules_exclusivity:
+
+Note that these modules currently run in an exclusive manner.  If one of those
+is already running, others will return ``-EBUSY`` upon start requests.
 
 Sample DAMON Modules
 --------------------
_

Patches currently in -mm which might be from aethernet65535@gmail.com are


