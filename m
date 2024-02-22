Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1F320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560148; cv=none; b=FmX38PGXrfLJQ5T2TyvrfR1XLPXwuh7hXiJytTkyR5uFsGlaELYlhBwgB4GWikALN+yYiG5DXpV1Wk4AXe1VrrI94tK+H4d4fqt8T1j2b9JynsqOGOQOPoXc5FGMOZTk2w3cZlyMb4EppnwBcq3Aza1GfQfHDUvbIuG4pFNK/r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560148; c=relaxed/simple;
	bh=h4phY4baE1ngrKKVY3TZGRVxN3w1/KaJVlqGID0fP7A=;
	h=Date:To:From:Subject:Message-Id; b=EEdCgH0RkiFQtP49tBrow+pIloOVkqNqUm/7JMSoQiQUiLSnihc7V4/UnM2krQ25OnaZ3J2YUMECkPanjQVG/STe8QfcmqzAdfgoqJljdFYiX/GhXssuffx5WZIxaphoYZ4hUNK3IcgCX7mHjdw5qpLC492ktDr+hUswKtlT3Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OWNe55IY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OWNe55IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0637FC433C7;
	Thu, 22 Feb 2024 00:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560148;
	bh=h4phY4baE1ngrKKVY3TZGRVxN3w1/KaJVlqGID0fP7A=;
	h=Date:To:From:Subject:From;
	b=OWNe55IYa7wRgZ+g9maUUG29IugvVbjbcCr+TRmAlpFnrIyVngdDNwrdK94OFAMYM
	 axIiyPPP7QqS/8CZmrvr5qm3npYEImtO8aRaBy4X85okqiDpyciGxzlTvPcz6OOu1G
	 sG0ursQ+++wl2reIrjP/tPJ1vZc1B1Uwnm/29nwM=
Date: Wed, 21 Feb 2024 16:02:27 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ptdump-add-check_wx_pages-debugfs-attribute.patch removed from -mm tree
Message-Id: <20240222000228.0637FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ptdump: add check_wx_pages debugfs attribute
has been removed from the -mm tree.  Its filename was
     mm-ptdump-add-check_wx_pages-debugfs-attribute.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


