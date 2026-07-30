Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFB93191D3
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785444352; cv=none; b=Y29IfHy/Z7lWNdzCOnli0YAc6OnJjC4vvriVZFHnQvlZf6qL85Nu3+6Y7EvyOC3h5Glzol8j5AraQjGtPtXAO7TjSKmXvpzDDt5ObKGh2IfpcGgRwOwnK6Gjz/EdSfnoU7YOkQOfSHf3CGp5P3zwOIne2hr+rHXY0L/WHOQsG34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785444352; c=relaxed/simple;
	bh=tz1/dZuFuPvsTxXyg8o75SWHAS11lHI9FTMYKqCGI2M=;
	h=Date:To:From:Subject:Message-Id; b=Z7eOxJl1iMGu9cuCMLEAf7A2HkRGoQu2/7WS5Up+cK6VshjSI7K27kHC9GUMradQMKGyzKfF1g14onO3b2D/aX0b3r8JSchG22ZUYMNYG2vmH2RRo8Oty2vdTmRuD2jD+XGeaGEOgwG9jyXdI22kjR7ZK5h+oVUREyQIAQRTetw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yByPe2lG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yByPe2lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AB91F000E9;
	Thu, 30 Jul 2026 20:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785444346;
	bh=xS5bWE1h7Ba2msVVWwhRCcCSleUgc/zn6VUhvEmnKxs=;
	h=Date:To:From:Subject;
	b=yByPe2lGRHPHNuyonxmU4Y2diaWrNzGZWzfdQd6Eo7E9Q3/eFInNYbC0eGwkNAtG6
	 kLLx5+/dDLkl/wdnD5yNuKEWjzdEjJwqQ4p5ZatvwdSm3pBwhXxwncidxpE+t5a+ai
	 J/cUY0WGdWd81rv/+8jDAlAo1/uSEtm7diMEoGAQ=
Date: Thu, 30 Jul 2026 13:45:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org,warren.xiong@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-prevent-page_owner_sort-from-truncating-input.patch added to mm-nonmm-unstable branch
Message-Id: <20260730204546.39AB91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: prevent page_owner_sort from truncating input
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-mm-prevent-page_owner_sort-from-truncating-input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-prevent-page_owner_sort-from-truncating-input.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Warren Xiong <warren.xiong@ugreen.com>
Subject: tools/mm: prevent page_owner_sort from truncating input
Date: Thu, 30 Jul 2026 09:58:09 +0800

page_owner_sort opens the output file with "w" before reading the input. 
If both paths refer to the same file, this truncates the input and the
tool silently processes zero records before returning success.

Delay opening the output file until all input records have been loaded
into memory.  This allows the tool to sort a file in place without
truncating data before it has been consumed.

Link: https://lore.kernel.org/20260730015809.3819606-1-warren.xiong@ugreen.com
Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-prevent-page_owner_sort-from-truncating-input
+++ a/tools/mm/page_owner_sort.c
@@ -836,8 +836,7 @@ int main(int argc, char **argv)
 	}
 
 	fin = fopen(argv[optind], "r");
-	fout = fopen(argv[optind + 1], "w");
-	if (!fin || !fout) {
+	if (!fin) {
 		usage();
 		perror("open: ");
 		exit(1);
@@ -874,6 +873,13 @@ int main(int argc, char **argv)
 			goto out_free;
 	}
 
+	fout = fopen(argv[optind + 1], "w");
+	if (!fout) {
+		usage();
+		perror("open: ");
+		exit(1);
+	}
+
 	printf("loaded %d\n", list_size);
 
 	printf("sorting ....\n");
_

Patches currently in -mm which might be from warren.xiong@ugreen.com are

tools-mm-prevent-page_owner_sort-from-truncating-input.patch

