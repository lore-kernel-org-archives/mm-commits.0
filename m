Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EFD190686
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719432713; cv=none; b=c8UysY6k/AMksRAQB//RWGgqcWI02jZQNuOPMxmPxyvIW6+k9R2USNMoPLE/b6B3r1hjEO2hFcPPW/fmJ211xv04DuKMMgiZNlcs3LaOAquUNpZkhA6OmzJv4/z4O2ImDlzjrIokJTv76HuXMzilkum3y+ktWU8Xo9iT+Nhi8gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719432713; c=relaxed/simple;
	bh=OicSWxlPsYSkY79A3qvXLxO3CVtx5/DYIzWm5yq/z5w=;
	h=Date:To:From:Subject:Message-Id; b=iAJQ3IgCAxFJoQRn7ifBgdBk43zIJTY6ohtZ+kQ14e3ZfoH24AH2yUxdBi28MgTf0h+5KPJFP/nz4MeXbogSzXXtZzbrA4YRVapkUkDFFx9OraBAQKP8wwdZpoo/PQpwVRZg5bg9Q2+n7xNCGgGY1MXTqV3/yCvxATwO4ef0kic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VsBZk7qN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VsBZk7qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE6BC116B1;
	Wed, 26 Jun 2024 20:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719432712;
	bh=OicSWxlPsYSkY79A3qvXLxO3CVtx5/DYIzWm5yq/z5w=;
	h=Date:To:From:Subject:From;
	b=VsBZk7qNDJftE5xjV7t5VG6qEqxkA2Gtiq590TMXSl5MG4ImAq3hjdwdDyPgMY4zD
	 djASyvv2wXrVOr786Q9MfXg5TYx7hnUul4ArpwB69humm6ogfpfmmZcNRjmwcTnHuG
	 OYKqSqSHJMqPnBrEb2Hi3a+UBnvLRCf6Ta54Cv2Y=
Date: Wed, 26 Jun 2024 13:11:52 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-remove-redundant-seq_buf_has_overflowed.patch added to mm-unstable branch
Message-Id: <20240626201152.BBE6BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: remove redundant seq_buf_has_overflowed()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-remove-redundant-seq_buf_has_overflowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-remove-redundant-seq_buf_has_overflowed.patch

This patch will later appear in the mm-unstable branch at
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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: memcg: remove redundant seq_buf_has_overflowed()
Date: Wed, 26 Jun 2024 09:42:32 +0000

Both the end of memory_stat_format() and memcg_stat_format() will call
WARN_ON_ONCE(seq_buf_has_overflowed()).  However, memory_stat_format() is
the only caller of memcg_stat_format(), when memcg is on the default
hierarchy, seq_buf_has_overflowed() will be executed twice, so remove the
redundant one.

Link: https://lkml.kernel.org/r/20240626094232.2432891-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-remove-redundant-seq_buf_has_overflowed
+++ a/mm/memcontrol.c
@@ -1476,9 +1476,6 @@ static void memcg_stat_format(struct mem
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
 	}
-
-	/* The above should easily fit into one page */
-	WARN_ON_ONCE(seq_buf_has_overflowed(s));
 }
 
 static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-memcg-remove-redundant-seq_buf_has_overflowed.patch

