Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719AB34B1B0;
	Tue, 23 Dec 2025 19:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517857; cv=none; b=Y/fgpIoIZMHgsta38eWyVmS2WpAuBUmpOX6qxIPSJpiVW/P/YuUiWRPxuESWvtOKmmCZPemq1JKb8NecpcH5UFbBGLsmf67k25DJi4gRFT6MVQ6ygkAcUUoEcc+IAHxTJX4zJ4kclUjhxPkB0QRNh9sWH8DwnIloEw0CfdJxlQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517857; c=relaxed/simple;
	bh=4SZBJERtximoSjHx13esxaLcgXd9tbNQ10wb0DXTtMY=;
	h=Date:To:From:Subject:Message-Id; b=T5PxgATIgKUFc1KL//499pSLoYeb1YSdKN1RBkhUMpTnOOoVtAUGIULJTVLZ8G2+lGPxtcnmkz5k9x4kA+5Cx0nAeDAppm90Z/qJgzk/ZYN5uyKb2Q1An7EBdETIyCf/fHefgK6MsLWbJkDF7gIpHUrW7w59XqZOxiq0Z9JedSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4AUmbIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4AUmbIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F0FC113D0;
	Tue, 23 Dec 2025 19:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517857;
	bh=4SZBJERtximoSjHx13esxaLcgXd9tbNQ10wb0DXTtMY=;
	h=Date:To:From:Subject:From;
	b=N4AUmbIlOO5UzEK9gKdJXvTfx13WR78uHvH9kz2K5wApeFWCyMV6t7Iea5d+joVYT
	 MrAPB+o2+MaZXMnsaPXRBHD3fv0xpvyDTD9koEeZOqtkXcLFoO8nbaKq/gXOmN3YgS
	 oZ0mM7fZgQzpPOSa9Ih7yDkxKUIkwldkMNRP3cqA=
Date: Tue, 23 Dec 2025 11:24:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,wakel@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-thread-state-check-in-uffd-unit-tests.patch removed from -mm tree
Message-Id: <20251223192417.01F0FC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix thread state check in uffd-unit-tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-thread-state-check-in-uffd-unit-tests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wake Liu <wakel@google.com>
Subject: selftests/mm: fix thread state check in uffd-unit-tests
Date: Wed, 10 Dec 2025 17:14:08 +0800

In the thread_state_get() function, the logic to find the thread's state
character was using `sizeof(header) - 1` to calculate the offset from the
"State:\t" string.

The `header` variable is a `const char *` pointer.  `sizeof()` on a
pointer returns the size of the pointer itself, not the length of the
string literal it points to.  This makes the code's behavior dependent on
the architecture's pointer size.

This bug was identified on a 32-bit ARM build (`gsi_tv_arm`) for Android,
running on an ARMv8-based device, compiled with Clang 19.0.1.

On this 32-bit architecture, `sizeof(char *)` is 4.  The expression
`sizeof(header) - 1` resulted in an incorrect offset of 3, causing the
test to read the wrong character from `/proc/[tid]/status` and fail.

On 64-bit architectures, `sizeof(char *)` is 8, so the expression
coincidentally evaluates to 7, which matches the length of "State:\t". 
This is why the bug likely remained hidden on 64-bit builds.

To fix this and make the code portable and correct across all
architectures, this patch replaces `sizeof(header) - 1` with
`strlen(header)`.  The `strlen()` function correctly calculates the
string's length, ensuring the correct offset is always used.

Link: https://lkml.kernel.org/r/20251210091408.3781445-1-wakel@google.com
Fixes: f60b6634cd88 ("mm/selftests: add a test to verify mmap_changing race with -EAGAIN")
Signed-off-by: Wake Liu <wakel@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-thread-state-check-in-uffd-unit-tests
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1317,7 +1317,7 @@ static thread_state thread_state_get(pid
 		p = strstr(tmp, header);
 		if (p) {
 			/* For example, "State:\tD (disk sleep)" */
-			c = *(p + sizeof(header) - 1);
+			c = *(p + strlen(header));
 			return c == 'D' ?
 			    THR_STATE_UNINTERRUPTIBLE : THR_STATE_UNKNOWN;
 		}
_

Patches currently in -mm which might be from wakel@google.com are


