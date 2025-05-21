Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEC122F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846656; cv=none; b=FLrhmt/AW7Lgqic53oVUre/VUI0511euFgbK9f3pOt/Z8NHRGNu+TGTSxvwDqKCvZ6jES/S8omI+WVWCuXisI96p6Rz+Cl+K9gjCnb/NB7q97vqPDRjnwYnMIsgqMa2DFYRbuvwa7+/27c7726IpiOzdOYOannpsG14rOXg4hwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846656; c=relaxed/simple;
	bh=z7VodOrGqxb9ZrgtvzfO1AZgNgV+jUAHctuSVpNWtcc=;
	h=Date:To:From:Subject:Message-Id; b=YgLgeM3trxLDTJLiUb47l6SruAVFB5OV440QFN6nYrgjvYkIq/lOCQvdG9h+leHqoWwx9Sh4rMknefiY9P1/mYtMvvgf+SjzUYU10gf8Z1gTzC9P4okgcfTBGix6q9UPb11ZGdzOa/T9fDWBi1EiRnm48EKpNKs/rwV7H8j8604=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x3iIGuXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x3iIGuXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23C3C4CEE4;
	Wed, 21 May 2025 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846655;
	bh=z7VodOrGqxb9ZrgtvzfO1AZgNgV+jUAHctuSVpNWtcc=;
	h=Date:To:From:Subject:From;
	b=x3iIGuXi2ZmgfvPZiP3DEmVuIjsQ4myiOJ1pTXQ9rSZLwFXX5tPK3xLe139f54vf0
	 +fg66RiHUInllSSfXCUJlL35q+2AFF7+2X0bjDRz9Ga9HIqHf0aJ7IAjVeA0JTTO30
	 ttNYDc5l80wi/yfs70xq4wBMznaNkNTZeRgUISZM=
Date: Wed, 21 May 2025 09:57:35 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch removed from -mm tree
Message-Id: <20250521165735.C23C3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/damon: update titles and brief introductions to explain DAMOS
has been removed from the -mm tree.  Its filename was
     docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/damon: update titles and brief introductions to explain DAMOS
Date: Mon, 12 May 2025 17:27:15 -0700

DAMON was initially developed only for data access monitoring, and then
extended for not only access monitoring but also access-aware system
operations (DAMOS).  But the documents have old titles and brief
introductions for only the monitoring part.  Update the titles and the
brief introductions to explain DAMOS part together.

Link: https://lkml.kernel.org/r/20250513002715.40126-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/index.rst |   11 +++++------
 Documentation/mm/damon/index.rst             |    6 +++---
 2 files changed, 8 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/mm/damon/index.rst~docs-damon-update-titles-and-brief-introductions-to-explain-damos
+++ a/Documentation/admin-guide/mm/damon/index.rst
@@ -1,12 +1,11 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-==========================
-DAMON: Data Access MONitor
-==========================
+================================================================
+DAMON: Data Access MONitoring and Access-aware System Operations
+================================================================
 
-:doc:`DAMON </mm/damon/index>` allows light-weight data access monitoring.
-Using DAMON, users can analyze the memory access patterns of their systems and
-optimize those.
+:doc:`DAMON </mm/damon/index>` is a Linux kernel subsystem for efficient data
+access monitoring and access-aware system operations.
 
 .. toctree::
    :maxdepth: 2
--- a/Documentation/mm/damon/index.rst~docs-damon-update-titles-and-brief-introductions-to-explain-damos
+++ a/Documentation/mm/damon/index.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-==========================
-DAMON: Data Access MONitor
-==========================
+================================================================
+DAMON: Data Access MONitoring and Access-aware System Operations
+================================================================
 
 DAMON is a Linux kernel subsystem that provides a framework for data access
 monitoring and the monitoring results based system operations.  The core
_

Patches currently in -mm which might be from sj@kernel.org are


