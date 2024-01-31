Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1622B34CD5
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706683057; cv=none; b=bhadN2ClHNjUHHMC8vIHDrcjIUJ50c8q96Ynw4P7YWcT3ILS0yyJMkl4WWnlPSwGiV9h0z//73XDzeewaaCbAxSdIy4FDvBGT1Egugxrkm5gKjJE8W5wZgA2L7+FkdB+tQ3YIl/tK/ZA0v9ZJsCnOD7pD+X1RTwwjLVVqEa6Oh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706683057; c=relaxed/simple;
	bh=4F6loPYuz4N3RYJ9UDbbZKzNyNev+yIVtiRK4cZzxag=;
	h=Date:To:From:Subject:Message-Id; b=FQYY/9sn6Z+ar/pUy9aIMP6mEwxNK2MrT5e+YpRsHB1NE35n7uqCPO0l6Ud4vPsCQ+r4EwiCd1R+F3gv0zboQvF/cS3HL1SCgoykOpTCGFWgU8SsHZEXAfwuL+ORqr0XTtE+Mi2NYR0oYhKWQ3e2Xe+ItYPIYS0IBj79WSz4e/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WpUycozY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WpUycozY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E411AC433C7;
	Wed, 31 Jan 2024 06:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706683056;
	bh=4F6loPYuz4N3RYJ9UDbbZKzNyNev+yIVtiRK4cZzxag=;
	h=Date:To:From:Subject:From;
	b=WpUycozYaN4V5X/oF1dZ9IP5R/CuG+rZ/Pt+YI6wNPBOG1QkHcnOAvJhzjDmMxDNU
	 x5ovsMT5MrOPFwVsjwZI6yU7Z8aYmgmZrEdGRtb231ZM6qUNkK0XytNjdh1GMeMBGS
	 N5i5d5CbJ7UPHRkTY/Kz6Afa6MqjmSjhmddLuFc0=
Date: Tue, 30 Jan 2024 22:37:22 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ptdump-add-check_wx_pages-debugfs-attribute.patch added to mm-unstable branch
Message-Id: <20240131063734.E411AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ptdump: add check_wx_pages debugfs attribute
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ptdump-add-check_wx_pages-debugfs-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ptdump-add-check_wx_pages-debugfs-attribute.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: ptdump: add check_wx_pages debugfs attribute
Date: Tue, 30 Jan 2024 11:34:36 +0100

Add a readable attribute in debugfs to trigger a W^X pages check at any
time.

To trigger the test, just read /sys/kernel/debug/check_wx_pages It will
report FAILED if the test failed, SUCCESS otherwise.

Detailed result is provided into dmesg.

Link: https://lkml.kernel.org/r/e947fb1a9f3f5466344823e532d343ff194ae03d.1706610398.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Phong Tran <tranmanphong@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Price <steven.price@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ptdump.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/ptdump.c~mm-ptdump-add-check_wx_pages-debugfs-attribute
+++ a/mm/ptdump.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/pagewalk.h>
+#include <linux/debugfs.h>
 #include <linux/ptdump.h>
 #include <linux/kasan.h>
 
@@ -163,3 +164,24 @@ void ptdump_walk_pgd(struct ptdump_state
 	/* Flush out the last page */
 	st->note_page(st, 0, -1, 0);
 }
+
+static int check_wx_show(struct seq_file *m, void *v)
+{
+	if (ptdump_check_wx())
+		seq_puts(m, "SUCCESS\n");
+	else
+		seq_puts(m, "FAILED\n");
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(check_wx);
+
+static int ptdump_debugfs_init(void)
+{
+	debugfs_create_file("check_wx_pages", 0400, NULL, NULL, &check_wx_fops);
+
+	return 0;
+}
+
+device_initcall(ptdump_debugfs_init);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx.patch
arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx.patch
powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx.patch
mm-ptdump-have-ptdump_check_wx-return-bool.patch
mm-ptdump-add-check_wx_pages-debugfs-attribute.patch

