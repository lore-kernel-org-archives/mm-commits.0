Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF582495
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104496; cv=none; b=QcccpDt9fFnJdkGrLljnO9Xs9UnqsHcmrB934LuMIOORmTv7DRD+YXwLYp5uTXfzGnZoyL/lMkP9t9hd63LjnvSyeqSQObw9wRV+YlE8AqAKsl7Pwtvdd/K2ZdmflK3UkUEIfupG1/z9PwNzRcm5PAFt5fzmQLIAhni8PsQ8HZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104496; c=relaxed/simple;
	bh=ILG97hy1tTzy9m8wI9L/9mEaWCnzWrc0g6io10OsYSo=;
	h=Date:To:From:Subject:Message-Id; b=QPQ0fklu23Ob+9DGEuPs/ZNf4ZTPfr23GQtl1g6qXfwqohGLYUnJBzdr1RsCg3y/yZVSD+DlCxQwuj+JPkr4fyM8KsiVj7ndgROmgkYhSQZ0DfOhj4lmzD9TMBGun5zGKufMNd0Nek8pQdYHnh+Y5kElxXMT46RGcwWAZrgvwho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LopbBw88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LopbBw88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DFFC113CD;
	Fri, 26 Apr 2024 04:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104496;
	bh=ILG97hy1tTzy9m8wI9L/9mEaWCnzWrc0g6io10OsYSo=;
	h=Date:To:From:Subject:From;
	b=LopbBw88dEHwGCd+e3c+D0uc6z7Ipca2WAZgTYNrmQZfttQddPvJuTL5MmM8ipJRZ
	 ikeqNLPC6gJTS3OUpfmuwpTIn3iM3fE0bMZCnBiZovNENRry1vrdAxsvsdcDr6L0AQ
	 hVeSIvRAXlTc5QG2jD2HLl7IAtYrjcuGhYCd0BZo=
Date: Thu, 25 Apr 2024 21:08:15 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,giometti@enneenne.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch removed from -mm tree
Message-Id: <20240426040816.29DFFC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pps: remove usage of the deprecated ida_simple_xx() API
has been removed from the -mm tree.  Its filename was
     pps-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


