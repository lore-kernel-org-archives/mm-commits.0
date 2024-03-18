Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB2258201
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710789749; cv=none; b=pw4Kro6BeBOUaBbIc6PCo3kuCOsEJEBTQ3LLblCeQLduRiTntYe2ktEudNLlo4ex4hDtcqnVlU9XTbu5SbniJHkac7ccAR347qpNbFzu2q5tPhteD6HFUIt42ZE6sT1AmP5DDMwDXrqh7JegGcsEI/J73mEBsOV5uc7fHACOM7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710789749; c=relaxed/simple;
	bh=4hOJjMbhZaJUA+KHw1qfM/SAD+b3RSrXrX+QwFtlUI4=;
	h=Date:To:From:Subject:Message-Id; b=oFogqpb/tS6XUfzAbLrLEBd2rNeXT58rcBpWdhs+CPS1khblcnMTQM/I3K3gkrWNw/WUlxkUqDIyibYx0PST9/cYyEEePrSCxOQZTdshv4Apm7vcR74V2WUOXjqR1M9XMvsvOjYbYP7Jh5szGTRkF+KgBp46kX5F0JDpJQYbCC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s2aTrHL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s2aTrHL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37074C433F1;
	Mon, 18 Mar 2024 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710789749;
	bh=4hOJjMbhZaJUA+KHw1qfM/SAD+b3RSrXrX+QwFtlUI4=;
	h=Date:To:From:Subject:From;
	b=s2aTrHL8r26SNCZeTmau4tw4WoRSGYJARkdX6zOXI8tCQ2GS1LTgUwYtMGHFd8RaG
	 SmGuwuljc4ixk8duE4Xpzg12LHh1fGjws4YUVmoCRGjh7PtgHwS/5ZlK6Uw0M8yMeU
	 kKyDScZ6+bM2C2erClrUQ0XgER/rwYE/zcnyMw+o=
Date: Mon, 18 Mar 2024 12:22:28 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,oliver.sang@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-increase-folio-batch-size.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318192229.37074C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: increase folio batch size
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-increase-folio-batch-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-increase-folio-batch-size.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: increase folio batch size
Date: Fri, 15 Mar 2024 14:08:21 +0000

On a 104 thread, 2 socket Skylake system, Intel report a 4.7% performance
reduction with will-it-scale page_fault2.  This was due to reducing the
size of the batch from 32 to 15.  Increasing the folio batch size from 15
to 31 gives a performance increase of 12.5% relative to the original, or
17.2% relative to the reduced performance commit.

The penalty of this commit is an additional 128 bytes of stack usage.  Six
folio_batches are also allocated from percpu memory in cpu_fbatches so
that will be an additional 768 bytes of percpu memory (per CPU).  Tim Chen
originally submitted a patch like this in 2020:
https://lore.kernel.org/linux-mm/d1cc9f12a8ad6c2a52cb600d93b06b064f2bbc57.1593205965.git.tim.c.chen@linux.intel.com/

Link: https://lkml.kernel.org/r/20240315140823.2478146-1-willy@infradead.org
Fixes: 99fbb6bfc16f ("mm: make folios_put() the basis of release_pages()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Yujie Liu <yujie.liu@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202403151058.7048f6a8-oliver.sang@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/pagevec.h~mm-increase-folio-batch-size
+++ a/include/linux/pagevec.h
@@ -11,8 +11,8 @@
 
 #include <linux/types.h>
 
-/* 15 pointers + header align the folio_batch structure to a power of two */
-#define PAGEVEC_SIZE	15
+/* 31 pointers + header align the folio_batch structure to a power of two */
+#define PAGEVEC_SIZE	31
 
 struct folio;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch

