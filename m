Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221281C17
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560092; cv=none; b=m5MVllffCv4jgaCGRSKUCrNWKH0tqMvhgvECjpRIDEot4kHc5AVwiFL1XAc5DdfX/jfhDUC3vVAhQeNcW25eZjzRjeNqgkkSUHw2B7h7MbJEn1SyK/f77aVV5LfE3tPG/siFyTh/UoHRnS8Z5cLFjCuYfZXF9Fqw6XLGQo8uDVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560092; c=relaxed/simple;
	bh=GlTIogH20QlJbwiUMJVMRRMb7QmJW+q+mVr1dJMQ9kw=;
	h=Date:To:From:Subject:Message-Id; b=dNqJMOffdme+nRRJPhAUIj8pD7V5npfyzw6w8as7gTQpqrTJbxpkH7XWP0Jvw+dTvAWBJ8MfXjhjakrusv44Z22Ha0HW5AYgfLmHQfC2W6+DtCzyS/cCfsQrblHA/jfZcURihyfx0RDX5TWs3B8vMCmfIRggW2EyhZcJ4ludVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M08McW7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M08McW7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7D6C43399;
	Thu, 22 Feb 2024 00:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560092;
	bh=GlTIogH20QlJbwiUMJVMRRMb7QmJW+q+mVr1dJMQ9kw=;
	h=Date:To:From:Subject:From;
	b=M08McW7tznCmsl4fA50+R7oSFJIAKezFrPoFiDvGD9pm8yFNx5tJBvEts+I6Q6no+
	 Q4xIA3qJigBZWEFNCp28T0yUhhs6d7INN95hxPNvgPVAkzittwz2xf8nIbzcv4KcUx
	 2GjHMWd/ravq8+dlSamJpiuU7ftcHmiOcMLhDmRI=
Date: Wed, 21 Feb 2024 16:01:31 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,lukas.bulwahn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch removed from -mm tree
Message-Id: <20240222000131.EC7D6C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: avoid duplicate variable init in mast_spanning_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: maple_tree: avoid duplicate variable init in mast_spanning_rebalance()
Date: Mon, 22 Jan 2024 11:20:00 +0100

The local variables r_tmp and l_tmp in mast_spanning_rebalance() are
already initialized at its declaration; there is no need to assign the
value again.

Remove the duplicate initialization of {r,l}_tmp.  No functional change. 
Due to common compiler optimizations, also no change to object code.

This issue was identified with clang-analyzer's dead stores analysis.

Link: https://lkml.kernel.org/r/20240122102000.29558-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2271,8 +2271,6 @@ bool mast_spanning_rebalance(struct mapl
 	struct ma_state l_tmp = *mast->orig_l;
 	unsigned char depth = 0;
 
-	r_tmp = *mast->orig_r;
-	l_tmp = *mast->orig_l;
 	do {
 		mas_ascend(mast->orig_r);
 		mas_ascend(mast->orig_l);
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


