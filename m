Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5D32C15A8;
	Wed, 15 Oct 2025 20:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559909; cv=none; b=urUDmjJJqZOkrtng8eLdA8uiNazJc4+DSIhQJHb7y3wZ5MDsNosM/7StVQ8enm/HT0TZmWEzjAku71TWYXNrLOUH8EzO2sqyG6tC+xHl3ZpiE3kkD3TRRoAoemRes00sgs5l/tsPxz+Z06XIjTDIu5aKjfdJsM++wjOZEWlK3tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559909; c=relaxed/simple;
	bh=4ano0As7MGA4Eb2wYtt8MRyAysgoV1epPQRTrV31tPA=;
	h=Date:To:From:Subject:Message-Id; b=kHR7kEI/Uwy9dy9o2GFSIGrcVdJWaLblh46gRvR6dUri4yd6D4+gIQU8jp7Sg4gNE5KbLOxLQIDO23OJnAL3d6wvC9yW7nrHs5HShL57rCDWWu8nB5nZP7mYQXmEbINgnzzsDdc39XdXdc54WePKEZaD8PH9R7OcPI1OdcNrY6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cc69Qox0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cc69Qox0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC6DC4CEFB;
	Wed, 15 Oct 2025 20:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559909;
	bh=4ano0As7MGA4Eb2wYtt8MRyAysgoV1epPQRTrV31tPA=;
	h=Date:To:From:Subject:From;
	b=cc69Qox0A64EcyJp2AAmSnDOM+RdJmwtn6RXldoFQkr6NvBM2wboEs7ll2Pjry7+H
	 YsVTsEng17Zho8fdLvayTvmllpnZ8T19MDw/CHjCtDZihVC+SyTDsCa/AlSZb87YQu
	 jBM+2FATUaT61PpZPq4/uvOQ0GxnfdohITnpVnTA=
Date: Wed, 15 Oct 2025 13:25:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ast@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-dont-spin-in-add_stack_record-when-gfp-flags-dont-allow.patch removed from -mm tree
Message-Id: <20251015202509.4BC6DC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't spin in add_stack_record when gfp flags don't allow
has been removed from the -mm tree.  Its filename was
     mm-dont-spin-in-add_stack_record-when-gfp-flags-dont-allow.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com
Reported-by: syzbot+665739f456b28f32b23d@syzkaller.appspotmail.com
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
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


