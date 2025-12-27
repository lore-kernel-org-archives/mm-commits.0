Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204FE2236F7
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 02:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767233364; cv=none; b=XjZEnexhPi9x/5jghV1UxYDtGpqlcOST8fvsGREX9HgINv0vU/CUsr3aYajp2EQotKOtw05v+4to0Tpp9COFDrqX4SwkzYa6hjKhvHDisRaknablbSw5zI71KBVRB7G0ssP67O3aR/2YXBOspy//k5ikQ+zS5cHjFy7l5xGHAcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767233364; c=relaxed/simple;
	bh=rxVz8H5QeSQTaHap8Zl9vW3ylak8HePs+hRJ16P1RBY=;
	h=Date:To:From:Subject:Message-Id; b=GByJ9QtaNNj74jeJtyrCwyU/Msck9L//Ng39jw/GO/eDYThbfQk4liZDcD96j0IfjJVKXzt2y5hMsXWbcgkzHChNcSLZNGUaKu8VMfwwSobBncWQ28a1NbXCPyFClzH3iImRFzMoG2dL4KueFmGW3DX9WqQs7m3+eC+pAcZAzVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VNPj7eWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VNPj7eWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC1EC113D0;
	Thu,  1 Jan 2026 02:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767233363;
	bh=rxVz8H5QeSQTaHap8Zl9vW3ylak8HePs+hRJ16P1RBY=;
	h=Date:To:From:Subject:From;
	b=VNPj7eWq+qN48LGU9/IXYtpDjUdJxvPDGjJ2NWRpE0d1BDQ6lcriOss6qEz+bmkEu
	 QnEvwPU/OOL1h0aTe4nTpgvflybF7pb/hVbAl3UqBGln4NDYKr0k1halqHRIa3eOGk
	 GoZz3mKr4mTjkUfIheCxVkyn6aLw6nRTSWyP1frg=
Date: Wed, 31 Dec 2025 18:09:23 +9900
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,peterz@infradead.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch added to mm-nonmm-unstable branch
Message-Id: <20260101020923.8DC1EC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: atomic: specify alignment for atomic_t and atomic64_t
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Finn Thain <fthain@linux-m68k.org>
Subject: atomic: specify alignment for atomic_t and atomic64_t
Date: Wed, 31 Dec 2025 19:25:42 +1100

Some recent commits incorrectly assumed 4-byte alignment of locks.  That
assumption fails on Linux/m68k (and, interestingly, would have failed on
Linux/cris also).  The jump label implementation makes a similar alignment
assumption.

The expectation that atomic_t and atomic64_t variables will be naturally
aligned seems reasonable, as indeed they are on 64-bit architectures.  But
atomic64_t isn't naturally aligned on csky, m68k, microblaze, nios2,
openrisc and sh.  Neither atomic_t nor atomic64_t are naturally aligned on
m68k.

This patch brings a little uniformity by specifying natural alignment for
atomic types.  One benefit is that atomic64_t variables do not get split
across a page boundary.  The cost is that some structs grow which leads to
cache misses and wasted memory.

Link: https://lkml.kernel.org/r/88df424bfb93bdabe73bf91f5985c5b89f04d123.1767169542.git.fthain@linux-m68k.org
Link: https://lore.kernel.org/lkml/CAFr9PX=MYUDGJS2kAvPMkkfvH+0-SwQB_kxE4ea0J_wZ_pk=7w@mail.gmail.com
Link: https://lore.kernel.org/lkml/CAMuHMdW7Ab13DdGs2acMQcix5ObJK0O2dG_Fxzr8_g58Rc1_0g@mail.gmail.com/
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Acked-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Hao Luo <haoluo@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin (Microsoft) <sashal@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic64.h |    2 +-
 include/linux/types.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-generic/atomic64.h~atomic-specify-alignment-for-atomic_t-and-atomic64_t
+++ a/include/asm-generic/atomic64.h
@@ -10,7 +10,7 @@
 #include <linux/types.h>
 
 typedef struct {
-	s64 counter;
+	s64 __aligned(sizeof(s64)) counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
--- a/include/linux/types.h~atomic-specify-alignment-for-atomic_t-and-atomic64_t
+++ a/include/linux/types.h
@@ -179,7 +179,7 @@ typedef phys_addr_t resource_size_t;
 typedef unsigned long irq_hw_number_t;
 
 typedef struct {
-	int counter;
+	int __aligned(sizeof(int)) counter;
 } atomic_t;
 
 #define ATOMIC_INIT(i) { (i) }
_

Patches currently in -mm which might be from fthain@linux-m68k.org are

bpf-explicitly-align-bpf_res_spin_lock.patch
atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch
atomic-add-option-for-weaker-alignment-check.patch

