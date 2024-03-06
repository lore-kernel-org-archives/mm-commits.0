Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0043E1862F
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759129; cv=none; b=Z5m5xUPUlQ65q4UL2ctrnJb+E6RoEX8ZLAY8Stz05sR43HW1p5eIHMZe0nBTJyXkfTQ1jJvNuVJBE2XFI/ILJL9Hej2M1W7Q0CzlRF608F/4ERtdNlwj0KhVH8kA6Q9Z336d/wfcldjxmI0hg5mJl+O64Imsj42IDHjvCUVBwYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759129; c=relaxed/simple;
	bh=4ck/vTBETW0PEdMes4JTzrOR8MdkZcg0JmBgKnhdsYE=;
	h=Date:To:From:Subject:Message-Id; b=VomUYj/+bmhpzhj9AM2g+48KaEFSTiyjEZTeIcVBDn4iKjrOTe4Sc0968DIrgyICmoA0evtn0gLeEC0rlTAX5DgK78oWTJ2d5tjBDfkSp8zsQ32Kol8URjadpGkUuz0d2TYxT9IPpuzjCcUCsFWA4OgR5TyavLjIwhSrE+gjNMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JnvrhPs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JnvrhPs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C899EC433F1;
	Wed,  6 Mar 2024 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759128;
	bh=4ck/vTBETW0PEdMes4JTzrOR8MdkZcg0JmBgKnhdsYE=;
	h=Date:To:From:Subject:From;
	b=JnvrhPs6l4VLigK3rxivjV5NwGm15Kc98UAWGZ8w4ajEiGZTHxbCjQOo3aHmrpnuz
	 6pbqgAQ4kLYcPm0LpBwP58HUcmkT2aKFTuyiSwt4nCZym5UJarw+fpAq8KjUz0KNvx
	 ekFlJdbkradd0wvlPzn0+6sYkCpr8YHSKFVZYaD4=
Date: Wed, 06 Mar 2024 13:05:28 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmpage_owner-check-for-null-stack_record-before-bumping-its-refcount.patch removed from -mm tree
Message-Id: <20240306210528.C899EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: check for null stack_record before bumping its refcount
has been removed from the -mm tree.  Its filename was
     mmpage_owner-check-for-null-stack_record-before-bumping-its-refcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: check for null stack_record before bumping its refcount
Date: Wed, 6 Mar 2024 13:32:16 +0100

Patch series "page_owner: Fixup and cleanup".

This patchset consists of a fixup by an error that was reported by intel
robot, where it seems to be that by the time page_owner gets initialized,
stackdepot has already depleted its allocation space and returns
0-handles, turning that into null stack_records when trying to retrieve
the stack_record.  I was not able to reproduce that from the config
because it booted fine for me, but when setting e.g: dummy_handle to 0
artificially, I could see the same error that was reported.

The second patch is a cleanup that can also lead to a compilation warning.


This patch (of 2):

Although the retrieval of the stack_records for {dummy,failure}_handle
happen when page_owner gets initialized, there seems to be some situations
where stackdepot space has been already depleted by then, so we get
0-handles which make stack_records being NULL for those cases.

Be careful to 1) only bump stack_records refcount and 2) only access
stack_record fields if we actually have a non-null stack_record between
hands.

Link: https://lkml.kernel.org/r/20240306123217.29774-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20240306123217.29774-2-osalvador@suse.de
Fixes: 4bedfb314bdd ("mm,page_owner: implement the tracking of the stacks count")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202403051032.e2f865a-lkp@intel.com
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-check-for-null-stack_record-before-bumping-its-refcount
+++ a/mm/page_owner.c
@@ -107,8 +107,10 @@ static __init void init_page_owner(void)
 	/* Initialize dummy and failure stacks and link them to stack_list */
 	dummy_stack.stack_record = __stack_depot_get_stack_record(dummy_handle);
 	failure_stack.stack_record = __stack_depot_get_stack_record(failure_handle);
-	refcount_set(&dummy_stack.stack_record->count, 1);
-	refcount_set(&failure_stack.stack_record->count, 1);
+	if (dummy_stack.stack_record)
+		refcount_set(&dummy_stack.stack_record->count, 1);
+	if (failure_stack.stack_record)
+		refcount_set(&failure_stack.stack_record->count, 1);
 	dummy_stack.next = &failure_stack;
 	stack_list = &dummy_stack;
 }
@@ -856,6 +858,9 @@ static int stack_print(struct seq_file *
 	unsigned long nr_entries;
 	struct stack_record *stack_record = stack->stack_record;
 
+	if (!stack->stack_record)
+		return 0;
+
 	nr_entries = stack_record->size;
 	entries = stack_record->entries;
 	stack_count = refcount_read(&stack_record->count) - 1;
_

Patches currently in -mm which might be from osalvador@suse.de are


