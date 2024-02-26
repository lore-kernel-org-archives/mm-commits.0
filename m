Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F95136986
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967182; cv=none; b=IwdLpUgAcHSPuKWv4iPApMpNKg6UooGwvO7Gn/d8NXFdhA4WO57RFH6iAsGHTGhQMbWyQmHeaTSq0qSyAI+ysJvw5Dkpln2pQA2Wm16RerjAchqGKumQvGr+s9eggl9R8YlVVRg1CoDn07rQyWkRPAjLCdOC9DZkfmqJ9wgK1Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967182; c=relaxed/simple;
	bh=7CbPO8OY1KSXqbXlhKcc/DKLrMRx5aGYz1K9174Ungw=;
	h=Date:To:From:Subject:Message-Id; b=K6QBc7Rw5JLimSf4CfPYqMtQRi5DhjqvTDjGa+UBB+F6/No+yQoA2apdsdok57tHxQbXLYu0UxU1/qnqUiGvMxpsZsAnAvGYeRYVy6Xe/Gv38BwfjC5s9qxuPsLXBnHgo5uLZxw+7ahN6QFbT/SJS5MdvY36O6kQSKvmCtS1nwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CVhg1NxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CVhg1NxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B030BC433C7;
	Mon, 26 Feb 2024 17:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708967181;
	bh=7CbPO8OY1KSXqbXlhKcc/DKLrMRx5aGYz1K9174Ungw=;
	h=Date:To:From:Subject:From;
	b=CVhg1NxADpC5KR/k0llX7VyozQBJIIFVuMTN3KmQRAEXh4D5FQB8G9d0cF6sIkYmF
	 V9rSqTbMOl7o71+C+nlDGBUHAXvhxC5wY6IlsqbtI74JfXSJwZpPVu2l1c5/1xtHgV
	 0sA0/8LQLNmT7LMXyGERAbZcIuFpFWFTJUzrsfX4=
Date: Mon, 26 Feb 2024 09:06:20 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kfifo-add-kfifo_out_linear_ptr-fix.patch removed from -mm tree
Message-Id: <20240226170621.B030BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo-add-kfifo_out_linear_ptr-fix
has been removed from the -mm tree.  Its filename was
     kfifo-add-kfifo_out_linear_ptr-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kfifo-add-kfifo_out_linear_ptr-fix
Date: Fri Feb 23 06:28:24 PM PST 2024

fix mismatched parenthesis build error

Cc: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kfifo.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/kfifo.c~kfifo-add-kfifo_out_linear_ptr-fix
+++ a/lib/kfifo.c
@@ -497,7 +497,7 @@ unsigned int __kfifo_out_linear_r(struct
 	if (tail)
 		*tail = fifo->out + recsize;
 
-	return min(n, __kfifo_peek_n(fifo, recsize);
+	return min(n, __kfifo_peek_n(fifo, recsize));
 }
 EXPORT_SYMBOL(__kfifo_out_linear_r);
 
@@ -609,4 +609,3 @@ unsigned int __kfifo_dma_out_prepare_r(s
 	return setup_sgl(fifo, sgl, nents, len, fifo->out + recsize);
 }
 EXPORT_SYMBOL(__kfifo_dma_out_prepare_r);
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch

