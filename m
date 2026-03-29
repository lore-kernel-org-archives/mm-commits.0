Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35CD2580E1
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744878; cv=none; b=k5wBgCLMcyhN0FH9svwhLQ1NBTt87xwjYiJuK1fo1lToXxNHIwsdBeCMDRf1bHkb5XzpFCveBasHGr4ufXmq6z42OEB0ww3yFj090k6asN2R6MLZ4mOXXqJMhec97o9x16jvvoq1rZFXD7ixp1y4YI0fMXYkV3eHIW9sivveKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744878; c=relaxed/simple;
	bh=oXWAjaYh2qQoSAR/CLw7RA4SN/Ce4ij48E3yYmZJwKY=;
	h=Date:To:From:Subject:Message-Id; b=j3YwWa+nELLL4ekrgguLaHBrTnSx2jq7NA2jo0tqcAefeULKloWM5XMJtYC7V60vmRLeJraoFlDcZDjgbdqkLCjVZbd6ylAOB0hTZxDdeUdDL2u7D2629SbYsS7ts83Ll7i9u6gimn3lOeE8/KIyYzRqK2U+/75g3pvJlrfjwAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wXVW0XyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wXVW0XyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D15FC4CEF7;
	Sun, 29 Mar 2026 00:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744878;
	bh=oXWAjaYh2qQoSAR/CLw7RA4SN/Ce4ij48E3yYmZJwKY=;
	h=Date:To:From:Subject:From;
	b=wXVW0XyUFkJ1FXsChSDsIzBIeE0u/X9tko++Pfc70f40voNxfLMeaDwnSuZroxQsM
	 nyEkFNU3o8E4/k7KWcWIWn66QgQII/dVBBkp1Al3sSRRr6enqELoQC7AFwbl5FhDNH
	 uPTSG7RWT4GYHVkiLYWcYklRhTGXClms6Iv+AzyM=
Date: Sat, 28 Mar 2026 17:41:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-export-set_recommended_min_free_kbytes.patch removed from -mm tree
Message-Id: <20260329004118.9D15FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: export set_recommended_min_free_kbytes()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-export-set_recommended_min_free_kbytes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: khugepaged: export set_recommended_min_free_kbytes()
Date: Tue, 17 Mar 2026 08:33:56 -0700

Patch series "mm: thp: reduce unnecessary start_stop_khugepaged()", v7.

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

Link: https://lkml.kernel.org/r/20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org
Link: https://lkml.kernel.org/r/20260317-thp_logs-v7-1-31eb98fa5a8b@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    5 +++++
 mm/khugepaged.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-khugepaged-export-set_recommended_min_free_kbytes
+++ a/mm/internal.h
@@ -641,6 +641,11 @@ int user_proactive_reclaim(char *buf,
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
@@ -2660,7 +2660,7 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-static void set_recommended_min_free_kbytes(void)
+void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch

