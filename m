Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB682F1FEF
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 20:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001570; cv=none; b=cU5ftNgv5O7TNbxrRV4W21vl7NG/y+mgJfJI83XVcmYSwguiWy9dMjiRA5YjNaODsBOjKyl/9htb1zHruoqSG0jFU5BPKXi6yWiprZ5eNP8Ia3rCr541kCRLaOSCg8hEwGs+OY6tMsgFbQY+MCIhf1bdpIOWQlPJvIiiKzd/Dzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001570; c=relaxed/simple;
	bh=ZgzD+ENf7U5xCETM95dM1wyRGaafPIK88E49D0D6sCY=;
	h=Date:To:From:Subject:Message-Id; b=O9O1Roc3ikIgKCci8HY9MeFzQynyOfHq8PVnnPwmGHJ/lo890610a9/24g//Jgnb4qociVq8J6fHwBhQyyGYcWZ8xTQsPpcfzjJO8iG6LOaHmtKO6Og5gGGbfxYS5LbR5ZzMWj8S0Po0GEaAsoL+x22vqn7WcE+PJdHTHeW56Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jV5QZ11X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jV5QZ11X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9EF1F000E9;
	Thu, 28 May 2026 20:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780001569;
	bh=t3IZKq3HaaQy6Ac3UqNgrPjlurkBX7iwoaUrzOBHBHQ=;
	h=Date:To:From:Subject;
	b=jV5QZ11XdOh5ksoC4dH4PqaDhsT3SnGI6ectz7g9Scws9vRZAnzMndQNQ1tBw5Hkp
	 0opbiCeFNfC0xDD+5/RvF1yZlokSnviajWXvefMluXJ5q4x7iC80zodzV/x3wN24Iu
	 FdCmWdzEWgC4xV6hOyP0/XeubESAg37X7Tm9vxGs=
Date: Thu, 28 May 2026 13:52:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,skhan@linuxfoundation.org,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,bmasney@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1.patch added to mm-unstable branch
Message-Id: <20260528205249.7A9EF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: mm: clarify that user_reserve_kbytes has no effect when overcommit_memory is set to 0 or 1
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Brian Masney <bmasney@redhat.com>
Subject: docs: mm: clarify that user_reserve_kbytes has no effect when overcommit_memory is set to 0 or 1
Date: Thu, 28 May 2026 09:45:10 -0400

Looking at __vm_enough_memory() in mm/util.c, user_reserve_kbytes has no
effect when overcommit_memory is set to 0 or 1. The documentation for
overcommit_memory already references user_reserve_kbytes when the flag
is set to 2.

Let's go ahead and add a clarification to user_reserve_kbytes in vm.rst
that it has no effect when overcommit_memory is set to 0 or 1.

Link: https://lore.kernel.org/20260528-mm-clarify-docs-v1-1-aa88e83b4bfd@redhat.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -1034,6 +1034,8 @@ min(3% of current process size, user_res
 This is intended to prevent a user from starting a single memory hogging
 process, such that they cannot recover (kill the hog).
 
+This setting has no effect when overcommit_memory is set to 0 or 1.
+
 user_reserve_kbytes defaults to min(3% of the current process size, 128MB).
 
 If this is reduced to zero, then the user will be allowed to allocate
_

Patches currently in -mm which might be from bmasney@redhat.com are

maintainers-add-vmrst-to-memory-management-core.patch
docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1.patch

