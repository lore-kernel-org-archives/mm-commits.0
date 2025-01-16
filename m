Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7017D07D
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 22:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737064844; cv=none; b=pbGUx0FaJHRQhfk4izfeM0tjXMYkHgPT/7QJzzDSZhatCV2uStz9CyxPf6GVoDHqRWhfyLFGm56EDVIbkv0WvvHgtpwdeTvjaP30LY/QAYXZle4g+bqJiGzlle0JTl+u5xQyPkKdC3RLftAPHziGP7AzMMzyUFpOmo32axf38VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737064844; c=relaxed/simple;
	bh=JfCADPyilU0q6q7dbvHkq3+5x+GPSd8oDOfUoFVZmfQ=;
	h=Date:To:From:Subject:Message-Id; b=U6f6V1K9eyiBXHjdOvti9YkKp3mYvRaUhCBcFWDfoYVxk9B1wA3HmwMpsS6NtKHXcnVNAcjwN3Rrm12E5jF+8UHlWOOHFUwUbsbRh2/kQjCIivDeIf11gB0xM+8/hSc78n3DbOs1qq2TSEEyajK1WZF1/CwMFbhjSfC2CAoVr/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pi4lIF7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pi4lIF7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843D1C4CEDD;
	Thu, 16 Jan 2025 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737064843;
	bh=JfCADPyilU0q6q7dbvHkq3+5x+GPSd8oDOfUoFVZmfQ=;
	h=Date:To:From:Subject:From;
	b=pi4lIF7/ra6Yw40yHAOGUzG6c86bRCUTsFJwdto7njfDONtfuqVBpQJObmf/W0ECM
	 feZjdHHPwi7cP46cfEDglSwLGkD+wQ0nWT0VO+XDKgvUH5/sKjRquvjzmYpwR7i7xR
	 PTiL7y3ofMjAOVwruaZq258gbkkvbRcMJXjGEYcg=
Date: Thu, 16 Jan 2025 14:00:42 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,sfr@canb.auug.org.au,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,liam.howlett@oracle.com,david@redhat.com,boqun.feng@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin.patch added to mm-unstable branch
Message-Id: <20250116220043.843D1C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: seqlock: add missing parameter documentation for raw_seqcount_try_begin()
has been added to the -mm mm-unstable branch.  Its filename is
     seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: seqlock: add missing parameter documentation for raw_seqcount_try_begin()
Date: Thu, 16 Jan 2025 10:27:30 -0800

Add missing documentation for raw_seqcount_try_begin() start parameter.

Link: https://lkml.kernel.org/r/20250116182730.801497-1-surenb@google.com
Fixes: dba4761a3e40 ("seqlock: add raw_seqcount_try_begin")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20250116170522.23e884d5@canb.auug.org.au/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seqlock.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/seqlock.h~seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin
+++ a/include/linux/seqlock.h
@@ -322,6 +322,7 @@ SEQCOUNT_LOCKNAME(mutex,        struct m
  * raw_seqcount_try_begin() - begin a seqcount_t read critical section
  *                            w/o lockdep and w/o counter stabilization
  * @s: Pointer to seqcount_t or any of the seqcount_LOCKNAME_t variants
+ * @start: count to be passed to read_seqcount_retry()
  *
  * Similar to raw_seqcount_begin(), except it enables eliding the critical
  * section entirely if odd, instead of doing the speculation knowing it will
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin.patch

