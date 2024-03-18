Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE965674B
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 19:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710789545; cv=none; b=PO8NQ8Btg6Hf1vFo03UbA+ygoy9wNxkr1Bp4vpkCdtZodKYG8yrViDmcPuy6C2m1pei8N75PnItbf2oxrzhI6/4GQpOSNYbp6lDqngZrIzIobEJ4xaGev9W3xZudHqWuGK2onOsFPycO73h1SueZcEQtkibP4NhsnIrrTv+qd8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710789545; c=relaxed/simple;
	bh=doKkbe9nasnGhFNxB03uejFCQZRbKecQud5zm92nWlk=;
	h=Date:To:From:Subject:Message-Id; b=Ds9DElyC+nvl1W2CYWtrnqoruxshp0f1Y7FzZ8HrQr94OzMN+tiJ4vbIkTq8oDyKRBfu4IjeC1bU2fXqZIrl3xnvgKFoWgLKpU/fS1glRX20YUUI5fpirQ3EJfHpgOjBi4AfPYyYKV3Gmf0se+mrK8twFzMc/Qu4Cz6t1zCr1QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GqQ2bsAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GqQ2bsAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5343BC433F1;
	Mon, 18 Mar 2024 19:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710789545;
	bh=doKkbe9nasnGhFNxB03uejFCQZRbKecQud5zm92nWlk=;
	h=Date:To:From:Subject:From;
	b=GqQ2bsAmuLic6JIScIng0dGPnIGNc5jXBF2ILZEIwAC8cd1Jr5ZacQ0D0kPu5FuqQ
	 ziFruLb1ebR5YtG3cESzgz0Jo+32N1MLE6nQpYTuNWqCbX4lRS1WwTuKy4YQTLOE+r
	 dP/jzIdRjV+siqloN2ZrjXMMJBkbPpzy3diJo63k=
Date: Mon, 18 Mar 2024 12:19:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-fix-recursion.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318191905.5343BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: fix recursion
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmpage_owner-fix-recursion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-fix-recursion.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: fix recursion
Date: Fri, 15 Mar 2024 23:26:10 +0100

Prior to 217b2119b9e2 ("mm,page_owner: implement the tracking of the
stacks count") the only place where page_owner could potentially go into
recursion due to its need of allocating more memory was in save_stack(),
which ends up calling into stackdepot code with the possibility of
allocating memory.

We made sure to guard against that by signaling that the current task was
already in page_owner code, so in case a recursion attempt was made, we
could catch that and return dummy_handle.

After above commit, a new place in page_owner code was introduced where we
could allocate memory, meaning we could go into recursion would we take
that path.

Make sure to signal that we are in page_owner in that codepath as well. 
Move the guard code into two helpers {un}set_current_in_page_owner() and
use them prior to calling in the two functions that might allocate memory.

Link: https://lkml.kernel.org/r/20240315222610.6870-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-fix-recursion
+++ a/mm/page_owner.c
@@ -54,6 +54,22 @@ static depot_stack_handle_t early_handle
 
 static void init_early_allocated_pages(void);
 
+static inline void set_current_in_page_owner(void)
+{
+	/*
+	 * Avoid recursion.
+	 *
+	 * We might need to allocate more memory from page_owner code, so make
+	 * sure to signal it in order to avoid recursion.
+	 */
+	current->in_page_owner = 1;
+}
+
+static inline void unset_current_in_page_owner(void)
+{
+	current->in_page_owner = 0;
+}
+
 static int __init early_page_owner_param(char *buf)
 {
 	int ret = kstrtobool(buf, &page_owner_enabled);
@@ -137,23 +153,16 @@ static noinline depot_stack_handle_t sav
 	depot_stack_handle_t handle;
 	unsigned int nr_entries;
 
-	/*
-	 * Avoid recursion.
-	 *
-	 * Sometimes page metadata allocation tracking requires more
-	 * memory to be allocated:
-	 * - when new stack trace is saved to stack depot
-	 */
 	if (current->in_page_owner)
 		return dummy_handle;
-	current->in_page_owner = 1;
 
+	set_current_in_page_owner();
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
 	handle = stack_depot_save(entries, nr_entries, flags);
 	if (!handle)
 		handle = failure_handle;
+	unset_current_in_page_owner();
 
-	current->in_page_owner = 0;
 	return handle;
 }
 
@@ -168,9 +177,13 @@ static void add_stack_record_to_list(str
 	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
 	gfp_mask |= __GFP_NOWARN;
 
+	set_current_in_page_owner();
 	stack = kmalloc(sizeof(*stack), gfp_mask);
-	if (!stack)
+	if (!stack) {
+		unset_current_in_page_owner();
 		return;
+	}
+	unset_current_in_page_owner();
 
 	stack->stack_record = stack_record;
 	stack->next = NULL;
_

Patches currently in -mm which might be from osalvador@suse.de are

mmpage_owner-fix-refcount-imbalance.patch
mmpage_owner-fix-recursion.patch

