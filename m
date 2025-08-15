Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD81E191
	for <mm-commits@vger.kernel.org>; Fri, 15 Aug 2025 00:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755218623; cv=none; b=L+Nfpg8lS529F86JwPtf9G7bxOOeG7VW2/dqiqy7Al08ZRoWavI/98VgIGw2GlnAi5GE7KPiIMDionsJL0+UGIhAiuMb1OJV5Sl60tegOx6ek8kE6cKHqspFiStyHrRhtE7ec2nLkE3lg1n47yYPnPKwwMAer5IOXiTLzNsyXaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755218623; c=relaxed/simple;
	bh=ZkivN9FRJZXXX+ZmNwuRp4KJliGzQIfm8SMblKw55No=;
	h=Date:To:From:Subject:Message-Id; b=aUiJyUSz+TQ1mIyBYoW/jERIs12oeTuJ2F9bqmspy9imzDgG9v5bF2lr1Z6tzF6r7Z1B8w6cMRBjsPbrb1UmELRYLlHpI8vYYbgCqFEFV30iUrOylqem8lOeHeO7kAOTwFmSGmeHANyTVNt9KkKJ3hrIKGA90gzPIfez65gsQhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJ51VFxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJ51VFxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4125EC4CEED;
	Fri, 15 Aug 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755218623;
	bh=ZkivN9FRJZXXX+ZmNwuRp4KJliGzQIfm8SMblKw55No=;
	h=Date:To:From:Subject:From;
	b=nJ51VFxzVtSoTpo5oVe31g8QppMVz86H4ahokEUE4NG36VyQygnZ5Z/sIw2Cu7ST0
	 L/KqjjN5lmx3DUbboOztHoecGOqJr9W4azwRU1FpMMPTdGZrxR6qUCyO254PiHy7wH
	 4gsU11Q5ClCNuV4D7xgMTQqvSJLWYHWeuzZ2u0J8=
Date: Thu, 14 Aug 2025 17:43:42 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-use-str_on_off-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20250815004343.4125EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: use str_on_off() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     alloc_tag-use-str_on_off-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-use-str_on_off-helper.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: alloc_tag: use str_on_off() helper
Date: Thu, 14 Aug 2025 17:38:27 +0800

Replace the ternary (enable ?  "on" : "off") with the str_on_off() helper
from string_choices.h.  This improves readability by replacing the
three-operand ternary with a single function call, ensures consistent
string output, and allows potential string deduplication by the linker,
resulting in a slightly smaller binary.

Link: https://lkml.kernel.org/r/20250814093827.237980-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-use-str_on_off-helper
+++ a/lib/alloc_tag.c
@@ -9,6 +9,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
+#include <linux/string_choices.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
 
@@ -726,7 +727,7 @@ static int __init setup_early_mem_profil
 		}
 		mem_profiling_support = true;
 		pr_info("Memory allocation profiling is enabled %s compression and is turned %s!\n",
-			compressed ? "with" : "without", enable ? "on" : "off");
+			compressed ? "with" : "without", str_on_off(enable));
 	}
 
 	if (enable != mem_alloc_profiling_enabled()) {
_

Patches currently in -mm which might be from visitorckw@gmail.com are

test_firmware-use-str_true_false-helper.patch
alloc_tag-use-str_on_off-helper.patch

