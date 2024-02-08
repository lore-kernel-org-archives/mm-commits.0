Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B4F4BABE
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707426924; cv=none; b=jWcPeUj9Y53UiaA0fnGYCxqixjtFmhvkmrmVFmr7F1nH2LoBG0yBDTMlEU8Ayq6evergZeH0GqH5qba6TPjE2A0nHT0SCnOPQTI0WJMm4o9SvBVN3dS8IxkTvHuUpnM5+/PfKB4x3vWBjeszf0VCectj6e9RaJoCZ0lNej2qcA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707426924; c=relaxed/simple;
	bh=W4skE1MNWLbTRgQDWjkVlW9IcnshjvvJAFJgo0hBLpc=;
	h=Date:To:From:Subject:Message-Id; b=AmXF/RvoFFKagL6FJkHBWTPg3zB4ZjQ9YUI+qavgLWmUYyRU1wN7duZAu1h7XEju/FapQ2e/rV6OYjycksRPdMeW7l5rJK09iCCr1EMjcboKnl6XHJZHyz0vlW77YhDq4H5tXSJ1jSR3d5WK8N1gT/1RxcjSUN+T+h32Mnfk4tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vfAxwSp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vfAxwSp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BD9C433C7;
	Thu,  8 Feb 2024 21:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707426924;
	bh=W4skE1MNWLbTRgQDWjkVlW9IcnshjvvJAFJgo0hBLpc=;
	h=Date:To:From:Subject:From;
	b=vfAxwSp90vU3me4TKzRC6AKogXcDxobxh7hKtG4kNJI8ZhHITyRDKhYqYGqZ8aVoZ
	 ikrdHMbNJhkpwFG0GHPdWf6optL99Okia/mO0yvpx8rDacxvrDaBy9Ke5VFi7sqYD6
	 ronrBdhbr1nznislLFIMQPQ97RbKcUyUVSwBXF9w=
Date: Thu, 08 Feb 2024 13:15:23 -0800
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-leverage-list_is_head-for-list_entry_is_head.patch added to mm-nonmm-unstable branch
Message-Id: <20240208211524.50BD9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: leverage list_is_head() for list_entry_is_head()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-leverage-list_is_head-for-list_entry_is_head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-leverage-list_is_head-for-list_entry_is_head.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: list: leverage list_is_head() for list_entry_is_head()
Date: Thu, 8 Feb 2024 02:14:23 +0000

This is what list_is_head() exactly do.

Link: https://lkml.kernel.org/r/20240208021423.15704-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/list.h~list-leverage-list_is_head-for-list_entry_is_head
+++ a/include/linux/list.h
@@ -766,7 +766,7 @@ static inline size_t list_count_nodes(st
  * @member:	the name of the list_head within the struct.
  */
 #define list_entry_is_head(pos, head, member)				\
-	(&pos->member == (head))
+	list_is_head(&pos->member, (head))
 
 /**
  * list_for_each_entry	-	iterate over list of given type
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

list-leverage-list_is_head-for-list_entry_is_head.patch

