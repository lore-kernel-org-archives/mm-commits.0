Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6742515687A
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212154; cv=none; b=fXS2+10cnbBilKF9YZ2WbVTtIggra2/sHVDoIMuhuV9vh2ST8ztvc5UyXYMARV+UmgpDtwDt0n9eowk7fbq4KtMhd7En5gvCezcJmDA5F5jLvooAGMjd7twOU7T6JgduGz+DHrok7qr7MAQ3z2FeABqOuGgOXDzcx/Z0ox/M+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212154; c=relaxed/simple;
	bh=fz7GDpZaQ1cHLLk/MnZ1NxLcDWASMYJdYbjyqfuoOwc=;
	h=Date:To:From:Subject:Message-Id; b=eK7v9xb+ORUcFB+sOXF4BEcLm7qMCmkBwS+eHouu0u2+uv2gZaG/M2BmKcXJKjFookTl4+Y+R8+rwTyCYmeq2FhKUcqZK3VR9GtTg9tnD3zPfnmH4R7guc/St57sf1wsmpnnpZASvrCoCUuC+tdskmBpTshv4CEa7XZJCEy1Uy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bkES5/yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bkES5/yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EB6C113CC;
	Mon, 15 Apr 2024 20:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212153;
	bh=fz7GDpZaQ1cHLLk/MnZ1NxLcDWASMYJdYbjyqfuoOwc=;
	h=Date:To:From:Subject:From;
	b=bkES5/ylP+dfSsRdW37cZXio/Wl+DNx/U+1/mRRzTybaK4SudjVSXI1STG52ZGoFF
	 2p9oAJGwGZAOStD/h4NNSRhe7zDjCj1hRBZbEa+TNxxao4hUJ663X1jNxkJ9lVTFe5
	 wpTvcZs9ImXSAZvwDnClesorRZps/cRTBYVgbRjQ=
Date: Mon, 15 Apr 2024 13:15:53 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,giometti@enneenne.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240415201553.D4EB6C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pps: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

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
Subject: pps: remove usage of the deprecated ida_simple_xx() API
Date: Sun, 14 Apr 2024 12:10:17 +0200

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Link: https://lkml.kernel.org/r/9f681747d446b874952a892491387d79ffe565a9.1713089394.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps_parport.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pps/clients/pps_parport.c~pps-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/drivers/pps/clients/pps_parport.c
@@ -148,7 +148,7 @@ static void parport_attach(struct parpor
 		return;
 	}
 
-	index = ida_simple_get(&pps_client_index, 0, 0, GFP_KERNEL);
+	index = ida_alloc(&pps_client_index, GFP_KERNEL);
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -188,7 +188,7 @@ err_release_dev:
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
 err_free:
-	ida_simple_remove(&pps_client_index, index);
+	ida_free(&pps_client_index, index);
 	kfree(device);
 }
 
@@ -208,7 +208,7 @@ static void parport_detach(struct parpor
 	pps_unregister_source(device->pps);
 	parport_release(pardev);
 	parport_unregister_device(pardev);
-	ida_simple_remove(&pps_client_index, device->index);
+	ida_free(&pps_client_index, device->index);
 	kfree(device);
 }
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

intel_th-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
hid-sony-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

