Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151A88634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189202; cv=none; b=MQRLegrmqNBcFeNXWOw7SNMNb2bCJohn0OUZ/QfdFi2Gf+grKjDE6G+R0tBTmJXftZeazQoWJPh1fPRfsiiSDBiXMKkdjOx9uHUf5PT7MF3vFi6ZnQAgcHirMJLb3VP/aIzBcuOdcoSCbCDaRuc8s5DCFJ+IRU35IUe6BRNC3tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189202; c=relaxed/simple;
	bh=bN1Nt7dEyVzM5jS2rjAWY4j67uxvgaH3lz78+uQH8Y8=;
	h=Date:To:From:Subject:Message-Id; b=YouHzr70bAYQiVjHAZgIKrDkxhqNv1QQQW/nlwYHadDLSkzWcIFLaUOKze0liLkQlfiOWPR4m1Bq1Y9LPSN5zXPFz/fpeB9c+bJR3lnvOhqkfn50dCkv/ri0MoXf6J1PR3mlk1/mFXO2GDj6ZyW/UmPzuUUm0f1sqBfVm7IrYE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HeDqIjSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HeDqIjSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7844AC4CEEC;
	Mon, 17 Mar 2025 05:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189201;
	bh=bN1Nt7dEyVzM5jS2rjAWY4j67uxvgaH3lz78+uQH8Y8=;
	h=Date:To:From:Subject:From;
	b=HeDqIjSnA0SW+EmDF7ipRV0lWWF8wJz6GzuU4nZkspAzg9er+JdsppFVaPS7WhAY7
	 k2P+p7avuQ7X8nfE1ImdtZQ1pcjfJG02Ny+t5FiI4sCcVdCzhDYFigaPb+wY0ZL+/S
	 RaSM9NuMTjw4cO3MYuNTKjZhM+4Odo+KpA7zbIow=
Date: Sun, 16 Mar 2025 22:26:40 -0700
To: mm-commits@vger.kernel.org,james.bottomley@HansenPartnership.com,eahariha@linux.microsoft.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch removed from -mm tree
Message-Id: <20250317052641.7844AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix
has been removed from the -mm tree.  Its filename was
     scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch

This patch was dropped because it was folded into scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix
Date: Tue Feb 25 07:32:03 PM PST 2025

fix build

Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -3954,7 +3954,7 @@ void lpfc_poll_eratt(struct timer_list *
 	else
 		/* Restart the timer for next eratt poll */
 		mod_timer(&phba->eratt_poll,
-			  jiffies + secs_to_jiffies(phba->eratt_poll_interval);
+			  jiffies + secs_to_jiffies(phba->eratt_poll_interval));
 	return;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

