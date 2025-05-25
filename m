Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50348FC1D;
	Sun, 25 May 2025 07:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159662; cv=none; b=FXZG/JOpNyV+Q3dGLERYFbbScSWgGwRd1w/VoUXEfjRHlGHygbHRSQzpeFoD5OuoeWFO+fKGEE8XC8iOI63QnzCKXSG+zbWkPM3CjWQgvYpj3Ys9i4qgn4o5xMh/uE3EPGqjJXA2TGbsIv5zO1FwO+Cy0HB44IQ0l48OCjWzhaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159662; c=relaxed/simple;
	bh=3h5NFni8rLfHSyxuQHOpPLd+4LaDfPatYXssy4152t8=;
	h=Date:To:From:Subject:Message-Id; b=r0PVlhCoS5wIQBF1/jcytQ74dG/G32gbsu4j2Vbo83g2W1hjM38paWeMgWLl8P5sF9o3DcHRvgraDVxUVUjMAHveFmugce+D1BKebutr/93Ll3iNtMlKore9PXIWs4+wh0gNMzTSuc/67LpmxmN9fZMgoi81MlveFTGmJc+uPZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XZk5x/K0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XZk5x/K0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF5C4CEF0;
	Sun, 25 May 2025 07:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748159661;
	bh=3h5NFni8rLfHSyxuQHOpPLd+4LaDfPatYXssy4152t8=;
	h=Date:To:From:Subject:From;
	b=XZk5x/K0d4a5aL3zySzMhwq1n8QXcjtgwrb2gRWgCRSiGeAAIWDhEqtcMz8KBeefX
	 vm1FgKCBQRLE863Z5N6ZZCPDIjrCUvc4q/nO1916ujvOrMiIY7c+a6cCLoAmTKnj1K
	 3UJcQoWGHNcAKGTnvR9cRPaFJiL6qaMvqfaNloYU=
Date: Sun, 25 May 2025 00:54:21 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,petr.pavlu@suse.com,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] module-release-codetag-section-when-module-load-fails.patch removed from -mm tree
Message-Id: <20250525075421.B7BF5C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: module: release codetag section when module load fails
has been removed from the -mm tree.  Its filename was
     module-release-codetag-section-when-module-load-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Wang <00107082@163.com>
Subject: module: release codetag section when module load fails
Date: Tue, 20 May 2025 00:38:23 +0800

When module load fails after memory for codetag section is ready, codetag
section memory will not be properly released.  This causes memory leak,
and if next module load happens to get the same module address, codetag
may pick the uninitialized section when manipulating tags during module
unload, and leads to "unable to handle page fault" BUG.

Link: https://lkml.kernel.org/r/20250519163823.7540-1-00107082@163.com
Fixes: 0db6f8d7820a ("alloc_tag: load module tags into separate contiguous memory")
Closes: https://lore.kernel.org/all/20250516131246.6244-1-00107082@163.com/
Signed-off-by: David Wang <00107082@163.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/module/main.c~module-release-codetag-section-when-module-load-fails
+++ a/kernel/module/main.c
@@ -2829,6 +2829,7 @@ static void module_deallocate(struct mod
 {
 	percpu_modfree(mod);
 	module_arch_freeing_init(mod);
+	codetag_free_module_sections(mod);
 
 	free_mod_mem(mod);
 }
_

Patches currently in -mm which might be from 00107082@163.com are


