Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B73763F8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104495; cv=none; b=XnpstwyBPtnTyARfH85GA9LJ2dzB723w9rmXdRC48rj1TwbbXOwKt+q5FSBogjBTSJOdWKDE2/U0wFZSOBa0dbcwsZAvOTmmnEQXv9tlQu9IA9BjqDCAk+x6+y0lS18b651MrY1W3t8AJGcxFRtLPCV068HZP2W8qFa/5GSKlY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104495; c=relaxed/simple;
	bh=F+7srm8ZfGI3VyySKrOOwnpijP1NlKziXR+cjUrLjwI=;
	h=Date:To:From:Subject:Message-Id; b=NV1U7UNEqNdvCW/yIGCQZeSTjYdMPr5CbIebWCT+AwlTRy1ghabWqOsSFp8KLrGfty0HKVmTq0X6UhtOgB8jDq1FywuyCTdE7LLwOKE+aT2f61XW/RqJz37dTqARLpedI1HSe2rHlQl36mPjo7SvTP9v9/dWX6Ves/PkfTNJEA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQ9rtyCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQ9rtyCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4D4C3277B;
	Fri, 26 Apr 2024 04:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104495;
	bh=F+7srm8ZfGI3VyySKrOOwnpijP1NlKziXR+cjUrLjwI=;
	h=Date:To:From:Subject:From;
	b=CQ9rtyCUDltIwT9JBWmVwoHu9v5vG+1jBuTkNvMvDVgy6yAfBgaMU9/uWoBIsYh/N
	 0adlcL/xBR84ZRatYy7vZLzMGNMC5du1wgBUumT6eoLZtFdSiaDtkS76blSDksd7Ir
	 cQ+ZeZd9oajhX9L70isGpCY8LhwrTy7XiOWA+sOc=
Date: Thu, 25 Apr 2024 21:08:14 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,alexander.shishkin@linux.intel.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch removed from -mm tree
Message-Id: <20240426040815.1F4D4C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: intel_th: remove usage of the deprecated ida_simple_xx() API
has been removed from the -mm tree.  Its filename was
     intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


