Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F9F4582D7;
	Wed, 22 Jul 2026 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763478; cv=none; b=fsCnW/J9zPedj0lwqJsLf8yCHt3uay/ShDBZ8bQsY6GeKpqcmHNYEkAp1fNuKzAGkljIfwKAXLsdsMQWq2H0qqlyNG9xPU/VEWp7B2XKxOF/0i7KCPsQQHqvWd4TsZWzAe9T0b1rCJuUDRr3phaJ+f8VOxoM0r3UtlIdpTWvEvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763478; c=relaxed/simple;
	bh=srv+JxPI50I3hAmho83VcinQJ1CBhq9BTVRvfPewKHk=;
	h=Date:To:From:Subject:Message-Id; b=VHUn/lldo5PJhUO7AURxG326yP8YIHRczows/yxuIueIhna/Zf6ebAgKFYHaarKxZMFW1ut0UOJzFosFs21PR+medu3KhLBC5L3SFvtIpWQ3YxjcJXIeMZ3tD7VAUY2/uEd356nZlWYgiw+WXdwL2Wy+P3My1+aJzNf7AF1LYMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FM1P1olV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FM1P1olV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A93B1F00A3A;
	Wed, 22 Jul 2026 23:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784763474;
	bh=Ait/7xcW6IyXP3x2T74gn+XxJM4RKfADZsVYudUdF5M=;
	h=Date:To:From:Subject;
	b=FM1P1olVdvX94THEq3ysE2N3/FkaHiGcLp8eJsTLNiglg/A4lENF9+Bit3m+JKeEL
	 ocOxU8l+ByZb+W/S6fIYDmfJS+GpAiYCMTAwkFbhccZmR+d1SuhY7HL6s0QiGGM8pC
	 03sqoycK3lH9UNqTxksn0VZeuZ6B0qfSdowKgFb0=
Date: Wed, 22 Jul 2026 16:37:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,brauner@kernel.org,christian.gellermann@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init.patch added to mm-hotfixes-unstable branch
Message-Id: <20260722233754.0A93B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix potential wild pointer access of getline due to missing init
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Chris Gellermann <christian.gellermann@codasip.com>
Subject: selftests/mm: fix potential wild pointer access of getline due to missing init
Date: Wed, 22 Jul 2026 15:02:46 +0200

This is another occurrence of using getline where the code assumes that
getline allocates memory to store the line, but the pointer passed to it
is uninitialized and potentially a non-null pointer.  This violates the
Open Group Spec[1] and caused a segfault in a similar situation in
selftest/clone3/clone3_set_tid.  Fix it by initializing the line pointer
to NULL.

The issue has been found by simply grepping through the selftest code
after running into the issue in clone3_set_tid.  Whether it segfaults in
its current state is unknown to me.  But it's good to be addressed due to
defensive reasons.

Link: https://lore.kernel.org/20260722130246.2135563-3-christian.gellermann@codasip.com
Link: https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html [1]
Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock-random-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -84,7 +84,7 @@ int get_proc_locked_vm_size(void)
 int get_proc_page_size(unsigned long addr)
 {
 	FILE *smaps;
-	char *line;
+	char *line = NULL;
 	unsigned long mmupage_size = 0;
 	size_t size;
 
_

Patches currently in -mm which might be from christian.gellermann@codasip.com are

selftests-clone3-fix-wild-pointer-access-of-getline-due-to-missing-init.patch
selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init.patch

