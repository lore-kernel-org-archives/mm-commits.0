Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F3E382293
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779126858; cv=none; b=VG01s92uQmMLta2a6V/UF1yvVJ8Xk0zm9stMNiwJf5tpB1l479SkZxYNAOfBvJvsp7ZsBmVonBN03dGRoctcurZXchNzriD7F/qVzYlmxrRR5dtGByZjXSF5Ns7BskoT4aGP21crXgvHKcUTCzXcGM5Arh2QIttqbUcYNIv4jVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779126858; c=relaxed/simple;
	bh=WQurAhR8fJhyUAw1LLRdu5FLW2PlRvLEYj7d9zYKYy8=;
	h=Date:To:From:Subject:Message-Id; b=KklcDhqf65iF3JdoDaOLMi/5r7qCwVfBA1mofg8sk6CNYfwBRG/lJF1eCW9e9xqBiLRbuZ8KQn0KO2rlLEg6qdRS1pjSIBCpS0jUdjNcxygNgpFn61Dvf9Sq55styKpvBE80jU2NfoFqtihaIwOqluMltAQO44FghaDzS3CYb14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PLgPHta4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PLgPHta4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9986C2BCB7;
	Mon, 18 May 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779126857;
	bh=WQurAhR8fJhyUAw1LLRdu5FLW2PlRvLEYj7d9zYKYy8=;
	h=Date:To:From:Subject:From;
	b=PLgPHta4pjKz2sVosXeLOA9Bas4rf5Ef6QRfwOPkGfQ3TIk4oIwfmlD0b0qnMXB88
	 kkYmEjfTyUmvtdGiIVjdRBOuD3edYs7jPDh75c1iiQRn2+v5+eQlXyDb5i7fkhnOOG
	 RmECTjCm/LbvsYhc364LWBbIlRsFZIlLzDcMG/fU=
Date: Mon, 18 May 2026 10:54:17 -0700
To: mm-commits@vger.kernel.org,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] percpu-fix-wrong-chunk-hints-update.patch removed from -mm tree
Message-Id: <20260518175417.D9986C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: fix wrong chunk hints update
has been removed from the -mm tree.  Its filename was
     percpu-fix-wrong-chunk-hints-update.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joonwon Kang <joonwonkang@google.com>
Subject: percpu: fix wrong chunk hints update
Date: Sun, 10 May 2026 07:21:46 +0000

Chunk end offset was set to a block end offset, which could prevent chunk
hints from being updated correctly.  It was observed that the chunk free
size gets minus or shorter than the actual free size due to this.  This
commit fixes it.

Link: https://lore.kernel.org/20260510072149.1279887-1-joonwonkang@google.com
Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: <dodam@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~percpu-fix-wrong-chunk-hints-update
+++ a/mm/percpu.c
@@ -1054,7 +1054,7 @@ static void pcpu_block_update_hint_free(
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(e_index, end));
 }
 
 /**
_

Patches currently in -mm which might be from joonwonkang@google.com are

a.patch
percpu-do-not-trust-hint-starts-when-they-are-not-set.patch
percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

