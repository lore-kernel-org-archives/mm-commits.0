Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1B12EC557
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 19:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765914598; cv=none; b=krJ/imgP8lvw1AMSfJS/h6cZYQlhBeSFPl4OOMXFhQlUY9oOxb6HKG4UvZSTUGJGeLfExYzvSL/r4oW6rMW523O90RPEb66yRncBcPXzdQ3V89QROB92uk8dUQn9wKsbqfYA7P+rJIlhvOIYb2IgIyqAUqH9gHWqvluAghUbW20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765914598; c=relaxed/simple;
	bh=zLq9VCcVt3mLct6K6llKqtvFLdtIihQfaGWaYDzbOt0=;
	h=Date:To:From:Subject:Message-Id; b=eha+JLKnRlRBlLlWwd9EHFDNd7Qa/u20YbRjnHAPEJH0UBt5w60OV7UQioiCF+givJKjejdUGdA9/04ToaDnGkcXMhYTPn0fhCWsX8bxn1m11e3q5XBCIIyvvfL55nQ5AoDiifNawqy1fQTqM4L1kem1J1EXOvXMwxNsVnhSIf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TYujHl/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TYujHl/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DE7C4CEF1;
	Tue, 16 Dec 2025 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765914597;
	bh=zLq9VCcVt3mLct6K6llKqtvFLdtIihQfaGWaYDzbOt0=;
	h=Date:To:From:Subject:From;
	b=TYujHl/aukmZVv6xN4AFaD0zc7GKJgyk66sMW+XvtVUsksUzyhes1cHjwNR/o4slK
	 VAFBqWYDi9g2dbjehlZWhxwpuhM6SDgiYVveEscqZjnAu6eDxjci6bKOBMFNKHAeyI
	 vMsXa6jf0awRVn8DIix8jcmXwsrhwPnhBnzgEy9g=
Date: Tue, 16 Dec 2025 11:49:56 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,peterz@infradead.org,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,daniel@iogearbox.net,dalias@libc.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bpf-explicitly-align-bpf_res_spin_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20251216194957.70DE7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bpf: explicitly align bpf_res_spin_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bpf-explicitly-align-bpf_res_spin_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bpf-explicitly-align-bpf_res_spin_lock.patch

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
Subject: bpf: explicitly align bpf_res_spin_lock
Date: Tue, 16 Dec 2025 17:31:05 +1100

Patch series "Align atomic storage", v5.

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

Link: https://lkml.kernel.org/r/cover.1765866665.git.fthain@linux-m68k.org
Link: https://lkml.kernel.org/r/4ff540deaf87eb24ba11bbac95bdbea68d22a129.1765866665.git.fthain@linux-m68k.org
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Guo Ren <guoren@kernel.org>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
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

bpf-explicitly-align-bpf_res_spin_lock.patch
atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch
atomic-add-option-for-weaker-alignment-check.patch

