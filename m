Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2E7284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126261; cv=none; b=f73T6iNk7fUjRjuwtdfuuwuaheGBD8Jp2HEPCF2nzbaagR6GBEGuxePgnEJBM3RRE5mj0aCj7qdG/TS8i57yfKhGttcnMsKi0+xlMjvsJUTyQj/FzQI4d2Wg2NJiY6iLJthrX+8j6O6gdhxGXk6BZTP/mim9pwBiD5Fd6aH85m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126261; c=relaxed/simple;
	bh=Li8rPL9j4e5fGleWtLDN6wkyCKecI3FZCOexjNyAvsE=;
	h=Date:To:From:Subject:Message-Id; b=TC6OB3pFulbLzIYB98MazxkH/X+TCHJVI/KsdBM+fmLYQCmT63JyEI7sG0VaCf5D5hYMVn7wW+h6ydhpHGIPH/dtsmYREOrzXT0CE7nhtNKz2d21QXl3c6Vt7GoBloqLYTVpXUtAS3928ZWK/+5H3a36CIca4TYSg2SnWGGaGvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eO1/a/Po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eO1/a/Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71495C4CEE3;
	Thu, 10 Jul 2025 05:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126261;
	bh=Li8rPL9j4e5fGleWtLDN6wkyCKecI3FZCOexjNyAvsE=;
	h=Date:To:From:Subject:From;
	b=eO1/a/PoEkwVc8N3SFpVBcweAe9+8BvNpn6/dIMJDyqNlenrEDVjktwRfXvBsNteG
	 AlJfDuh68kzb5E/5mgXjuWZqNK607d9kkHaAV1jXJtIyatS4EzNUiS/vuVwk0deIcG
	 ETCUPTrDdqG0H9wG9UISCU6ScURQ1YFy5v6jYhIQ=
Date: Wed, 09 Jul 2025 22:44:20 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-clarify-errors-for-pipe.patch removed from -mm tree
Message-Id: <20250710054421.71495C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest/mm: clarify errors for pipe()
has been removed from the -mm tree.  Its filename was
     kselftest-mm-clarify-errors-for-pipe.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: kselftest/mm: clarify errors for pipe()
Date: Tue, 10 Jun 2025 15:13:54 +0100

Patch series "selftests/mm: Tweaks to the cow test".

A collection of non-functional updates from David Hildenbrand's review.


This patch (of 4):

Specify that errors reported from pipe() failures are the result of
failures.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-0-43cd7457500f@kernel.org
Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-1-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~kselftest-mm-clarify-errors-for-pipe
+++ a/tools/testing/selftests/mm/cow.c
@@ -113,11 +113,11 @@ struct comm_pipes {
 static int setup_comm_pipes(struct comm_pipes *comm_pipes)
 {
 	if (pipe(comm_pipes->child_ready) < 0) {
-		ksft_perror("pipe()");
+		ksft_perror("pipe() failed");
 		return -errno;
 	}
 	if (pipe(comm_pipes->parent_ready) < 0) {
-		ksft_perror("pipe()");
+		ksft_perror("pipe() failed");
 		close(comm_pipes->child_ready[0]);
 		close(comm_pipes->child_ready[1]);
 		return -errno;
_

Patches currently in -mm which might be from broonie@kernel.org are


