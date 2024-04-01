Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366F4CB4A
	for <mm-commits@vger.kernel.org>; Mon,  1 Apr 2024 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994816; cv=none; b=LLZRsLZ4WJmEXfvuraF83WHmUgcF64+JRpnowirzmUG1XbWD/YZuz3GGj5jLTQ+sZMDBQky1QSJE87ZXxxyVCklvUZviJ428yPLIBnkSsR1LGM02XHJZuFjYnXcs1ZPpN65plYpm8RPkx3Xo0PCSvcsEnzWi62FpYpw41VG88Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994816; c=relaxed/simple;
	bh=l75uJgkKmMI33strNO0l05EGwefbBMBKduo021CYCRM=;
	h=Date:To:From:Subject:Message-Id; b=Xs+f9sIgZ6+frGsnXDoWT91j9QVRh7ZY2Ib5zbjvn5T5NMlOHVSqp8/KAKjguGoSoiSe+YZpjs3/h8XSW/6o8USSwWhWO5V47LsV/g7WapZMgMQd6XUyssiIKjjOuaco9MkzPFrL5ijKWzNYf2S/yt5+gTNObAbq5NE8tU4VSuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VpDG3qB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VpDG3qB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49A8C433C7;
	Mon,  1 Apr 2024 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711994816;
	bh=l75uJgkKmMI33strNO0l05EGwefbBMBKduo021CYCRM=;
	h=Date:To:From:Subject:From;
	b=VpDG3qB8aOZ9j7kOY8Az7jtfZgXNoLt+AukTumJPfpYtjYzu57Ea8x9RnYReUn+J4
	 aZ5T4CbGQ5kcy1AAlRyfobyEDq7IoFGZeuE+0A+KjrRGnkus6Muh+MJ7rHGgV0Q5Y3
	 rBkOruvW7nqVEGAkP+ICXT/iWDvlzlmneDW9+5ZQ=
Date: Mon, 01 Apr 2024 11:06:55 -0700
To: mm-commits@vger.kernel.org,horenchuang@bytedance.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types-fix.patch added to mm-unstable branch
Message-Id: <20240401180655.E49A8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types-fix.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types-fix
Date: Sun, 31 Mar 2024 12:08:57 -0700

fix build error

Link: https://lkml.kernel.org/r/20240331190857.132490-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memory-tiers.h~memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types-fix
+++ a/include/linux/memory-tiers.h
@@ -140,12 +140,12 @@ static inline int mt_perf_to_adistance(s
 	return -EIO;
 }
 
-struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
 {
 	return NULL;
 }
 
-void mt_put_memory_types(struct list_head *memory_types)
+static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 
 }
_

Patches currently in -mm which might be from sj@kernel.org are

memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types-fix.patch

