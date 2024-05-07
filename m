Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DD416D4DF
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097768; cv=none; b=ovgNV0H4g2fhugrzipideSijeXKranhRrEgYj33t1rQFmvXKXocyqjCuQ3QBxaF94+YBxNei4cGRUH1ijkbPGdQKeWVgJw500urUg5yTqSIWScQQDKRtUte53A7xldVJ2UlO0pV3GdMcFs4M+GHnfKeue6pUg0hiNW1YMre2LOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097768; c=relaxed/simple;
	bh=Vv3TgcRqryRMcipQS5eVvoTo/CPbDp3lY4bOLdp54hI=;
	h=Date:To:From:Subject:Message-Id; b=cZL+qeKYPRpWYkOwaZjyVGSdWUyj2Y9p2FsyWLCYezzuGlE0a6QntGyaXsyt+aK/dltoqr+dob9583KA4kEz9dtl5WyVzIHN2Xn1dOXKvKQkQuhhjFWIWvZKNDFWEaa1RXmkJtFQKhv95Rr7V9p4d2kHY+hbbNFd1qIvv/V0m5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R1uTBRDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R1uTBRDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE64C2BBFC;
	Tue,  7 May 2024 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715097768;
	bh=Vv3TgcRqryRMcipQS5eVvoTo/CPbDp3lY4bOLdp54hI=;
	h=Date:To:From:Subject:From;
	b=R1uTBRDHyFT2Fo2DCLDKRg7A/R6dtAPp7HL0KLrv3mUzrvXBc3r18KYlmWxpO9dOY
	 KAZKyRReLxXXzrLfzCD0Ycl16nK3Prp4XURQ6PmFn+pwEfs6PBT44bhJGZKBeHXbjl
	 ppdsq8NLAJP1X2UEmjrj86GzteEMeHeJFblF9MZw=
Date: Tue, 07 May 2024 09:02:47 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,lkp@intel.com,linux@rasmusvillemoes.dk,konishi.ryusuke@gmail.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-use-__field_struct-for-a-bitwise-field.patch added to mm-nonmm-unstable branch
Message-Id: <20240507160248.4CE64C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: use __field_struct() for a bitwise field
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-use-__field_struct-for-a-bitwise-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-use-__field_struct-for-a-bitwise-field.patch

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
From: Bart Van Assche <bvanassche@acm.org>
Subject: nilfs2: use __field_struct() for a bitwise field
Date: Tue, 7 May 2024 23:24:54 +0900

As one can see in include/trace/stages/stage4_event_fields.h, the
implementation of __field() uses the is_signed_type() macro.  As one can
see in commit dcf8e5633e2e ("tracing: Define the is_signed_type() macro
once"), there has been an attempt to not make is_signed_type() trigger
sparse warnings for bitwise types.  Despite that change, sparse complains
when passing a bitwise type to is_signed_type().  It is not clear to me
why.

Follow the example of <trace/events/initcall.h> and suppress the following
sparse warnings by changing __field() into __field_struct():

 fs/nilfs2/segment.c: note: in included file (through
   include/trace/trace_events.h, include/trace/define_trace.h,
   include/trace/events/nilfs2.h):
 ./include/trace/events/nilfs2.h:191:1: warning: cast to restricted
   blk_opf_t
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer

Link: https://lkml.kernel.org/r/20240507142454.3344-1-konishi.ryusuke@gmail.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401092241.I4mm9OWl-lkp@intel.com/
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Closes: https://lore.kernel.org/all/20240430080019.4242-2-konishi.ryusuke@gmail.com/
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/nilfs2.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/trace/events/nilfs2.h~nilfs2-use-__field_struct-for-a-bitwise-field
+++ a/include/trace/events/nilfs2.h
@@ -200,7 +200,11 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
 		    __field(struct inode *, inode)
 		    __field(unsigned long, ino)
 		    __field(unsigned long, blkoff)
-		    __field(enum req_op, mode)
+		    /*
+		     * Use field_struct() to avoid is_signed_type() on the
+		     * bitwise type enum req_op.
+		     */
+		    __field_struct(enum req_op, mode)
 	    ),
 
 	    TP_fast_assign(
_

Patches currently in -mm which might be from bvanassche@acm.org are

nilfs2-use-__field_struct-for-a-bitwise-field.patch

