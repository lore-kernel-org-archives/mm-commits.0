Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF2C1B424F
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 01:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772069413; cv=none; b=Gk9UQohxcHvSrhm/1rwQdRoYLvn79JPxWb7i5UQO+qAqsARdKfJEyyOXowj6Dquwg2uBgHc5zbXmHfWkln+tAl5wQFCahJqsd7cA1F4PpfgkSTKql96PTBBCeac/oZAj4YF69DSKrErvOHW9S1C73p3svb8wPM2Kgaxa8SwgCp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772069413; c=relaxed/simple;
	bh=V9atTxBnlX5ekhZOEA7pUjOkrJoGXKn3zT3nUPW14xQ=;
	h=Date:To:From:Subject:Message-Id; b=YSrYV1XPgf0gnqpmrwq/MTtxpUN81ANcP5/hhMo+dE3O8CH8VMyY4gk56a9l21CeDtQszTko8lcwippAnfXHxQsev90xpNMhX+aB9xrLYk3JRr0bVpfVEhDP1mwS7NBgaOysECNckeZ2F/16ngHu8jyi/XQUiV3z9IGnUlycvhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n0Do9SOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n0Do9SOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416F4C116D0;
	Thu, 26 Feb 2026 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772069413;
	bh=V9atTxBnlX5ekhZOEA7pUjOkrJoGXKn3zT3nUPW14xQ=;
	h=Date:To:From:Subject:From;
	b=n0Do9SOwhM3t2/aHjjiEuKgXrFAtlfdx1BgDJJiNL8tLWI2hy3YpYL4mxAwHe5tqL
	 R4FqSblX2kMrlfjttiVoC3eZq/4dj/YzEEx6eDENQxInEGJYdFT5R4ZADk8KL9t8NJ
	 3PiwrIkGLNEsk2qW2KQeH0RzdRynajfB7dx+q6fY=
Date: Wed, 25 Feb 2026 17:30:12 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-reviewer-for-swap.patch added to mm-unstable branch
Message-Id: <20260226013013.416F4C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Youngjun Park as reviewer for SWAP
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-myself-as-reviewer-for-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-reviewer-for-swap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: MAINTAINERS: add Youngjun Park as reviewer for SWAP
Date: Thu, 26 Feb 2026 10:07:39 +0900

Recently, I have been actively contributing to the swap subsystem through
works such as swap-tier patches and flash friendly swap proposal.  During
this process, I have consistently reviewed swap table code, some other
patches and fixed several bugs.

As I am already CC'd on many patches and maintaining active interest in
ongoing developments, I would like to officially add myself as a reviewer.
I am committed to contributing to the kernel community with greater
responsibility.

Link: https://lkml.kernel.org/r/20260226010739.3773838-1-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-reviewer-for-swap
+++ a/MAINTAINERS
@@ -16913,6 +16913,7 @@ R:	Kemeng Shi <shikemeng@huaweicloud.com
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
+R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
_

Patches currently in -mm which might be from youngjun.park@lge.com are

maintainers-add-myself-as-reviewer-for-swap.patch

