Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEC2330654
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967417; cv=none; b=Zw2GUOfnl7ymbpcjRQNScWhbtKJ/7N5L042Jb/XbYLnzgswbCevf/s4kZqWd8rpxZjbLrJTrChigjAq28HbjeN/He1zK9rdvogKsIkQ7ZVdKCFTqYLBdbuP+Qpz55sdwaGKDQOFbBC4QsM+PfFWxsS5EM6avCAIagEKo3/zTq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967417; c=relaxed/simple;
	bh=popbt+mVPLvl6VymQ0dWj6S8+PN5YfM4Ww+fFjtlUUM=;
	h=Date:To:From:Subject:Message-Id; b=bthFmZjRPj23Ed3BY+/Z0bCZJIpgHdKjdCNQpHimRKdExbJ/vp87HCSa9/G99UgJPO/1dVNlcnK3GrsL2l6qbLci/Mw3emH6xDopRcshAhsRqqZfZU3DnU13cLyllNKRpg2ZMA+ollZwRhqOF1CLPKM7cw4Tsk6unvNcUXCGZ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OWKcl6WE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OWKcl6WE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F32C116D0;
	Wed, 21 Jan 2026 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967416;
	bh=popbt+mVPLvl6VymQ0dWj6S8+PN5YfM4Ww+fFjtlUUM=;
	h=Date:To:From:Subject:From;
	b=OWKcl6WEywvMNOTQbnpmU0m84yRCE4a9OJZr6FX4+Kt4wHH+yAzjcBKaEMuLeLq8d
	 ylAWaUdyFpxeUmyGu6A6DJRKWcQXWx7+e7n2X4HMtrBVOBl5Zs6O8tbsTYKIECCeUt
	 cD10o6zCwt6EyZI3HfPsWxFk1qgXrqnK9vxrPQz8=
Date: Tue, 20 Jan 2026 19:50:16 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,peterz@infradead.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch removed from -mm tree
Message-Id: <20260121035016.98F32C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: atomic: specify alignment for atomic_t and atomic64_t
has been removed from the -mm tree.  Its filename was
     atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Finn Thain <fthain@linux-m68k.org>
Subject: atomic: specify alignment for atomic_t and atomic64_t
Date: Tue, 13 Jan 2026 16:22:28 +1100

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

See also, commit bbf2a330d92c ("x86: atomic64: The atomic64_t data type
should be 8 bytes aligned on 32-bit too").

Link: https://lkml.kernel.org/r/a76bc24a4e7c1d8112d7d5fa8d14e4b694a0e90c.1768281748.git.fthain@linux-m68k.org
Link: https://lore.kernel.org/lkml/CAFr9PX=MYUDGJS2kAvPMkkfvH+0-SwQB_kxE4ea0J_wZ_pk=7w@mail.gmail.com
Link: https://lore.kernel.org/lkml/CAMuHMdW7Ab13DdGs2acMQcix5ObJK0O2dG_Fxzr8_g58Rc1_0g@mail.gmail.com/
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Acked-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Guo Ren <guoren@kernel.org>
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
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
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


