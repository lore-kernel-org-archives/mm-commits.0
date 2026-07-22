Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA09040681A;
	Wed, 22 Jul 2026 23:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763479; cv=none; b=NNPPtkUjijpxXOX87+a02FsvBUg0vSF+m2S1qSfkq8kMjuOiwHnEueKBlyghg2pkjSesJUGF4KlkQGC82dkFJY2rW+sGeGas/bLfwS2SRsXGFWT3SB6yLJwuMnZJDygEmqEXA5+f6+3zY0J1LSWBtUf9D/hzeMZFjrv2Fbn1RtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763479; c=relaxed/simple;
	bh=vF/8hAICx4bFDDjWgYb6UFhBAUwsY3z9ONkute/i9TI=;
	h=Date:To:From:Subject:Message-Id; b=WsfuT/5RxU4zF+ZloHMycFdZLiJKrCbgehlo1MnTI3lS8Ppne3nO8dz0ex9TauBWC3RN/+C+MWRNZhCTbXN1BpgMczod9jvxdKH847tb8oZdOFRgAqyrSx/pE/TlG5BX1eJmlkP07m7+3xo0Nk3ieVrWP8xN/FXm17eG5kvN57U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bly2iOi8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bly2iOi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE85A1F000E9;
	Wed, 22 Jul 2026 23:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784763472;
	bh=//5nbV14hJdemR/PxJbBZyvB+Uul/2syz/AhZEtsyIs=;
	h=Date:To:From:Subject;
	b=bly2iOi8Bv5b0RCqE0KOjaaUljVkkn8TEkwkNqr0JZwmn7El1FrdQPGIhgLMNA2qE
	 T9Mq3JaCew4NgaWYrYAltonc1lVD0oFpRLYYjH61niiyWhub0gHxPyKb/ANDoSDaas
	 Ah3mQPQxHOgOiUMLxSHjw5BC6kuE/1RJg/tSU4mY=
Date: Wed, 22 Jul 2026 16:37:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,brauner@kernel.org,christian.gellermann@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-clone3-fix-wild-pointer-access-of-getline-due-to-missing-init.patch added to mm-hotfixes-unstable branch
Message-Id: <20260722233751.EE85A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/clone3: fix wild pointer access of getline due to missing init
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-clone3-fix-wild-pointer-access-of-getline-due-to-missing-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-clone3-fix-wild-pointer-access-of-getline-due-to-missing-init.patch

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
Subject: selftests/clone3: fix wild pointer access of getline due to missing init
Date: Wed, 22 Jul 2026 15:02:45 +0200

Patch series "selftests: Add missing initalization of pointer passed to
getline", v2.


This patch (of 2):

Clone3_set_tid uses getline(&line, ...) in a loop to read the child's
process status.  The code expects that getline allocates the buffer for
the line on the first loop iteration.  According to the Open Group
Spec[1], char *line has to be null pointer for this:

> ssize_t getline(char **restrict lineptr, ...);
> If *lineptr is a null pointer or if the object pointed to by *lineptr
> is of insufficient size, an object shall be allocated as if by
malloc()
> or the object shall be reallocated as if by realloc()[...].

However, char *line is only declared, leading to an undefined value that
is potentially non-null.  In an example run with Musl v1.2.6, the realloc
call[2] of getdelim, which implements getline, triggers a segfault:

./run_kselftest.sh --test clone3:clone3_set_tid
[ 1366.165898] kselftest: Running tests in clone3
...
[ 1367.799244] clone3_set_tid[811]: unhandled signal 11 code 0x1 at
0x0000000000000000 in libc.so[68184,3fbf69f000+4c000]
[ 1367.802808] CPU: 0 UID: 0 PID: 811 Comm: clone3_set_tid Not tainted
..
[ 1367.804188]  epc: 0x0000003fbf6b0184
[ 1367.804188]  ra : 0x0000003fbf6d4664
[ 1367.804188]  sp : 0x0000003fce5f2e40
[ 1367.805314]  gp : 0x0000002aaab0dfb8
[ 1367.805314]  tp : 0x0000003fbf6f14a8
[ 1367.805314]  t0 : 0x0000003fbf63d000
...

Looking at the realloc implementation, Musl mallocs for a null pointer
memory.  But for a non-null pointer, it assumes it's passed a valid
pointer to the heap and tries to access its meta-data.  This leads to the
segfault we see:

void *realloc(void *p, size_t n)
{
        if (!p) return malloc(n);
        if (size_overflows(n)) return 0;

        struct meta *g = get_meta(p);
        ...
}

Fix this by properly initializing the line pointer to NULL.

Link: https://lore.kernel.org/20260722130246.2135563-1-christian.gellermann@codasip.com
Link: https://lore.kernel.org/20260722130246.2135563-2-christian.gellermann@codasip.com
Link: https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html [1]
Link: https://git.musl-libc.org/cgit/musl/tree/src/stdio/getdelim.c#n38 [2]
Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/clone3/clone3_set_tid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/clone3/clone3_set_tid.c~selftests-clone3-fix-wild-pointer-access-of-getline-due-to-missing-init
+++ a/tools/testing/selftests/clone3/clone3_set_tid.c
@@ -141,7 +141,7 @@ int main(int argc, char *argv[])
 {
 	FILE *f;
 	char buf;
-	char *line;
+	char *line = NULL;
 	int status;
 	int ret = -1;
 	size_t len = 0;
_

Patches currently in -mm which might be from christian.gellermann@codasip.com are

selftests-clone3-fix-wild-pointer-access-of-getline-due-to-missing-init.patch
selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init.patch

