Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7A306B09
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308391; cv=none; b=mU+4TI82pknWUH4nXQ3EGZ+0D2emAWEKRiFh/4g84F4To0xSdkfrxWmLSNZ7sFpSUXvHzJKWN7lzV5u/5fOAFA7cH3nKWjJMnK01FF3T6KlFLfFEHh+b/9NeO1E0GAUsIxAzmpFnZvHXaAxZmThdL2cVe+ZSi4xaBxzFsZuPMEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308391; c=relaxed/simple;
	bh=2yOfHxVz+UWK8n9P0gDqQFCCGwPW6xSogw5bwXsrD90=;
	h=Date:To:From:Subject:Message-Id; b=tPfWV4bDeWjVBIqkA+rbiJLRj/W6MUEdVMBfwiRqhJEbmML2VpRd8IkyGyU4d5zxu7A3O0E5y3wiS7foUMrbO/G+pCRoDNjpALrNKml/Zkgf1D+nTe2BoUTvVjGZuCfhPKK38QgHokgwr4mpPl+chBMhE7vM+bhFjnkq6VjB7vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W7DyYhLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W7DyYhLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F41EC4CEF5;
	Tue,  9 Dec 2025 19:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308390;
	bh=2yOfHxVz+UWK8n9P0gDqQFCCGwPW6xSogw5bwXsrD90=;
	h=Date:To:From:Subject:From;
	b=W7DyYhLDfDeWN5R/aWg+s3LElZFAbFfPRzqhH/9zROIvR1t7YUV1mCM07eGt/jh2K
	 VkW1f9o+EchfFmA7sSmUBpbt2TWTYtEG1NH30GjzC4jcUCW4cIKlyNa2RXqeJzMshA
	 xJxGZoeawZCls7lba1AwY/K/t1S9XB3HtqkhJ2Xs=
Date: Tue, 09 Dec 2025 11:26:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-idr-core-api-doc-file-to-xarray.patch removed from -mm tree
Message-Id: <20251209192630.9F41EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add idr core-api doc file to XARRAY
has been removed from the -mm tree.  Its filename was
     maintainers-add-idr-core-api-doc-file-to-xarray.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: MAINTAINERS: add idr core-api doc file to XARRAY
Date: Wed, 5 Nov 2025 11:58:57 +0100

The files in Documentation/core-api/ are by virtue of their top-level
directory part of the Documentation section in MAINTAINERS.  Each file in
Documentation/core-api/ should however also have a further section in
MAINTAINERS it belongs to, which fits to the technical area of the
documented API in that file.

idr.rst provides some explanation to the ID allocation API defined in
lib/idr.c, which itself is part of the XARRAY section.

Add this core-api document to XARRAY.

Link: https://lkml.kernel.org/r/20251105105857.156950-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-idr-core-api-doc-file-to-xarray
+++ a/MAINTAINERS
@@ -27879,6 +27879,7 @@ M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Supported
+F:	Documentation/core-api/idr.rst
 F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
 F:	include/linux/xarray.h
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are


