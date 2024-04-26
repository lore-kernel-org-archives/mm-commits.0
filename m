Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ECC823DC
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104497; cv=none; b=M3eLsTzhyXvKyRwkk5C0z1patn5OJ6933QvK6PJVU74e9jSucVsiDuvhZpsF2+y4umHjNNCP7JfE6SdVayKQQQC+8qg83bB0+pU4MZfZr8+KjvM+CIljP0dzf1kZWw5XxPcxznIZepgD9qFxrhaNp/Pn5rOsPTZLem4Ajd30eNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104497; c=relaxed/simple;
	bh=tuc9EPn7o/kbYRcvfRl6RI3jvJ5HUi2SIUEki9LYdn0=;
	h=Date:To:From:Subject:Message-Id; b=p4aCsIQxGzXe0NyFaW4kVBai8rC28o4cnMZgTGQQhj7B40K9/Az7XPARu1/j5tzUC/rhh7B64NDeQx3X8S//WTVXRLZgbFcQyzRwPyxr87xN5b+uq+4LMZQE+AOfpYS8R7qOmq6Bx+WVS/Tuz/G0kKgi96hFqaNBYkR9plYzG5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aY5miy4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aY5miy4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35239C116B1;
	Fri, 26 Apr 2024 04:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104497;
	bh=tuc9EPn7o/kbYRcvfRl6RI3jvJ5HUi2SIUEki9LYdn0=;
	h=Date:To:From:Subject:From;
	b=aY5miy4HMkxIdJYQU3KDMm29JHWnKEvFIaXbmUtrHYczIzCrZOuRTalr5s6rHBjMG
	 P+9ftlVgOwBBrYyrktVBvqJakb7O+vycQcsLc7tKL3VsSc+inkzbvvTuBzrix7TUs7
	 QL117Ir480jQCTTWYOq6UjMwXxSX4FoTCn6FRl5Q=
Date: Thu, 25 Apr 2024 21:08:16 -0700
To: mm-commits@vger.kernel.org,peda@axentia.se,gregkh@linuxfoundation.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch removed from -mm tree
Message-Id: <20240426040817.35239C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mux: remove usage of the deprecated ida_simple_xx() API
has been removed from the -mm tree.  Its filename was
     mux-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


