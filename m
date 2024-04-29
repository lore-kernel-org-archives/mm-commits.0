Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D100C33C7
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714409462; cv=none; b=p7nnIMErq+A9zfOl9Omhqv5gVp4V5HYUchJxrxCrqYe0D81C+53gK3ndUkUMk1aUkxwdvWbAgvXjrV/ifLevzJtdPoJayD7n+wdG+3ZwZjFwOl1y8+JLWWdQ+Wf8ur3v7Y+LjAPFi0S9tO8Jbt89GGe1HFvyq+/AUDwXgl0KOWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714409462; c=relaxed/simple;
	bh=EaK+Dt0sUP3fws3w7JeaBzT6rDjfaBd6LRLcmibJ0EI=;
	h=Date:To:From:Subject:Message-Id; b=kdkva7y4fL1SvJdJcZL/IWW+mjwnlyY+W4P5bD9RpH3YuxUPquNOLf8MscqT6m3/Ideb5eN4wJORalDmuvJa+8JBQdvU7Gy4zeF4UcAqxaRcB40vPG4wogUjgUW8aEHNS5EJNKX3W5Hy5QLwU2TKJEXdWU1YWVopWf7IEtkGa7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wZux7Znx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wZux7Znx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375BFC113CD;
	Mon, 29 Apr 2024 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714409462;
	bh=EaK+Dt0sUP3fws3w7JeaBzT6rDjfaBd6LRLcmibJ0EI=;
	h=Date:To:From:Subject:From;
	b=wZux7ZnxzzRdJQm8NybzutPrBymy/yBKoFPLy8e9iLJGvudDKgk93pNK4vVP6l3w0
	 7jyYUJv4Q0ubxLS9OvCuB/oxavIngxClunnYp2wMqLzmzKJfmpRHcXFpMXO8NYV0CT
	 1RtNe2sho9w0mcPHLblcRk8WPb48uFrdJa80+8w4=
Date: Mon, 29 Apr 2024 09:51:00 -0700
To: mm-commits@vger.kernel.org,lilinke99@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-mark-racy-access-on-si-highest_bit.patch added to mm-unstable branch
Message-Id: <20240429165102.375BFC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: mark racy access on si->highest_bit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-mark-racy-access-on-si-highest_bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-mark-racy-access-on-si-highest_bit.patch

This patch will later appear in the mm-unstable branch at
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
From: linke li <lilinke99@qq.com>
Subject: mm/swapfile: mark racy access on si->highest_bit
Date: Sat, 27 Apr 2024 14:29:56 +0800

In scan_swap_map_slots(), si->highest_bit can by changed by
swap_range_alloc() concurrently.  All reads on si->highest_bit except one
is either protected by lock or read using READ_ONCE.  So mark the one racy
read on si->highest_bit as benign using READ_ONCE.

This patch is aimed at reducing the number of benign races reported by
KCSAN in order to focus future debugging effort on harmful races.

Link: https://lkml.kernel.org/r/tencent_912BC3E8B0291DA4A0028AB424076375DA07@qq.com
Signed-off-by: linke li <lilinke99@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-mark-racy-access-on-si-highest_bit
+++ a/mm/swapfile.c
@@ -902,7 +902,7 @@ static int scan_swap_map_slots(struct sw
 		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
 
 		/* Locate the first empty (unaligned) cluster */
-		for (; last_in_cluster <= si->highest_bit; offset++) {
+		for (; last_in_cluster <= READ_ONCE(si->highest_bit); offset++) {
 			if (si->swap_map[offset])
 				last_in_cluster = offset + SWAPFILE_CLUSTER;
 			else if (offset == last_in_cluster) {
_

Patches currently in -mm which might be from lilinke99@qq.com are

mm-swapfile-mark-racy-access-on-si-highest_bit.patch

