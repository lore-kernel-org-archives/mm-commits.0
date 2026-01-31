Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C138B7D6
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898350; cv=none; b=r/icQBwI7/Yl5ntOUVyMUnH52orkBNkhxbOTvkYhks/7MB1xksRWe/2C+jgQ1V7PWXbgsXUQ/cAFURC4RRfjin0v9lC1CiYJTnI3uCec6RfQEgFBg9nH936JZCF2WZkkIQ4XOfr1baRzh3U6jyHXicC9gCqQAAXrfKUmi2fVBho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898350; c=relaxed/simple;
	bh=uaAkiavXYpesbGfCOb8LZAQEk2nGlTLfGyWWEsV/3yc=;
	h=Date:To:From:Subject:Message-Id; b=NPch9U4JGAnEJpixlt/YyUuX9wZwM3XwVigWafXlnNRubrycdDtY897vEkHVMSrfmW2Rh2Da1R7XhgXcGBbFFVwK1LpT2bqYY6NSgd+gxMFP1dS7TKmO8syJPfWVe9dBHarZ0JJI01/Ah2I5vfclHmZ96eKE9AFUzx/ZKjwQcUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EoDwWS+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoDwWS+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D860C116D0;
	Sat, 31 Jan 2026 22:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898350;
	bh=uaAkiavXYpesbGfCOb8LZAQEk2nGlTLfGyWWEsV/3yc=;
	h=Date:To:From:Subject:From;
	b=EoDwWS+viKwhR3/Z85yqcOUkAiUWYg+gfpWOqCkqvwslA+bkW2xiV+Fb4zd3RT0jz
	 5Xc/s4nc6GD08JaHdXDCIs+GW5BdUziDV00/HsSHytJA17t4wb7G2tysL2hgjalxM2
	 KC37Xt9emat3IE3BqDULLxBQ4sKZoRQmfyYc5Rtg=
Date: Sat, 31 Jan 2026 14:25:49 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch removed from -mm tree
Message-Id: <20260131222550.5D860C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: introduce DAMON modules at the beginning
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: introduce DAMON modules at the beginning
Date: Sun, 18 Jan 2026 10:02:56 -0800

DAMON usage document provides a list of available DAMON interfaces with
brief introduction at the beginning of the doc.  The list is missing DAMON
modules for special purposes, while it is one of the major suggested
interfaces.  Add an item for those to the list.

Link: https://lkml.kernel.org/r/20260118180305.70023-6-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/usage.rst |    5 +++++
 Documentation/mm/damon/design.rst            |    2 ++
 2 files changed, 7 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -6,6 +6,11 @@ Detailed Usages
 
 DAMON provides below interfaces for different users.
 
+- *Special-purpose DAMON modules.*
+  :ref:`This <damon_modules_special_purpose>` is for people who are building,
+  distributing, and/or administrating the kernel with special-purpose DAMON
+  usages.  Using this, users can use DAMON's major features for the given
+  purposes in build, boot, or runtime in simple ways.
 - *DAMON user space tool.*
   `This <https://github.com/damonitor/damo>`_ is for privileged people such as
   system administrators who want a just-working human-friendly interface.
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning
+++ a/Documentation/mm/damon/design.rst
@@ -817,6 +817,8 @@ available.  Please refer to the ABI :ref
 the interfaces.
 
 
+.. _damon_modules_special_purpose:
+
 Special-Purpose Access-aware Kernel Modules
 -------------------------------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are


