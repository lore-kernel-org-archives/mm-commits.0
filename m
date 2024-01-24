Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC63E18C01
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091455; cv=none; b=e7uargrbF7qotg2OddZy6H/M0lIO6AVn2kbF+eDecgMkLYQs6k/kN3IVZHsJe4Egoq3xizhzuHejaOlVR8zg+KD+D2ay6chJLbFcXuNkid6mg4fBHhTY57UNQ9wXttlRN/DubwNxqnrl8dVjbkglHULjA8fpMff75QFD4ILjEHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091455; c=relaxed/simple;
	bh=uuflpC0PAVRQ+XCfKgk4D36ckYuXDwb+wUjsffyxhuY=;
	h=Date:To:From:Subject:Message-Id; b=k1PVZKqFWnrhWPVkEOQeOWYP+bateQN1pLMy6rFb8GCJ4uSV9fIdZ6JA122PWBXSQ4HAs1Hc/IlhLOvQWO1qoq5mctqCBxKzRpF94XVbEiCEf8GTu2T83nnHlqzsDkra/hxKAQV75AkP1gjsTtjIHVMmlBAs1qOBx8DTQDzQPSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h4XtoJ6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h4XtoJ6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0182CC433F1;
	Wed, 24 Jan 2024 10:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091455;
	bh=uuflpC0PAVRQ+XCfKgk4D36ckYuXDwb+wUjsffyxhuY=;
	h=Date:To:From:Subject:From;
	b=h4XtoJ6HjdvdtAXxwnKQuBk57SWzS4MWG/LEp6kdJfVnD9BmGxv/ajw+3rasGhSe3
	 uAOUw7Mu5SGkgdJLl15krUb4YoFRD8JFNwHB5l37mpdca1fQpt2JDvsXxQVu6ox/4X
	 nBdYw0vpx6bMaBfCrrWFsR7TmyozCSf4ATdRIaWY=
Date: Wed, 24 Jan 2024 02:17:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,guoxuenan@huawei.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-avoid-multiple-marked-readahead-pages-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240124101735.0182CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: Avoid multiple marked readahead pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     readahead-avoid-multiple-marked-readahead-pages-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-avoid-multiple-marked-readahead-pages-v2.patch

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
From: Jan Kara <jack@suse.cz>
Subject: readahead: Avoid multiple marked readahead pages
Date: Tue, 23 Jan 2024 16:32:54 +0100

fix one more place where mark rounding was done as well

Link: https://lkml.kernel.org/r/20240123153254.5206-1-jack@suse.cz
Fixes: b9ff43dd2743 ("mm/readahead: Fix readahead with large folios")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~readahead-avoid-multiple-marked-readahead-pages-v2
+++ a/mm/readahead.c
@@ -575,7 +575,7 @@ static void ondemand_readahead(struct re
 	 * It's the expected callback index, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	expected = round_up(ra->start + ra->size - ra->async_size,
+	expected = round_down(ra->start + ra->size - ra->async_size,
 			1UL << order);
 	if (index == expected || index == (ra->start + ra->size)) {
 		ra->start += ra->size;
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-avoid-multiple-marked-readahead-pages.patch
readahead-avoid-multiple-marked-readahead-pages-v2.patch

