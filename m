Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E7E18C031
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 18:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758479645; cv=none; b=RYReqXu7DLu2y9VKtEpEWFn9p4J8NYwpb00Yyr4fvTYuCvgcKKwIQt9CITZ1kITLd3sQmsruU084uKYsQwmNSPna0NzlhCbMTGLsMUVjC2j11OGyY/vQV33QafPvJHHK8ukQoeWgCyVEIg9LGWo9QbFfH6a8YxJr5JtZoJB94g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758479645; c=relaxed/simple;
	bh=eSTt3LnPKcN9fD3A2D3KI5plcvzY7dLb1fkYZvDB7+A=;
	h=Date:To:From:Subject:Message-Id; b=JVfcE27Kkhv1KndhypcQEVdQmEL5gesPCGlFXxUzFZ24XpbgF2xBa/BxsaKX2mcgnDoUtinKywgRDHrJ9hrxQw4Fmby/Pl4x8ScYXIomObqRN1GpZKLUyNMobsQ0bPfEk8DSMnYih7WS4i6iTMd7fkZMmjFVPZRPgzDwgN7m1b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZS9qzt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZS9qzt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC0BC4CEE7;
	Sun, 21 Sep 2025 18:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758479644;
	bh=eSTt3LnPKcN9fD3A2D3KI5plcvzY7dLb1fkYZvDB7+A=;
	h=Date:To:From:Subject:From;
	b=TZS9qzt54hNRiAnOXm24BtShgIaWOULy9Z/1NVeetmKBpeHCzFFSYZV3U4r2eycP/
	 ENrOXjaUWDaMkDJVEs9BZPLYkQbFp00+fqbV3xLtYMW318n2lCSE8QR0hFur7zjW8s
	 3qbhHzH6K2thskHaFJqqyH8+a8EO1/ZDciEZ9aYo=
Date: Sun, 21 Sep 2025 11:34:04 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory.patch removed from -mm tree
Message-Id: <20250921183404.DBC0BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu: add a simple double-free check for per-CPU memory
has been removed from the -mm tree.  Its filename was
     mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/percpu: add a simple double-free check for per-CPU memory
Date: Thu, 4 Sep 2025 16:35:14 +0200

The free path clears the allocation bits in pcpu_chunk::alloc_map.  A
simple double free check would be to check if the bits, which are about to
be cleared, are already cleared.

Check if the bit is already cleared. Issue a warning and abort free in
that case.

Link: https://lkml.kernel.org/r/20250904143514.Yk6Ap-jy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-add-a-simple-double-free-check-for-per-cpu-memory
+++ a/mm/percpu.c
@@ -1276,7 +1276,7 @@ static int pcpu_alloc_area(struct pcpu_c
 static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
-	int bit_off, bits, end, oslot, freed;
+	int bit_off, bits, end, oslot, freed, free_bit;
 
 	lockdep_assert_held(&pcpu_lock);
 	pcpu_stats_area_dealloc(chunk);
@@ -1289,6 +1289,11 @@ static int pcpu_free_area(struct pcpu_ch
 	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
 			    bit_off + 1);
 	bits = end - bit_off;
+
+	free_bit = find_next_bit(chunk->alloc_map, end, bit_off);
+	if (WARN(free_bit != bit_off, "Trying to free already free memory"))
+		return 0;
+
 	bitmap_clear(chunk->alloc_map, bit_off, bits);
 
 	freed = bits * PCPU_MIN_ALLOC_SIZE;
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


