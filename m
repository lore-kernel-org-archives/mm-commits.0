Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697723112DB
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967415; cv=none; b=qyzqSQW8/NLEVzVTSxqttDYg1XkYWHZQVzZx2SJbgDUkyt4CBZ3auQIjYkMyE9tR9l3r1cdmvoKUuL5FA9QWh224HLXMx7YznXuCaHh/C2d+rRmgxD72U2Pkue83p3gU7CzS0CPY5el/nBM3w7OZKwqBnbuEa6YqDv9rPqXSs7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967415; c=relaxed/simple;
	bh=8sbJz2Ow/VHHCw6I1d9m/jeRh8YHHVJaBgVovtqlVro=;
	h=Date:To:From:Subject:Message-Id; b=e6r5DCqXT9HTnZ2dH2wkPE0o8rpcszbzwvjUgOsokVy+APwmsAZB17GX0BhqO5/aUCTiGLoVM3iQWNQMAHa73Qe+s1lO/MSvJAD4MkV1WcfjBKccLowCgS6dzH619peKc9pSlJFgie70VHZHPzlNhS6OjCe8d8IBCVZEYcQaebo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPVxtiyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPVxtiyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC18BC19424;
	Wed, 21 Jan 2026 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967414;
	bh=8sbJz2Ow/VHHCw6I1d9m/jeRh8YHHVJaBgVovtqlVro=;
	h=Date:To:From:Subject:From;
	b=VPVxtiyGipbZTCqQz+sj1RX1Z4XGM6hEF39Ej35CXfAhTCj+e+IvuL9rsE1devBH8
	 lCUYzAC7LUI/fdXIz646JqhOu3fPz7Q9T09wmWMFjndHt8CTFqUn9vJ/8i9MVC5uk3
	 qdtnrtKiJisSAPIlRXdoa90sj6ts19TyKAaaMdjU=
Date: Tue, 20 Jan 2026 19:50:14 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,peterz@infradead.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bpf-explicitly-align-bpf_res_spin_lock.patch removed from -mm tree
Message-Id: <20260121035014.AC18BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bpf: explicitly align bpf_res_spin_lock
has been removed from the -mm tree.  Its filename was
     bpf-explicitly-align-bpf_res_spin_lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Finn Thain <fthain@linux-m68k.org>
Subject: bpf: explicitly align bpf_res_spin_lock
Date: Tue, 13 Jan 2026 16:22:28 +1100

Patch series "Align atomic storage", v7.

This series adds the __aligned attribute to atomic_t and atomic64_t
definitions in include/linux and include/asm-generic (respectively) to get
natural alignment of both types on csky, m68k, microblaze, nios2, openrisc
and sh.

This series also adds Kconfig options to enable a new run-time warning to
help reveal misaligned atomic accesses on platforms which don't trap that.

The performance impact is expected to vary across platforms and workloads.
The measurements I made on m68k show that some workloads run faster and
others slower.


This patch (of 4):

Align bpf_res_spin_lock to avoid a BUILD_BUG_ON() when the alignment
changes, as it will do on m68k when, in a subsequent patch, the minimum
alignment of the atomic_t member of struct rqspinlock gets increased from
2 to 4.  Drop the BUILD_BUG_ON() as it becomes redundant.

Link: https://lkml.kernel.org/r/cover.1768281748.git.fthain@linux-m68k.org
Link: https://lkml.kernel.org/r/8a83876b07d1feacc024521e44059ae89abbb1ea.1768281748.git.fthain@linux-m68k.org
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Guo Ren <guoren@kernel.org>
Cc: Hao Luo <haoluo@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Sasha Levin (Microsoft) <sashal@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/rqspinlock.h |    2 +-
 kernel/bpf/rqspinlock.c          |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/asm-generic/rqspinlock.h~bpf-explicitly-align-bpf_res_spin_lock
+++ a/include/asm-generic/rqspinlock.h
@@ -28,7 +28,7 @@ struct rqspinlock {
  */
 struct bpf_res_spin_lock {
 	u32 val;
-};
+} __aligned(__alignof__(struct rqspinlock));
 
 struct qspinlock;
 #ifdef CONFIG_QUEUED_SPINLOCKS
--- a/kernel/bpf/rqspinlock.c~bpf-explicitly-align-bpf_res_spin_lock
+++ a/kernel/bpf/rqspinlock.c
@@ -694,7 +694,6 @@ __bpf_kfunc int bpf_res_spin_lock(struct
 	int ret;
 
 	BUILD_BUG_ON(sizeof(rqspinlock_t) != sizeof(struct bpf_res_spin_lock));
-	BUILD_BUG_ON(__alignof__(rqspinlock_t) != __alignof__(struct bpf_res_spin_lock));
 
 	preempt_disable();
 	ret = res_spin_lock((rqspinlock_t *)lock);
_

Patches currently in -mm which might be from fthain@linux-m68k.org are


