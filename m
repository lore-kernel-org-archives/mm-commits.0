Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D5E2572
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374262; cv=none; b=PlHADJDbgaP7Xadko19xftt3K7D+94dPXW/rkSVo0bDiq444nzNINYvx7xauhv1iXi/ihZRZZkVz8r6Dt5pPJKyQciUA8Z1xCAoPIbgqbYyL1lsXZoO0Y3h081Xz8mriLmIC/iNTYlefvMJt+dpJEVo06+8ROPLFvGYkWowmj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374262; c=relaxed/simple;
	bh=uH28wXVZtKR0tFy+dxgEF3g2mTBvl5wvqEZcOxUS9aI=;
	h=Date:To:From:Subject:Message-Id; b=WRY7U4vD7Fx9UA3nmgeL6N1QcLLWI7/CzSw2Q8widQxTRjCQh5LSqfEMWjsv8yLEkR/VsBpZshFcmJSCpEQd5L+lMkii5FNqJqeFz0iqi0hHDxNkBbfBsvLxcn8O+IlPI5R57hUQ6Yn1kNiHkuV+qJgwC80eUcvhCjfMMcvVEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfWF7ABK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfWF7ABK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65EAC4CED7;
	Tue, 12 Nov 2024 01:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374261;
	bh=uH28wXVZtKR0tFy+dxgEF3g2mTBvl5wvqEZcOxUS9aI=;
	h=Date:To:From:Subject:From;
	b=GfWF7ABKcnBRd/HkWKKMoSVNlahZ7qmBgj0pWgkzLYgyryw/FlDt5m7rOwo9bWBRh
	 AUD3k0Kzw5I6e5F9uqQirVX1PHAiaC1LPdiKG++m0vbFDXLRmWl2fd6pf+TChoMnr/
	 gLpZU5rezIG1zpf9+3aiBZFGoiM+djjdq6ff1QcY=
Date: Mon, 11 Nov 2024 17:17:41 -0800
To: mm-commits@vger.kernel.org,linux@weissschuh.net,joel.granados@kernel.org,festevam@denx.de,daniel.lezcano@linaro.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-reboot-replace-sprintf-with-sysfs_emit.patch removed from -mm tree
Message-Id: <20241112011741.A65EAC4CED7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/reboot: replace sprintf() with sysfs_emit()
has been removed from the -mm tree.  Its filename was
     kernel-reboot-replace-sprintf-with-sysfs_emit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhangguopeng <zhangguopeng@kylinos.cn>
Subject: kernel/reboot: replace sprintf() with sysfs_emit()
Date: Tue, 5 Nov 2024 17:49:41 +0800

As Documentation/filesystems/sysfs.rst suggested, show() should only use
sysfs_emit() or sysfs_emit_at() when formatting the value to be returned
to user space.

No functional change intended.

Link: https://lkml.kernel.org/r/20241105094941.33739-1-zhangguopeng@kylinos.cn
Signed-off-by: zhangguopeng <zhangguopeng@kylinos.cn>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/reboot.c~kernel-reboot-replace-sprintf-with-sysfs_emit
+++ a/kernel/reboot.c
@@ -1137,7 +1137,7 @@ static ssize_t mode_show(struct kobject
 		val = REBOOT_UNDEFINED_STR;
 	}
 
-	return sprintf(buf, "%s\n", val);
+	return sysfs_emit(buf, "%s\n", val);
 }
 static ssize_t mode_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
@@ -1167,7 +1167,7 @@ static struct kobj_attribute reboot_mode
 #ifdef CONFIG_X86
 static ssize_t force_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", reboot_force);
+	return sysfs_emit(buf, "%d\n", reboot_force);
 }
 static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
@@ -1214,7 +1214,7 @@ static ssize_t type_show(struct kobject
 		val = REBOOT_UNDEFINED_STR;
 	}
 
-	return sprintf(buf, "%s\n", val);
+	return sysfs_emit(buf, "%s\n", val);
 }
 static ssize_t type_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
@@ -1247,7 +1247,7 @@ static struct kobj_attribute reboot_type
 #ifdef CONFIG_SMP
 static ssize_t cpu_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", reboot_cpu);
+	return sysfs_emit(buf, "%d\n", reboot_cpu);
 }
 static ssize_t cpu_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are


