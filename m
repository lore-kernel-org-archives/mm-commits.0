Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7BE18032
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759130; cv=none; b=W9G5r6J2kGalhE9f/l1CNX280fbF/aK98f7Glwqwd66GUOgfiOpLgAdbNEmPL4R5objltPpt4oO8hPgYL42iExerXLN7d+kcrcDctH34Yc1yl4AtRG5kRiFfZbGcc/Fy2TxadspSedcHhQ6D/77S4ztVZXepf2KW5ZkUa2KXMD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759130; c=relaxed/simple;
	bh=xQG7EMvqWVWMgRPKN2PnE75yLkLE/LhSx5mC/UFyG5s=;
	h=Date:To:From:Subject:Message-Id; b=l9ckkNiaH/fknQqFbZ9wrkQpBBLCdL/CNbfAHbA3Mba3hHUSYtBpjIJsj4od4oVEYvGfKURX3eIDZHXSVtQoYklmWomZon5infooysLTiOVDZgOiKUMSdUcR2VkZM3tQDyXDpGV+4oTO9Nnwtjp0qfVBxCJVsYOhRe4l3gDR/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zNqhKJKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zNqhKJKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52BDC43390;
	Wed,  6 Mar 2024 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759130;
	bh=xQG7EMvqWVWMgRPKN2PnE75yLkLE/LhSx5mC/UFyG5s=;
	h=Date:To:From:Subject:From;
	b=zNqhKJKNyiLxWpDDYs9N/TEYB9h/FyQ/OGbndB+/BE8CGFsHZwEGrqvGs/QrU7q24
	 xWxT2lh2W1F+KKjKlXo7F9zbCL+x5tlN/b0A/dDAG3OEduXPmjwBoSIeNSkDVOkp7D
	 ltSIxp0LiIG5sJr0o30GUprmQz6x0+EKj0XqNfQA=
Date: Wed, 06 Mar 2024 13:05:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmpage_owner-drop-unnecesary-check.patch removed from -mm tree
Message-Id: <20240306210529.E52BDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: drop unnecessary check
has been removed from the -mm tree.  Its filename was
     mmpage_owner-drop-unnecesary-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: drop unnecessary check
Date: Wed, 6 Mar 2024 13:32:17 +0100

stackdepot only saves stack_records which size is greather than 0,
so we cannot possibly have empty stack_records.
Drop the check.

Link: https://lkml.kernel.org/r/20240306123217.29774-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-drop-unnecesary-check
+++ a/mm/page_owner.c
@@ -865,8 +865,7 @@ static int stack_print(struct seq_file *
 	entries = stack_record->entries;
 	stack_count = refcount_read(&stack_record->count) - 1;
 
-	if (!nr_entries || nr_entries < 0 || stack_count < 1 ||
-	    stack_count < page_owner_stack_threshold)
+	if (stack_count < 1 || stack_count < page_owner_stack_threshold)
 		return 0;
 
 	for (i = 0; i < nr_entries; i++)
_

Patches currently in -mm which might be from osalvador@suse.de are


