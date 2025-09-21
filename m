Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D2321D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489987; cv=none; b=drOkk5YoZLsiWFg6N7CE/tQJ51ZMR+nVCHFcOS00Wne+wAL9j0fTSv4FoVCh+w+YXaBB8/hrd0P7+lPQl7t88p2+KQLshYqtNsNR9G/jLgZWgmBo8djU3MXIQEazcPxhQ2nhgN3sasoD1fqiRkDPcRYnXg4vUh6+QLbrlsVVyT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489987; c=relaxed/simple;
	bh=YiNRr2JoMKNZrDtv36johX4T3rO5GzxUbUz/UBVFsig=;
	h=Date:To:From:Subject:Message-Id; b=HaeXVf0LFJdPCo7Y5K/J3EHQ8HWS5iWkRaFR78NhcMI16eSnNOyo5egTUdBnwXNKZ7lXU5jk8SDGfQPWsaK3DTJmS5HZiWeFQYfdrq+YVFpFlQ8GGS9pgulInxikAom5BeD8FoQJ3tQGZvB0qDgzJHWOu4eAlQvvfPw4CjK8l9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yl5QMoz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yl5QMoz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65FFC4CEE7;
	Sun, 21 Sep 2025 21:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489986;
	bh=YiNRr2JoMKNZrDtv36johX4T3rO5GzxUbUz/UBVFsig=;
	h=Date:To:From:Subject:From;
	b=yl5QMoz+8Qz3iF2kSDZbD3A02917gtb1TCeYh9ImbqWe9OcCQvguiNtOeU1Nyyk+P
	 ZnoBrv+1rrSPrcl35uPDdquiJrEZbGFPv/meMeawaJ2scqAmGwPg7xbhoE+3qeovCI
	 5tUWwHhIDN0Ft3fGepdPqkt5dO0EROv0bQPBG1U4=
Date: Sun, 21 Sep 2025 14:26:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,briannorris@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vm_event_item-explicit-include-for-thread_size.patch removed from -mm tree
Message-Id: <20250921212626.B65FFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vm_event_item: explicit #include for THREAD_SIZE
has been removed from the -mm tree.  Its filename was
     mm-vm_event_item-explicit-include-for-thread_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Norris <briannorris@chromium.org>
Subject: mm: vm_event_item: explicit #include for THREAD_SIZE
Date: Tue, 9 Sep 2025 13:13:57 -0700

This header uses THREAD_SIZE, which is provided by the thread_info.h
header but is not included in this header.  Depending on the #include
ordering in other files, this can produce preprocessor errors.

Link: https://lkml.kernel.org/r/20250909201419.827638-1-briannorris@chromium.org
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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


