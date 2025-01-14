Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA0D23A0F9
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836936; cv=none; b=OWJiucmo/QPmBqhvQ3+J+9drBZREj398UlqCWlBjIvNEMQeIFoxZUjqx588ueHu2AhzSO0zhPT+kdbRz85BhzkORUsEashAMtagK6Nlu3v1I5f7MM40OL3UyDMYKMcvRMmSpoO0zbkPiImPJePqqKFEQyVxdWyaO+ruml+m0rf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836936; c=relaxed/simple;
	bh=/0/ZTaD8tPM7xMM6iJ6mtrU9JI5vgxtTCoSbLliivU8=;
	h=Date:To:From:Subject:Message-Id; b=Hxy59KtKjUHPmk6OvsecwXn7TNbvymoTjgthLUjlCpiodTZg4vC/I5FksCVEWCfEciLdAuY2LI2JsfbJTSgJoAzLc09+KOHieMRcmuI2dhW4vfnL/UZ8YUt4nA1wR+u0VaViJH3DyIK0e8N1WNj6sVhPW1m+XZ1LhfTIeQvJkeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kf5PfY9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kf5PfY9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB65FC4CEDD;
	Tue, 14 Jan 2025 06:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836933;
	bh=/0/ZTaD8tPM7xMM6iJ6mtrU9JI5vgxtTCoSbLliivU8=;
	h=Date:To:From:Subject:From;
	b=Kf5PfY9UYnGcNVxIexZNaE0jA1KRbMFg0Ge4pRpjXvkxHhDWIwSK1zFV76DRQvBUM
	 cNT72kzl9V9zD/t5j75bLTE3CgX5CAFbJymhcT+PB9PuN6xEPIddgi9LmtVxwhq7Zh
	 N5W8mOY8SPabmLsjU5BIcOjCbyOfP6M9W7DK2MaI=
Date: Mon, 13 Jan 2025 22:42:13 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,pintu.ping@gmail.com,quic_pintu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-avoid-useless-return-in-void-function.patch removed from -mm tree
Message-Id: <20250114064213.BB65FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: avoid useless return in void function
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-avoid-useless-return-in-void-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: mm/hugetlb_cgroup: avoid useless return in void function
Date: Fri, 22 Nov 2024 23:05:58 +0530

The return statement at the end of void function is unnecessary.  Just
remove it as part of cleanup.

Link: https://lkml.kernel.org/r/20241122173558.20670-1-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Cc: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-avoid-useless-return-in-void-function
+++ a/mm/hugetlb_cgroup.c
@@ -917,7 +917,6 @@ void hugetlb_cgroup_migrate(struct folio
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
 	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
-	return;
 }
 
 static struct cftype hugetlb_files[] = {
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are


