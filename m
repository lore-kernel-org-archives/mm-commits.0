From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_owner-skip-unnecessary-stack_trace-entries.patch removed from -mm
 tree
Date: Fri, 15 Sep 2017 10:51:34 -0700
Message-ID: <20170915175134.Q1Wxu6W-B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdIORvf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 13:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, guptap@codeaurora.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, vbabka@suse.cz, will.deacon@arm.com


The patch titled
     Subject: mm, page_owner: skip unnecessary stack_trace entries
has been removed from the -mm tree.  Its filename was
     mm-page_owner-skip-unnecessary-stack_trace-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prakash Gupta <guptap@codeaurora.org>
Subject: mm, page_owner: skip unnecessary stack_trace entries

The page_owner stacktrace always begin as follows:

[<ffffff987bfd48f4>] save_stack+0x40/0xc8
[<ffffff987bfd4da8>] __set_page_owner+0x3c/0x6c

These two entries do not provide any useful information and limits the
available stacktrace depth.  The page_owner stacktrace was skipping caller
function from stack entries but this was missed with commit f2ca0b557107
("mm/page_owner: use stackdepot to store stacktrace")

Example page_owner entry after the patch:

Page allocated via order 0, mask 0x8(ffffff80085fb714)
PFN 654411 type Movable Block 639 type CMA Flags 0x0(ffffffbe5c7f12c0)
[<ffffff9b64989c14>] post_alloc_hook+0x70/0x80
...
[<ffffff9b651216e8>] msm_comm_try_state+0x5f8/0x14f4
[<ffffff9b6512486c>] msm_vidc_open+0x5e4/0x7d0
[<ffffff9b65113674>] msm_v4l2_open+0xa8/0x224

Link: http://lkml.kernel.org/r/1504078343-28754-2-git-send-email-guptap@codeaurora.org
Fixes: f2ca0b557107 ("mm/page_owner: use stackdepot to store stacktrace")
Signed-off-by: Prakash Gupta <guptap@codeaurora.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_owner.c~mm-page_owner-skip-unnecessary-stack_trace-entries mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-skip-unnecessary-stack_trace-entries
+++ a/mm/page_owner.c
@@ -142,7 +142,7 @@ static noinline depot_stack_handle_t sav
 		.nr_entries = 0,
 		.entries = entries,
 		.max_entries = PAGE_OWNER_STACK_DEPTH,
-		.skip = 0
+		.skip = 2
 	};
 	depot_stack_handle_t handle;
 
_

Patches currently in -mm which might be from guptap@codeaurora.org are


