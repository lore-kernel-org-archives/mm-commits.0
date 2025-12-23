Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B760A34B433;
	Tue, 23 Dec 2025 19:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766518052; cv=none; b=R7SQKGdRwynGskb5rGLBFD02qBPU6CtlbwIDCZpxARBNey0rjZsvvm6/EO6rDny6zAw0Gumhqzpgr0hSx27RMoO80obgWFNIPiCyiP24cAaKMYys6rR1zNuczOG/fcvA+n6hYbOnKCDs8Gp55eX9YoBcc1M4JflQWFPg5KVuB6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766518052; c=relaxed/simple;
	bh=w/mM1RtlPC6+5CfYRU4ZgCWz1IFYWz8OSAL7MrhqG8s=;
	h=Date:To:From:Subject:Message-Id; b=SE8ufSQC5akR3kwWCMUM5ydfktkLnEbPUrveGj1gF/FmYwJX8ptwRVELxF6VEU946P7hiLuOscBuz2I+q27RgjFQAnVo3BwQVGifIIOwV7FnAh0IWcWoCi5UPPArAESUbA44EjhORJk20S9kALRtz+EkCm5AkX2iYuLii2FBzRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DLYIi9pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLYIi9pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787F1C113D0;
	Tue, 23 Dec 2025 19:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766518052;
	bh=w/mM1RtlPC6+5CfYRU4ZgCWz1IFYWz8OSAL7MrhqG8s=;
	h=Date:To:From:Subject:From;
	b=DLYIi9ppdiw4Z3b7OQImI2BDcPCCly4JBSKLukHiefcHJdpNHfHnjnZY2Q0tZVnlR
	 8pgF7hioIEvLRPPMpeh7MjrL0JnB60zH+vxjp2EFM2ENLcAwkLOJMELjr+PsL4oY23
	 MS5AOGCQ57VEqwghQMVXiLkNM3FBB+A2hojptt7Q=
Date: Tue, 23 Dec 2025 11:27:31 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yonghong.song@linux.dev,weixugc@google.com,syzbot+e008db2ac01e282550ee@syzkaller.appspotmail.com,stable@vger.kernel.org,song@kernel.org,shakeel.butt@linux.dev,sdf@fomichev.me,osandov@fb.com,mhocko@kernel.org,martin.lau@linux.dev,lorenzo.stoakes@oracle.com,kpsingh@kernel.org,kartikey406@gmail.com,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,hannes@cmpxchg.org,eddyz87@gmail.com,david@kernel.org,daniel@iogearbox.net,axelrasmussen@google.com,ast@kernel.org,andrii@kernel.org,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] buildid-validate-page-backed-file-before-parsing-build-id.patch removed from -mm tree
Message-Id: <20251223192732.787F1C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buildid: validate page-backed file before parsing build ID
has been removed from the -mm tree.  Its filename was
     buildid-validate-page-backed-file-before-parsing-build-id.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Jinchao Wang <wangjinchao600@gmail.com>
Subject: buildid: validate page-backed file before parsing build ID
Date: Tue, 23 Dec 2025 18:32:07 +0800

__build_id_parse() only works on page-backed storage.  Its helper paths
eventually call mapping->a_ops->read_folio(), so explicitly reject VMAs
that do not map a regular file or lack valid address_space operations.

Link: https://lkml.kernel.org/r/20251223103214.2412446-1-wangjinchao600@gmail.com
Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reported-by: <syzbot+e008db2ac01e282550ee@syzkaller.appspotmail.com>
Tested-by: <syzbot+e008db2ac01e282550ee@syzkaller.appspotmail.com>
  Link: https://lkml.kernel.org/r/694a67ab.050a0220.19928e.001c.GAE@google.com
Closes: https://lkml.kernel.org/r/693540fe.a70a0220.38f243.004c.GAE@google.com
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/buildid.c~buildid-validate-page-backed-file-before-parsing-build-id
+++ a/lib/buildid.c
@@ -288,7 +288,10 @@ static int __build_id_parse(struct vm_ar
 	int ret;
 
 	/* only works for page backed storage  */
-	if (!vma->vm_file)
+	if (!vma->vm_file ||
+	    !S_ISREG(file_inode(vma->vm_file)->i_mode) ||
+	    !vma->vm_file->f_mapping->a_ops ||
+	    !vma->vm_file->f_mapping->a_ops->read_folio)
 		return -EINVAL;
 
 	freader_init_from_file(&r, buf, sizeof(buf), vma->vm_file, may_fault);
_

Patches currently in -mm which might be from wangjinchao600@gmail.com are


