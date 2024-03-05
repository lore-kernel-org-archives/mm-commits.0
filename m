Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12A98C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600560; cv=none; b=fOc36IPD/x6uCR+IQ9UIsue1aJBg3tmVevFV8ERFtbgHSnuu4PCqn94KCSJymrQ+La+awYNHO7/ALpFOAm+E/Eajmv6NSYGTFo6QZr83jfK+x/TT40vKPvWiRNK0pc8eJWzotw5KAEDPlJMk26ue3T7GjoTqdF6JR8PCrjCbVfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600560; c=relaxed/simple;
	bh=X8CzHjPr0oLeCOo2gd68QdpTPAPQhG37UanIPvL2yqU=;
	h=Date:To:From:Subject:Message-Id; b=rV5zWnsDXRK1UdwD5fgbjghfStLCnmUrKmL63L/uHdL89OEEbRk9mi5t072BrYcyGcvz2L3p4qobSkAUi2KFeizo3mUP9O+6GTYvh5gyCmNEoWjhBSS8xrdBrzRJA0+7RQhxcdjWrj2gVMJFSP5a2eDDKIgjVZB3b4+1j0LFndM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMZym8mH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMZym8mH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA097C433F1;
	Tue,  5 Mar 2024 01:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600559;
	bh=X8CzHjPr0oLeCOo2gd68QdpTPAPQhG37UanIPvL2yqU=;
	h=Date:To:From:Subject:From;
	b=HMZym8mHhmUQz8wMCb/YZajRRhEgpufNFROYRUrZGMMz19joBIO1cjdFRRpeLHkkC
	 6ljOjbPYgQSCYHmAieZ69RcKlXG69yMuHIutZi8801On+fUbCLyzjhYtFKP1kb+7WC
	 fvNjYzH0Sm6hv5rP+DnUwIJf6BJWkRAarc5ytewk=
Date: Mon, 04 Mar 2024 17:02:39 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,martin@kaiser.cx,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-use-unsigned-long-constant.patch removed from -mm tree
Message-Id: <20240305010239.BA097C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: use unsigned long constant
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-use-unsigned-long-constant.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Kaiser <martin@kaiser.cx>
Subject: lib/test_vmalloc.c: use unsigned long constant
Date: Mon, 26 Feb 2024 20:11:59 +0100

Use an unsigned long constant instead of an int constant and a cast.  This
fixes the checkpatch warning

WARNING: Unnecessary typecast of c90 int constant - '(unsigned long) 1' could be '1UL'
+     align = ((unsigned long) 1) << i;

Link: https://lkml.kernel.org/r/20240226191159.39509-4-martin@kaiser.cx
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-use-unsigned-long-constant
+++ a/lib/test_vmalloc.c
@@ -117,7 +117,7 @@ static int align_shift_alloc_test(void)
 	int i;
 
 	for (i = 0; i < BITS_PER_LONG; i++) {
-		align = ((unsigned long) 1) << i;
+		align = 1UL << i;
 
 		ptr = __vmalloc_node(PAGE_SIZE, align, GFP_KERNEL|__GFP_ZERO, 0,
 				__builtin_return_address(0));
_

Patches currently in -mm which might be from martin@kaiser.cx are


