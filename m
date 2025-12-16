Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C922EC557
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 19:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765914601; cv=none; b=P8kJ71s0KCngQuLbxHGPmGmUKIZjGyjYiNdVwWqFLfH9Bsols6jrPb8KEu/4eIREcoOOWMECftUbV/I4ztn4p6Gv7A688OZ0sLqNU4CZoJ1J4D2swPKFfSW54hZYqegB30h3iB96wk6y7IxCUK2WuPHXXnvw7w2nNjWsxN5jAkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765914601; c=relaxed/simple;
	bh=sDLDJPjCCJ865bCLg6gNbA8me/Cz80PR+ExCDpoe/DQ=;
	h=Date:To:From:Subject:Message-Id; b=nhW1BNyP00rrqLHMZT0XQlyGin9lN371ueH2WzEBJmGU89FBFvggN9EsrOi6Gn8yBkV145vZ1ZubBEuyFU+bzsKpn9fv9Itwa56rGb43GL0N/8/px3gIlYvKn1laHkEu+ybw7hKC8UbWLcF0OEMaUM572/HTzzlzmiB1r+8qync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bsxUQfXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bsxUQfXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9EEC4CEF1;
	Tue, 16 Dec 2025 19:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765914600;
	bh=sDLDJPjCCJ865bCLg6gNbA8me/Cz80PR+ExCDpoe/DQ=;
	h=Date:To:From:Subject:From;
	b=bsxUQfXv3SSNdnXOYx3G/nMbEiVZThQEznmFii/zOpQhw4pkJxQzpNkQra8BoNh/h
	 rG1UseOEt/sEKXw4zHz35rgUTjn6Xl17pKINylPUGyEydsesXo6wo5y1S3FP1QxVDU
	 ihAImgPnxIySkcvAH7/cmwhxhq94shEhrL5Ncn8s=
Date: Tue, 16 Dec 2025 11:49:59 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,peterz@infradead.org,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,daniel@iogearbox.net,dalias@libc.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch added to mm-nonmm-unstable branch
Message-Id: <20251216195000.8B9EEC4CEF1@smtp.kernel.org>
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
Date: Tue, 16 Dec 2025 17:31:05 +1100

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

Link: https://lkml.kernel.org/r/d6cd17b387fa4b4cf9f419ec586ac4756bc7aaeb.1765866665.git.fthain@linux-m68k.org
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
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
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
@@ -180,7 +180,7 @@ typedef phys_addr_t resource_size_t;
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

