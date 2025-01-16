Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77BE155756
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 22:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737065682; cv=none; b=FFHoqsyEDhPV4teLt2CeK6nZo5B9F0IeXJnxb3D5Wh5z6DIRv1p08xHeNz9VogjgNoxMZtOlNCCp+GpI/+GNe7GIatQyv7dWQyX8pZS51v4rL8673LRPVLT51eYWVHjA883oYUuTquBw77pclGfXSRAdxlzGS4RjqczLTvMzRxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737065682; c=relaxed/simple;
	bh=4mOhI+340GUTr+0zKIRsCrXcxnmu4JlxomSBeemxqXw=;
	h=Date:To:From:Subject:Message-Id; b=miz+5rqpPkPuCSK8nGPrWiUiYYsujt/Qos4R3S5QXiG44llmWxhog8LRjZwdZWUPalPMtX5yncCvlt+DTiT7BYGcgJsyHWt6/XbnoAaDfW0naRNnvd33/oLUdyTMZvdibJsBgqUaUCcwQnmJ00qWCoxnNcNlUv/DHgdq0Dwi7jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lOV4qxtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lOV4qxtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA3FC4CED6;
	Thu, 16 Jan 2025 22:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737065682;
	bh=4mOhI+340GUTr+0zKIRsCrXcxnmu4JlxomSBeemxqXw=;
	h=Date:To:From:Subject:From;
	b=lOV4qxtloQIyoVkDj9ZrHKTIPnTqV+K26Y7NqDuMWe3q/B0rR28/Ik2Gjb2Ic5+rW
	 Au4v3/QEvK2oja/0L6l+fDy2wVPH9rC2wsd5r+ujj/F26pfG5zLYSFwGSEf17YghMi
	 wxmN2OQegqMib2uniN9b67tsJJHjiGXpCDOBEMFc=
Date: Thu, 16 Jan 2025 14:14:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch added to mm-unstable branch
Message-Id: <20250116221442.4AA3FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: use str_high_low() helper in damos_wmark_wait_us()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/damon/core: use str_high_low() helper in damos_wmark_wait_us()
Date: Thu, 16 Jan 2025 21:42:16 +0100

Remove hard-coded strings by using the str_high_low() helper function.

Link: https://lkml.kernel.org/r/20250116204216.106999-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us
+++ a/mm/damon/core.c
@@ -14,6 +14,7 @@
 #include <linux/psi.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -2075,9 +2076,8 @@ static unsigned long damos_wmark_wait_us
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
 		if (scheme->wmarks.activated)
 			pr_debug("deactivate a scheme (%d) for %s wmark\n",
-					scheme->action,
-					metric > scheme->wmarks.high ?
-					"high" : "low");
+				 scheme->action,
+				 str_high_low(metric > scheme->wmarks.high));
 		scheme->wmarks.activated = false;
 		return scheme->wmarks.interval;
 	}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch
mm-kfence-use-str_write_read-helper-in-get_access_type.patch
mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch

