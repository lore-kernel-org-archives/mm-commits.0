Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B5628686
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334133; cv=none; b=qUvrL3CJUbwgvzeOwcDUqwba5iEKPLRuyPrcnaOTs00onPsnPBpPvDxO20USOoaBQvs87ag62//+Odc/Yq+EH4NeO5+bckKyXhKdjVcH+RGqjXmzjJKo9Nar7CPXrRAtdX0V9Nyk+nuni8XXdVLzhYEpjtRkAPyhrfE1Ch7tLbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334133; c=relaxed/simple;
	bh=TAWzud39GSt/EXgJ7eiLE2KBVrIhMOsokwlmobAmVXk=;
	h=Date:To:From:Subject:Message-Id; b=D7p22mnTK/fILx1KzHer4cPcQeROwk1oTt7RTEKFPgg5e/adYEWEB3yt206vGlHXy3OIrjH5P0i9Rht5DdIax+CpRPO4TLhqgXdxRcUb3/O/W8YmgFdA0tIjG45T6eRRYf0Snh4DcopB6oqjTY4LnJZOqLhB4bnBY1qXcliXjx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6EMfjax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6EMfjax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502761F0089B;
	Wed,  7 Oct 2026 00:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334132;
	bh=plCM+FxsAmXtVpyQvzRO+Mq3/QqEh3pQFZ9TFVAl0zc=;
	h=Date:To:From:Subject;
	b=f6EMfjaxyWm9daLhQyqJRuYcQS5ZU1U6Nwzo5i2lSSI7B3dnLG+vVvgR+T6AltcYY
	 L3qaB3/abTwnIH07fjd0HhROQ5L/vu3yQ7EoK94mwOwUkO9tvoMHmbh+AeQQ3R8ATe
	 TzS+C9pxCmbBpd8QlIldvx5Te5lWupk8Iy/uFRQo=
Date: Tue, 06 Oct 2026 17:48:51 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,shr@devkernel.io,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-ksm-fix-typos-in-sysfs-knob-names.patch removed from -mm tree
Message-Id: <20261007004852.502761F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: ksm: fix typos in sysfs knob names
has been removed from the -mm tree.  Its filename was
     docs-ksm-fix-typos-in-sysfs-knob-names.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: docs: ksm: fix typos in sysfs knob names
Date: Mon, 24 Aug 2026 14:10:09 +0800

Patch series "docs/ksm: fix advisor documentation and comment", v3.

This series fixes two problems left in the KSM advisor documentation
and code comment:
 - Patch 1 fixes two typos in sysfs knob names ("adivsor_max_cpu" and
   "adivsor_max_pages_to_scan") in ksm.rst that don't match the actual
  knob names.
 - Patch 2 fixes the description of advisor_min_pages_to_scan: it is
   described as the lower limit of pages_to_scan, but is actually only
   used as it's initial value, and the runtime pages_to_scan can drop
   below advisor_min_pages_to_scan.


This patch (of 2):

The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
"advisor_max_pages_to_scan", but the ksm.rst documentation spelled both as
"adivsor_*", fix the two typos.

Link: https://lore.kernel.org/20260824061010.3343959-1-tujinjiang@huawei.com
Link: https://lore.kernel.org/20260824061010.3343959-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
---

 Documentation/admin-guide/mm/ksm.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/ksm.rst~docs-ksm-fix-typos-in-sysfs-knob-names
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -174,7 +174,7 @@ advisor_mode
         The section about ``advisor`` explains in detail how the scan time
         advisor works.
 
-adivsor_max_cpu
+advisor_max_cpu
         specifies the upper limit of the cpu percent usage of the ksmd
         background thread. The default is 70.
 
@@ -186,7 +186,7 @@ advisor_min_pages_to_scan
         specifies the lower limit of the ``pages_to_scan`` parameter of the
         scan time advisor. The default is 500.
 
-adivsor_max_pages_to_scan
+advisor_max_pages_to_scan
         specifies the upper limit of the ``pages_to_scan`` parameter of the
         scan time advisor. The default is 30000.
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


