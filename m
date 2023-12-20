Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9AC4C634
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="geFHWwan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37ACC433C8;
	Wed, 20 Dec 2023 22:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112573;
	bh=SQdUNPRb542p05/pxFjpMFWe9GRoL4+EVcoYLqsRG8I=;
	h=Date:To:From:Subject:From;
	b=geFHWwanNJoqmjhbr9hwtYFnKWEMnnePOf8L/yJjpczwbaoG3tvteqgOcKyJYQRaW
	 e7T1pfzCebolOn/SzU+J0kgm/LqhA4wA/k7KOyrHLS842yODktYNSGQsufpPNs17gS
	 ROGs6DJsglPd9tM5jtdvIuMTG32ESQVmvmQMFW9Q=
Date: Wed, 20 Dec 2023 14:49:33 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,bp@alien8.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ubsan-use-the-kernel-panic-message-markers.patch removed from -mm tree
Message-Id: <20231220224933.D37ACC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: UBSAN: use the kernel panic message markers
has been removed from the -mm tree.  Its filename was
     ubsan-use-the-kernel-panic-message-markers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


