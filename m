Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA181F03D2
	for <mm-commits@vger.kernel.org>; Fri, 10 Oct 2025 00:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760056884; cv=none; b=uBaoOkSKLnLymNEsB78SReAoYogC79kNnQDABlSV0ejf1HndLsMEmm7W6++9eB+KEeFtV+C3vDdInQ0Kcpxcg8vIatX67u/uQM5qVxEgxnk9x6n899ji+M1y84z/AUSVfnP1r1bfdd+DiVfXAfVN2y+suku5ONEIwWP2BTDjwho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760056884; c=relaxed/simple;
	bh=olkPzNw4teBn5EHnsQNy8wI49fOD44FsZAvHTNHi8cE=;
	h=Date:To:From:Subject:Message-Id; b=ThgniKLWmB8bmGbI63Ep0+dcw2t4eR05u31UTB1vNVoLvt0aOU4EqzgYwLtUfyI9f8DIi++mW9xDTMm1kZBZgFUNUS/MQzCJz4DR2TQ3pmFl3+0WEkkd3ir8gUCECU4s/cjSotebk40SILHMXWeNk5K7fG83bS6TmBn8eJRhZbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eL+D2LK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eL+D2LK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5368DC4CEE7;
	Fri, 10 Oct 2025 00:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760056884;
	bh=olkPzNw4teBn5EHnsQNy8wI49fOD44FsZAvHTNHi8cE=;
	h=Date:To:From:Subject:From;
	b=eL+D2LK97c0Siy/P44VwlzNy2q2HL0WSvQWL/1hf5Rdz6J5Dq3jQTtBYQtL0hAAQW
	 gemFqjLOsRb9T4fOEtAy3dAxdT48K3zJmO29c2QL+ztOeSyA1puia+FFJ3U2RRm/dE
	 elSAQgye5qVIo1XO/vemD45IH/+dVcwxUWQMje58=
Date: Thu, 09 Oct 2025 17:41:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ast@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-spin-in-add_stack_record-when-gfp-flags-dont-allow.patch added to mm-hotfixes-unstable branch
Message-Id: <20251010004124.5368DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't spin in add_stack_record when gfp flags don't allow
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-spin-in-add_stack_record-when-gfp-flags-dont-allow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-spin-in-add_stack_record-when-gfp-flags-dont-allow.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexei Starovoitov <ast@kernel.org>
Subject: mm: don't spin in add_stack_record when gfp flags don't allow
Date: Thu, 9 Oct 2025 17:15:13 -0700

syzbot was able to find the following path:
  add_stack_record_to_list mm/page_owner.c:182 [inline]
  inc_stack_record_count mm/page_owner.c:214 [inline]
  __set_page_owner+0x2c3/0x4a0 mm/page_owner.c:333
  set_page_owner include/linux/page_owner.h:32 [inline]
  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
  prep_new_page mm/page_alloc.c:1859 [inline]
  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
  alloc_pages_nolock_noprof+0x94/0x120 mm/page_alloc.c:7554

Don't spin in add_stack_record_to_list() when it is called
from *_nolock() context.

Link: https://lkml.kernel.org/r/CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com
Reported-by: syzbot+665739f456b28f32b23d@syzkaller.appspotmail.com
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_owner.c~mm-dont-spin-in-add_stack_record-when-gfp-flags-dont-allow
+++ a/mm/page_owner.c
@@ -168,6 +168,9 @@ static void add_stack_record_to_list(str
 	unsigned long flags;
 	struct stack *stack;
 
+	if (!gfpflags_allow_spinning(gfp_mask))
+		return;
+
 	set_current_in_page_owner();
 	stack = kmalloc(sizeof(*stack), gfp_nested_mask(gfp_mask));
 	if (!stack) {
_

Patches currently in -mm which might be from ast@kernel.org are

mm-dont-spin-in-add_stack_record-when-gfp-flags-dont-allow.patch

