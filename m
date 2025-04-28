Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A1D1E4BE
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 23:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745882226; cv=none; b=DLgrCq4uLS4A7TRu2gWkWZbM0I+fNclbWbiFxFCR0xgnY+irBccJltxMsXCwAeyY73RtuHaLCUm7TcycAb8DbOv1epBnQdgWGE3gxYfn+uFzNgqZKsoBDEzyjHyf3NnOsby7cgm7dteBtjw/bBT2SS899yzWA9sJHhijtwyBXKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745882226; c=relaxed/simple;
	bh=dfuUZk/k0N/vYmRYFZI45TM+FTUc2qrYaDLif/JCBHk=;
	h=Date:To:From:Subject:Message-Id; b=WHIGPWodA/a2nNeAfaovnX1LtUPRyvDSE3kLKciW28+fNuAeFWBRCtQYXY5xbztuXaI7wfFG0IgWLUozefdtC6NeE/Rz7qh02c8+x6WZLSqnHeOd/Y62qWwrtNEse9JNPOlAP+NkHDESxfscE6IGFOX1ZULqIIWu0ImHXEHqtLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=le9+5AGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="le9+5AGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33024C4CEE4;
	Mon, 28 Apr 2025 23:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745882226;
	bh=dfuUZk/k0N/vYmRYFZI45TM+FTUc2qrYaDLif/JCBHk=;
	h=Date:To:From:Subject:From;
	b=le9+5AGexYDX/uGFGAkMZXy0uwOgcxFccwjlkg5tSn7VYvlkKdn3sWIisbJQgXm2E
	 pYXnjCg0+fxKVOdqJ6XQza4ESnek4FGSoiIiBUsbgF1mS50vhs8yCrcCy6E5zw19pn
	 hPAgYudlo/k3KmSgGIDT5hfmQQsaFh3xurqc2azE=
Date: Mon, 28 Apr 2025 16:17:05 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,pasha.tatashin@soleen.com,andreyknvl@gmail.com,trintaeoitogc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags.patch added to mm-new branch
Message-Id: <20250428231706.33024C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page-flags-layout.h: change the KASAN_TAG_WIDTH for HW_TAGS
has been added to the -mm mm-new branch.  Its filename is
     mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: mm: page-flags-layout.h: change the KASAN_TAG_WIDTH for HW_TAGS
Date: Mon, 28 Apr 2025 17:14:09 -0300

KASAN_TAG_WIDTH is 8 bits for both (HW_TAGS and SW_TAGS), but for HW_TAGS
the KASAN_TAG_WIDTH can be 4 bits bits because due to the design of the
MTE the memory words for storing metadata only need 4 bits.  Change the
preprocessor define KASAN_TAG_WIDTH for check if SW_TAGS is define, so
KASAN_TAG_WIDTH should be 8 bits, but if HW_TAGS is define, so
KASAN_TAG_WIDTH should be 4 bits to save a few flags bits.

Link: https://lkml.kernel.org/r/20250428201409.5482-1-trintaeoitogc@gmail.com
Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags-layout.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags-layout.h~mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags
+++ a/include/linux/page-flags-layout.h
@@ -72,8 +72,10 @@
 #define NODE_NOT_IN_PAGE_FLAGS	1
 #endif
 
-#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+#if defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_TAG_WIDTH 8
+#elif defined(CONFIG_KASAN_HW_TAGS)
+#define KASAN_TAG_WIDTH 4
 #else
 #define KASAN_TAG_WIDTH 0
 #endif
_

Patches currently in -mm which might be from trintaeoitogc@gmail.com are

mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags.patch

