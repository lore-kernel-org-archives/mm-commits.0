Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E911FBEA2
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282438; cv=none; b=idScS68+LsYo7aOgUrzHZAVJLmUnS4a9asXuKThSo0+T+CuS8hYJkYmc/DoUZIfhwXyKsbDmIsYvjN6qRNAJZsJ7YUqPJGzpj5fzl4+XSxgZqd3E8W1vBdCwjv4KNqITQg6xrSWl/bL7bDeZ+tb6wrxNGrhKC1C1PqvVH7n64Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282438; c=relaxed/simple;
	bh=SST2ZLnIDkpyDP0pdtYvqjGwmIHyUZnFGFZ/JwecFsc=;
	h=Date:To:From:Subject:Message-Id; b=ItALIRnzzk08tsA0mgt/LvgLJqXjFXGC2r1p1rUtlChpBdQMZl5QDxCvdvmvxNC8/Vg2rWD4ibThNz8DPTPpqAu3yy7dp7FIIhiE9e5WOq1y2Nd6hxlJ31f+BoIdwQvkwTMQo9n7axSTToXDsqa6ZMwOcSXP8f7g8SYQl8SDP7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=alViDBZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="alViDBZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D504C4CEF8;
	Thu, 27 Nov 2025 22:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282438;
	bh=SST2ZLnIDkpyDP0pdtYvqjGwmIHyUZnFGFZ/JwecFsc=;
	h=Date:To:From:Subject:From;
	b=alViDBZssmkgSbOJHS/ygU8FIbou689O2l64VG1U1BxOZCb/a4nfy9FXoUEh4S/vI
	 xqXbOMetIIDBxi7yTPVU3WnClTy3EYzP7eN618bVz/ozHmj6QorQr0FYO/ufvW9mR1
	 +k4fL+28bNsoTbFQO5EpWoy0hIawhg3KRE8rFl98=
Date: Thu, 27 Nov 2025 14:27:17 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,brauner@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup.patch removed from -mm tree
Message-Id: <20251127222718.5D504C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: replace simple_strtoul with kstrtoul to improve lpj_setup
has been removed from the -mm tree.  Its filename was
     init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: init: replace simple_strtoul with kstrtoul to improve lpj_setup
Date: Sat, 22 Nov 2025 12:45:37 +0100

Replace simple_strtoul() with the recommended kstrtoul() for parsing the
'lpj=' boot parameter.

Check the return value of kstrtoul() and reject invalid values.  This adds
error handling while preserving existing behavior for valid values, and
removes use of the deprecated simple_strtoul() helper.

Link: https://lkml.kernel.org/r/20251122114539.446937-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/calibrate.c~init-replace-simple_strtoul-with-kstrtoul-to-improve-lpj_setup
+++ a/init/calibrate.c
@@ -14,10 +14,10 @@
 
 unsigned long lpj_fine;
 unsigned long preset_lpj;
+
 static int __init lpj_setup(char *str)
 {
-	preset_lpj = simple_strtoul(str,NULL,0);
-	return 1;
+	return kstrtoul(str, 0, &preset_lpj) == 0;
 }
 
 __setup("lpj=", lpj_setup);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


