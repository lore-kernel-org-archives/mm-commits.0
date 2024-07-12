Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A2A12FB2F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 23:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827620; cv=none; b=Mwag/wNvhYPjE1J1UVDHYXAn8dQKK0OX5nGETKVONgURUkhLJG2MM6UX3TJlMBPN4k/ZW+BOXqilGp8IXoGnjPz34InTeZzUhRFcgmNh8J5WE3ONb77cQTdhDAWQuyfOyPoWLbsYFZNVZJVlTdr50TCwN6rcYzg89XYf+WPcarU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827620; c=relaxed/simple;
	bh=7E40y6a2wO65Kp769fRN9tDy/zXHV0VCv8QIWi44+1s=;
	h=Date:To:From:Subject:Message-Id; b=eeZyjDszttFWS4lsysqqsTv4d047tqpCrZXv8Aavu26Uv3AQuI3ib25gH0Wfeyhay/wPeajOZmPd7VQXU4VXAw/3yBmPeeqfQjbPAmTjdFOwvtaca9Ws0G4T6DW1LSd/Q/AIMjr8BSpIzYBvgasZQZH6kLS4DvVP69Gtaf0h6NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sCBsQ+RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sCBsQ+RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE50FC32782;
	Fri, 12 Jul 2024 23:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720827619;
	bh=7E40y6a2wO65Kp769fRN9tDy/zXHV0VCv8QIWi44+1s=;
	h=Date:To:From:Subject:From;
	b=sCBsQ+RTaxDD32NKLwZpG+ZMRN5X+U370fzh/zHSe34JvK8vpdQJMPCRN9lq79xmr
	 OgGu3mkf2sTPJEM5RofjUbe9YSKMWQIU7EcrzF5AczX+vPkakb24TwvipqQjc5aZEo
	 OSxen9OsCkydsDaNz2mg7tLR1t4egxh+4r6Wo9y4=
Date: Fri, 12 Jul 2024 16:40:19 -0700
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,sdf@fomichev.me,martin.lau@linux.dev,kpsingh@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,eddyz87@gmail.com,daniel@iogearbox.net,ast@kernel.org,andrii@kernel.org,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] test_bpf-convert-comma-to-semicolon.patch removed from -mm tree
Message-Id: <20240712234019.CE50FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_bpf: convert comma to semicolon
has been removed from the -mm tree.  Its filename was
     test_bpf-convert-comma-to-semicolon.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


