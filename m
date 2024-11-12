Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C436205121
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374585; cv=none; b=uerpYVvSXISvVknVSTuqsLJAAXfSCLglwilyxd6uUPQRylkOMaw6cW8V/QD8h1pWIIF8qSUMgG9ltJGrkwgQ7jYd0M+nyiqrfvalQuETeMMrjFBcodVadL6DDHzM5RMqIdDefg+nl/Dznm+cKDPGmSiCSPiSaAKuNi1C5jF18fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374585; c=relaxed/simple;
	bh=mPUgOtjU7fsF6Nrjhd0fCZfDu8vu3uMKNyu7LZKE1Po=;
	h=Date:To:From:Subject:Message-Id; b=WR0llqTJsZWIGGLMp+bHJ3l1uEv4bLo+47CmMVDvZO0J6IgoyuCag+dz7DpWIk/jQNewe61coyJcHSCX/WlCKIBT6OaksV4QqcxoyF+rSt1nSZ7V22FScCWNtYr60JFyaCnaoFfWkO4fmulLellpX1vBvyLiXof83zAH4G1DLsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mCrIiysV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mCrIiysV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69B0C4CECF;
	Tue, 12 Nov 2024 01:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374585;
	bh=mPUgOtjU7fsF6Nrjhd0fCZfDu8vu3uMKNyu7LZKE1Po=;
	h=Date:To:From:Subject:From;
	b=mCrIiysVX4hyjq1UnJrGuUl7dIt3WICKU7R9VtiBU9/E4+CbuMlvbuucY6OpEn6GE
	 ROtNYaMejx45ogQU/c+bJ9LQfBVfF1eW6J6kbQ5dEfqXWpHOBIOlJFkjV8C7d+rYV1
	 2JlokBeKQo2A9KvfLKPOhFq9FSOLWFNDMg7PyGiU=
Date: Mon, 11 Nov 2024 17:23:04 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch removed from -mm tree
Message-Id: <20241112012304.E69B0C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon: recommend academic papers to read and/or cite
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon: recommend academic papers to read and/or cite
Date: Fri, 1 Nov 2024 13:35:57 -0700

Kernel documentation is the most up-to-date and recommended resource for
DAMON.  It doesn't cover non-kernel part of the entire project[1], though.
Also it is not optimum for formal long-term citations.  Depending on
cases, DAMON academic papers[2,3] could be better to be read and cited. 
However, there is no clear guidance for those.  Add a paragraph for DAMON
academic papers on the kernel documentation for DAMON.

[1] https://damonitor.github.io
[2] https://dl.acm.org/doi/abs/10.1145/3366626.3368125
[3] https://dl.acm.org/doi/abs/10.1145/3502181.353146

Link: https://lkml.kernel.org/r/20241101203557.55210-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/index.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-recommend-academic-papers-to-read-and-or-cite
+++ a/Documentation/mm/damon/index.rst
@@ -37,3 +37,9 @@ with no code but simple configurations.
 
 To utilize and control DAMON from the user-space, please refer to the
 administration :doc:`guide </admin-guide/mm/damon/index>`.
+
+If you prefer academic papers for reading and citations, please use the papers
+from `HPDC'22 <https://dl.acm.org/doi/abs/10.1145/3502181.3531466>`_ and
+`Middleware19 Industry <https://dl.acm.org/doi/abs/10.1145/3366626.3368125>`_ .
+Note that those cover DAMON implementations in Linux v5.16 and v5.15,
+respectively.
_

Patches currently in -mm which might be from sj@kernel.org are


