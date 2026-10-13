Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CFA481FCA
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865942; cv=none; b=IiWB8XziAGhh1ll97MZ8d30A3qKqU/osM3wFCS2GYEjP7B8bukvuvZ3Os26qhS0sOrf4lfV+5grgyF987a9M4znJYvitgB2DkXLGSXt2dW8psI4jJjP2yxwLZAa/lGFch0btDxI9oZa+fLQLtz1nYHYuNMNs1xKCcpH37dYaXuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865942; c=relaxed/simple;
	bh=+uCw6Ds2c5oJHeyvqRYUDI/lM09vdEYge+gRlVuokaU=;
	h=Date:To:From:Subject:Message-Id; b=gBaM0i4Vy7Nsn2KdAmqIB9vx/l+uOwffj6owLJAGTYN501nrGzqC5Km8YM0a25GhK0Nq4sxXTFuOxQAnFR8gBM0BplX/K2AqGD8MUPO83OpWrn4HPDOU9jvFPGwhxnuTQ48kJcsG9PWDAqiSXAP5vSn82vm4vd8/WOhgUPuKsxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xsLLibFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xsLLibFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B681F00893;
	Tue, 13 Oct 2026 04:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865941;
	bh=fo5AtCfgPXGCB0UuS8XaN1Sl07phbakpYtgmhlMxajQ=;
	h=Date:To:From:Subject;
	b=xsLLibFZaFZ+aYPAsrzl42rMG0jmFfJs1JekuJkqHWXjmMJV8UhqqsXQaiYGsoafh
	 svXIycIr57isJVFVIBmoEpcWuffYt3zxUlQ0/5CSI3TPM+W4qwKkbxq4O21FVK9qCV
	 2yAdLxZ2IZkPoC8qlwdrrkMeg/ZuX8qTpF1frKSk=
Date: Mon, 12 Oct 2026 21:32:20 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,hanchuanhua802@gmail.com,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch removed from -mm tree
Message-Id: <20261013043221.19B681F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: restore accidentally removed seq < max_seq check
has been removed from the -mm tree.  Its filename was
     mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: restore accidentally removed seq < max_seq check
Date: Tue, 15 Sep 2026 18:15:56 +0800

Since commit 798c0330c2ca ("mm/mglru: rework aging feedback"), the
following sanity check was accidentally removed:

       if (seq < max_seq)
               return 0;

That means we can perform aging for any value less than or equal to
max_gen_nr.

This has been inconsistent with
Documentation/admin-guide/mm/multigen_lru.rst, which states:

 Users can write the following command to ``lru_gen`` to create a new
 generation ``max_gen_nr+1``:

     ``+ memcg_id node_id max_gen_nr [can_swap [force_scan]]``

The correct semantics are that writing a value smaller than max_gen_nr
should return 0, since the requested generation already exists.

Link: https://lore.kernel.org/20260915101556.50467-1-baohua@kernel.org
Fixes: 798c0330c2ca ("mm/mglru: rework aging feedback")
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chuanhua Han <hanchuanhua802@gmail.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c~mm-mglru-restore-accidentally-removed-seq-max_seq-check
+++ a/mm/vmscan.c
@@ -5839,6 +5839,9 @@ static int run_aging(struct lruvec *lruv
 {
 	DEFINE_MAX_SEQ(lruvec);
 
+	if (seq < max_seq)
+		return 0;
+
 	if (seq > max_seq)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from baohua@kernel.org are


