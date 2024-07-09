Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E61414374C
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 21:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561689; cv=none; b=IShMWvYYpJL1VORB4MNbT2OUeaYe77XarIYpFJ6Uj0oIXGBkApQhStd+5QxQ73sU4+6FGy98Y84UArtzZeeltptCdx/7t5ygmNPiguaxOOhatmrRN1szOZmed3UdZ0EgwDwgBaFBEB2FnKnleadv6Ip4RfuCtj54pVEdQnE90/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561689; c=relaxed/simple;
	bh=ziJl/j45bZlups9tDtuDecVfHx3YvjqZcjMbfQHEenY=;
	h=Date:To:From:Subject:Message-Id; b=cf4sCGiupgTxjDEmqayCrTe2jpb1vvVcs0JYZjR2ddWhJQY1tD9ztRuvmJCuduf5MJUOD9TkPOFFWrD+9m4AH0JqfNvPnp03MwjsrBaO0wQe1ccO9NehWUfhy1ATy4ZAKInC0bzRPweeFefjRSjMkur8ZCNd3l+1zSpDN/mmPOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=po8JxV9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="po8JxV9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBE9C3277B;
	Tue,  9 Jul 2024 21:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720561688;
	bh=ziJl/j45bZlups9tDtuDecVfHx3YvjqZcjMbfQHEenY=;
	h=Date:To:From:Subject:From;
	b=po8JxV9f9NbjUtkd3bnGBcqyU3yy++StvN3KaCoGtd6SdCjrJB9Vjc7FZo9osJIvL
	 hF2582kwoLLobPaBHPhhIjYpy44Wdjud9riJprUpn/eRO9K9HtjL2+JznbC7XA0pPN
	 TBSuB9te5fwX614yfZKiPGyarN5C3l0qcfTyaQ+U=
Date: Tue, 09 Jul 2024 14:48:08 -0700
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,sdf@fomichev.me,martin.lau@linux.dev,kpsingh@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,eddyz87@gmail.com,daniel@iogearbox.net,ast@kernel.org,andrii@kernel.org,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_bpf-convert-comma-to-semicolon.patch added to mm-nonmm-unstable branch
Message-Id: <20240709214808.BCBE9C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_bpf: convert comma to semicolon
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     test_bpf-convert-comma-to-semicolon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_bpf-convert-comma-to-semicolon.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Chen Ni <nichen@iscas.ac.cn>
Subject: test_bpf: convert comma to semicolon
Date: Tue, 9 Jul 2024 11:43:23 +0800

Replace commas between expression statements with semicolons.

Link: https://lkml.kernel.org/r/20240709034323.586185-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bpf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_bpf.c~test_bpf-convert-comma-to-semicolon
+++ a/lib/test_bpf.c
@@ -1740,7 +1740,7 @@ static int __bpf_emit_cmpxchg32(struct b
 	/* Result unsuccessful */
 	insns[i++] = BPF_STX_MEM(BPF_W, R10, R1, -4);
 	insns[i++] = BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R2, -4);
-	insns[i++] = BPF_ZEXT_REG(R0), /* Zext always inserted by verifier */
+	insns[i++] = BPF_ZEXT_REG(R0); /* Zext always inserted by verifier */
 	insns[i++] = BPF_LDX_MEM(BPF_W, R3, R10, -4);
 
 	insns[i++] = BPF_JMP32_REG(BPF_JEQ, R1, R3, 2);
@@ -1754,7 +1754,7 @@ static int __bpf_emit_cmpxchg32(struct b
 	/* Result successful */
 	i += __bpf_ld_imm64(&insns[i], R0, dst);
 	insns[i++] = BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R2, -4);
-	insns[i++] = BPF_ZEXT_REG(R0), /* Zext always inserted by verifier */
+	insns[i++] = BPF_ZEXT_REG(R0); /* Zext always inserted by verifier */
 	insns[i++] = BPF_LDX_MEM(BPF_W, R3, R10, -4);
 
 	insns[i++] = BPF_JMP32_REG(BPF_JEQ, R2, R3, 2);
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are

test_bpf-convert-comma-to-semicolon.patch

