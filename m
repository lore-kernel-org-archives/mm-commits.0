Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A607F266EFC
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757462116; cv=none; b=pdTWOSEScsYRt3o72qsm5YZ9ESc+/Y9GwFovqqDAsRRFb0uAAGbAAH91bLAW5+GpSR+Bl5It/SFSD5V2carIJDrtf2ShvROs6SUz2/5pR8QRQu1iaF7/3zD8GTDSMoRqHqDbhFQARRwGuRz+GcC4G6ROT4Mi5icV3j5iYN8tgZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757462116; c=relaxed/simple;
	bh=YBKwYwpDrp6c7Bo8WAmupOjZvyIh8kboRGbZKBHbKvk=;
	h=Date:To:From:Subject:Message-Id; b=iM2iNMgguUnuqdwqhNo+VhfgD8a1znJXCNpDpIIBQ0wolIHTwj05Qlox+CUbatfN/S9Q8wuCJu0s7KGB7NJkTXmTAa3DgOTDm4ni+J/cF2wgIVIlyso/H2HWhTvgLnpsSv4Hlfa7yiA0vYSGa+aTfOtjytA/924F9AmKpZtFlS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXcTKyWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXcTKyWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D2BC4CEF4;
	Tue,  9 Sep 2025 23:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757462116;
	bh=YBKwYwpDrp6c7Bo8WAmupOjZvyIh8kboRGbZKBHbKvk=;
	h=Date:To:From:Subject:From;
	b=IXcTKyWG0Xo2J9TrNHRvdaKWU477Psnzttn5ZWN6D2XIrnT5PVWzpnTtAT6e4ZIaK
	 dye02AlmvWXAEPRJDuzTVyhWrNSZR7exw5glYe+gDzRtI2PkMf1LdyaO0CmNYBgtiz
	 pYw599fv6BvqLeZ2nX9YIbGv7ZMogQDwkGd1bsHU=
Date: Tue, 09 Sep 2025 16:55:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,briannorris@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vm_event_item-explicit-include-for-thread_size.patch added to mm-new branch
Message-Id: <20250909235516.18D2BC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vm_event_item: explicit #include for THREAD_SIZE
has been added to the -mm mm-new branch.  Its filename is
     mm-vm_event_item-explicit-include-for-thread_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vm_event_item-explicit-include-for-thread_size.patch

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
From: Brian Norris <briannorris@chromium.org>
Subject: mm: vm_event_item: explicit #include for THREAD_SIZE
Date: Tue, 9 Sep 2025 13:13:57 -0700

This header uses THREAD_SIZE, which is provided by the thread_info.h
header but is not included in this header.  Depending on the #include
ordering in other files, this can produce preprocessor errors.

Link: https://lkml.kernel.org/r/20250909201419.827638-1-briannorris@chromium.org
Signed-off-by: Brian Norris <briannorris@chromium.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/vm_event_item.h~mm-vm_event_item-explicit-include-for-thread_size
+++ a/include/linux/vm_event_item.h
@@ -2,6 +2,8 @@
 #ifndef VM_EVENT_ITEM_H_INCLUDED
 #define VM_EVENT_ITEM_H_INCLUDED
 
+#include <linux/thread_info.h>
+
 #ifdef CONFIG_ZONE_DMA
 #define DMA_ZONE(xx) xx##_DMA,
 #else
_

Patches currently in -mm which might be from briannorris@chromium.org are

mm-vm_event_item-explicit-include-for-thread_size.patch

