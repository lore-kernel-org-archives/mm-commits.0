Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B02636F419
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778265631; cv=none; b=K6FX5LvVhp9R6kja74XsNYK+W1Cl/7mOCqS/rU/xXp51z6v8F8xQilWQUY45Jo+FiuX4XgrrkNbsXPLYH3i19OhlZzjyEUs4kc5qDMlU0ngicES0esv+eYUmcSP8ElHe1ap22jQaTOOgKF+Rmv+dLkkU4g4uZvNQpZcgBeVZ9Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778265631; c=relaxed/simple;
	bh=0eXpDzJTswheJ6U5+2nA3aaPmEWp2c1ZL53c1zEqdas=;
	h=Date:To:From:Subject:Message-Id; b=HL+QeFL64MXnSQ0MGxNQ77C19WbNDtj0YIxw+SDK6u8JQIbC1vImRBjrR7/USHDfNYrt2GeuGbZkI2kL/tN11aHvFSpIO7dYElr4ohik5AvUKEuEwcegimmz2L91GepBoBVp/xX71sKE5X+jSNzQLCBS3pd9QKnt1jIiq1nMTgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gh0/2/BF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gh0/2/BF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0E5C2BCB0;
	Fri,  8 May 2026 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778265631;
	bh=0eXpDzJTswheJ6U5+2nA3aaPmEWp2c1ZL53c1zEqdas=;
	h=Date:To:From:Subject:From;
	b=gh0/2/BFwQjBT6sLV1O5L9Y1e1QfFI4O9UqDbbNGJDBQARyR1c8C0hTL/jXdgGnr1
	 P5oL22lgAdzzy1nIpvl2MaiMQkGWtZnuVMXlQU6TLyO/3Xol+Jzo4FsH2/REMc8Lyx
	 1HKfGhVXzlKBEaTaz5i62NNwnqg4zXBCAypW0WAk=
Date: Fri, 08 May 2026 11:40:30 -0700
To: mm-commits@vger.kernel.org,mporter@kernel.crashing.org,chul.kim@idt.com,alex.bou9@gmail.com,error27@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-tsi721-prevent-a-bad-dereference-in-tsi721_db_dpc.patch added to mm-nonmm-unstable branch
Message-Id: <20260508184031.1A0E5C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-tsi721-prevent-a-bad-dereference-in-tsi721_db_dpc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-tsi721-prevent-a-bad-dereference-in-tsi721_db_dpc.patch

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

rapidio-tsi721-prevent-a-bad-dereference-in-tsi721_db_dpc.patch

