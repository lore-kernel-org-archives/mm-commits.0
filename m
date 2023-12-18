Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7EC49894
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KlGpEFF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59883C433C9;
	Mon, 18 Dec 2023 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702918719;
	bh=qw325+wxNuvVbLK2RDkqX6Z2y7rWtkRcpgDYv7j2S1A=;
	h=Date:To:From:Subject:From;
	b=KlGpEFF9dT12I5x3sW40xm9xWER4R+DvVYs/Z4WqBNdKE9vVyCoDq55uNu+6x/JfM
	 es0hzFWtJrH0Em3/b7+/J9NA73w4xZZP9Sv4xrEUrKHsp3+3TWMyikRFZnbXtGB2A7
	 3VHO4QXvNr2Dk+0u2kUogwIofsVNHP7B80lfAlYo=
Date: Mon, 18 Dec 2023 08:58:38 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,bp@alien8.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ubsan-use-the-kernel-panic-message-markers.patch added to mm-unstable branch
Message-Id: <20231218165839.59883C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: UBSAN: use the kernel panic message markers
has been added to the -mm mm-unstable branch.  Its filename is
     ubsan-use-the-kernel-panic-message-markers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ubsan-use-the-kernel-panic-message-markers.patch

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
From: "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: UBSAN: use the kernel panic message markers
Date: Mon, 18 Dec 2023 14:53:39 +0100

Use the same splat markers as panic does for easier matching by external
tools scanning kernel dmesg for splats.

Link: https://lkml.kernel.org/r/20231218135339.23209-1-bp@alien8.de
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/ubsan.c~ubsan-use-the-kernel-panic-message-markers
+++ a/lib/ubsan.c
@@ -204,8 +204,8 @@ static void ubsan_prologue(struct source
 {
 	current->in_ubsan++;
 
-	pr_err("========================================"
-		"========================================\n");
+	pr_warn(CUT_HERE);
+
 	pr_err("UBSAN: %s in %s:%d:%d\n", reason, loc->file_name,
 		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
 
@@ -215,8 +215,7 @@ static void ubsan_prologue(struct source
 static void ubsan_epilogue(void)
 {
 	dump_stack();
-	pr_err("========================================"
-		"========================================\n");
+	pr_warn("---[ end trace ]---\n");
 
 	current->in_ubsan--;
 
_

Patches currently in -mm which might be from bp@alien8.de are

ubsan-use-the-kernel-panic-message-markers.patch

