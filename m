Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DC523EAA5
	for <mm-commits@vger.kernel.org>; Tue,  2 Dec 2025 16:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693964; cv=none; b=ek6tt12NWpaNDPwgDg/NyyCU8SkO3eEMzmWbigYB8oIQGwNCCtrhon0KCFja5edL56syhCrIK76NT0P3PY/ZmUS2lzCgXtioum7B7DLIVI0ttriNi8s3AEV8xkdHCF16907m+LwKsgsfUzrA/7+MgrDSmEzeQSmNU+OY6J5IttE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693964; c=relaxed/simple;
	bh=iHa3wShM6ppvLhAD8hg40doZqGA050z6Dx5TlBcbikU=;
	h=Date:To:From:Subject:Message-Id; b=KqQKQ8buDwb0+DUyQY4jJs3+ILnOW+RR1ENL8d201DcH+T7yigcPCoAyhzaIS20qjIbmkhN1E2El+V+uloeJ1zszDMvlt1oM756I+TOqAcik8jpdorPpHI6rgU/dnOzrge8uf21BwOQCsIxMqBL3eOuck9hewDeMw/XtRpVmpQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QniSILtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QniSILtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011A7C4CEF1;
	Tue,  2 Dec 2025 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764693964;
	bh=iHa3wShM6ppvLhAD8hg40doZqGA050z6Dx5TlBcbikU=;
	h=Date:To:From:Subject:From;
	b=QniSILtcRPaQueJCGRQxMPPwBqsKB/qYckFhWn/Wuw0rR+odY42hD9iGIq+Kp4RaO
	 scqH3PyLyxCW8Q5x10fJv0JUyev+9zs8nzyFwPOOhZzsw48hKI/d/QD765I9I98gpQ
	 8ETDVKXIhb9SDOg8w4ADzfw7ssZ+jedyQZJtp9y4=
Date: Tue, 02 Dec 2025 08:46:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-idr-core-api-doc-file-to-xarray.patch added to mm-unstable branch
Message-Id: <20251202164604.011A7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add idr core-api doc file to XARRAY
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-idr-core-api-doc-file-to-xarray.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-idr-core-api-doc-file-to-xarray.patch

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
@@ -27880,6 +27880,7 @@ M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Supported
+F:	Documentation/core-api/idr.rst
 F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
 F:	include/linux/xarray.h
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

mm-fix-config-option-typo-in-header-file.patch
maintainers-add-idr-core-api-doc-file-to-xarray.patch

