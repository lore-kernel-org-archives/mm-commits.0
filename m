Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EFB37266E
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028762; cv=none; b=dadLGdN6gnAhO6BGwxl5tRVFI3TvShS5ifjXIoJBWMSsBoKfR1PgiKz84yIluEz76TzVedm2bfib6ryMrGVaNB8Ej+n86uQxxYAH+5uGf0e6xPfRDxzAzxPYBv8LgGj+YsfT8/p5v270dOK22oXV8XOisykWUU/m9XD/0ywEacM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028762; c=relaxed/simple;
	bh=O3fcK1GA7LcyRdpMkrZbedCwQJrsGFM0LCnj6x+QxAU=;
	h=Date:To:From:Subject:Message-Id; b=A3WVApJQQHhg4AOGx7XAUoq9gn+DB/+jwkN2/7Pn/F+f28VN0sOGoaCLFVZho5Dm2LeLW2N/aw6OrWwh8GEJLahMVrx//m6cmYrEk9FTj2+rXC6JZsnyrS6j+c/gFQFRzsQ+Tfvke9l61LVkQBHuTKTlPQlFv3hKVptPH5eXR/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=buTH/1St; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="buTH/1St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6816C1F00899;
	Fri, 29 May 2026 04:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028761;
	bh=vQdYaDxmCutXW1sLUmYwsI2z/GaVaAbXmOBHYBBTjVY=;
	h=Date:To:From:Subject;
	b=buTH/1St6jIgcHdQDAGK7CM6DHWZwvUDWgCnubftAArFuboy702zqrnYjFi2wd8+O
	 BcCIwsL2aRpY6NA64VtJgc5yrzbsI4kjZ/uq1kVjy4zQ/eKRI3G6yeWzvdaUcKDYkr
	 BlJHV+Sea2f7Nm5I4giqEHLvNKdOF1i+8n7gJn+4=
Date: Thu, 28 May 2026 21:26:01 -0700
To: mm-commits@vger.kernel.org,mporter@kernel.crashing.org,chul.kim@idt.com,alex.bou9@gmail.com,error27@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-tsi721-prevent-a-bad-dereference-in-tsi721_db_dpc.patch removed from -mm tree
Message-Id: <20260529042601.6816C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-prevent-a-bad-dereference-in-tsi721_db_dpc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <error27@gmail.com>
Subject: rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()
Date: Fri, 8 May 2026 10:51:56 +0300

With a list_for_each() loop, if we don't find the item we are looking for
in the list, then the loop exits with the iterator, which is "dbell" in
this loop, pointing to invalid memory.

This code uses the "found" variable to determine if we have found the
doorbell we are looking for or not.  However, the problem that the "found"
variable needs to be set to false at the start of each iteration,
otherwise after the first correct doorbell, then everything is marked as
found.

Reset the "found" to false at the start of the iteration and move the
variable inside the loop.

Link: https://lore.kernel.org/af2WHMZiqMwdYveO@stanley.mountain
Fixes: 48618fb4e522 ("RapidIO: add mport driver for Tsi721 bridge")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-prevent-a-bad-dereference-in-tsi721_db_dpc
+++ a/drivers/rapidio/devices/tsi721.c
@@ -394,7 +394,6 @@ static void tsi721_db_dpc(struct work_st
 						    idb_work);
 	struct rio_mport *mport;
 	struct rio_dbell *dbell;
-	int found = 0;
 	u32 wr_ptr, rd_ptr;
 	u64 *idb_entry;
 	u32 regval;
@@ -412,6 +411,8 @@ static void tsi721_db_dpc(struct work_st
 	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE)) % IDB_QSIZE;
 
 	while (wr_ptr != rd_ptr) {
+		int found = 0;
+
 		idb_entry = (u64 *)(priv->idb_base +
 					(TSI721_IDB_ENTRY_SIZE * rd_ptr));
 		rd_ptr++;
_

Patches currently in -mm which might be from error27@gmail.com are


