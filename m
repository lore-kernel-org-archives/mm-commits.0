Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088A215E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628284; cv=none; b=FUbadeMDjit8eiPnB7Y819NNfisqcnSubYDRqIgcjP8xIFLtWKt+NT6Pertle57nX5zRG8DabNjcdm95461sWeqFYNqR8EbaayubkUhchna5z/ddgt5m7KBkhdzExbm7KhlAi9QdOGsk1gCvJ3UT/Ch7G4tJp+/0N03osENXrSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628284; c=relaxed/simple;
	bh=gJJjJUR5O8wMMbeqElmdnoz9EmcnIsXoh9Tht3qeqvs=;
	h=Date:To:From:Subject:Message-Id; b=PTNUZtZYvc8PagDhftaOphRNkZ4gsbND5FHSU0r+FKCdjhBxvea3jgLlch9jNMEhJeIBzvyLM6MGOWXMXFZr5jeVJeV/GvUUKsdlQK0dL+1A5qth9bILD5PmDF0bP7Y+n64mrxP1xORy21UqbGkkskZuocNslkqQy3glccLZCAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cOTwCEqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cOTwCEqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD51C116B1;
	Sat, 29 Jun 2024 02:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628283;
	bh=gJJjJUR5O8wMMbeqElmdnoz9EmcnIsXoh9Tht3qeqvs=;
	h=Date:To:From:Subject:From;
	b=cOTwCEqaTx//GPqIJKOUq78kXPNzoOkeXSP1idpAyzqBgkthR7ypdEToUxzmOMU9R
	 jCeC6aLZ48sbv1I5yOwlg9MpNewFxQfsGTdV/rai47t1USm47SI9lN0BQwsKZHhoRN
	 NtFJsh8gih44XcihAJCNEA97eMK/GCR/CYPla3G0=
Date: Fri, 28 Jun 2024 19:31:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-unwind-disable-kmsan-checks.patch removed from -mm tree
Message-Id: <20240629023123.CAD51C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/unwind: disable KMSAN checks
has been removed from the -mm tree.  Its filename was
     s390-unwind-disable-kmsan-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/unwind: disable KMSAN checks
Date: Fri, 21 Jun 2024 13:35:20 +0200

The unwind code can read uninitialized frames.  Furthermore, even in the
good case, KMSAN does not emit shadow for backchains.  Therefore disable
it for the unwinding functions.

Link: https://lkml.kernel.org/r/20240621113706.315500-37-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/unwind_bc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/kernel/unwind_bc.c~s390-unwind-disable-kmsan-checks
+++ a/arch/s390/kernel/unwind_bc.c
@@ -49,6 +49,8 @@ static inline bool is_final_pt_regs(stru
 	       READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE;
 }
 
+/* Avoid KMSAN false positives from touching uninitialized frames. */
+__no_kmsan_checks
 bool unwind_next_frame(struct unwind_state *state)
 {
 	struct stack_info *info = &state->stack_info;
@@ -118,6 +120,8 @@ out_stop:
 }
 EXPORT_SYMBOL_GPL(unwind_next_frame);
 
+/* Avoid KMSAN false positives from touching uninitialized frames. */
+__no_kmsan_checks
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs, unsigned long first_frame)
 {
_

Patches currently in -mm which might be from iii@linux.ibm.com are


