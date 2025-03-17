Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8238634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189162; cv=none; b=gIsR5VF6kmzLh3xBoqX2lbXkAcfP6E0D87xVIY4h/G1cG8tDO9hiHhjU3dN2nvkyd4B/w8IxBLBBNsQnrxNmdN5+KI5hMoBwrC5TrXxqF6lLYFyFvANQvj1cKqijsvKGIedeGM5hznGej+JXBFjPS9bg+fJMlRWzs+6aI/ninbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189162; c=relaxed/simple;
	bh=xT9wkuuYhcw+mE6wHazXuEs1CZUW1m58sHSpGXBvnsk=;
	h=Date:To:From:Subject:Message-Id; b=G7KeRbooydMVGLK85jojiXBqh2P9t+6IvGy/MI0X+jeP7/n5fitxiiuXUeeiH+5pWZ3EY8wXGersvbKhmkR2KbUrVN4VETM+mfM4q5hC7jKQBLl5t2Z+8tEevNX/b/qEyDmn6yA8bLWCucPZ8wNWfTtWDE8il/a3rQABV3yw+Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mfyp0VrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mfyp0VrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80103C4CEEC;
	Mon, 17 Mar 2025 05:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189161;
	bh=xT9wkuuYhcw+mE6wHazXuEs1CZUW1m58sHSpGXBvnsk=;
	h=Date:To:From:Subject:From;
	b=Mfyp0VrKgnDIIEZHQutOCGS8JBCnf/iXnheCHtcOVX2viwsq9ju7deLyrYQA2+LGb
	 xBegm27TNtcty4wArLHqHmMXje8t+BuK86IcTe39kUNlvCB/zDm5wEg4l7ViVEirgK
	 T36IEN0ZMP5KbY+P3dckElHk5wKZLGQ05hZIzjzU=
Date: Sun, 16 Mar 2025 22:26:00 -0700
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,joel.granados@kernel.org,a.fatoum@pengutronix.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch removed from -mm tree
Message-Id: <20250317052601.80103C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: reboot: hide unused hw_protection_attr
has been removed from the -mm tree.  Its filename was
     reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch

This patch was dropped because it was folded into reboot-add-support-for-configuring-emergency-hardware-protection-action.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: reboot: hide unused hw_protection_attr
Date: Mon, 24 Feb 2025 15:16:09 +0100

The reference to hw_protection_attr is inside of an #ifdef block, but the
definition is not:

kernel/reboot.c:1092:30: error: unused variable 'hw_protection_attr' [-Werror,-Wunused-variable]
 1092 | static struct kobj_attribute hw_protection_attr = __ATTR_RW(hw_protection);
      |                              ^~~~~~~~~~~~~~~~~~

Add another #ifdef to match the first.

Link: https://lkml.kernel.org/r/20250224141849.1546019-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/reboot.c~reboot-add-support-for-configuring-emergency-hardware-protection-action-fix
+++ a/kernel/reboot.c
@@ -1071,6 +1071,7 @@ static int __init hw_protection_setup(ch
 }
 __setup("hw_protection=", hw_protection_setup);
 
+#ifdef CONFIG_SYSFS
 static ssize_t hw_protection_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
@@ -1090,6 +1091,7 @@ static ssize_t hw_protection_store(struc
 	return count;
 }
 static struct kobj_attribute hw_protection_attr = __ATTR_RW(hw_protection);
+#endif
 
 static int __init reboot_setup(char *str)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories-fix.patch
reboot-add-support-for-configuring-emergency-hardware-protection-action.patch

