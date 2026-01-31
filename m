Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA74438A9C0
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898347; cv=none; b=MrNpOPhAbV2TBs/9Z1A+rI/5NRnT4+FWkI0pAFbczOgCXppFZBW0zmOSYu18idFZsPuYX1EWgQVeD3TcT/YvkixjVMsUmz/yChihgfjCJq1vp9X568L78eQon2MVGXmzdqaVW2V95kRrte2ioNTnqVkcWGObS8OtUQSgpFQCHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898347; c=relaxed/simple;
	bh=DXTx1ZfTsfLwFJHPV7dfHyJVMYjGJtZeg2EbDN0kFiw=;
	h=Date:To:From:Subject:Message-Id; b=rf/FdcyycsYexsLenUMFE4+caB4H+lYXVmbpE3x4dr+WCQVzwYwALHhmmY+MntVX07O0wQiluzavdSbHf1JHfxd4DZKSnVTVPHadP/PwFmBKcVEA81968X674OUsdNa2HqfKWVabNekRbtLz1Etn1dBtaiAaYQldB2izuI3yZ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y5GEeofV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y5GEeofV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1179C4CEF1;
	Sat, 31 Jan 2026 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898346;
	bh=DXTx1ZfTsfLwFJHPV7dfHyJVMYjGJtZeg2EbDN0kFiw=;
	h=Date:To:From:Subject:From;
	b=y5GEeofVi1m56oIEoBYKQPjtcoH1D4z9nUbrGHIOseQwXKwBXhHZV1K/8dUv8MuT6
	 LD/WpMmHAr+bXREeTgw+VSPzPxGz2FGi3gqUBBEa5dXMwkgngC1PvgN/6lnLxPwYJK
	 rbOu2BvJQSyPa3AOVNgfxQ/9QzaZQ7uo2azZe8gQ=
Date: Sat, 31 Jan 2026 14:25:46 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-link-repology-instead-of-fedora-package.patch removed from -mm tree
Message-Id: <20260131222546.C1179C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: link repology instead of Fedora package
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-link-repology-instead-of-fedora-package.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: link repology instead of Fedora package
Date: Sun, 18 Jan 2026 10:02:53 -0800

The document is introducing Fedora as one way to get DAMON user-space tool
(damo) from OS-providing packaging system.  Linux distros more than Fedora
are providing damo with their packaging systems, though.  Replace the
Fedora part with the repology.org page that shows damo packaging status
for multiple Linux distros.

Link: https://lkml.kernel.org/r/20260118180305.70023-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-link-repology-instead-of-fedora-package
+++ a/Documentation/mm/damon/design.rst
@@ -809,8 +809,8 @@ The ABIs are designed to be used for use
 rather than human beings' fingers.  Human users are recommended to use such
 user space tools.  One such Python-written user space tool is available at
 Github (https://github.com/damonitor/damo), Pypi
-(https://pypistats.org/packages/damo), and Fedora
-(https://packages.fedoraproject.org/pkgs/python-damo/damo/).
+(https://pypistats.org/packages/damo), and multiple distros
+(https://repology.org/project/damo/versions).
 
 Currently, one module for this type, namely 'DAMON sysfs interface' is
 available.  Please refer to the ABI :ref:`doc <sysfs_interface>` for details of
_

Patches currently in -mm which might be from sj@kernel.org are


