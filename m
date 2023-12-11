Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07B77493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UWWLfCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A377C433C9;
	Mon, 11 Dec 2023 01:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257805;
	bh=7kxTLq30db4v7n8Pq/E0eF5NcmEczdU96osjhR1cMJ8=;
	h=Date:To:From:Subject:From;
	b=1UWWLfCuvD1rgv3Q5FPbbPTwDUCiqPp03hM7+/IieZUb61TAd+KmnV8DGayri895u
	 NQGo1uUHnWzRu9XbI10xQLP0bMcgxqOjsGDa/Da1o1X0MdJFVFy8y7Ns1tWgSDAS+j
	 fkMNIM66yBD1GfV8cYduqOXiAOj+ujZPjB1X9OgM=
Date: Sun, 10 Dec 2023 17:23:25 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-vm_events-remove-unused-dummy_handler.patch removed from -mm tree
Message-Id: <20231211012325.8A377C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: vm_events: remove unused dummy_handler()
has been removed from the -mm tree.  Its filename was
     hexagon-vm_events-remove-unused-dummy_handler.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: vm_events: remove unused dummy_handler()
Date: Thu, 30 Nov 2023 15:58:29 -0700

Clang warns:

  arch/hexagon/kernel/vm_events.c:76:6: warning: no previous prototype for function 'dummy_handler' [-Wmissing-prototypes]
     76 | void dummy_handler(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/vm_events.c:76:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     76 | void dummy_handler(struct pt_regs *regs)
        | ^
        | static

This function appears to be entirely unused, so remove it.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-16-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/vm_events.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/hexagon/kernel/vm_events.c~hexagon-vm_events-remove-unused-dummy_handler
+++ a/arch/hexagon/kernel/vm_events.c
@@ -73,13 +73,6 @@ void show_regs(struct pt_regs *regs)
 		pt_psp(regs), pt_badva(regs), ints_enabled(regs));
 }
 
-void dummy_handler(struct pt_regs *regs)
-{
-	unsigned int elr = pt_elr(regs);
-	printk(KERN_ERR "Unimplemented handler; ELR=0x%08x\n", elr);
-}
-
-
 void arch_do_IRQ(struct pt_regs *regs)
 {
 	int irq = pt_cause(regs);
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

