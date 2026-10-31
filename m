Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793412739;
	b=a/yIh/VF/sA/9h0c/WNltlrkxMhUgPAPAAurXCBAiV5d2gkTzyntypklUpq2rTMpvSrE
	 B9+UcRdkJAI1UP4z/Igd7q3iShBu1DcV2X4d25u/78mzh2uwTU41dbjcp/X9IRPBtrEIQ
	 AdRNnFSUWHDa8zPzYOdoVyJ/bEaJHHo4VmRAV3/O9sqbQH0D1mfHCvjgA+VdRuuDpEmgS
	 3n94Vkb0eWsNhQ/kMQUdlWBlY8eL8/jsQaPxg4TO9zxMsuWTqYAge+wsctjpTga9AYHJx
	 DVj5gh9HImZ3mNG2/rivudbmpHwcHKy6CC0klLQ7fKSNKE8VfcyIoP+Qa5nYpqs6x4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793412739;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=z3HM1AW+ThIEsoWwKhYtVmBhzEJjgEKpAW1F5yOX8No=;
	b=P0i3j8M9qVs/CyAr/63ocr3ePAZyvtkV7NhJbK2l1vrxDKVLKhKS0R9BO0BYhZGrqrar
	 HVdfQ/zB90upKNAyNhtAeeNswgvxJi6+DFfFUzxxaj5FzzYpX5zTt5SE1ubGmd6DdcVkX
	 Gu5diegzFxWmseH/suaBWC0pzJ2ez+Bq29r5A43cweFpmlNaOxsUWE2+ADXLRcMcmSzXt
	 ctCNuPVXdMgq0afiPCaQT4KUHJWuyL10ZaY3gV9J3TwYL4+qZWehSVWKDf3lY5PhVIQPc
	 DGM4NZ9gs2CgX3QLe5feaJ1w2ypO7Vfx67e2n9RNg0bcZHDem0yk9w5mPLjYYdN82Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vOaAfJHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6071E606A31C
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 02:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vOaAfJHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D274B1F000C1;
	Sat, 31 Oct 2026 02:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793412738;
	bh=z3HM1AW+ThIEsoWwKhYtVmBhzEJjgEKpAW1F5yOX8No=;
	h=Date:To:From:Subject;
	b=vOaAfJHgyDZdmWKb683OEWzWcZi9OhXPKjNbAbDhYr0NIvC0QHHebVT1O7kugIG8X
	 sGvlg0e3LFIjBdaM2G8ozmQYjVJ2py1nZEdXcnsVvaG6DjatTKfPVPkr9az/Ywb0gB
	 IXRmI+0O0Uv89uug8Vgsy0acpszTsjgMt3SeFGwE=
Date: Fri, 30 Oct 2026 19:12:18 -0700
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,
	rostedt@goodmis.org,mhiramat@kernel.org,memxor@gmail.com,matt@bobrowski.net,
	mathieu.desnoyers@efficios.com,martin.lau@linux.dev,marscheng@google.com,
	kpsingh@kernel.org,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,
	ihor.solodrai@linux.dev,hch@infradead.org,emil@etsalapatis.com,
	eleanor.lin@realtek.com,eddyz87@gmail.com,daniel@iogearbox.net,
	ast@kernel.org,andrii@kernel.org,visitorckw@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bpf-replace-sort_r_nonatomic-with-sort_r-in-check_dup_ids.patch added to mm-nonmm-unstable branch
Message-Id: <20261031021218.D274B1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: bpf: replace sort_r_nonatomic() with sort_r() in check_dup_ids()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bpf-replace-sort_r_nonatomic-with-sort_r-in-check_dup_ids.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bpf-replace-sort_r_nonatomic-with-sort_r-in-check_dup_ids.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bpf: replace sort_r_nonatomic() with sort_r() in check_dup_ids()
Date: Thu, 10 Sep 2026 16:52:20 +0000

Patch series "lib/sort: Clean up sort_nonatomic() and sort_r_nonatomic()",
v2.

kernel/trace/bpf_trace.c is the sole remaining user of sort_r_nonatomic().
Switch check_dup_ids() to sort_r() to match
bpf_kprobe_multi_link_attach() in the same file, which has safely used
sort_r() under the same limit (1U << 20) for 4 years.

With no users left in the tree, remove the unused sort_nonatomic() and
sort_r_nonatomic() APIs.  This drops the __sort_r() wrapper and eliminates
the may_schedule branch and cond_resched() from the inner sorting loop.


This patch (of 2):

bpf_kprobe_multi_link_attach() in the same file has been using sort_r()
under the exact same limit (1U << 20) for 4 years without issues.  Switch
check_dup_ids() from sort_r_nonatomic() to sort_r() to match it.

This removes the last in-tree user of sort_r_nonatomic(), allowing the
unused _nonatomic() sort variants to be dropped from the core library.

Link: https://lore.kernel.org/20260910165222.1186628-1-visitorckw@gmail.com
Link: https://lore.kernel.org/20260910165222.1186628-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: <matt@bobrowski.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: <martin.lau@linux.dev>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Emil Tsalapatis <emil@etsalapatis.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: <hch@infradead.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Yu-Chun Lin <eleanor.lin@realtek.com>
Cc: <marscheng@google.com>
---

 kernel/trace/bpf_trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/bpf_trace.c~bpf-replace-sort_r_nonatomic-with-sort_r-in-check_dup_ids
+++ a/kernel/trace/bpf_trace.c
@@ -3842,7 +3842,7 @@ static int check_dup_ids(u32 *ids, u64 *
 	 * and check it for duplicates. The ids and cookies arrays
 	 * are left sorted.
 	 */
-	sort_r_nonatomic(ids, cnt, sizeof(ids[0]), ids_cmp_r, ids_swap_r, data);
+	sort_r(ids, cnt, sizeof(ids[0]), ids_cmp_r, ids_swap_r, data);
 
 	for (int i = 1; i < cnt; i++) {
 		if (ids[i] == ids[i - 1]) {
_

Patches currently in -mm which might be from visitorckw@gmail.com are

bpf-replace-sort_r_nonatomic-with-sort_r-in-check_dup_ids.patch
revert-lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

