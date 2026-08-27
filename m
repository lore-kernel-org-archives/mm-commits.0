Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A44E36897F
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 03:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787803007; cv=none; b=Cr4a4Mzd4RFZv1wnN0tZFTEbkce1TNQxB7ki96PgKMpgVISpGFCnugxWwyB39RNIhDgaxOltjfEmKHAjOV6R3Dk0QchY+uATWwqTi9130U24ivorF0h+whGRq9XdiBBFgOxYPDqmN3i8XgCiddQfhhFkk5+7szqaJlFuzW9CBgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787803007; c=relaxed/simple;
	bh=siZ+XiiRfACYkcdhmLU0dlMj4sfEhANo5RGOymjYS+Q=;
	h=Date:To:From:Subject:Message-Id; b=MKO4XqveRP2fWgdcjLC4O/Ff13oFaG4ULMOXbvDCfoRsrkQroLgkjjNMHE65XzMjdIA3XBk5QZpM6CLSpOa6oC4yETpsx63FR2FZ/KEvoLlxIr9xOcyJ7En+5awjTLYZ/99MK/nEGIVxIUuFwrCwdBEZ8mpeWjmkobysnxHI4WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LsrREkib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LsrREkib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4C11F000E9;
	Thu, 27 Aug 2026 03:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787803005;
	bh=X6lLgAmc+wh6MDcmHxBuVYZdPoVoxF11MnUnUY0sjNw=;
	h=Date:To:From:Subject;
	b=LsrREkibnfB6onAwt7tGv41unrjAQSa3TW5HbUYyHCVF+qVRazpQ8DAjCDafUJ6bq
	 jp1wH0mVvRa4qFU+6hsJBLtA7sUpo6KtB+6CBQ1oj5b+gGrZIYvCxAT+vjCtkQyNJO
	 iFG0XLvhBR7m9FAhZ+/8FoJUW5IjvI+AkGQxshZA=
Date: Wed, 26 Aug 2026 20:56:45 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,shr@devkernel.io,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-ksm-fix-typos-in-sysfs-knob-names.patch added to mm-new branch
Message-Id: <20260827035645.AB4C11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: ksm: fix typos in sysfs knob names
has been added to the -mm mm-new branch.  Its filename is
     docs-ksm-fix-typos-in-sysfs-knob-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-ksm-fix-typos-in-sysfs-knob-names.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

docs-ksm-fix-typos-in-sysfs-knob-names.patch
mm-ksm-fix-advisor_min_pages_to_scan-description.patch

