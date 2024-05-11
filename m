Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D014A28
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467939; cv=none; b=fXXRb0oxWXBCs+tfT7ZUsIzmhnhdvintx0gIBIo0JUMylb1D7o3Th4NK2q4v7fvc4Sw+23U8RlNketxd8BZgxQz3YXp4YlQyKISWokDd/hnW2jly54pnZ44Pt5SAKDQkRsW38ecLrqxu0pRnS/XgWTpYxWarq1dJxSP9qyOWb2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467939; c=relaxed/simple;
	bh=403q2az42vYlH4c9XRm0XHcFLhMN6VumMJDYAZXkdik=;
	h=Date:To:From:Subject:Message-Id; b=XFrgaMd0bIe95Et1pWkSPEsfivxUmTfMWjdNnsV7ynwGZnfcsSFbhQFJ7Zbrlz66dFr+ihqvUPEQaKoJtb9tcxhJ+CMiI3/SD7o2gbEkr8IAmY55MWfkF9tzUIAx44xN2hCluqcZW94dF1oG5e8doW1hPil04/I/WLZQEPEm3vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=19AXOlSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="19AXOlSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC7C32782;
	Sat, 11 May 2024 22:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467939;
	bh=403q2az42vYlH4c9XRm0XHcFLhMN6VumMJDYAZXkdik=;
	h=Date:To:From:Subject:From;
	b=19AXOlSIeJXRuXi0DKzbCXD7aKuPq4cSWMX6Fr5DH74V7v3HPxbGmA0BhXPomOyy2
	 BtOijai4bwFWnlYVNuAZ7tHEr5QiBL7G+qhtoLay8O6BH+EJYlkCyArZDAy92YnoDX
	 l6lgsSaaFddYffSN9AAlZjGm9MATHC3D3NcWmf9g=
Date: Sat, 11 May 2024 15:52:18 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,lkp@intel.com,linux@rasmusvillemoes.dk,konishi.ryusuke@gmail.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-use-__field_struct-for-a-bitwise-field.patch removed from -mm tree
Message-Id: <20240511225219.49CC7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: use __field_struct() for a bitwise field
has been removed from the -mm tree.  Its filename was
     nilfs2-use-__field_struct-for-a-bitwise-field.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: nilfs2: use __field_struct() for a bitwise field
Date: Tue, 7 May 2024 23:24:54 +0900

As one can see in include/trace/stages/stage4_event_fields.h, the
implementation of __field() uses the is_signed_type() macro.  As one can
see in commit dcf8e5633e2e ("tracing: Define the is_signed_type() macro
once"), there has been an attempt to not make is_signed_type() trigger
sparse warnings for bitwise types.

Despite that change, sparse complains when passing a bitwise type to
is_signed_type().  The reason is that in its definition below, an
inequality comparison will be made against bitwise types, which are random
collections of bits (the casts to bitwise types themselves are
semantically valid and not problematic):

 #define is_signed_type(type) (((type)(-1)) < (__force type)1)

So, as a workaround, follow the example of <trace/events/initcall.h> and
suppress the following sparse warnings by changing __field() into
__field_struct() that doesn't use is_signed_type():

 fs/nilfs2/segment.c: note: in included file (through
   include/trace/trace_events.h, include/trace/define_trace.h,
   include/trace/events/nilfs2.h):
 ./include/trace/events/nilfs2.h:191:1: warning: cast to restricted
   blk_opf_t
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer

[konishi.ryusuke: describe the reason for the warnings per Linus's explanation]
  Link: https://lkml.kernel.org/r/20240507222041.4876-1-konishi.ryusuke@gmail.com
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


