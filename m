Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910422144C7
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758487738; cv=none; b=Izi+iJdoviCXzVEQPmPwh2okb9D30x4WRH21hNeHsbISiJfpmKUAa7UPJW29Byl+0huPR/NLJ/EZpZpy/h7JfNyfBNh7La7G7Jh9WMwx+ePqnw4VJOgKipO1pe1TCdb0ZsfB2ly5Nka5WPkBizee+epv7NWIZGDHiDSdIelLabg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758487738; c=relaxed/simple;
	bh=9VmNckj6K/QbWhM1Vym76TS76rWhpWRctKJjNWyizo8=;
	h=Date:To:From:Subject:Message-Id; b=iwTQk3T/Xvsvw2cVKyxYvk9AA6AhMuFioH9JP/YAR7vAPnrMZLzGknUAjnn5ZyMZAAkCNUAKoHGdvO5VCNFSs8kp1clHwL+9VUL91oxB2BFv/O6QxJTmlPc6inL0dEQ/l6M++21CmBZzc2FcsBkVxJZN4qmA8fehbkdnsV3kePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MWBCTbhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MWBCTbhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087D2C4CEE7;
	Sun, 21 Sep 2025 20:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758487738;
	bh=9VmNckj6K/QbWhM1Vym76TS76rWhpWRctKJjNWyizo8=;
	h=Date:To:From:Subject:From;
	b=MWBCTbhVOTeqIosnc8/VTlV6y9ED0umXGaNjc1QfzVwlub7V+wj//GPanIRAV4nAW
	 nTLSRuy0zwpqaY0LpggUpICMgmWwW5aw3f4ZgValYkoaVa7V1YgWxB2GlK3crL/mep
	 PpZzZ6aZpmzVb1du7oYz13/0Uu9j+l6/skUFS8Fk=
Date: Sun, 21 Sep 2025 13:48:57 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rdunlap@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch removed from -mm tree
Message-Id: <20250921204858.087D2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch

This patch was dropped because it was folded into alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix
Date: Fri Sep 19 01:47:57 PM PDT 2025

add newline to prevent docs warning, per Randy

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1016,6 +1016,7 @@ For example if the counters are not accu
 
 Supported markers in v2:
 accurate:no
+
               Absolute values of the counters in this line are not accurate
               because of the failure to allocate memory to track some of the
               allocations made at this location.  Deltas in these counters are
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

