Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5C93236
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955334; cv=none; b=sC1JgbRZ7PC4XnuxYBEAu9byvQNBnzm6Gfnry8s4VkrIv8YB8Q8asUAAlXB3s0gTI86ERVcJxL5uXTTME53urkgtS6O05YP1iHVoeTBIWfaHtJ6mXgJyQjmIC0amUpkGTkAPDVMWGkrDA0l5NKenFR628Oycs6aW1KzMGYE5mWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955334; c=relaxed/simple;
	bh=Gy95jyKm9ycki4tRcjCoi5PAG5D3gOakU8ReA8T09dw=;
	h=Date:To:From:Subject:Message-Id; b=rfWbsA7joqZiI4xfkNJBGcSUotpweC8ibRp3YkN9wjFrRvh9x1wRmPdZrP/9FEBGT4+4cakF0AGkgP0zDJcT/Am5oX6pYngANhtFIGwo9sH/M6juMqRrqw88+1Ii19phC7oEJNl7RNrgLMXp5fl9B9iB8V8sMQt1UNej7+6tvhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MkPJlc04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MkPJlc04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A77C113CC;
	Mon,  6 May 2024 00:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955333;
	bh=Gy95jyKm9ycki4tRcjCoi5PAG5D3gOakU8ReA8T09dw=;
	h=Date:To:From:Subject:From;
	b=MkPJlc046p0sVBwjm6abSCyz2nVwl/YrqNvOjPqSvvnzdWk4tlnZBrhCF1yCs4La7
	 uuRZhlcwNrWcVsPPqj5W0oChVH1u2ncwWerJribnh7zJcivwAkwVr+qYOLtNY8myVT
	 B9dS/vJMhPM27qAt1QBRWfMMGIe4IiPmmSvdWlqw=
Date: Sun, 05 May 2024 17:28:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,elver@google.com,djwong@kernel.org,david@fromorbit.com,andreyknvl@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list.patch removed from -mm tree
Message-Id: <20240506002853.D7A77C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: don't remove __GFP_NOLOCKDEP in add_stack_record_to_list
has been removed from the -mm tree.  Its filename was
     mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm,page_owner: don't remove __GFP_NOLOCKDEP in add_stack_record_to_list
Date: Mon, 29 Apr 2024 10:28:28 +0200

Otherwise we'll generate false lockdep positives.

Link: https://lkml.kernel.org/r/20240429082828.1615986-1-hch@lst.de
Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mmpage_owner-dont-remove-__gfp_nolockdep-in-add_stack_record_to_list
+++ a/mm/page_owner.c
@@ -170,7 +170,7 @@ static void add_stack_record_to_list(str
 
 	/* Filter gfp_mask the same way stackdepot does, for consistency */
 	gfp_mask &= ~GFP_ZONEMASK;
-	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
+	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL | __GFP_NOLOCKDEP);
 	gfp_mask |= __GFP_NOWARN;
 
 	set_current_in_page_owner();
_

Patches currently in -mm which might be from hch@lst.de are


