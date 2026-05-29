Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F67370AF8
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027708; cv=none; b=jxZ+z0DWXksfdqA8b/VhzA97D2wZeWuOcv5xJ0qIU9DxbT213t6+48KyNaLlX3gcz6SO11Oqv4bwvHjdmqqpdD2dKKWSg80osNCWKOljc0FRSjFUuJSOAusQw1Jbwn5bDJb2qaMeCPeM3djziWQurp7IgwNoLug8FK8woUo2uew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027708; c=relaxed/simple;
	bh=izMVzCNKIwwiG9yaq/SXPyS31FBxSmhmWG4RzRlPkEM=;
	h=Date:To:From:Subject:Message-Id; b=izI3kW6e3SFXXpZmeUseKvGaBLA9A8aS86gZhXW147FnHFtiatH9KD+ozXFJP9MSINqC0DhF9LyYBK9UA+l7VUrn6Egi1xsvk5X8U50bzffphpuOghxSD+Ry5e3aexqkFudumHHvBhgD/zFw7bW+DpmZs+0xD7uOz2Zp1BSQPJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u2NDddzf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2NDddzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD341F00893;
	Fri, 29 May 2026 04:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027707;
	bh=8sXnjunr2eH4UOkjT0oegXE38QLtfLlwL1KrW0YYSxU=;
	h=Date:To:From:Subject;
	b=u2NDddzfl7clelk4uIwB5oUE15c8h53wXHAlJ0cPZiI//K/mxZ24dk4RyMRG3SU54
	 buU+u5B+QpfXWbWgoKd8Jm1Iez9i1BCTO2wP6nvReTD55eY+pmHbCzEfQ7CIHoqGlc
	 lr9rnaOk9Cuvp2QY6o9bTGECCtUZuX/7zsSTttX0=
Date: Thu, 28 May 2026 21:08:27 -0700
To: mm-commits@vger.kernel.org,bigeasy@linutronix.de,zhouzhouyi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic.patch removed from -mm tree
Message-Id: <20260529040827.BAD341F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: highmem-internal.h: fix typo in the comment for kunmap_atomic()
has been removed from the -mm tree.  Its filename was
     preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
Subject: highmem-internal.h: fix typo in the comment for kunmap_atomic()
Date: Tue, 5 May 2026 02:11:25 +0000

Replace `PREEMP_RT` with `PREEMPT_RT` in the header comment to match the
correct kernel configuration name.

Link: https://lore.kernel.org/20260505021125.1941691-1-zhouzhouyi@gmail.com
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem-internal.h~preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic
+++ a/include/linux/highmem-internal.h
@@ -262,7 +262,7 @@ static inline bool is_kmap_addr(const vo
  * @__addr:       Virtual address to be unmapped
  *
  * Unmaps an address previously mapped by kmap_atomic() and re-enables
- * pagefaults. Depending on PREEMP_RT configuration, re-enables also
+ * pagefaults. Depending on PREEMPT_RT configuration, re-enables also
  * migration and preemption. Users should not count on these side effects.
  *
  * Mappings should be unmapped in the reverse order that they were mapped.
_

Patches currently in -mm which might be from zhouzhouyi@gmail.com are


