Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B368323D3ED
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837085; cv=none; b=tLgqjI+KmRE4XP003XMLjzB4GSvNPodrSv8QT//sNIcbFubkLBqxOP1GpDf/tFzm+Fr62ETamLjklaUtjSD+rjxU0fXjJkayQe5iXRz+ybaNhmwwmkW7n9AoCLlRq4llZ+hcsE7CXCOOIy19a0ZDqFx7BEzgtuKCXoxFWMBDOeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837085; c=relaxed/simple;
	bh=6E4fsmONVSzDOY72hXcLawziQimS9LWPYwi7sG0gtFU=;
	h=Date:To:From:Subject:Message-Id; b=GAzo/cVei1gMh8xtopC/nDqotcH63JTKR5Ojt65pTO87rGvZ2pP6fgMw2uASXCKghUeyeipRIpy50o+n2ZB1KThLWPkAwl7P0mclMp7wnnF/Qc+hNEcpVI69pwh/oZc9qmsMjAgMHOOede3Br1UlhEU57qEWqsXkq2R70V7iBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fac/PN37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fac/PN37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8012DC4CEDD;
	Tue, 14 Jan 2025 06:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837085;
	bh=6E4fsmONVSzDOY72hXcLawziQimS9LWPYwi7sG0gtFU=;
	h=Date:To:From:Subject:From;
	b=Fac/PN37nbdfMNfJMBl+WjjWM91FwPskcbRti7jex0YjgX8D/qzWoGZJGBi62U25v
	 oYxdDzk91UP5ulXXWUMML+1B10C1V5xbSj7Ca5LZ9XevoEnFaTw2p3jvOprlMFpmyr
	 nlz12jtVcq1NEDonoNYSxZF+DVWHmsJYjQCHM2F4=
Date: Mon, 13 Jan 2025 22:44:44 -0800
To: mm-commits@vger.kernel.org,leocstone@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memoryc-rename-shadowed-local.patch removed from -mm tree
Message-Id: <20250114064445.8012DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory.c: rename shadowed local
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-rename-shadowed-local.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/huge_memory.c: rename shadowed local
Date: Sun Dec 15 09:44:47 PM PST 2024

split_huge_pages_write() has a lccal `buf' which shadows incoming arg
`buf'.  Reviewer confusion resulted.  Rename the inner local to `tok_buf'.

Cc: Leo Stone <leocstone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-rename-shadowed-local
+++ a/mm/huge_memory.c
@@ -4181,20 +4181,21 @@ static ssize_t split_huge_pages_write(st
 
 	if (input_buf[0] == '/') {
 		char *tok;
-		char *buf = input_buf;
+		char *tok_buf = input_buf;
 		char file_path[MAX_INPUT_BUF_SZ];
 		pgoff_t off_start = 0, off_end = 0;
 		size_t input_len = strlen(input_buf);
 
-		tok = strsep(&buf, ",");
-		if (tok && buf) {
+		tok = strsep(&tok_buf, ",");
+		if (tok && tok_buf) {
 			strscpy(file_path, tok);
 		} else {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		ret = sscanf(buf, "0x%lx,0x%lx,%d", &off_start, &off_end, &new_order);
+		ret = sscanf(tok_buf, "0x%lx,0x%lx,%d", &off_start,
+			    &off_end, &new_order);
 		if (ret != 2 && ret != 3) {
 			ret = -EINVAL;
 			goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch

