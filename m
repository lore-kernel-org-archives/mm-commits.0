Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AB413BAF8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645220; cv=none; b=TuukNTPdUkqOTwZKxoYIS2nOoUvFand0BA3N45JhP97kze4Ua1wvVd/syCKyPiYgsuNuzkG+uDfmbx9HRYDdD7L18AMAgaxT7KpS4ZKWDYhjaICqL+uolGDPFlpj0XOlBR3w54emo8IqZQ8rG950Zes9KK3w/plQ/3lbBzmWlOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645220; c=relaxed/simple;
	bh=NtXfVjeQzCQM1xWHO7SjLTcjjNK2U7lDZRsv3Tf6OW4=;
	h=Date:To:From:Subject:Message-Id; b=s1Y7eWc2NPYISinZn85AMODtlovEPV6eFNQod8zzizC/o6qp/F5mWDnHez6l/F0rWBwM76hXhD9Rg8NSGPA2s8if+3OGNgt/qCIPRW04CqoH6asUBOr0I81Zveq2LDAsfAeiU4+nCDVkt0267Sn+YJEfii6ZegPmo2waiojmKzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DpvbQxpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DpvbQxpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9E1C433C7;
	Thu, 22 Feb 2024 23:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645220;
	bh=NtXfVjeQzCQM1xWHO7SjLTcjjNK2U7lDZRsv3Tf6OW4=;
	h=Date:To:From:Subject:From;
	b=DpvbQxpdM2ijBqvlHGe+jsc9UjpDiEMBVYu6ApvZVrfFXNzrXwmDzP0q39L0soOjm
	 sve1K+fXBgZ6Zwfkrth+h0iziircZxkB7dmy7BA+EPiNooexPbKEuR44eOebjinNgm
	 2ZJzK7q2/jXIhbJu65VsbTu+GIJsBCAdEOjGXFQw=
Date: Thu, 22 Feb 2024 15:40:20 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] smp-make-__smp_processor_id-0-argument-macro.patch removed from -mm tree
Message-Id: <20240222234020.9C9E1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: smp: make __smp_processor_id() 0-argument macro
has been removed from the -mm tree.  Its filename was
     smp-make-__smp_processor_id-0-argument-macro.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: smp: make __smp_processor_id() 0-argument macro
Date: Mon, 5 Feb 2024 12:39:30 +0300

smp_processor_id family of macros never accepted any arguments.

	#define __smp_processor_id(x)

works by accident (see C99 6.10.3 §4). __smp_processor_id() gets
1 (empty) argument and passes it down to raw_smp_processor_id()
which doesn't accept arguments.

Link: https://lkml.kernel.org/r/0037d1f2-8153-4b33-b43e-f4b6ecd710ac@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/smp.h~smp-make-__smp_processor_id-0-argument-macro
+++ a/include/linux/smp.h
@@ -261,7 +261,7 @@ static inline int get_boot_cpu_id(void)
  * regular asm read for the stable.
  */
 #ifndef __smp_processor_id
-#define __smp_processor_id(x) raw_smp_processor_id(x)
+#define __smp_processor_id() raw_smp_processor_id()
 #endif
 
 #ifdef CONFIG_DEBUG_PREEMPT
_

Patches currently in -mm which might be from adobriyan@gmail.com are


