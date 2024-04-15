Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A0182D98
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212155; cv=none; b=uf6zALfF/AyLeYfZ51sCiZr8xoBLAH2rszkqfAjONJOklydmKCvVc8m5CqG1gWwEUNvmTG482Z2zGzWa18qxQbSsHrkh8Sg/aLD7SWz5dkh33SgFK0I4YB7hCEphonks0k91u2nngAV6bD3OpsLQqxkve/6CintNbuGDydPu/oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212155; c=relaxed/simple;
	bh=/E/HYzWP9OYK71nB0+KH4fKM+QmAHmrdRouMmcLV8/o=;
	h=Date:To:From:Subject:Message-Id; b=R2VTilNdoZj+NXI41DrfKSq4aKaf+PsTrGvbvqPjpDDUlrlkq9kz2VKZ/JHr2ExSDyZc08iL4w98wOWDH04Ycjil70J6LsJE1R7klSQ7JFaakWJllOI9nKbOGZth5ZaFnDJe32GAAYITzX+2MdZ+MyJEfZMVKMUeSY4bwPvdydY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BIvPg9F1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BIvPg9F1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F045C113CC;
	Mon, 15 Apr 2024 20:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212155;
	bh=/E/HYzWP9OYK71nB0+KH4fKM+QmAHmrdRouMmcLV8/o=;
	h=Date:To:From:Subject:From;
	b=BIvPg9F1aoi5izrWVbBwJwNPfSF7WQhqDQM2Fk59NaBd/WI2+ofG6tMV3+ekbFAJ+
	 m8GPOcuNF2f0JLG0GDXDuHeLTYEG1flFX0CG6TW1upOcJqm4SWMse21Ws1IocBNGBv
	 hi95P9850cEP13q0/fmduM8vMnWqKJtNKxJVQ+S8=
Date: Mon, 15 Apr 2024 13:15:55 -0700
To: mm-commits@vger.kernel.org,peda@axentia.se,gregkh@linuxfoundation.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240415201555.9F045C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mux: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

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
Subject: mux: remove usage of the deprecated ida_simple_xx() API
Date: Sun, 14 Apr 2024 12:12:52 +0200

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Link: https://lkml.kernel.org/r/f82e013abe4c71f1c7d06819f96472f298acdcf3.1713089554.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Peter Rosin <peda@axentia.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mux/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mux/core.c~mux-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/drivers/mux/core.c
@@ -64,7 +64,7 @@ static void mux_chip_release(struct devi
 {
 	struct mux_chip *mux_chip = to_mux_chip(dev);
 
-	ida_simple_remove(&mux_ida, mux_chip->id);
+	ida_free(&mux_ida, mux_chip->id);
 	kfree(mux_chip);
 }
 
@@ -111,7 +111,7 @@ struct mux_chip *mux_chip_alloc(struct d
 	mux_chip->dev.of_node = dev->of_node;
 	dev_set_drvdata(&mux_chip->dev, mux_chip);
 
-	mux_chip->id = ida_simple_get(&mux_ida, 0, 0, GFP_KERNEL);
+	mux_chip->id = ida_alloc(&mux_ida, GFP_KERNEL);
 	if (mux_chip->id < 0) {
 		int err = mux_chip->id;
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

