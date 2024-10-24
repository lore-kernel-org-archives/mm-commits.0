Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3011B1779BB;
	Thu, 24 Oct 2024 06:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750525; cv=none; b=R9zQRee5NgEPJoW38uaH1IAgjMRM0uSE51wJm4DpgY1WkdfT2YPje4NojTEHocvSIb8oYnyaZhgK85a8BwjHH/76O+M/EscmS2GybOAyVvUwGFx27JwR5TEFZ9fT573zDsf+dWIYiaQznB3jgLxJVQ7hVR7sxrPf9+CvITdHqdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750525; c=relaxed/simple;
	bh=RRfyls5VlO56gLXXp0yjK5DT0o1gqbKmduVmiZK3y2A=;
	h=Date:To:From:Subject:Message-Id; b=DH+IcHHYX3l61lZDya3GbrrJqk2lVi7OypS5IMVzRKi7ZS2UDspBGJrfFwAAQx4mR1CpO9QvyLrKNRMp5WJWzCTYs7Yc9kPH6hTkvQIbyow/lLhZ4my8mN9PJrJHL/5bbBZy4qqn2uTxAcg7oyQR0Wo0RkdRfL+t2+FfLHNFseQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ABApSdJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ABApSdJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2511C4CEC7;
	Thu, 24 Oct 2024 06:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750525;
	bh=RRfyls5VlO56gLXXp0yjK5DT0o1gqbKmduVmiZK3y2A=;
	h=Date:To:From:Subject:From;
	b=ABApSdJa04AcnWB7rtliF6JUuxIe68KkTeQXeqMToIrC3iJWeVpPeZjjKcKJQLeXY
	 XyEQrHl/whMl5hkoLpBhS8yvcNBRzueoyKZZCJM3FjvOgA/EDL2pO06ZAQQnfb7APz
	 nEhvXRdJb/VqXXK5BftR7aI70nifi8vw5zpfGJc0=
Date: Wed, 23 Oct 2024 23:15:24 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,glider@google.com,dave.hansen@linux.intel.com,bp@alien8.de,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-traps-move-kmsan-check-after-instrumentation_begin.patch removed from -mm tree
Message-Id: <20241024061524.F2511C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/traps: move kmsan check after instrumentation_begin
has been removed from the -mm tree.  Its filename was
     x86-traps-move-kmsan-check-after-instrumentation_begin.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: x86/traps: move kmsan check after instrumentation_begin
Date: Wed, 16 Oct 2024 20:24:07 +0500

During x86_64 kernel build with CONFIG_KMSAN, the objtool warns following:

  AR      built-in.a
  AR      vmlinux.a
  LD      vmlinux.o
vmlinux.o: warning: objtool: handle_bug+0x4: call to
    kmsan_unpoison_entry_regs() leaves .noinstr.text section
  OBJCOPY modules.builtin.modinfo
  GEN     modules.builtin
  MODPOST Module.symvers
  CC      .vmlinux.export.o

Moving kmsan_unpoison_entry_regs() _after_ instrumentation_begin() fixes
the warning.

There is decode_bug(regs->ip, &imm) is left before KMSAN unpoisoining, but
it has the return condition and if we include it after
instrumentation_begin() it results the warning "return with
instrumentation enabled", hence, I'm concerned that regs will not be KMSAN
unpoisoned if `ud_type == BUG_NONE` is true.

Link: https://lkml.kernel.org/r/20241016152407.3149001-1-snovitoll@gmail.com
Fixes: ba54d194f8da ("x86/traps: avoid KMSAN bugs originating from handle_bug()")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/traps.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/traps.c~x86-traps-move-kmsan-check-after-instrumentation_begin
+++ a/arch/x86/kernel/traps.c
@@ -261,12 +261,6 @@ static noinstr bool handle_bug(struct pt
 	int ud_type;
 	u32 imm;
 
-	/*
-	 * Normally @regs are unpoisoned by irqentry_enter(), but handle_bug()
-	 * is a rare case that uses @regs without passing them to
-	 * irqentry_enter().
-	 */
-	kmsan_unpoison_entry_regs(regs);
 	ud_type = decode_bug(regs->ip, &imm);
 	if (ud_type == BUG_NONE)
 		return handled;
@@ -276,6 +270,12 @@ static noinstr bool handle_bug(struct pt
 	 */
 	instrumentation_begin();
 	/*
+	 * Normally @regs are unpoisoned by irqentry_enter(), but handle_bug()
+	 * is a rare case that uses @regs without passing them to
+	 * irqentry_enter().
+	 */
+	kmsan_unpoison_entry_regs(regs);
+	/*
 	 * Since we're emulating a CALL with exceptions, restore the interrupt
 	 * state to what it was at the exception site.
 	 */
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-kasan-kmsan-copy_from-to_kernel_nofault.patch
kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch
kasan-delete-config_kasan_module_test-fix.patch

