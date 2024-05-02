Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714D2153571
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714668435; cv=none; b=bFIrwraruKvJtlkLMy7XxDQawvCh8LMedJLUA3F8fSz0unYfB0L493kqxNZbZE4ONJNCrr5Aiai0GwBSVCzCTQk6qkOxJb9YHj0x+HdBrPZWcFy5INDvO1tzVUGJsSLigJW4TYGeiVdOvSONdakUF72vzwesTV1NmlCWeXEoN+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714668435; c=relaxed/simple;
	bh=woQ+ebHpMHY3oS8cZa5Trq4W4Bl4WaADuem6TN7DBOQ=;
	h=Date:To:From:Subject:Message-Id; b=ncokQeDJomHPBzOdd4sFIvQhU3yqgDLHLQvyu5gHbU8Nl9YflVdWl2jN6V0GICjFze6TBvJj3jShyLAIUqxldxOOrS1ALq53L7SCumSvKx+p9/TAPJ+UQLZ4FI7s+AlswXiQW6DeA7fUkjRtUxzNqw/biPk87xUDPavwq69cdsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F9Mt0nTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F9Mt0nTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B43C113CC;
	Thu,  2 May 2024 16:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714668435;
	bh=woQ+ebHpMHY3oS8cZa5Trq4W4Bl4WaADuem6TN7DBOQ=;
	h=Date:To:From:Subject:From;
	b=F9Mt0nTElOBhNybskuYHfcYDD/SKKwZ6OelutSsMMF+yyrdxmY+t7n9xbbwkLAWJ9
	 FSzJu1Pr+0pP5CL/JHnqsA9XSlkC/5v20B7bb/38qHurGGeJSZsyVK35N4ruVvCQ6v
	 OEf/cF1mMkPYVyvF0M+941zs8wT8rNDhtSoFMjms=
Date: Thu, 02 May 2024 09:47:13 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,bvanassche@acm.org,axboe@kernel.dk,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-use-integer-type-instead-of-enum-req_op-for-event-tracing-header.patch added to mm-nonmm-unstable branch
Message-Id: <20240502164714.D6B43C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: use integer type instead of enum req_op for event tracing header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-use-integer-type-instead-of-enum-req_op-for-event-tracing-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-use-integer-type-instead-of-enum-req_op-for-event-tracing-header.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: use integer type instead of enum req_op for event tracing header
Date: Tue, 30 Apr 2024 17:00:18 +0900

Patch series "nilfs2: reduce build warnings with "make C=1""

These two are cleanups that eliminate the warnings output by sparse (not
including common one related to refcount_dec_and_lock).  Neither is a
bugfix.  


This patch (of 2):

The sparse check with "make C=1" outputs warnings regarding references to
the header file "include/trace/events/nilfs2.h" for event tracing:

 fs/nilfs2/segment.c: note: in included file (through
   include/trace/trace_events.h, include/trace/define_trace.h,
   include/trace/events/nilfs2.h):
 ./include/trace/events/nilfs2.h:191:1: warning: cast to restricted
   blk_opf_t
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer

Fix this issue by reverting the type of the parameter related to the bio
operation mode in the event tracing definition from "enum req_op" to
"int".

In order to prevent sparse warnings on the caller side (where
trace_nilfs2_mdt_submit_block() is used), also add a typecast to an
argument passed to the tracepoint.

Link: https://lkml.kernel.org/r/20240430080019.4242-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240430080019.4242-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401092241.I4mm9OWl-lkp@intel.com/
Fixes: ed4512590bd5 ("fs/nilfs2: Use the enum req_op and blk_opf_t types")
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c               |    2 +-
 include/trace/events/nilfs2.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-use-integer-type-instead-of-enum-req_op-for-event-tracing-header
+++ a/fs/nilfs2/mdt.c
@@ -152,7 +152,7 @@ nilfs_mdt_submit_block(struct inode *ino
 	ret = 0;
 
 	trace_nilfs2_mdt_submit_block(inode, inode->i_ino, blkoff,
-				      opf & REQ_OP_MASK);
+				      (__force int)(opf & REQ_OP_MASK));
  out:
 	get_bh(bh);
 	*out_bh = bh;
--- a/include/trace/events/nilfs2.h~nilfs2-use-integer-type-instead-of-enum-req_op-for-event-tracing-header
+++ a/include/trace/events/nilfs2.h
@@ -192,7 +192,7 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
 	    TP_PROTO(struct inode *inode,
 		     unsigned long ino,
 		     unsigned long blkoff,
-		     enum req_op mode),
+		     int mode),
 
 	    TP_ARGS(inode, ino, blkoff, mode),
 
@@ -200,7 +200,7 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
 		    __field(struct inode *, inode)
 		    __field(unsigned long, ino)
 		    __field(unsigned long, blkoff)
-		    __field(enum req_op, mode)
+		    __field(int, mode)
 	    ),
 
 	    TP_fast_assign(
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-use-integer-type-instead-of-enum-req_op-for-event-tracing-header.patch
nilfs2-make-superblock-data-array-index-computation-sparse-friendly.patch

