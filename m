Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B01C2EA
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298411; cv=none; b=V3yaQW4Q6Yq+zWu8AFiEMZ4in2YuFPpYWCDEkaWFeLZAxITp9Yk8pPpUTdpPGa6wV060mmCdEDKIYJZKnB4Xu1kI2KsvCIsfAEWFCgQzqHgbJCLJ5OTFi0A2EK2NiOL/m/6bV8g/oZNkP8F8JF6f5Zhhqxb2Xgva60kvCbXUTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298411; c=relaxed/simple;
	bh=TVm7+gHYORAePSPkdn9krVjMoatxJ9Fa58YssTMTM30=;
	h=Date:To:From:Subject:Message-Id; b=nL+rysYshqMCclixWGYSNC5c2JCtYIspvHNp9PpQ3awKBemqMjzXjMw2Uz7ESqjao2bcDWgKGndKjOzcfrrORZ3dFtS1EAKScrbu6MTiKZOpzIsW1+0EIyxFSqbvYKURxsQGZ2DlRdtWplDMzZRQFPFbxJd1FBaFeYSh7S6a6dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YHwZRlRG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YHwZRlRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8885D1F00A3A;
	Wed, 29 Jul 2026 04:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298409;
	bh=ZGVFSG2Vz1+IZgdnz5ADjQTJr15pIrTXnyQ5EMVPC98=;
	h=Date:To:From:Subject;
	b=YHwZRlRG1H53bRZkypA/km5HeyGsjv5n3917Lc2pn1w1I3QPqH3SDnRyRILTJc/jL
	 rwnhs+FOdi4+80oJcQtV1x56w6vfrhvrmIQY1L+P87YZDj2rmBKNQMdL5/KRSvm+Ju
	 hUogLnUmPBEqkuv9ZBRWcwtfd6gNZL4KHJb+FHwc=
Date: Tue, 28 Jul 2026 21:13:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch removed from -mm tree
Message-Id: <20260729041329.8885D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: add MR_NEVER to enum migrate_reason and use it for last_migrate_reason
Date: Tue, 14 Jul 2026 09:51:01 +0800

The last_migrate_reason field uses -1 as a sentinel value to mean "no
migration has happened".  Replace the four bare -1 occurrences by adding a
proper MR_NEVER member to enum migrate_reason, defining a corresponding
"never_migrated" string in the MIGRATE_REASON trace macro, and updating
the GDB page_owner script to use MR_NEVER instead of the hardcoded -1 so
that lx-dump-page-owner does not incorrectly report unmigrated pages as
migrated.

No functional change.

Link: https://lore.kernel.org/20260714015117.78351-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate_mode.h    |    1 +
 include/trace/events/migrate.h  |    3 ++-
 mm/page_owner.c                 |    8 ++++----
 scripts/gdb/linux/page_owner.py |    4 +++-
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/migrate_mode.h~mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason
+++ a/include/linux/migrate_mode.h
@@ -25,6 +25,7 @@ enum migrate_reason {
 	MR_LONGTERM_PIN,
 	MR_DEMOTION,
 	MR_DAMON,
+	MR_NEVER,		/* page has never been migrated */
 	MR_TYPES
 };
 
--- a/include/trace/events/migrate.h~mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason
+++ a/include/trace/events/migrate.h
@@ -23,7 +23,8 @@
 	EM( MR_CONTIG_RANGE,	"contig_range")			\
 	EM( MR_LONGTERM_PIN,	"longterm_pin")			\
 	EM( MR_DEMOTION,	"demotion")			\
-	EMe(MR_DAMON,		"damon")
+	EM( MR_DAMON,		"damon")			\
+	EMe(MR_NEVER,		"never_migrated")
 
 /*
  * First define the enums in the above macros to be exported to userspace
--- a/mm/page_owner.c~mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason
+++ a/mm/page_owner.c
@@ -339,7 +339,7 @@ noinline void __set_page_owner(struct pa
 	depot_stack_handle_t handle;
 
 	handle = save_stack(gfp_mask);
-	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
+	__update_page_owner_handle(page, handle, order, gfp_mask, MR_NEVER,
 				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
@@ -596,7 +596,7 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	if (page_owner->last_migrate_reason != -1) {
+	if (page_owner->last_migrate_reason != MR_NEVER) {
 		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
@@ -667,7 +667,7 @@ void __dump_page_owner(const struct page
 		stack_depot_print(handle);
 	}
 
-	if (page_owner->last_migrate_reason != -1)
+	if (page_owner->last_migrate_reason != MR_NEVER)
 		pr_alert("page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	page_ext_put(page_ext);
@@ -826,7 +826,7 @@ static void init_pages_in_zone(struct zo
 
 			/* Found early allocated page */
 			__update_page_owner_handle(page, early_handle, 0, 0,
-						   -1, local_clock(), current->pid,
+						   MR_NEVER, local_clock(), current->pid,
 						   current->tgid, current->comm);
 			count++;
 ext_put_continue:
--- a/scripts/gdb/linux/page_owner.py~mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason
+++ a/scripts/gdb/linux/page_owner.py
@@ -34,6 +34,7 @@ class DumpPageOwner(gdb.Command):
     max_pfn = None
     p_ops = None
     migrate_reason_names = None
+    mr_never = None
 
     def __init__(self):
         super(DumpPageOwner, self).__init__("lx-dump-page-owner", gdb.COMMAND_SUPPORT)
@@ -65,6 +66,7 @@ class DumpPageOwner(gdb.Command):
         self.max_pfn = int(gdb.parse_and_eval("max_pfn"))
         self.page_ext_size = int(gdb.parse_and_eval("page_ext_size"))
         self.migrate_reason_names = gdb.parse_and_eval('migrate_reason_names')
+        self.mr_never = int(gdb.parse_and_eval('MR_NEVER'))
 
     def page_ext_invalid(self, page_ext):
         if page_ext == gdb.Value(0):
@@ -138,7 +140,7 @@ class DumpPageOwner(gdb.Command):
         else:
             gdb.write('page last free stack trace:\n')
             stackdepot.stack_depot_print(page_owner["free_handle"])
-        if page_owner['last_migrate_reason'] != -1:
+        if page_owner['last_migrate_reason'] != self.mr_never:
             gdb.write('page has been migrated, last migrate reason: %s\n' % self.migrate_reason_names[page_owner['last_migrate_reason']])
 
     def read_page_owner(self):
_

Patches currently in -mm which might be from ye.liu@linux.dev are


