Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4CF182B9
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708547795; cv=none; b=WpCecmKEAS7p/aCav5i0wkzYm5to4kBRjEEZc/Pq5p1Hs9UdmYLfHt4NZzArk9yiUVIU4UQKZi5+bcvcnTehB1h8gebsgd47nU3Walg1fUXiYUgfqoM0q1o2Qcm8J035IZH7OfYf9qXnBl4b4B2coKUTxkzWX49JCJFAH4CW/nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708547795; c=relaxed/simple;
	bh=rvtjLWdH75UuTrMA/p7Jvl0hMVLUadyV9ezwA4kUjhk=;
	h=Date:To:From:Subject:Message-Id; b=oU68PZJrAsHg46UHOgOJQJPzozFDzGzIvDRhPSip2FYxvQTQEm1YegkIvvgMljZoy3IX4BaYMptT0++7oRkOY8loB6hOXJF/TsyNgYOL9fiRCTXKn4sv2QiveKeyaYAX8YCs24GpEDZ0WHn8pWkvYc4miu9+GaGkK3tWM1YVxXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2VBo/KI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2VBo/KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081B0C43399;
	Wed, 21 Feb 2024 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708547795;
	bh=rvtjLWdH75UuTrMA/p7Jvl0hMVLUadyV9ezwA4kUjhk=;
	h=Date:To:From:Subject:From;
	b=Z2VBo/KIL8pORPtQony16DWkZi86jw2INqwOt4p0eNuUPD4n2KoloRDy8cyAuxzbr
	 P2twsNT/saKhjT94kLUM5gE47CcTnE4VZR+cQVUotRF/uvf8AZ+0H4vH57Q26csbU0
	 OQpgtHvIEzowBHBA4TMzm2OJGtkUeeOa7lYJJBrw=
Date: Wed, 21 Feb 2024 12:36:34 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,21cnbao@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch added to mm-unstable branch
Message-Id: <20240221203635.081B0C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix
Date: Wed Feb 21 12:35:32 PM PST 2024

avoid using goto

Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix
+++ a/mm/swapfile.c
@@ -3335,10 +3335,8 @@ static int __swap_duplicate(swp_entry_t
 	} else
 		err = -ENOENT;			/* unused swap entry */
 
-	if (err)
-		goto unlock_out;
-
-	WRITE_ONCE(p->swap_map[offset], count | has_cache);
+	if (!err)
+		WRITE_ONCE(p->swap_map[offset], count | has_cache);
 
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

