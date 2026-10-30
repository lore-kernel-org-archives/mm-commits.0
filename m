Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793332663;
	b=QlI/MOeWjUTNSWkSNz0xiD/DMsL0pAcUA9lR8wQbM9A2B+dkHSM+jrr0ZgKWcRhdJtPP
	 l9EyW/mM7ukhSKzpNUmUGsZvhGue9QY+pgtkRsSK7uz5jUbk0xg3MlSXSc5BrXNOSul5T
	 IymhbIG0BGUJ2M8lgjIT+HjQngM3se5RZYOVA8n3A239sT2SNfMMPazhphd6/jFddaio8
	 yJK5raEuNZnTcHJ7vC5JQjP0ZJ+ofyKslPtySRMzZaYfZDcoOrqmED57E+ybfrzEYC2Hz
	 FEkC+jQ21o3o79uUuV5hBnePmccaL3hdiLw/33q8145dFRp4dqr+vfZBWIkByeAdT7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793332663;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cTZ1UXj2TwtoxH7WI8yDJz/z0lozFLIwNfxkmtodEl8=;
	b=1+V1lhmJ8X3RN4LyVvT/8BbxEHOVj+/OwS6Af+CcJTyD66T8yGR9XAf48YvhqLHkWUMM
	 c9YFWh3xDJbmkMMQaa8thqr94sPuwDtGG3/a+//NdkEt3YyjA6hx2gY4OqiNR8WtmVm3Y
	 SAzkcSqIlJbk3GyS7CfykEr+GdgX2DBWsirvO64TDaw+bUIUBNcTIliMl6/sdrMETeJq7
	 7Vgd6niv7Uysw608E2isr3KCYiTI5e3AiiP/GGlEnidUUvm3PzDhnJdQNMwXLE5yow1pp
	 NfMjp0VkFFDfFvU6ZDSkdWh+i9VvZboxD0lIaO1Rbb+rwHwnjVFj72CyzhzGVan/Hzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gnQyjPAD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58067606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gnQyjPAD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60DD1F000C1;
	Fri, 30 Oct 2026 03:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793332662;
	bh=cTZ1UXj2TwtoxH7WI8yDJz/z0lozFLIwNfxkmtodEl8=;
	h=Date:To:From:Subject;
	b=gnQyjPAD2vT2MVQKixQ5QziBAu8kK9IOfuMXkPsfx+Lq/NUIzYQCj4YZVlwGv1ZTH
	 Z79EauxAGbuCgZh3Y7Xsrx4JSn0U/o6aMECoYfwWw5Tn4CSR3+oJPUh1/rDKeeQy5P
	 W5sLYg3NV6ARl0+ruU9brV6AFtCn0Pp3vAZRq/RQ=
Date: Thu, 29 Oct 2026 20:57:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vincenzo.frascino@arm.com,
	tglx@kernel.org,svens@linux.ibm.com,sshegde@linux.ibm.com,shuah@kernel.org,
	ryabinin.a.a@gmail.com,ritesh.list@gmail.com,pjw@kernel.org,peter@pcc.me.uk,
	palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,
	mark.rutland@arm.com,maddy@linux.ibm.com,linux@armlinux.org.uk,
	kees@kernel.org,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,
	glider@google.com,elver@google.com,dvyukov@google.com,
	dave.hansen@linux.intel.com,chleroy@kernel.org,catalin.marinas@arm.com,
	bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,
	andreyknvl@gmail.com,alex@ghiti.fr,agordeev@linux.ibm.com,
	odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad.patch added to mm-new branch
Message-Id: <20261030035742.D60DD1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: word-at-a-time: check the first byte in load_unaligned_zeropad()
has been added to the -mm mm-new branch.  Its filename is
     word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: word-at-a-time: check the first byte in load_unaligned_zeropad()
Date: Fri, 23 Oct 2026 09:49:48 +0800

Patch series "word-at-a-time: let KASAN see load_unaligned_zeropad()", v2.

load_unaligned_zeropad() is inline assembly, so KASAN and KCSAN never see
the word loads that sized_strscpy(), the dcache name compare, path name
hashing and x86 csum_partial() do through it.  While reviewing a strscpy()
KASAN fix, Peter Collingbourne suggested checking the first byte inside
load_unaligned_zeropad() itself, as read_word_at_a_time() does [1].

Patch 1 adds that check on the six architectures that implement
load_unaligned_zeropad(). Patch 2 adds a KASAN KUnit case for it.


This patch (of 2):

load_unaligned_zeropad() reads a word that may run into an unmapped page
and recovers through an exception fixup.  It does the word loads of
sized_strscpy() and of the name compare in dentry_string_cmp(), path
components in hash_name() and hashlen_string(), and the trailing bytes in
x86's csum_partial().

It is inline assembly on every architecture that implements it, so KASAN
and KCSAN never see these loads, while read_word_at_a_time() at least
checks the first byte of each word.  A use-after-free or out-of-bounds
read of a name handed to path lookup goes unreported, and so does
strscpy() reading from a bad source, which the kasan_strings KUnit case
expects to be reported.  On x86_64 with generic KASAN:

  KASAN and string KUnit suites      failures
                                  before    after
  CONFIG_FORTIFY_SOURCE=n              1        0
  CONFIG_FORTIFY_SOURCE=y              1        0

Check the first byte with instrument_read() at the start of
load_unaligned_zeropad() on every architecture, as read_word_at_a_time()
does.  All callers only load a word whose first byte belongs to the string
or buffer they read, so the check does not flag their intended reads past
the end.  Add a no-op instrument_read() for the powerpc selftest that
builds the header in user space.

Link: https://lore.kernel.org/r/CAPQLkRhXZwozmfhNd_PEx1ihwdH1_5qthP6PANYJ_m-v9vfQTw@mail.gmail.com [1]
Link: https://lore.kernel.org/20261023-bug-word-at-a-time-zeropad-kasan-v2-0-be0ecfbae847@gmail.com
Link: https://lore.kernel.org/20261023-bug-word-at-a-time-zeropad-kasan-v2-1-be0ecfbae847@gmail.com
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Peter Collingbourne <peter@pcc.me.uk>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: AlexandreGhiti <alex@ghiti.fr>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Kees Cook <kees@kernel.org>
---

 arch/arm/include/asm/word-at-a-time.h                           |    5 +++++
 arch/arm64/include/asm/word-at-a-time.h                         |    4 ++++
 arch/powerpc/include/asm/word-at-a-time.h                       |    4 ++++
 arch/riscv/include/asm/word-at-a-time.h                         |    4 ++++
 arch/s390/include/asm/word-at-a-time.h                          |    4 ++++
 arch/x86/include/asm/word-at-a-time.h                           |    4 ++++
 tools/testing/selftests/powerpc/primitives/linux/instrumented.h |    3 +++
 7 files changed, 28 insertions(+)

--- a/arch/arm64/include/asm/word-at-a-time.h~word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad
+++ a/arch/arm64/include/asm/word-at-a-time.h
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -45,6 +46,9 @@ static inline unsigned long load_unalign
 {
 	unsigned long ret;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	__mte_enable_tco_async();
 
 	/* Load word from unaligned pointer addr */
--- a/arch/arm/include/asm/word-at-a-time.h~word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad
+++ a/arch/arm/include/asm/word-at-a-time.h
@@ -56,6 +56,8 @@ static inline unsigned long find_zero(un
 #include <asm-generic/word-at-a-time.h>
 #endif
 
+#include <linux/instrumented.h>
+
 #ifdef CONFIG_DCACHE_WORD_ACCESS
 
 /*
@@ -69,6 +71,9 @@ static inline unsigned long load_unalign
 {
 	unsigned long ret, tmp;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	/* Load word from unaligned pointer addr */
 	asm(
 	"1:	ldr	%0, [%2]\n"
--- a/arch/powerpc/include/asm/word-at-a-time.h~word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad
+++ a/arch/powerpc/include/asm/word-at-a-time.h
@@ -5,6 +5,7 @@
  * Word-at-a-time interfaces for PowerPC.
  */
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 #include <asm/asm-compat.h>
 #include <asm/extable.h>
@@ -168,6 +169,9 @@ static inline unsigned long load_unalign
 {
 	unsigned long ret, offset, tmp;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	asm(
 	"1:	" PPC_LL "%[ret], 0(%[addr])\n"
 	"2:\n"
--- a/arch/riscv/include/asm/word-at-a-time.h~word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad
+++ a/arch/riscv/include/asm/word-at-a-time.h
@@ -11,6 +11,7 @@
 
 #include <asm/asm-extable.h>
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -60,6 +61,9 @@ static inline unsigned long load_unalign
 {
 	unsigned long ret;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	/* Load word from unaligned pointer addr */
 	asm(
 	"1:	" REG_L " %0, %2\n"
--- a/arch/s390/include/asm/word-at-a-time.h~word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad
+++ a/arch/s390/include/asm/word-at-a-time.h
@@ -3,6 +3,7 @@
 #define _ASM_WORD_AT_A_TIME_H
 
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 #include <asm/asm-extable.h>
 #include <asm/bitsperlong.h>
@@ -52,6 +53,9 @@ static inline unsigned long load_unalign
 {
 	unsigned long data;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	asm_inline volatile(
 		"0:	lg	%[data],0(%[addr])\n"
 		"1:\n"
--- a/arch/x86/include/asm/word-at-a-time.h~word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad
+++ a/arch/x86/include/asm/word-at-a-time.h
@@ -3,6 +3,7 @@
 #define _ASM_WORD_AT_A_TIME_H
 
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -71,6 +72,9 @@ static inline unsigned long load_unalign
 {
 	unsigned long ret;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	asm volatile(
 		"1:	mov %[mem], %[ret]\n"
 		"2:\n"
diff --git a/tools/testing/selftests/powerpc/primitives/linux/instrumented.h a/tools/testing/selftests/powerpc/primitives/linux/instrumented.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/powerpc/primitives/linux/instrumented.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* There is nothing for KASAN or KCSAN to check in user space. */
+#define instrument_read(p, size)	((void)(p), (void)(size))
_

Patches currently in -mm which might be from odys.yuan@gmail.com are

selftests-mm-track-the-modules-run_vmtestssh-loads.patch
selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch
word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad.patch
kasan-test-cover-load_unaligned_zeropad.patch

