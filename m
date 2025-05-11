Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CBC1D6AA
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934594; cv=none; b=G9WEhEQBTK4nWdWqfTUNNFI6lDUoIIc2wFC/cIQSj032rHmsnNPCP5mD6qPArFqAdRYCtZYf/EU1ZNyXDtOGGY3Esxik1b49RsOo7LBHCpnht0StlzNv28XgvUTl46aMW+/eeBJJczNUu5zR8TbVjruTswus+yMCpvY9/yUs6ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934594; c=relaxed/simple;
	bh=IguAda0SFvxjVDe7AzqwHfR0KH3pLCWtxW2y907zCpc=;
	h=Date:To:From:Subject:Message-Id; b=gFrtiETyCh+mEyTkiZabauhr2GgY4H1XmtzM7TjCQK6PA3hTzXiJ4Ry6E59EVouI0rv1/R8TkUElnMAzYpraRkdaGl1HYSetdp6oT/rDByfsm/bOUIlsg12/guPRFrSZdvBfLPU8nM6rifJtjlkJB66aU/+D0Givazxs3NaYmhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TyqBeEea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TyqBeEea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACDBC4CEE4;
	Sun, 11 May 2025 03:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934593;
	bh=IguAda0SFvxjVDe7AzqwHfR0KH3pLCWtxW2y907zCpc=;
	h=Date:To:From:Subject:From;
	b=TyqBeEeaBF7qyDIy7ImlOlPzswRhD8EbE4Xcgpf3eTlhWL8yptfLPXeLcnHQFYc4Y
	 /SHWqo4Wi8cv/1IMizxxay+n+SYcZV01Rz4Oko898GxwB1WaydlL7Pk/abT1eWkOk3
	 xA/QmQ3ZG1eNzDe7FHsyZwSQhbCbtE3/ZOpkctu4=
Date: Sat, 10 May 2025 20:36:33 -0700
To: mm-commits@vger.kernel.org,macro@orcam.me.uk,ldv@strace.io,deller@gmx.de,charlie@rivosinc.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] syscallh-add-syscall_set_arguments-fix.patch removed from -mm tree
Message-Id: <20250511033633.CACDBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: syscallh-add-syscall_set_arguments-fix
has been removed from the -mm tree.  Its filename was
     syscallh-add-syscall_set_arguments-fix.patch

This patch was dropped because it was folded into syscallh-add-syscall_set_arguments.patch

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: syscallh-add-syscall_set_arguments-fix
Date: Tue, 8 Apr 2025 14:31:31 -0700

fix compile time fortify checks

Link: https://lkml.kernel.org/r/20250408213131.GA2872426@ax162
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Helge Deller <deller@gmx.de> # parisc
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: "Dmitry V. Levin" <ldv@strace.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/syscall.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/syscall.h~syscallh-add-syscall_set_arguments-fix
+++ a/arch/riscv/include/asm/syscall.h
@@ -74,8 +74,11 @@ static inline void syscall_set_arguments
 					 const unsigned long *args)
 {
 	regs->orig_a0 = args[0];
-	args++;
-	memcpy(&regs->a1, args, 5 * sizeof(regs->a1));
+	regs->a1 = args[1];
+	regs->a2 = args[2];
+	regs->a3 = args[3];
+	regs->a4 = args[4];
+	regs->a5 = args[5];
 }
 
 static inline int syscall_get_arch(struct task_struct *task)
_

Patches currently in -mm which might be from nathan@kernel.org are

syscallh-add-syscall_set_arguments.patch

