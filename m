Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC7615666B
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212150; cv=none; b=UlNk87QzqTiRiNgk5gGVGFQqcLJBU/6Woo/D1gz816PofBmeLhW0ptsllpjQ8GWB21HDdZMSU035KgcJKNy5JcgWvvk9GA2rkTV+RSWFmTaT5iJpHTnbjWgvkGDTycBw80KdDm0AJBwHPxqfpRdWkCcdFrD7h+1li45fGFYlEGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212150; c=relaxed/simple;
	bh=1xyGTtLPoMFp+ljyznbDDGPQpkhQchJwGZTxzLLpGUs=;
	h=Date:To:From:Subject:Message-Id; b=jlkS61yKbwQCy6eDQUi3BLv06+TkvchhyHkOle/1vhtpefqgGbE0KsH/+DED9Qvy3QuWA9zPpwxK1Vk7E9BqrjapvdR87T70P/WHhSNqQflBcGlDY9PNHQuFbQjoLnniFItWOHETCh2xyYQQWYrT33nyE983JsctMQRLcLdA9FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pnz5/Rqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pnz5/Rqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E06C113CC;
	Mon, 15 Apr 2024 20:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212150;
	bh=1xyGTtLPoMFp+ljyznbDDGPQpkhQchJwGZTxzLLpGUs=;
	h=Date:To:From:Subject:From;
	b=Pnz5/RqpAVy95XvN3RlQGr7tdZfbtkLkDerDRIk0PJl+nG7Qv2FS2W+KGmY6H/oMD
	 zR0MztB69FPCayhJ7sJcxn6eUKRI0aHm37kMr1/ABziJd9c9xp0RdBfdsXrwQV7zXt
	 +LeV3i0NDj4DsM5eJ/4bq2uRSy4r+Gn+bo+qBff8=
Date: Mon, 15 Apr 2024 13:15:49 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,alexander.shishkin@linux.intel.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240415201550.47E06C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: intel_th: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: intel_th: remove usage of the deprecated ida_simple_xx() API
Date: Sun, 14 Apr 2024 11:28:13 +0200

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Link: https://lkml.kernel.org/r/2aca50a9d061faecfd4ded80b5874cd3be9b855d.1713086613.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwtracing/intel_th/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c~intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/drivers/hwtracing/intel_th/core.c
@@ -871,7 +871,7 @@ intel_th_alloc(struct device *dev, const
 	if (!th)
 		return ERR_PTR(-ENOMEM);
 
-	th->id = ida_simple_get(&intel_th_ida, 0, 0, GFP_KERNEL);
+	th->id = ida_alloc(&intel_th_ida, GFP_KERNEL);
 	if (th->id < 0) {
 		err = th->id;
 		goto err_alloc;
@@ -931,7 +931,7 @@ err_chrdev:
 			    "intel_th/output");
 
 err_ida:
-	ida_simple_remove(&intel_th_ida, th->id);
+	ida_free(&intel_th_ida, th->id);
 
 err_alloc:
 	kfree(th);
@@ -964,7 +964,7 @@ void intel_th_free(struct intel_th *th)
 	__unregister_chrdev(th->major, 0, TH_POSSIBLE_OUTPUTS,
 			    "intel_th/output");
 
-	ida_simple_remove(&intel_th_ida, th->id);
+	ida_free(&intel_th_ida, th->id);
 
 	kfree(th);
 }
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

