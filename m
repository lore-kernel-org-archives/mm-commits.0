Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F831E519
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 02:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353779; cv=none; b=QPXM/dQwqYADdpL7nmlsl0W/F8lQJ2/TEHLnUVCfuhBTsMj5DvyF8IsGg3cCQdozFrSVXXn/Hh+I5ICgQMIC1LbRuAgxjEcz5ijDgM+zael02g6THNcaPW7rkGrNe2fX91CK3J8W8rkkMcSMojjBQG+oyLzQtTH7tVZtvcsAt5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353779; c=relaxed/simple;
	bh=/6j73lVo048Vml7WY4CfbiXNUdfnjcKb5+xwnzGHfik=;
	h=Date:To:From:Subject:Message-Id; b=u1Dy308lemanD3M1KQwyKd/6qMsfW94ASGKKKF2bsinuCnKbWE9bMz/oSGM5wW5V5KJzZyEAWrR5dp4bcuoBU2z7QdfFA7R/SjEf7d8eUbCU65gOrXagxw9FIRArUyBTfxLuG49xDfVPaHeGvDvLww+CkYMS7LTbrn4rjKT/L1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFo0xX5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFo0xX5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77DFC4CEC6;
	Tue,  8 Oct 2024 02:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728353778;
	bh=/6j73lVo048Vml7WY4CfbiXNUdfnjcKb5+xwnzGHfik=;
	h=Date:To:From:Subject:From;
	b=IFo0xX5wGbH/TOB8cJURxtcOE+lcKbjUc5xZTNYiL6L9zn8/OJptR8KZlh6J1Qn9E
	 dCRbQ1uiYp75AC1Xi66wJMOqw03IWMC3eGhwVnJ5ZqFivNcpPAWRbIPSZvaeVzdw+F
	 PsTj9IvbeS3QpJ/y+MHr3+g5dMROaCVCUfNfqfxA=
Date: Mon, 07 Oct 2024 19:16:18 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,gorcunov@openvz.org,david@redhat.com,brahmajit.xyz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-fix-build-with-gcc-15-due-to-werror=unterminated-string-initialization.patch added to mm-hotfixes-unstable branch
Message-Id: <20241008021618.D77DFC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: fix build with GCC 15 due to -Werror=unterminated-string-initialization
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-fix-build-with-gcc-15-due-to-werror=unterminated-string-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-fix-build-with-gcc-15-due-to-werror=unterminated-string-initialization.patch

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
From: Brahmajit Das <brahmajit.xyz@gmail.com>
Subject: fs/proc: fix build with GCC 15 due to -Werror=unterminated-string-initialization
Date: Sat, 5 Oct 2024 12:07:00 +0530

show show_smap_vma_flags() has been a using misspelled initializer in
mnemonics[] - it needed to initialize 2 element array of char and it used
NUL-padded 2 character string literals (i.e.  3-element initializer).

This has been spotted by gcc-15[*]; prior to that gcc quietly dropped the
3rd eleemnt of initializers.  To fix this we are increasing the size of
mnemonics[] (from mnemonics[BITS_PER_LONG][2] to
mnemonics[BITS_PER_LONG][3]) to accomodate the NUL-padded string literals.

This also helps us in simplyfying the logic for printing of the flags as
instead of printing each character from the mnemonics[], we can just print
the mnemonics[] using seq_printf.

[*]: fs/proc/task_mmu.c:917:49: error: initializer-string for array of `char' is too long [-Werror=unterminate d-string-initialization]
  917 |                 [0 ... (BITS_PER_LONG-1)] = "??",
      |                                                 ^~~~
fs/proc/task_mmu.c:917:49: error: initializer-string for array of `char' is too long [-Werror=unterminate d-string-initialization]
fs/proc/task_mmu.c:917:49: error: initializer-string for array of `char' is too long [-Werror=unterminate d-string-initialization]
fs/proc/task_mmu.c:917:49: error: initializer-string for array of `char' is too long [-Werror=unterminate d-string-initialization]
fs/proc/task_mmu.c:917:49: error: initializer-string for array of `char' is too long [-Werror=unterminate d-string-initialization]
fs/proc/task_mmu.c:917:49: error: initializer-string for array of `char' is too long [-Werror=unterminate d-string-initialization]
...


Stephen pointed out:

: The C standard explicitly allows for a string initializer to be too long
: due to the NUL byte at the end ...  so this warning may be overzealous.

but let's make the warning go away anwyay.

Link: https://lkml.kernel.org/r/20241005063700.2241027-1-brahmajit.xyz@gmail.com
Link: https://lkml.kernel.org/r/20241003093040.47c08382@canb.auug.org.au
Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-fix-build-with-gcc-15-due-to-werror=unterminated-string-initialization
+++ a/fs/proc/task_mmu.c
@@ -909,8 +909,15 @@ static void show_smap_vma_flags(struct s
 {
 	/*
 	 * Don't forget to update Documentation/ on changes.
+	 *
+	 * The length of the second argument of mnemonics[]
+	 * needs to be 3 instead of previously set 2
+	 * (i.e. from [BITS_PER_LONG][2] to [BITS_PER_LONG][3])
+	 * to avoid spurious
+	 * -Werror=unterminated-string-initialization warning
+	 *  with GCC 15
 	 */
-	static const char mnemonics[BITS_PER_LONG][2] = {
+	static const char mnemonics[BITS_PER_LONG][3] = {
 		/*
 		 * In case if we meet a flag we don't know about.
 		 */
@@ -987,11 +994,8 @@ static void show_smap_vma_flags(struct s
 	for (i = 0; i < BITS_PER_LONG; i++) {
 		if (!mnemonics[i][0])
 			continue;
-		if (vma->vm_flags & (1UL << i)) {
-			seq_putc(m, mnemonics[i][0]);
-			seq_putc(m, mnemonics[i][1]);
-			seq_putc(m, ' ');
-		}
+		if (vma->vm_flags & (1UL << i))
+			seq_printf(m, "%s ", mnemonics[i]);
 	}
 	seq_putc(m, '\n');
 }
_

Patches currently in -mm which might be from brahmajit.xyz@gmail.com are

fs-proc-fix-build-with-gcc-15-due-to-werror=unterminated-string-initialization.patch

