Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7651C07E1;
	Wed, 16 Oct 2024 21:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729115056; cv=none; b=sGy6t6T3Kss0dqoXVbbVLARXmD2Ko6recRbSU4UGCHAUMbAdRn52kOHVis58SxtXK6nTI44tAdppYQvZi7FKY1i2jTA4PQ8lIzoj3+mURM2IAsgWv9biLe34YuSlHmxjufNMByb2J48OBxIP3OnO0525ZdVUvqNj34Qj/sLmUlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729115056; c=relaxed/simple;
	bh=4+lHm9ImuQE82ZpWm+YVKOxyojVXUWrhR6KsSBKQM/0=;
	h=Date:To:From:Subject:Message-Id; b=QEvQ+ePTl8WHcBp9gy/Ozpcf+0cy5yC3VQKJkAUW88MEF0xunqHE8UkTFvu03VKd2oZ3ejXHBnMUBR1rtAVK2aAAJEZW/RmX2rY8UxwlhFGQmrjv3tqbElqbeMFtZ+8zeyueEsQge2hbh/NF+TgHXCSBQOEImRdv4ITKF9oPgXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i419QJnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i419QJnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1129C4CEC5;
	Wed, 16 Oct 2024 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729115055;
	bh=4+lHm9ImuQE82ZpWm+YVKOxyojVXUWrhR6KsSBKQM/0=;
	h=Date:To:From:Subject:From;
	b=i419QJnk7yhmN+Ohcmz5sefwXwE8X/b1diSs16AUCUf51lUWJ9Uswu7UhlauHeA2A
	 pnGX8/UElV62l9ulnqwZ0LMFt2HNgKZQHVDnHn/F5DHkKnqwFq8u/Y88+jffKs+vOb
	 WoUBjPf3tAmwpvXcsmwcPHD2eiutE8P6/ZFRI6JE=
Date: Wed, 16 Oct 2024 14:44:15 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,glider@google.com,dave.hansen@linux.intel.com,bp@alien8.de,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-traps-move-kmsan-check-after-instrumentation_begin.patch added to mm-hotfixes-unstable branch
Message-Id: <20241016214415.D1129C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/traps: move kmsan check after instrumentation_begin
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-traps-move-kmsan-check-after-instrumentation_begin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-traps-move-kmsan-check-after-instrumentation_begin.patch

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

x86-traps-move-kmsan-check-after-instrumentation_begin.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

