Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4717736897F
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 03:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787803009; cv=none; b=IbHWpB7AwkNunnNA1pCFH4DOS/d1uaxnGmZCmmrM32sFt9VQASdL0NH+h4oEEyFxBWXshh2dFmmOMfXOzRACmRzo9vikGAyhOKLmc6Wahqg6zet36CADv8c1P1RIdWlHKR4kDsrCOqmm9PmuZ+3dENPfmFSG858ZZtBzROVv2s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787803009; c=relaxed/simple;
	bh=ZZ8CoaMlJX+rMOnYt5TrX4ssesLwIfWLbfG+x6Qmc+U=;
	h=Date:To:From:Subject:Message-Id; b=E1TFIh74CJNUmOuBnC/WmA5fGfWcbxl7N9Ba3ck2TA8ABE+OSSqD12ccYPXhAxVBIG8e183TDQ4+36ZG5JsWWIFx+e49HNyKAe2m/k4QPwdCCdrl1Ov1PvDFQAhqKwQeKGvIw2iZA/FlpjF+730i2FeAMwsSgRViZqoTNwleBsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TQ9Q5r65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TQ9Q5r65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FEC1F000E9;
	Thu, 27 Aug 2026 03:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787803007;
	bh=eMG7rKt+Xm+df1LwuSpgJccLQKl9RmXJ7zT15y/vuE0=;
	h=Date:To:From:Subject;
	b=TQ9Q5r65/tOgtPgUgRzDHPTnFsX7VuYjwAfGVc3ucD3HYP3mCEF/o3YE0ZKbGzOnq
	 vPV4u2VQS9qEZ80msFFQDa4Pb56mArp5V2DczFIR9zNkRui4IwTvLvdA7g4kzkgQPP
	 i0+xU6OebFKapkS8UeitCL6PXN6mgL4yjY9ZZnjk=
Date: Wed, 26 Aug 2026 20:56:47 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,shr@devkernel.io,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-advisor_min_pages_to_scan-description.patch added to mm-new branch
Message-Id: <20260827035647.B7FEC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix advisor_min_pages_to_scan description
has been added to the -mm mm-new branch.  Its filename is
     mm-ksm-fix-advisor_min_pages_to_scan-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-advisor_min_pages_to_scan-description.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

docs-ksm-fix-typos-in-sysfs-knob-names.patch
mm-ksm-fix-advisor_min_pages_to_scan-description.patch

