Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C30236A73
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773086657; cv=none; b=Mus9oEYUDkPdyrLWeSEdNXHzBXNADhgDzuskhS+zI0ErwaRgJIag9Q6yPip84cZFTRV5F2mWcC4QOPpnCqdLmEMsDgvd/KwYohbHblC1z6rTvbBt3s3PWLeC6E/2rBGZbawvrBNZ0vH0wvMvPL4vl78jFdiK3eEmCqnAQtBM/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773086657; c=relaxed/simple;
	bh=WoqhRBjyTFDBV3JQigOuAAPmsrirPvwDjifkqenz7lQ=;
	h=Date:To:From:Subject:Message-Id; b=TS4oy6tXKmwv83mnSJie6ZksrnzTF7J1Mf1Sl2ifZdZClbZ8W+3jbx7i0W9MySi1hCYoAoZrq2MFn3IWyrqup4/4yVnhGK/qyE4iTBwxqXR7GBRFtAkVN1BRmfxpik6Dd6Fpi4AMiybOb6utvZZQ++XCU2wA3CRCH7Jzuh4urqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k9UVJblQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k9UVJblQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622B6C4CEF7;
	Mon,  9 Mar 2026 20:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773086656;
	bh=WoqhRBjyTFDBV3JQigOuAAPmsrirPvwDjifkqenz7lQ=;
	h=Date:To:From:Subject:From;
	b=k9UVJblQP0InzUjW+FO4amZJyumaVhlQfNygWBAvtsSjTeHNp+fpsUxWVsbWt9V58
	 Adl/JqzBhgEFrnLCkvpnrXA05OeD1frnfKw4Va9noC5yRjhwPvZ9fYIfWHhSaYTt4X
	 K4N2z23Ih98tGmDWCCF6buoDrvPXltns7Iz+MM0g=
Date: Mon, 09 Mar 2026 13:04:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-export-set_recommended_min_free_kbytes.patch added to mm-new branch
Message-Id: <20260309200416.622B6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: export set_recommended_min_free_kbytes()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-export-set_recommended_min_free_kbytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-export-set_recommended_min_free_kbytes.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: khugepaged: export set_recommended_min_free_kbytes()
Date: Mon, 09 Mar 2026 04:07:30 -0700

Patch series "mm: thp: reduce unnecessary start_stop_khugepaged()", v4.

Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
start_stop_khugepaged() called independent of any change. 
start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
exact same message, even when nothing changes.

For instance, if you have a custom vm.min_free_kbytes, just touching
/sys/kernel/mm/transparent_hugepage/enabled causes a printk message. 
Example:

      # sysctl -w vm.min_free_kbytes=112382
      # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done

and you have 100 WARN messages like the following, which is pretty dull:

      khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred

A similar message shows up when setting thp to "always":

      # for i in $(seq 100); do
      #       echo 1024 > /proc/sys/vm/min_free_kbytes
      #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
      # done

And then, we have 100 messages like:

      khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations

This is more common when you have a configuration management system that
writes the THP configuration without an extra read, assuming that nothing
will happen if there is no change in the configuration, but it prints
these annoying messages.

For instance, at Meta's fleet, ~10K servers were producing 3.5M of these
messages per day.

Fix this by making the sysfs _store helpers easier to digest and
ratelimiting the message.


This patch (of 4):

Make set_recommended_min_free_kbytes() callable from outside khugepaged.c
by removing the static qualifier and adding a declaration in
mm/internal.h.

This allows callers that change THP settings to recalculate watermarks
without going through start_stop_khugepaged().

Link: https://lkml.kernel.org/r/20260309-thp_logs-v4-0-926b9840083e@debian.org
Link: https://lkml.kernel.org/r/20260309-thp_logs-v4-1-926b9840083e@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    5 +++++
 mm/khugepaged.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-khugepaged-export-set_recommended_min_free_kbytes
+++ a/mm/internal.h
@@ -642,6 +642,11 @@ int user_proactive_reclaim(char *buf,
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
 /*
+ * in mm/khugepaged.c
+ */
+void set_recommended_min_free_kbytes(void);
+
+/*
  * in mm/page_alloc.c
  */
 #define K(x) ((x) << (PAGE_SHIFT-10))
--- a/mm/khugepaged.c~mm-khugepaged-export-set_recommended_min_free_kbytes
+++ a/mm/khugepaged.c
@@ -2652,7 +2652,7 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-static void set_recommended_min_free_kbytes(void)
+void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;
_

Patches currently in -mm which might be from leitao@debian.org are

selftests-mm-add-thp-sysfs-interface-test.patch
mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders.patch
mm-huge_memory-refactor-enabled_store-with-change_enabled.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch

