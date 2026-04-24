Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158653BE638
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 11:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777031751; cv=none; b=sGpZYGpD7jcv65PwJTCYmJzuLrPsYM9i3gsGZq1u17KU/MY5zaTPUP3fp172Dt8ljoxMVU2lduqEbmYLzqcrR2+pMd88U91aHDHx4vUJu5UhoF5MNd6oXkQj6Yl/84/bhvlED3hMpkZPF5mmr1b6+SSmNyLN7uw0GcEYIjzlpOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777031751; c=relaxed/simple;
	bh=NRJYlXTA/COd/71LLBvNmHTh6WFGGT6hHO5iVpwVc8g=;
	h=Date:To:From:Subject:Message-Id; b=ZAT7Q9bJl6gOr7BrhBjAGvQGfarccYy+jSSStXvBbAJAxZrcb/MDsCWmQvqFBUqE5LRb3FzhSJNOsh7QEcJMHzw/N9IBf27D8YF0TSm+DosRgK0/aMh6tvAQOL/OPyPYFypslEZs1BhgHOlRmWEPVuzAdOWWXS4Wh4IQ7DF3WdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n74WvxXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n74WvxXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A5C19425;
	Fri, 24 Apr 2026 11:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777031750;
	bh=NRJYlXTA/COd/71LLBvNmHTh6WFGGT6hHO5iVpwVc8g=;
	h=Date:To:From:Subject:From;
	b=n74WvxXD5qUPh+6H8UTAeiBQDMy2jcaQTMxHaWst/ncZ4ZqMkmWe6MhyACW/usxec
	 JsEJ+JZXMUks1v30g97NyAPXSP2qXLHPdEULBrYzPDpzPVA+EIZcP8INGnl/Ut4Wz+
	 KPZ3POT0emCMIK+kMabxWlS6tO6tSFm5D6OZw57M=
Date: Fri, 24 Apr 2026 04:55:50 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,willy@infradead.org,will@kernel.org,weixugc@google.com,wangzicheng@honor.com,surenb@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,liulei.rjpt@vivo.com,lance.yang@linux.dev,kasong@tencent.com,kaleshsingh@google.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active-in-pf.patch added to mm-new branch
Message-Id: <20260424115550.A75A5C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: use folio_mark_accessed to replace folio_set_active in PF
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active-in-pf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active-in-pf.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: use folio_mark_accessed to replace folio_set_active in PF
Date: Sat, 18 Apr 2026 20:02:33 +0800

MGLRU gives high priority to folios mapped in page tables.  As a result,
folio_set_active() is invoked for all folios read during page faults.  In
practice, however, readahead can bring in many folios that are never
accessed via page tables.

A previous attempt by Lei Liu proposed introducing a separate LRU for
readahead[1] to make readahead pages easier to reclaim, but that approach
is likely over-engineered.

Before commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
folios with PG_active were always placed in the youngest generation,
leading to over-protection and increased refaults.  After that commit,
PG_active folios are placed in the second youngest generation, which is
still too optimistic given the presence of readahead.  In contrast, the
classic active/inactive scheme is more conservative.

This patch switches to folio_mark_accessed().  If folio_check_references()
later detects referenced PTEs, the folio will be promoted based on the
reference flag set by folio_mark_accessed().

The following uses a simple model to demonstrate why the current code is
not ideal.  It runs fio-3.42 in a memcg, reading a file in a strided
pattern—4KB every 64KB—to simulate prefaulted pages that may not be
accessed.

 #!/bin/bash

 CG_NAME="mglru_verify_test"
 CG_PATH="/sys/fs/cgroup/$CG_NAME"
 MEM_LIMIT="400M"
 HOT_SIZE="600M"

 # 1. Environment Setup
 sudo rmdir "$CG_PATH" 2>/dev/null
 sudo mkdir -p "$CG_PATH"
 sudo chown -R $USER:$USER "$CG_PATH"
 echo "$MEM_LIMIT" > "$CG_PATH/memory.max"

 # 2. Prepare Data Files
 dd if=/dev/urandom of=hot_data.bin bs=1M count=600 conv=notrunc 2>/dev/null
 sync
 echo 3 > /proc/sys/vm/drop_caches

 # 3. Start Workload (Working Set)
 (
     echo $BASHPID > "$CG_PATH/cgroup.procs"
     exec ./fio-3.42 --name=hot_ws --rw=read --bs=4K --size=$HOT_SIZE --runtime=600 \
          --zonemode=strided --zonesize=4K --zonerange=64K \
 	 --time_based --direct=0 --filename=hot_data.bin --ioengine=mmap \
          --fadvise_hint=0 --group_reporting --numjobs=1 > fio.stats
 ) &
 WORKLOAD_PID=$!

 # 4. Waiting for hot data to warm up
 sleep 30
 BASE_FILE=$(grep "workingset_refault_file" "$CG_PATH/memory.stat" | awk '{print $2}')

 # 5. Running workload for 60second
 sleep 60

 # 6. Report refault and IO bandwidth
 FINAL_FILE=$(grep "workingset_refault_file" "$CG_PATH/memory.stat" | awk '{print $2}')
 FINAL_D_FILE=$((FINAL_FILE - BASE_FILE))
 echo "File Refault Delta is $FINAL_D_FILE"

 kill $WORKLOAD_PID 2>/dev/null
 sleep 2
 grep -E "READ|WRITE" fio.stats \
 | awk '{for(i=1;i<=NF;i++){if($i ~ /^bw=/) bw=$i; if($i ~ /^io=/) io=$i} print $1, bw, io}'
 rm -f hot_data.bin fio.stats

Without the patch, we observed 12883855 file refaults and a very low
bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy hot
positions, continuously pushing out the real working set and causing
incorrect reclaim.  With the patch, we observed 0 refaults and bandwidth
increased to 5078 MiB/s.

Note that this patch does not benefit any platform other than arm64, since
commit 315d09bf30c2 ("Revert "mm: make faultaround produce old ptes"")
reverted the change that made prefault PTEs “old”, after it was
identified as the cause of a ~6% regression in UnixBench on x86.  This was
due to reports that x86 uses an internal microfault mechanism for HW AF. 
The hardware access flag mechanism is relatively expensive and can lead to
a ~6% UnixBench regression when prefaulted PTEs are not marked young
directly in the page fault path, especially when UnixBench runs without
any memory pressure[2].

Thanks to Will for raising this for arm64—“Create `old' PTEs for
faultaround mappings on arm64 with hardware access flag” [3].  This is
also thanks to arm64 microarchitectures, which incur zero cost for HW AF
handling.

It may be time for x86 and other architectures to revisit whether HW AF is
truly costly on their platforms, given that the original x86 regression
was reported 10 years ago.

For those who want to try the model on x86, you will need the
following in arch/x86/include/asm/pgtable.h.

 #define arch_wants_old_prefaulted_pte arch_wants_old_prefaulted_pte
 static inline bool arch_wants_old_prefaulted_pte(void)
 {
 	return true;
 }

Lance and Xueyuan made a huge contribution to this patch through testing. 
They truly worked over weekends and after work hours.  If this patch
deserves any credit, it belongs to them.

Link: https://lore.kernel.org/20260418120233.7162-1-baohua@kernel.org
Link: https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.com/ [1]
Link: https://lore.kernel.org/lkml/20160606022724.GA26227@yexl-desktop/ [2]
Link: https://lore.kernel.org/lkml/20210120173612.20913-1-will@kernel.org/ [3]
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active-in-pf
+++ a/mm/swap.c
@@ -512,7 +512,7 @@ void folio_add_lru(struct folio *folio)
 	/* see the comment in lru_gen_folio_seq() */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-		folio_set_active(folio);
+		folio_mark_accessed(folio);
 
 	folio_batch_add_and_move(folio, lru_add);
 }
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch
mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active-in-pf.patch

