Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64554306B31
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780030302; cv=none; b=ezuLtnSlR/UIaXBq5TRe705LnWkJV4vDFKTlmN2Qs2ozFzUfCb5JYK7+j8eQeGFV+n1v5DGgHxJCNoEEwTeOSmhwpxuYnOj/9RYzI1Q1GQSaxQOye1tEH72Y4OYeekD4y522NXCxLTA2PggxxGvF4IRNBOC7/tti/+4UNb5sBOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780030302; c=relaxed/simple;
	bh=sHHHxZX2Bol7sU+nwkDEvo1E8kjRmi0sHN4JVJ/wg5s=;
	h=Date:To:From:Subject:Message-Id; b=C0MBPkSWGjDpHaFuFYT9Is46Ncz7/6chIr+cWxtbiUAPl+lFz8yG8f0wk4k+jDv3HLOysnR5yVHgCRoGcmzcfRlCcT8jHsfhbg9aTLqwK1L3xLmqQPuksoz15fXBo4dBYmogYI8AnnJRuPLFnYAjTBSE02qX5XVKYWmsv8gucIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eHJ4kwyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eHJ4kwyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FE91F0089B;
	Fri, 29 May 2026 04:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780030300;
	bh=+LcE62FVmSjnKxQTpljyOGqbNzYbEVM7M6Sf/DyfSfU=;
	h=Date:To:From:Subject;
	b=eHJ4kwyTDolQTkZ3nWC/QFDj2+Cv0hGUpTgBJ9IiwN/lEEx9ueOs3+o6HPt7Ll0Tn
	 S/t7ntomqnxyrODn7Cwk7Vf5xVkhusIHGR/tu5rwKM/anbsuN/oL7F40YdXk7AgA4z
	 BbvMV9SsH91UG6JmnsTMU2lJGdXQrptnXGJWFFQE=
Date: Thu, 28 May 2026 21:51:40 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] percpu-fix-wrong-chunk-hints-update.patch removed from -mm tree
Message-Id: <20260529045140.D5FE91F0089B@smtp.kernel.org>
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
Date: Wed, 13 May 2026 08:51:13 +0000

Chunk end offset was set to a block end offset, which could prevent chunk
hints from being updated correctly.  It was observed that the chunk free
size gets minus or shorter than the actual free size due to this.  This
commit fixes it.

Link: https://lore.kernel.org/20260513085117.1024175-1-joonwonkang@google.com
Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
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

percpu-do-not-trust-hint-starts-when-they-are-not-set.patch
percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

