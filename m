Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA0A1EEE6;
	Tue, 16 Dec 2025 03:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855622; cv=none; b=h/6UOLtmZWcX8D1RKqmQsdP/b85G9ngTekTRd5JaCnzHuseROJJTWhan6ZObcIbz9+vX7v/tRIez6daUCNWfWxOv/2kaF3/rPyCCO+jvBl5i9eg88coLPjW1xc1ldnMytKEtVGBQoawDNe2Sr1ehwslqpv+HQDZcOmpLszywego=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855622; c=relaxed/simple;
	bh=Cry2wmAN4Cz9SSQ/+BLRd2os0ES9qjDa8veSNc/7MLI=;
	h=Date:To:From:Subject:Message-Id; b=FBefLrJSGvUCmLwiNGO5+Vz78JlN0Ec5TALjX6l0RKDgEm4IULZ4LPVjWEJabpWt3M0CsnyVe6VbUsgUs2ERKJKlQxxs4Ad9MyYpD3Pg8hndAkGiegDlAGjCR8OknTxQYU+5sapKk7WTs8NNUyoFoprxuBtHKz4EuTmHcGPV7hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzWgVx1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzWgVx1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2479EC4CEF5;
	Tue, 16 Dec 2025 03:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765855621;
	bh=Cry2wmAN4Cz9SSQ/+BLRd2os0ES9qjDa8veSNc/7MLI=;
	h=Date:To:From:Subject:From;
	b=IzWgVx1CkyYHAJe3k47wrVecZjwp9yebKYh4aTqzRhvwTiC2Hz7U8cDcZUX+N+QK5
	 xODKC/3nWn9GpFlfQv3/H+JEs/gr7Zv9+IqD6z9zKNiNvPizpGbk1aEW/hMzg4KBTu
	 V2N1TdynOaJ4CbMwkp+iOB66VxxhPTdUKiIz8Il0=
Date: Mon, 15 Dec 2025 19:27:00 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,wakel@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-thread-state-check-in-uffd-unit-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20251216032701.2479EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix thread state check in uffd-unit-tests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-thread-state-check-in-uffd-unit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-thread-state-check-in-uffd-unit-tests.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

selftests-mm-fix-thread-state-check-in-uffd-unit-tests.patch

