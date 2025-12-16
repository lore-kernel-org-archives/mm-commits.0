Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFC82367AC
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765854286; cv=none; b=OMPrBSUxFctZla2d7wTSQKt/sxJvHV5beny9Xq+9FUhJ5syCOTEvogSP3kcWBmnN7LBswYb/YJTakyO2bxyuSUu3WLfcEiU4OG/9/7orh3ZSX5RlS0dmuTlGcB/2LdJk0it4KWM/SiCcbek422oBVMiYwd4+RkoU/WySbk0xE78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765854286; c=relaxed/simple;
	bh=a5xxOqPcBdZ5cZGWBX8slALIFBtKqTB7HOg/LDilDAk=;
	h=Date:To:From:Subject:Message-Id; b=lp0pecxbAarO+Z9sB8ELwS9uNGSjtlnxTTFpyhltcmenzQGiAwOt1Q/5vp8gkKK3w5HRmeFjetrq5amlX/XEXAFpvFW2t+tG4SBuVxggbqtCHGsbbkjTIKnPF19NEi51BvrYsQr2rR/J9wCsd4HnoB3sESpPrcjr74QPiZCxGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LXLkFt73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LXLkFt73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA2CC4CEF5;
	Tue, 16 Dec 2025 03:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765854285;
	bh=a5xxOqPcBdZ5cZGWBX8slALIFBtKqTB7HOg/LDilDAk=;
	h=Date:To:From:Subject:From;
	b=LXLkFt73p7QlcXL+xK2P0Kv9zY5uJStff+kXhZ4afCT9n1PkmWtpwlh17djt6DDjy
	 Kd8tPVxCDYiucsF6Fo4txPv6i4CHPXBsrIKqXhWpkFuA/Hbh2Sr/uEd8+1RuMOZk91
	 993IdXZdPsMdsZqIdbX47t3V/tzyEtHWwBh9SGsA=
Date: Mon, 15 Dec 2025 19:04:44 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linux-foundation.org,mhocko@suse.com,macro@orcam.me.uk,linux@rasmusvillemoes.dk,kees@kernel.org,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,chris.bazley.wg14@gmail.com,alx@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + array_sizeh-add-array_end.patch added to mm-nonmm-unstable branch
Message-Id: <20251216030445.8EA2CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: array_size.h: add ARRAY_END()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     array_sizeh-add-array_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/array_sizeh-add-array_end.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alejandro Colomar <alx@kernel.org>
Subject: array_size.h: add ARRAY_END()
Date: Thu, 11 Dec 2025 11:43:49 +0100

Patch series "Add ARRAY_END(), and use it to fix off-by-one bugs", v6.

Add ARRAY_END(), and use it to fix off-by-one bugs

ARRAY_END() is a macro to calculate a pointer to one past the last element
of an array argument.  This is a very common pointer, which is used to
iterate over all elements of an array:

        for (T *p = a; p < ARRAY_END(a); p++)
                ...

Of course, this pointer should never be dereferenced.  A pointer one past
the last element of an array should not be dereferenced; it's perfectly
fine to hold such a pointer --and a good thing to do--, but the only thing
it should be used for is comparing it with other pointers derived from the
same array.

Due to how special these pointers are, it would be good to use consistent
naming.  It's common to name such a pointer 'end' --in fact, we have many
such cases in the kernel--.  C++ even standardized this name with
std::end().  Let's try naming such pointers 'end', and try also avoid
using 'end' for pointers that are not the result of ARRAY_END().

It has been incorrectly suggested that these pointers are dangerous, and
that they should never be used, suggesting to use something like

	#define ARRAY_LAST(a)  ((a) + ARRAY_SIZE(a) - 1)

	for (T *p = a; p <= ARRAY_LAST(a); p++)
		...

This is bogus, as it doesn't scale down to arrays of 0 elements.  In the
case of an array of 0 elements, ARRAY_LAST() would underflow the pointer,
which not only it can't be dereferenced, it can't even be held (it
produces Undefined Behavior).  That would be a footgun.  Such arrays don't
exist per the ISO C standard; however, GCC supports them as an extension
(with partial support, though; GCC has a few bugs which need to be fixed).

This patch set fixes a few places where it was intended to use the array
end (that is, one past the last element), but accidentally a pointer to
the last element was used instead, thus wasting one byte.

It also replaces other places where the array end was correctly calculated
with ARRAY_SIZE(), by using the simpler ARRAY_END().

Also, there was one drivers/ file that already defined this macro.  We
remove that definition, to not conflict with this one.


This patch (of 4):

ARRAY_END() returns a pointer one past the end of the last element in the
array argument.  This pointer is useful for iterating over the elements of
an array:

	for (T *p = a, p < ARRAY_END(a); p++)
		...

Link: https://lkml.kernel.org/r/cover.1765449750.git.alx@kernel.org
Link: https://lkml.kernel.org/r/5973cfb674192bc8e533485dbfb54e3062896be1.1765449750.git.alx@kernel.org
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c     |    2 --
 include/linux/array_size.h |    6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/block/floppy.c~array_sizeh-add-array_end
+++ a/drivers/block/floppy.c
@@ -4802,8 +4802,6 @@ static void floppy_release_allocated_reg
 	}
 }
 
-#define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
-
 static int floppy_request_regions(int fdc)
 {
 	const struct io_region *p;
--- a/include/linux/array_size.h~array_sizeh-add-array_end
+++ a/include/linux/array_size.h
@@ -10,4 +10,10 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+/**
+ * ARRAY_END - get a pointer to one past the last element in array @arr
+ * @arr: array
+ */
+#define ARRAY_END(arr)  (&(arr)[ARRAY_SIZE(arr)])
+
 #endif  /* _LINUX_ARRAY_SIZE_H */
_

Patches currently in -mm which might be from alx@kernel.org are

array_sizeh-add-array_end.patch
mm-fix-benign-off-by-one-bugs.patch
kernel-fix-off-by-one-benign-bugs.patch
mm-use-array_end-instead-of-open-coding-it.patch

