Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB48E2D73BC;
	Thu, 14 May 2026 00:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719231; cv=none; b=HRN/Qd6QXi7pFpLchuEAbhngwxRwsKwAChr1lMj8BfPvo3XI31+6OU5GUKxPRXKFhU2OUvdWTXnHV8xCJm7tBzR992grTxX3pFODGmSh7ulfedgo7BkOO06tQ0g0G82AcXQipKrQcwXxCPvwMfs4ooNsclLUYE+4prbmbhMkWLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719231; c=relaxed/simple;
	bh=CQzpbYW3GZQ+fj24ZS4EgusVa0yIWsjnVY6RHxVqFt4=;
	h=Date:To:From:Subject:Message-Id; b=fzaIx4qsx0AymEOdC3QNEiNdSfszFv9PMJFmSIi+lwHEtV1PwQ7uoufidldjMKktz6a20sBYalki9/+JEAUw6FOWWgM3Yi1fAkBxU1hvl2t8Pp3q7nP8Xsf5MHElu8DYN9bT2I9BZQ6nRe9mqDc1UhH0NnZnrAdYQaiSx9BGds0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h29nHhNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h29nHhNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB49C19425;
	Thu, 14 May 2026 00:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719231;
	bh=CQzpbYW3GZQ+fj24ZS4EgusVa0yIWsjnVY6RHxVqFt4=;
	h=Date:To:From:Subject:From;
	b=h29nHhNtOAsAsDTTn08NeifwszNLdF/+IbuBNf3Dgj8ugHVRF27ySZYfjcVHOEP53
	 efbZOOv4UlX2WZ+9yfwRYAZBmdoEnOhrLo1zoASrdCfs9fiv2mbzvBBDStOcTHg3jv
	 je2X2D13Y9oCrM5W2Rje1MNk7VELC1Fglu2YP63U=
Date: Wed, 13 May 2026 17:40:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-run_vmtestssh-fix-destructive-tests-invocation.patch removed from -mm tree
Message-Id: <20260514004031.6EB49C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: fix destructive tests invocation
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-fix-destructive-tests-invocation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: selftests/mm: run_vmtests.sh: fix destructive tests invocation
Date: Mon, 27 Apr 2026 12:03:51 -0400

Destructive tests should be invoked with -d command-line option, but this
won't work today since 'd' is missing in getopts command-line.  This
commit fixes it.

Link: https://lore.kernel.org/214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com
Fixes: f16ff3b692ad ("selftests/mm: run_vmtests.sh: add missing tests")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-fix-destructive-tests-invocation
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -103,7 +103,7 @@ RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
-while getopts "aht:n" OPT; do
+while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
 		"h") usage ;;
_

Patches currently in -mm which might be from luizcap@redhat.com are


