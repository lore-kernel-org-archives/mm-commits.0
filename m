Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7430C33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293212; cv=none; b=aXOqszKB5FpqjJMpv6r+CLh3PducDYgEZ/mHdGLoUFpR7Fni1dM683dpL3grx0ST0NwbwJEQkuDv5rKdrU/FQMOvaLWcqXsKLrPdPx8HfuJrYSJG30MgufWABKP59KZSAFer3koxavPsIb1OsqtoQPOog3CvkrzwsKwF6ni8MMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293212; c=relaxed/simple;
	bh=m4ZqD3b82UjXtFet5UxRiV0hBCCxrTbs2FZ0LxsGu8A=;
	h=Date:To:From:Subject:Message-Id; b=AcoaHuww9ahriEbr6JBvoNk1/YSQAKrCoSmoeCA+65yogJN0f+Vg1Lv3590swigfchbw0JKnYv3ArN4NvFh9sRKntY82MKw1vrKU+fPMPiQEWDEc+7djC+AyCzvWwm7UUQpy/MWgcvnm8tzp/X8Efn2oM6oFg2mCUtA2XI+uY5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JZ6R0p9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JZ6R0p9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7BCC4AF09;
	Tue, 25 Jun 2024 05:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293212;
	bh=m4ZqD3b82UjXtFet5UxRiV0hBCCxrTbs2FZ0LxsGu8A=;
	h=Date:To:From:Subject:From;
	b=JZ6R0p9/eKfOOXaWQGpsthdRDTtX67AKOIojaTJ+XUUJp7aM048oPN2pwWCFIOsVC
	 zbnId42aRYByFWaDe8YMBkHQTwMmdSWTsCt3qPY+cWxw67MjdtUaLOzbkWtOHkdPuM
	 5TU+fBHMRnQqYbRFOvBEW3uaOMeIS/cx9bR7vV08=
Date: Mon, 24 Jun 2024 22:26:51 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,haowenchao22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-remove-header-files-which-are-included-more-than-once.patch removed from -mm tree
Message-Id: <20240625052652.4A7BCC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: remove header files which are included more than once
has been removed from the -mm tree.  Its filename was
     crash-remove-header-files-which-are-included-more-than-once.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wenchao Hao <haowenchao22@gmail.com>
Subject: crash: remove header files which are included more than once
Date: Thu, 6 Jun 2024 17:14:27 +0800

Following warning is reported, so remove these duplicated header
including:

./kernel/crash_reserve.c: linux/kexec.h is included more than once.

This is just a clean code, no logic changed.

Link: https://lkml.kernel.org/r/20240606091427.3512314-1-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/crash_reserve.c~crash-remove-header-files-which-are-included-more-than-once
+++ a/kernel/crash_reserve.c
@@ -13,7 +13,6 @@
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
-#include <linux/kexec.h>
 #include <linux/kmemleak.h>
 
 #include <asm/page.h>
_

Patches currently in -mm which might be from haowenchao22@gmail.com are


