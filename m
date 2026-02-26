Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9961623BD05
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 21:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772143091; cv=none; b=t+OjT3m2qe2GvHVbyybDAy2yvQgTXh5ylqaOK47yvPedITHnjWo+7jWUecA8UdGQ0cPPafo6KkgIwkUth4mPu/k6pS69YYyPmQcsEp6Y4l16xG5tIqUibqOvBppZrt7bhKD7lr8IbrlNBpOnVyecDwzuIAd6Vxx9g4Hf/B/W5HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772143091; c=relaxed/simple;
	bh=RNCg+HwMnGA3qALJaYF4/h6qurtdYnRWHUibshzhixk=;
	h=Date:To:From:Subject:Message-Id; b=b0CCuLu5agCNK2ZLxZQHA8CJK1HaSmS8H6mKrczNwdINjKij/Kjj7xwelSdTBf4OxYbi9CS8x4gpRfGkfbY7eTu/oqHAHiTGhN7gkr66I1asIxFi8BPydkoFagjfexDe0EPYS5M/5yzn5wmrzAv2MhwZFtOYQTH8GJeFpcPoJ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJrfSs6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJrfSs6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA11C116C6;
	Thu, 26 Feb 2026 21:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772143091;
	bh=RNCg+HwMnGA3qALJaYF4/h6qurtdYnRWHUibshzhixk=;
	h=Date:To:From:Subject:From;
	b=WJrfSs6p3OccSM8G4K0NTkiXZQsr3+bfdR3uYN3jF2dElUG+a4NfTflCZBrBj59IZ
	 KcmiXbJcLJ1Hl0A7Tc7AH47HJ63ckeiIkq0ZrBDIGjzFXWG+dlYpxH8zhaHNve7fAx
	 dt31DmfhqzTaFM4WWNWZfn1PnY01jlHiJZrn7V8g=
Date: Thu, 26 Feb 2026 13:58:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,d@ilvokhin.com,david@kernel.org,benjamin.cheatham@amd.com,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-tracepoints-for-zone-lock-fix-fix.patch added to mm-new branch
Message-Id: <20260226215811.0AA11C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-tracepoints-for-zone-lock-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-tracepoints-for-zone-lock-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-tracepoints-for-zone-lock-fix-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-tracepoints-for-zone-lock-fix-fix
Date: Thu Feb 26 01:57:28 PM PST 2026

remove the EXPORT_SYMBOLs altogether

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Cheatham <benjamin.cheatham@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zone_lock.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/zone_lock.c~mm-add-tracepoints-for-zone-lock-fix-fix
+++ a/mm/zone_lock.c
@@ -14,18 +14,15 @@ void __zone_lock_do_trace_start_locking(
 {
 	trace_zone_lock_start_locking(zone);
 }
-EXPORT_SYMBOL_GPL(__zone_lock_do_trace_start_locking);
 
 void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success)
 {
 	trace_zone_lock_acquire_returned(zone, success);
 }
-EXPORT_SYMBOL_GPL(__zone_lock_do_trace_acquire_returned);
 
 void __zone_lock_do_trace_released(struct zone *zone)
 {
 	trace_zone_lock_released(zone);
 }
-EXPORT_SYMBOL_GPL(__zone_lock_do_trace_released);
 
 #endif /* CONFIG_TRACING */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-convert-zone-lock-users-to-wrappers-fix.patch
mm-convert-zone-lock-users-to-wrappers-fix-fix.patch
mm-add-tracepoints-for-zone-lock-fix.patch
mm-add-tracepoints-for-zone-lock-fix-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

