Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716C314265
	for <mm-commits@vger.kernel.org>; Sun,  9 Jun 2024 21:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717967199; cv=none; b=CEALmsEPrvg0IXRrPbFr3MDbNzWBkpUsGzKWxZTpYGBi+JBwnJMAzu1QWaG22WdO0Ls2DM7as57KRmHZN+GOCpuMUJKpCNOopnY0aJ4Aabns3DOZiXMm+N/GsbsNhxEUeeJS1EXnY8pYShMjfFdGwR242Xx1ivM85u2HL441yU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717967199; c=relaxed/simple;
	bh=23bn40WrgUBpzChQ5LTKTaUd79GCjghQjThXO5b0rVw=;
	h=Date:To:From:Subject:Message-Id; b=uj3QdZKoyRODc+S1/ju3ei1yrgR98leQvCWc3uzsib55EVAWKQs5e+irpYJqmEcWDx5+XnaYzTRt5DTwQ/6L24Yjcj7Hm061UXTwNKkqTm7/nnfcNt8afZ//nnX7T+wKLglBRpp+D0pwmWsdAhZwib7cOAm6apVqtwOWJLg2OoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=joHWWo/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="joHWWo/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF97AC2BD10;
	Sun,  9 Jun 2024 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717967199;
	bh=23bn40WrgUBpzChQ5LTKTaUd79GCjghQjThXO5b0rVw=;
	h=Date:To:From:Subject:From;
	b=joHWWo/9OpWzDMDkw1uDHzOZsNH0DuzG39G0QFikfHa6Z7lB5Bxzzr9mEHP3a1sV0
	 w4rfET1OeUYeqOhliRhY0hM2lmaP6sbKmndXAGNMG4N+3fG+nOhxySvF7G7ScpFWvJ
	 lcj8O1T9boyUsgd6hRiechr0wHmHClLRRhoIHIaY=
Date: Sun, 09 Jun 2024 14:06:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,parthiban.veerasooran@microchip.com,joel@jms.id.au,jk@ozlabs.org,eajames@linux.ibm.com,christian.gromm@microchip.com,alistair@popple.id.au,adobriyan@gmail.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240609210638.EF97AC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: most: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

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
Subject: most: remove usage of the deprecated ida_simple_xx() API
Date: Sat, 8 Jun 2024 16:34:19 +0200

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Link: https://lkml.kernel.org/r/ddbb2e3f249ba90417dc7ab01713faa1091fb44c.1717855701.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alistar Popple <alistair@popple.id.au>
Cc: Christian Gromm <christian.gromm@microchip.com>
Cc: Eddie James <eajames@linux.ibm.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/most/core.c      |   10 +++++-----
 drivers/most/most_cdev.c |    6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/most/core.c~most-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/drivers/most/core.c
@@ -1286,7 +1286,7 @@ int most_register_interface(struct most_
 	    !iface->poison_channel || (iface->num_channels > MAX_CHANNELS))
 		return -EINVAL;
 
-	id = ida_simple_get(&mdev_id, 0, 0, GFP_KERNEL);
+	id = ida_alloc(&mdev_id, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(iface->dev, "Failed to allocate device ID\n");
 		return id;
@@ -1294,7 +1294,7 @@ int most_register_interface(struct most_
 
 	iface->p = kzalloc(sizeof(*iface->p), GFP_KERNEL);
 	if (!iface->p) {
-		ida_simple_remove(&mdev_id, id);
+		ida_free(&mdev_id, id);
 		return -ENOMEM;
 	}
 
@@ -1308,7 +1308,7 @@ int most_register_interface(struct most_
 		dev_err(iface->dev, "Failed to register interface device\n");
 		kfree(iface->p);
 		put_device(iface->dev);
-		ida_simple_remove(&mdev_id, id);
+		ida_free(&mdev_id, id);
 		return -ENOMEM;
 	}
 
@@ -1366,7 +1366,7 @@ err_free_resources:
 	}
 	kfree(iface->p);
 	device_unregister(iface->dev);
-	ida_simple_remove(&mdev_id, id);
+	ida_free(&mdev_id, id);
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(most_register_interface);
@@ -1397,7 +1397,7 @@ void most_deregister_interface(struct mo
 		device_unregister(&c->dev);
 	}
 
-	ida_simple_remove(&mdev_id, iface->p->dev_id);
+	ida_free(&mdev_id, iface->p->dev_id);
 	kfree(iface->p);
 	device_unregister(iface->dev);
 }
--- a/drivers/most/most_cdev.c~most-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/drivers/most/most_cdev.c
@@ -100,7 +100,7 @@ static void destroy_cdev(struct comp_cha
 
 static void destroy_channel(struct comp_channel *c)
 {
-	ida_simple_remove(&comp.minor_id, MINOR(c->devno));
+	ida_free(&comp.minor_id, MINOR(c->devno));
 	kfifo_free(&c->fifo);
 	kfree(c);
 }
@@ -425,7 +425,7 @@ static int comp_probe(struct most_interf
 	if (c)
 		return -EEXIST;
 
-	current_minor = ida_simple_get(&comp.minor_id, 0, 0, GFP_KERNEL);
+	current_minor = ida_alloc(&comp.minor_id, GFP_KERNEL);
 	if (current_minor < 0)
 		return current_minor;
 
@@ -472,7 +472,7 @@ err_del_cdev_and_free_channel:
 err_free_c:
 	kfree(c);
 err_remove_ida:
-	ida_simple_remove(&comp.minor_id, current_minor);
+	ida_free(&comp.minor_id, current_minor);
 	return retval;
 }
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

