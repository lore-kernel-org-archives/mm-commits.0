Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976DD10F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744841; cv=none; b=gEKtGohTDtoHdgjnc3EFCLijUzMNXK5DH1miT6PE8kq7HSBbiTVKn2E045Aq1g9MS995c4/0C3cvuqLfvzZXWv8fdULg1wPYAKrbe07dLURtPljAGN6BU43QMUUMnkSd6ymtf4FtQtMOBRXW1injhYu9PRc5Mx7QUJytZs1T6c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744841; c=relaxed/simple;
	bh=tSTEPEqRppA02HCQfdmahKHZVcznlAUgawDq4n/wYx8=;
	h=Date:To:From:Subject:Message-Id; b=VWX2PC10pKzHHfFZPd1gIsUH2G949iJ4n36+Ji9bF/ShxQIjuxf3RMwyecVeTG7wzWw8POPzdolM1Q/yDg0YF0fnSUmXFCa0jLHfAvnKME9XnLYfJl1YyDP8E/yhlXsCKTTJ6/xXMxeTefo2TM+t8c/nHByeF+PGHeOguQKpd/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YlhXa6BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YlhXa6BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F00DC4CEF7;
	Sun, 29 Mar 2026 00:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744841;
	bh=tSTEPEqRppA02HCQfdmahKHZVcznlAUgawDq4n/wYx8=;
	h=Date:To:From:Subject:From;
	b=YlhXa6BORN43kFU7ZA8QqkmeQGDlQy9u0LubDDwYBroGEnOcK+zqD6YeN1v7zBA9/
	 HVxuZimMRZi2E3aOWucfCRXUq1r5fjrKq47sg/lt4LdxqDdbsjLy19l2XwRiF6EUeC
	 3Yd0CtajhAeBjny8AB5EIl5w6BqE/iWzJpl/qaZk=
Date: Sat, 28 Mar 2026 17:40:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch removed from -mm tree
Message-Id: <20260329004041.6F00DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: use flexible review cadence
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: use flexible review cadence
Date: Sat, 7 Mar 2026 11:53:54 -0800

The document mentions the maitainer is working in the usual 9-5 fashion. 
The maintainer nowadays prefers working in a more flexible way.  Update
the document to avoid contributors having a wrong time expectation.

Link: https://lkml.kernel.org/r/20260307195356.203753-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-use-flexible-review-cadence
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -63,10 +63,10 @@ management subsystem maintainer.
 Review cadence
 --------------
 
-The DAMON maintainer does the work on the usual work hour (09:00 to 17:00,
-Mon-Fri) in PT (Pacific Time).  The response to patches will occasionally be
-slow.  Do not hesitate to send a ping if you have not heard back within a week
-of sending a patch.
+The DAMON maintainer usually work in a flexible way, except early morning in PT
+(Pacific Time).  The response to patches will occasionally be slow.  Do not
+hesitate to send a ping if you have not heard back within a week of sending a
+patch.
 
 Mailing tool
 ------------
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

