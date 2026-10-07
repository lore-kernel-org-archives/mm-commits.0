Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EA2931CE
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334134; cv=none; b=paEEffZkBNfWkhPCtZtiLpPiGFtV58UFfDGkzLTB+PjRmw1bpBLFsxvAIsV5nETX8p05vcDZ5EdtKQcQq/LPTtChEeG5/rnZpslvAo+N2ISo+EFL6OleYYcmYSUrI2mXtPcGYgccR23Fmayz+LMbJgjQI+k25AMj4o1O4dW2ecs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334134; c=relaxed/simple;
	bh=a8gEUcfMlY1nNdyzc3SVSrhew3WpBYuf0WBAhTpH/FU=;
	h=Date:To:From:Subject:Message-Id; b=K2zgJfMTpCH2aa830Q+HHtxLTIyZfq9+5a+sI9mSOhBJ3oiR7x8NmZbNjvEVwr/YnQmixTwrdnHGsPUIJirHi5Y06XYzunoRuTIGZPBhUFwKW0MhXtiNPW3GSFfM9Phl98vk9ijPsUCyJ9z6VGKCMyoecrCz/JeqKmiwSMBVntI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CJrg7SIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CJrg7SIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664921F0089C;
	Wed,  7 Oct 2026 00:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334133;
	bh=3q+QuzmoLbM+ZgUGrF/BF523iaIq0cK46EQDbuNrC8s=;
	h=Date:To:From:Subject;
	b=CJrg7SIj6yU9dkT4OnFajdeaDdq1X6FBpPyXN6c1PdaXfpKbdp0f6uvStnKQ5KqV1
	 +SblVKfS1A5y7aQ4siD+ugcQYw62177+nQGqrzWHUCrwPInvlhp0iD8Vmo+ftUZUiX
	 ImmOoO4GC7vUSAGgsuDnCxALAPWNbpc8MDeNbOgU=
Date: Tue, 06 Oct 2026 17:48:53 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,shr@devkernel.io,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-fix-advisor_min_pages_to_scan-description.patch removed from -mm tree
Message-Id: <20261007004853.664921F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix advisor_min_pages_to_scan description
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-advisor_min_pages_to_scan-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/ksm: fix advisor_min_pages_to_scan description
Date: Mon, 24 Aug 2026 14:10:10 +0800

Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
lower limit of the pages_to_scan parameter, but that is not how the
scan-time advisor actually uses it.  commit 4e5fa4f5eff6 ("mm/ksm: add ksm
advisor") only uses it to initialize ksm_thread_pages_to_scan when the
scan-time advisor is enabled.

ksm_thread_pages_to_scan is adjusted by scan_time_advisor() after a full
scan finishes.  ksm_thread_pages_to_scan could be increased or decreased
depend on the real scan time is longer or shorter than the target scan
time.  The min value of ksm_thread_pages_to_scan is only limited by
KSM_ADVISOR_MIN_CPU, so ksm_thread_pages_to_scan could be smaller than
ksm_advisor_min_pages_to_scan.

The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
[1], but the documentation wasn't updated.

Update the documentation and comment to match the semantics of
advisor_min_pages_to_scan.

Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
Link: https://lore.kernel.org/20260824061010.3343959-3-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/admin-guide/mm/ksm.rst |    4 ++--
 mm/ksm.c                             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-fix-advisor_min_pages_to_scan-description
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -183,8 +183,8 @@ advisor_target_scan_time
         pages. The default value is 200 seconds.
 
 advisor_min_pages_to_scan
-        specifies the lower limit of the ``pages_to_scan`` parameter of the
-        scan time advisor. The default is 500.
+        specifies the initial value of the ``pages_to_scan`` parameter of
+        the scan time advisor. The default is 500.
 
 advisor_max_pages_to_scan
         specifies the upper limit of the ``pages_to_scan`` parameter of the
--- a/mm/ksm.c~mm-ksm-fix-advisor_min_pages_to_scan-description
+++ a/mm/ksm.c
@@ -348,7 +348,7 @@ static enum ksm_advisor_type ksm_advisor
  * Only called through the sysfs control interface:
  */
 
-/* At least scan this many pages per batch. */
+/* Initial number of pages to scan per batch. */
 static unsigned long ksm_advisor_min_pages_to_scan = 500;
 
 static void set_advisor_defaults(void)
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


