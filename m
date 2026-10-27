Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793072507;
	b=4i0Vzd3ES1szenTmI6Lcq1WGb+fNhYTJjLYRBwts/tXYVgEngFy3U9hGGTf7FmjBW0Jf
	 Ccn2EJ84kU6bgS1W6AEoOm5LdscRt6dGYqnBGGuVdsfFtV/UJj38GSIr2J0G7HxTe6bpj
	 p4KsfJ1oPD/A6cJrTrQ/mwNzIeY8PUGvOfRDQgzo6Up0zORc26Qrec5QiEsGctkwS2heO
	 WvU4xpWWqGXhPE3TwVS+N4mPGYkCKZ7ibd6MvN8WshyBL7MeiFjMFZMzVkvRIQR22RmRV
	 7kpY4sB/vPDS8d48VY6gZ/sA6m6Gf5lWDwa/85nyMPGgEt5t9RU+flsGU0q1yArnqpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793072507;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qX+JJYwLqT//VHqhTmW+OaWZiZe+lEM9Z1u64riIEgs=;
	b=Ltz67gaGfn3Jhp/ubobfX0kyRAbrvwlymvdB+NBONBmgG8syyGT+dsDBsLrdC3BGwkkz
	 2hYA6cKFk//9IS3ccMT8f+Vl372G4PM/IqpBtnOcpG36+lbihA6abzVWafM6ygx90WjpO
	 gtCZrViBxmEZq31D2pR1JvjxlL7al7GpX/6Hju3GGF60DWRCBhpajJqX5zCdP55uERVZr
	 eIaLLI9aVvY7VJxPOktf3UhvNbjpxxz5emc2+NI0lm7xFOftVA353kvTW6ghcF7gBMRag
	 v5xgAqHFvoGtn7U5hsEMWuFhyrf+4wduIEG9EiLaTFlswOnLAqb69zdIBoSHoPeczdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Ng1QRs/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AACF606A31B
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 03:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ng1QRs/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F66E1F01825;
	Tue, 27 Oct 2026 03:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793072507;
	bh=qX+JJYwLqT//VHqhTmW+OaWZiZe+lEM9Z1u64riIEgs=;
	h=Date:To:From:Subject;
	b=Ng1QRs/pAjbC7WbUvmNUg9Wk4Jp4bU9ugYv2rz6sSoyxPfWhDPHx17LOLeGlClKBc
	 TztZu+Vjq9kjVfnyrzn/cS9gXpkz6UVWynm/ujKVaPUAiKfbuoQH/hn5qvGPVYPk7v
	 wn0wROIs8Ol+hrV9DGNNOr+SS8HP/33JGf2FpoUc=
Date: Mon, 26 Oct 2026 20:41:46 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,
	matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-improve-fat_sync_bhs-write-submission.patch added to mm-nonmm-unstable branch
Message-Id: <20261027034147.0F66E1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fat: improve fat_sync_bhs() write submission
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-improve-fat_sync_bhs-write-submission.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-improve-fat_sync_bhs-write-submission.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Subject: fat: improve fat_sync_bhs() write submission
Date: Mon, 26 Oct 2026 13:39:41 -0300

fat_sync_bhs() does many individual write_dirty_buffer() calls without
plugging, making batching in the block layer more difficult.  It also does
not pass the REQ_SYNC hint for these synchronous writes.

Use a plug around the writes so the block layer can more easily batch
them.  Pass the REQ_SYNC hint to write_dirty_buffer().

Benchmarking was done under QEMU/KVM with a virtio-blk device using
cache=directsync.  Each result is the arithmetic mean of 10 samples.

start = now_ns();
for (unsigned i = 0; i < count; i++) {
    fallocate(fds[i], FALLOC_FL_KEEP_SIZE, 0, bytes);
}
elapsed = now_ns() - start;

Sync-mounted FAT32 using count=16 files:
File size    Cluster size    Before    After    Improvement
256MiB       512B            13.11s    11.87s   1.10x
256MiB       4096B           1.657s    1.469s   1.13x

Link: https://lore.kernel.org/20261026163941.495833-3-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/misc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/fat/misc.c~fat-improve-fat_sync_bhs-write-submission
+++ a/fs/fat/misc.c
@@ -9,6 +9,7 @@
 
 #include "fat.h"
 #include <linux/iversion.h>
+#include <linux/blk_plug.h>
 
 /*
  * fat_fs_error reports a file system problem that might indicate fa data
@@ -353,9 +354,14 @@ EXPORT_SYMBOL_GPL(fat_update_time);
 int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 {
 	int i, err = 0;
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
 
 	for (i = 0; i < nr_bhs; i++)
-		write_dirty_buffer(bhs[i], 0);
+		write_dirty_buffer(bhs[i], REQ_SYNC);
+
+	blk_finish_plug(&plug);
 
 	for (i = 0; i < nr_bhs; i++) {
 		wait_on_buffer(bhs[i]);
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are

fat-preallocate-space-before-expanding-in-fat_cont_expand.patch
fat-hold-truncate_lock-in-fat_write_failed.patch
fat-batch-synchronous-mirror-writes.patch
fat-improve-fat_sync_bhs-write-submission.patch

