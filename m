Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F20817BA8;
	Sat, 11 May 2024 22:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467944; cv=none; b=nOnsch9qXH1lpS1bFoDhHswRn0pzu5is3CFxz5HHAxlkgK1lf3XfytFB7wG5usyDL2V23VGjnYPrvPAUi/0TiOF/ZXIfZ2Q6TasjzOVG6kdbSLGZylNWYt9MMQnf6ApIjGjqTgQeTzNH4LVmjm4h3QJ6VuKRylwpcLJIhI0SfXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467944; c=relaxed/simple;
	bh=pSJ4NP0XOIqUdlgPwwowpqr7iVHGSTHUoLZQ2UOgdDI=;
	h=Date:To:From:Subject:Message-Id; b=NNq5Th3TxveI5VlommqtlvzNvJJBKAkwpJptmrvxloMemWlDTXimq+/1ozqpUQinFRpYkR2t1JwyDu4jR2CPVZ3AMZqJPTY5ujDBzObU4lwvlDAC5W7lwIDp9YwuHLh8Mt2HjpnAjPuEg0cIqbfQmTm/NZZIK2Hr32TF9fe/qoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GI8zwWrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GI8zwWrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313E6C32781;
	Sat, 11 May 2024 22:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467944;
	bh=pSJ4NP0XOIqUdlgPwwowpqr7iVHGSTHUoLZQ2UOgdDI=;
	h=Date:To:From:Subject:From;
	b=GI8zwWrkvZjSjs4dAFmon6QONjSYqpIDpPdXGVryUJKGFeMMihV7EBhT0SKTde6tb
	 7BI6/m7sDGvAiJ+5DxBfPabk8D9lgR/syRofrATIVAdMcii9m6o3ajJZ65I9jyEFAg
	 kSYANmtU7Q92qvxXUsArWTQjLxVppa/vUWVJdjww=
Date: Sat, 11 May 2024 15:52:23 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,bhe@redhat.com,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-fix-softlockup-in-__read_vmcore.patch removed from -mm tree
Message-Id: <20240511225224.313E6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: fix softlockup in __read_vmcore
has been removed from the -mm tree.  Its filename was
     fs-proc-fix-softlockup-in-__read_vmcore.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: fs/proc: fix softlockup in __read_vmcore
Date: Tue, 7 May 2024 09:18:58 -0400

While taking a kernel core dump with makedumpfile on a larger system,
softlockup messages often appear.

While softlockup warnings can be harmless, they can also interfere with
things like RCU freeing memory, which can be problematic when the kdump
kexec image is configured with as little memory as possible.

Avoid the softlockup, and give things like work items and RCU a chance to
do their thing during __read_vmcore by adding a cond_resched.

Link: https://lkml.kernel.org/r/20240507091858.36ff767f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/vmcore.c~fs-proc-fix-softlockup-in-__read_vmcore
+++ a/fs/proc/vmcore.c
@@ -383,6 +383,8 @@ static ssize_t __read_vmcore(struct iov_
 		/* leave now if filled buffer already */
 		if (!iov_iter_count(iter))
 			return acc;
+
+		cond_resched();
 	}
 
 	list_for_each_entry(m, &vmcore_list, list) {
_

Patches currently in -mm which might be from riel@surriel.com are


